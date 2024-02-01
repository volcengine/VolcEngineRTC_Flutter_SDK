/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.render;

import android.content.Context;
import android.util.Log;
import android.view.SurfaceView;
import android.view.TextureView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.VideoCanvas;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

@RestrictTo(RestrictTo.Scope.LIBRARY)
class RTCSurfaceView implements PlatformView, MethodChannel.MethodCallHandler {
    private static final String TAG = "RTCSurfaceView";

    /**
     * Use {@link android.view.SurfaceView} as Render, DEFAULT
     */
    public static final int VIEW_TYPE_SURFACE = 0;
    /**
     * Use {@link android.view.TextureView} as Render
     */
    public static final int VIEW_TYPE_TEXTURE = 1;

    @NonNull
    private final View mRenderView;
    @NonNull
    private final VideoCanvas mVideoCanvas;

    public RTCSurfaceView(BinaryMessenger messenger, Context context, int viewId, Object args) {
        RTCTypeBox arguments = new RTCTypeBox(args, "RTCSurfaceView");
        mRenderView = createRenderView(context, arguments);
        mVideoCanvas = new VideoCanvas();
        mVideoCanvas.renderView = mRenderView;

        MethodChannel methodChannel = new MethodChannel(messenger, "com.bytedance.ve_rtc_surfaceView" + viewId);
        methodChannel.setMethodCallHandler(this);

        int canvasType = arguments.optInt("canvasType", -1);
        if (BuildConfig.DEBUG) {
            Log.d(TAG, "RTCSurfaceView: canvasType=" + canvasType);
        }
        switch (canvasType) {
            case 0: // CanvasTypeLocal
                setupLocalVideo(arguments);
                break;
            case 1: // CanvasTypeRemote
                setupRemoteVideo(arguments);
                break;
            case 2: // CanvasTypePublicStream
                setupPublicStreamVideo(arguments);
                break;
            case 3: // CanvasTypeEchoTest
                setupEchoTestVideo(arguments);
                break;
            default:
                Log.e(TAG, "Unknown canvasType: " + canvasType);
                break;
        }
    }

    // region PlatformView
    @Override
    public View getView() {
        return mRenderView;
    }

    @Override
    public void dispose() {
        EchoTestViewHolder.setView(null);
    }
    // endregion

    // region MethodChannel.MethodCallHandler
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
        switch (call.method) {
            case "setupLocalVideo": {
                int retValue = setupLocalVideo(arguments);

                result.success(retValue);
                break;
            }
            case "setupRemoteVideo": {
                setupRemoteVideo(arguments);

                result.success(null);
                break;
            }

            case "setupPublicStreamVideo": {
                int retValue = setupPublicStreamVideo(arguments);

                result.success(retValue);
                break;
            }

            case "setupEchoTestVideo": {
                setupEchoTestVideo(arguments);

                result.success(null);
                break;
            }

            case "updateLocalVideo": {
                StreamIndex streamType = StreamIndex.fromId(arguments.optInt("streamType"));
                int renderMode = arguments.optInt("renderMode");
                int backgroundColor = arguments.optInt("backgroundColor");

                RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                rtcVideo.updateLocalVideoCanvas(streamType, renderMode, backgroundColor);
                result.success(null);
                break;
            }

            case "updateRemoteVideo": {
                final String roomId = arguments.optString("roomId");
                final String uid = arguments.optString("uid");
                StreamIndex streamType = StreamIndex.fromId(arguments.optInt("streamType"));
                int renderMode = arguments.optInt("renderMode");
                int backgroundColor = arguments.optInt("backgroundColor");

                RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                RemoteStreamKey streamKey = new RemoteStreamKey(roomId, uid, streamType);
                rtcVideo.updateRemoteStreamVideoCanvas(streamKey, renderMode, backgroundColor);
                result.success(null);
                break;
            }
            case "setZOrderOnTop": {
                if (mRenderView instanceof SurfaceView) {
                    ((SurfaceView) mRenderView).setZOrderOnTop(arguments.optBoolean("onTop"));
                }
                result.success(null);
                break;
            }
            case "setZOrderMediaOverlay": {
                if (mRenderView instanceof SurfaceView) {
                    ((SurfaceView) mRenderView).setZOrderMediaOverlay(arguments.optBoolean("isMediaOverlay"));
                }
                result.success(null);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    private int setupLocalVideo(RTCTypeBox arguments) {
        StreamIndex streamType = StreamIndex.fromId(arguments.optInt("streamType"));
        int renderMode = arguments.optInt("renderMode");
        int backgroundColor = arguments.optInt("backgroundColor");

        mVideoCanvas.renderMode = renderMode;
        mVideoCanvas.backgroundColor = backgroundColor;

        return RTCVideoManager.getRTCVideo().setLocalVideoCanvas(streamType, mVideoCanvas);
    }

    private void setupRemoteVideo(RTCTypeBox arguments) {
        final String roomId = arguments.optString("roomId");
        final String uid = arguments.optString("uid");
        StreamIndex streamType = StreamIndex.fromId(arguments.optInt("streamType"));
        int renderMode = arguments.optInt("renderMode");
        int backgroundColor = arguments.optInt("backgroundColor");

        mVideoCanvas.renderMode = renderMode;
        mVideoCanvas.backgroundColor = backgroundColor;

        final RemoteStreamKey streamKey = new RemoteStreamKey(roomId, uid, streamType);

        RTCVideoManager.getRTCVideo().setRemoteVideoCanvas(streamKey, mVideoCanvas);
    }

    private int setupPublicStreamVideo(RTCTypeBox arguments) {
        final String uid = arguments.optString("uid");
        int renderMode = arguments.optInt("renderMode");
        int backgroundColor = arguments.optInt("backgroundColor");

        mVideoCanvas.renderMode = renderMode;
        mVideoCanvas.backgroundColor = backgroundColor;

        RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
        return rtcVideo.setPublicStreamVideoCanvas(uid, mVideoCanvas);
    }

    private void setupEchoTestVideo(RTCTypeBox arguments) {
        int renderMode = arguments.optInt("renderMode");
        int backgroundColor = arguments.optInt("backgroundColor");

        mVideoCanvas.renderMode = renderMode;
        mVideoCanvas.backgroundColor = backgroundColor;

        EchoTestViewHolder.setView(mVideoCanvas);
    }

    // endregion

    @NonNull
    private static View createRenderView(Context context, RTCTypeBox arguments) {
        int viewType = arguments.optInt("viewType", VIEW_TYPE_TEXTURE);
        if (viewType == VIEW_TYPE_TEXTURE) {
            return new TextureView(context);
        } else {
            return new SurfaceView(context);
        }
    }
}
