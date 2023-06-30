/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.render.RTCSurfaceViewFactory;
import com.ss.bytertc.engine.flutter.video.RTCVideoPlugin;
import com.ss.bytertc.engine.flutter.video.VideoEventProxy;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformViewRegistry;

/**
 * ByteRTCPlugin 总入口管理类
 *
 * @see RTCVideoPlugin RTCVideo 交互管理类
 */
public class ByteRTCPlugin implements FlutterPlugin {
    private static final String TAG = "ByteRTCPlugin";

    public FlutterPlugin.FlutterPluginBinding binding;
    public MethodChannel channel;

    private final VideoEventProxy videoEventHandler = new VideoEventProxy();
    private RTCVideoPlugin mVideoPlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.binding = binding;

        // Hold an application context
        Context applicationContext = binding.getApplicationContext();
        RTCVideoManager.setAppContext(applicationContext);

        // Register platform view
        PlatformViewRegistry platformViewRegistry = binding.getPlatformViewRegistry();
        platformViewRegistry.registerViewFactory("ByteRTCSurfaceView",
                new RTCSurfaceViewFactory(binding.getBinaryMessenger()));

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_plugin");
        channel.setMethodCallHandler(methodCallHandler);
        videoEventHandler.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }

        if (mVideoPlugin != null) {
            mVideoPlugin.onDetachedFromEngine(binding);
            mVideoPlugin = null;
        }
        RTCVideoManager.destroy();
        videoEventHandler.destroy();
    }

    private final MethodChannel.MethodCallHandler methodCallHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(TAG, "ByteRTCPlugin Call: " + call.method);
        }

        final RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);

        switch (call.method) {
            // region Static Methods
            case "getSDKVersion": {
                result.success(RTCVideo.getSDKVersion());
                break;
            }

            case "getErrorDescription": {
                int code = arguments.optInt("code");
                result.success(RTCVideo.getErrorDescription(code));
                break;
            }

            case "createRTCVideo": {
                if (!RTCVideoManager.hasRTCVideo()) {
                    String appId = arguments.optString("appId");
                    JSONObject parameters = arguments.optJSONObject("parameters");
                    try {
                        parameters.put("rtc.platform", 6);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    RTCVideoManager.create(appId, videoEventHandler, parameters);
                }
                mVideoPlugin = new RTCVideoPlugin();
                mVideoPlugin.onAttachedToEngine(binding);
                result.success(RTCVideoManager.hasRTCVideo());
                break;
            }

            case "destroyRTCVideo": {
                if (mVideoPlugin != null) {
                    mVideoPlugin.onDetachedFromEngine(binding);
                    mVideoPlugin = null;
                }
                RTCVideoManager.destroy();
                result.success(null);
                break;
            }

            case "eventHandlerSwitches": { // for performance reason
                videoEventHandler.setSwitches(arguments);
                result.success(null);
                break;
            }
            // endregion

            default:
                result.notImplemented();
                break;
        }
    };
}
