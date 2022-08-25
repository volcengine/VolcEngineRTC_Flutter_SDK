/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.room;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.annotation.UiThread;

import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.RTCRoomConfig;
import com.ss.bytertc.engine.UserInfo;
import com.ss.bytertc.engine.audio.IRangeAudio;
import com.ss.bytertc.engine.audio.ISpatialAudio;
import com.ss.bytertc.engine.data.ForwardStreamInfo;
import com.ss.bytertc.engine.data.HumanOrientation;
import com.ss.bytertc.engine.data.Position;
import com.ss.bytertc.engine.data.ReceiveRange;
import com.ss.bytertc.engine.data.RemoteVideoConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.volc_engine_rtc.BuildConfig;
import com.ss.bytertc.engine.type.MediaStreamType;
import com.ss.bytertc.engine.type.MessageConfig;
import com.ss.bytertc.engine.type.PauseResumeControlMediaType;

import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * RTCRoomPlugin 管理与 RTCRoom 的交互
 */
@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCRoomPlugin implements FlutterPlugin {
    private static final String TAG = "RTCRoomPlugin";
    private final Integer mIns;
    @NonNull
    private final RTCRoom mRTCRoom;
    private final RTCRoomEventProxy mRoomEventHandler = new RTCRoomEventProxy();
    private final RangeAudioEventProxy mRangeAudioEventProxy = new RangeAudioEventProxy();

    public RTCRoomPlugin(Integer roomInsId, @NonNull RTCRoom rtcRoom) {
        mIns = roomInsId;
        rtcRoom.setRTCRoomEventHandler(mRoomEventHandler);
        mRTCRoom = rtcRoom;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        mRoomEventHandler.registerEvent(binding.getBinaryMessenger(), mIns);
        mRangeAudioEventProxy.registerEvent(binding.getBinaryMessenger(), mIns);

        { // RTCRoom
            MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_room" + mIns);
            channel.setMethodCallHandler(roomCallHandler);
        }

        { // SpatialAudio
            MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_spatial_audio" + mIns);
            channel.setMethodCallHandler(spatialAudioCallHandler);
        }

        { // RangeAudio
            MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_range_audio" + mIns);
            channel.setMethodCallHandler(rangeAudioCallHandler);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        RTCVideoManager.destroyRoom(mIns);
    }

    private final MethodChannel.MethodCallHandler rangeAudioCallHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "IRangeAudio Call: " + call.method);
            }
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
            IRangeAudio mRangeAudio = mRTCRoom.getRangeAudio();
            switch (call.method) {
                case "enableRangeAudio": {
                    boolean enable = arguments.optBoolean("enable");
                    mRangeAudio.enableRangeAudio(enable);

                    result.success(null);
                    break;
                }

                case "updateReceiveRange": {
                    ReceiveRange range = RTCType.toReceiveRange(arguments.optBox("range"));
                    int retValue = mRangeAudio.updateReceiveRange(range);

                    result.success(retValue);
                    break;
                }

                case "updatePosition": {
                    Position position = RTCType.toBytePosition(arguments.optBox("pos"));
                    int retValue = mRangeAudio.updatePosition(position);

                    result.success(retValue);
                    break;
                }

                case "registerRangeAudioObserver": {
                    boolean observer = arguments.optBoolean("observer");
                    if (observer) {
                        mRangeAudioEventProxy.setEnable(true);
                        mRangeAudio.registerRangeAudioObserver(mRangeAudioEventProxy);
                    } else {
                        mRangeAudioEventProxy.setEnable(false);
                    }

                    result.success(null);
                    break;
                }
            }
        }
    };

    private final MethodChannel.MethodCallHandler spatialAudioCallHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "ISpatialAudio Call: " + call.method);
            }
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
            ISpatialAudio mSpatialAudio = mRTCRoom.getSpatialAudio();
            switch (call.method) {
                case "enableSpatialAudio": {
                    boolean enable = arguments.optBoolean("enable");
                    mSpatialAudio.enableSpatialAudio(enable);

                    result.success(null);
                    break;
                }

                case "updatePosition": {
                    Position position = RTCType.toBytePosition(arguments.optBox("pos"));
                    int retValue = mSpatialAudio.updatePosition(position);

                    result.success(retValue);
                    break;
                }

                case "updateSelfOrientation": {
                    HumanOrientation orientation = RTCType.toHumanOrientation(arguments.optBox("orientation"));
                    int retValue = mSpatialAudio.updateSelfOrientation(orientation);

                    result.success(retValue);
                    break;
                }

                case "disableRemoteOrientation": {
                    mSpatialAudio.disableRemoteOrientation();

                    result.success(null);
                    break;
                }

                default: {
                    result.notImplemented();
                    break;
                }
            }
        }
    };


    private final MethodChannel.MethodCallHandler roomCallHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "Room Call: " + call.method);
            }
            RTCRoom room = mRTCRoom;
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);

            switch (call.method) {
                case "destroyRTCRoom":
                case "destroy": {
                    RTCVideoManager.destroyRoom(mIns);
                    result.success(null);
                    break;
                }

                case "joinRoom": {
                    String token = arguments.optString("token");
                    UserInfo userInfo = RTCType.toUserInfo(arguments.optBox("userInfo"));
                    RTCRoomConfig roomConfig = RTCType.toRTCRoomConfig(arguments.optBox("roomConfig"));

                    int retCode = room.joinRoom(token, userInfo, roomConfig);
                    result.success(retCode);
                    break;
                }

                case "setUserVisibility": {
                    room.setUserVisibility(arguments.optBoolean("enable"));

                    result.success(null);
                    break;
                }

                case "setMultiDeviceAVSync": {
                    String audioUserId = arguments.optString("audioUid");
                    int retValue = room.setMultiDeviceAVSync(audioUserId);

                    result.success(retValue);
                    break;
                }

                case "leaveRoom": {
                    room.leaveRoom();

                    result.success(null);
                    break;
                }

                case "updateToken": {
                    String token = arguments.optString("token");
                    room.updateToken(token);

                    result.success(null);
                    break;
                }

                case "setRemoteVideoConfig": {
                    String userId = arguments.optString("uid");
                    RemoteVideoConfig remoteVideoConfig = RTCType.toRemoteVideoConfig(arguments.optBox("videoConfig"));
                    room.setRemoteVideoConfig(userId, remoteVideoConfig);

                    result.success(null);
                    break;
                }

                case "publishStream": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.publishStream(type);

                    result.success(null);
                    break;
                }

                case "unpublishStream": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.unpublishStream(type);

                    result.success(null);
                    break;
                }

                case "publishScreen": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.publishScreen(type);

                    result.success(null);
                    break;
                }

                case "unpublishScreen": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.unpublishScreen(type);

                    result.success(null);
                    break;
                }

                case "subscribeStream": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.subscribeStream(userId, type);

                    result.success(null);
                    break;
                }

                case "unsubscribeStream": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.unsubscribeStream(userId, type);

                    result.success(null);
                    break;
                }

                case "subscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.subscribeScreen(userId, type);

                    result.success(null);
                    break;
                }

                case "unsubscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    room.unsubscribeScreen(userId, type);

                    result.success(null);
                    break;
                }

                case "pauseAllSubscribedStream": {
                    PauseResumeControlMediaType mediaType = RTCType.toPauseResumeControlMediaType(arguments.optInt("mediaType"));
                    room.pauseAllSubscribedStream(mediaType);

                    result.success(null);
                    break;
                }

                case "resumeAllSubscribedStream": {
                    PauseResumeControlMediaType mediaType = RTCType.toPauseResumeControlMediaType(arguments.optInt("mediaType"));
                    room.resumeAllSubscribedStream(mediaType);

                    result.success(null);
                    break;
                }

                case "sendUserMessage": {
                    String uid = arguments.optString("uid");
                    String msg = arguments.optString("message");
                    MessageConfig config = MessageConfig.fromId(arguments.optInt("config"));
                    long retValue = room.sendUserMessage(uid, msg, config);

                    result.success(retValue);
                    break;
                }

                case "sendUserBinaryMessage": {
                    String uid = arguments.optString("uid");
                    byte[] msg = arguments.optBytes("message");
                    MessageConfig config = MessageConfig.fromId(arguments.optInt("config"));
                    long retValue = room.sendUserBinaryMessage(uid, msg, config);

                    result.success(retValue);
                    break;
                }

                case "sendRoomMessage": {
                    String msg = arguments.optString("message");
                    long retValue = room.sendRoomMessage(msg);

                    result.success(retValue);
                    break;
                }

                case "sendRoomBinaryMessage": {
                    byte[] msg = arguments.optBytes("message");
                    long retValue = room.sendRoomBinaryMessage(msg);

                    result.success(retValue);
                    break;
                }

                case "startForwardStreamToRooms": {
                    List<ForwardStreamInfo> forwardStreamInfos = RTCType.toForwardStreamInfoList(arguments.getList("forwardStreamInfos"));
                    room.startForwardStreamToRooms(forwardStreamInfos);

                    result.success(null);
                    break;
                }

                case "updateForwardStreamToRooms": {
                    List<ForwardStreamInfo> forwardStreamInfos = RTCType.toForwardStreamInfoList(arguments.getList("forwardStreamInfos"));
                    room.updateForwardStreamToRooms(forwardStreamInfos);

                    result.success(null);
                    break;
                }

                case "stopForwardStreamToRooms": {
                    room.stopForwardStreamToRooms();

                    result.success(null);
                    break;
                }

                case "pauseForwardStreamToAllRooms": {
                    room.pauseForwardStreamToAllRooms();

                    result.success(null);
                    break;
                }

                case "resumeForwardStreamToAllRooms": {
                    room.resumeForwardStreamToAllRooms();

                    result.success(null);
                    break;
                }

                case "startCloudRendering": {
                    String effectInfo = arguments.optString("effectInfo");
                    room.startCloudRendering(effectInfo);

                    result.success(null);
                    break;
                }

                case "updateCloudRendering": {
                    String effectInfo = arguments.optString("effectInfo");
                    room.updateCloudRendering(effectInfo);

                    result.success(null);
                    break;
                }

                case "eventHandlerSwitches": { // for performance reason
                    mRoomEventHandler.setSwitch(arguments);
                    result.success(null);
                    break;
                }

                default: {
                    result.notImplemented();
                    break;
                }
            }
        }
    };
}

