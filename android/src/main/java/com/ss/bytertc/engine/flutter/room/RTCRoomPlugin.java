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
import com.ss.bytertc.engine.data.ForwardStreamInfo;
import com.ss.bytertc.engine.data.RemoteVideoConfig;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.engine.type.MediaStreamType;
import com.ss.bytertc.engine.type.MessageConfig;
import com.ss.bytertc.engine.type.PauseResumeControlMediaType;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * RTCRoomPlugin 管理与 RTCRoom 的交互
 */
@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCRoomPlugin extends RTCFlutterPlugin {

    private final Integer mIns;
    @NonNull
    private final RTCRoom mRTCRoom;

    private final List<RTCFlutterPlugin> flutterPlugins = new ArrayList<>();
    private final RTCRoomEventProxy mRoomEventHandler = new RTCRoomEventProxy();

    public RTCRoomPlugin(Integer roomInsId, @NonNull RTCRoom rtcRoom) {
        mIns = roomInsId;
        rtcRoom.setRTCRoomEventHandler(mRoomEventHandler);
        mRTCRoom = rtcRoom;
        flutterPlugins.add(new RangeAudioPlugin(roomInsId, rtcRoom));
        flutterPlugins.add(new SpatialAudioPlugin(roomInsId, rtcRoom));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        for (RTCFlutterPlugin plugin: flutterPlugins) {
            plugin.onAttachedToEngine(binding);
        }
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_room" + mIns);
        channel.setMethodCallHandler(callHandler);
        mRoomEventHandler.registerEvent(binding.getBinaryMessenger(), mIns);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);

        for (RTCFlutterPlugin plugin: flutterPlugins) {
            plugin.onDetachedFromEngine(binding);
        }
        RTCVideoManager.destroyRoom(mIns);
        mRoomEventHandler.destroy();
    }

    private final MethodChannel.MethodCallHandler callHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(getTAG(), "Room Call: " + call.method);
            }
            RTCRoom room = mRTCRoom;
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);

            switch (call.method) {
                case "joinRoom": {
                    String token = arguments.optString("token");
                    UserInfo userInfo = RTCType.toUserInfo(arguments.optBox("userInfo"));
                    RTCRoomConfig roomConfig = RTCType.toRTCRoomConfig(arguments.optBox("roomConfig"));

                    int retValue = room.joinRoom(token, userInfo, roomConfig);
                    result.success(retValue);
                    break;
                }

                case "setUserVisibility": {
                    int retValue = room.setUserVisibility(arguments.optBoolean("enable"));

                    result.success(retValue);
                    break;
                }

                case "setMultiDeviceAVSync": {
                    String audioUserId = arguments.optString("audioUid");
                    int retValue = room.setMultiDeviceAVSync(audioUserId);

                    result.success(retValue);
                    break;
                }

                case "leaveRoom": {
                    int retValue = room.leaveRoom();

                    result.success(retValue);
                    break;
                }

                case "updateToken": {
                    String token = arguments.optString("token");
                    int retValue = room.updateToken(token);

                    result.success(retValue);
                    break;
                }

                case "setRemoteVideoConfig": {
                    String userId = arguments.optString("uid");
                    RemoteVideoConfig remoteVideoConfig = RTCType.toRemoteVideoConfig(arguments.optBox("videoConfig"));
                    int retValue = room.setRemoteVideoConfig(userId, remoteVideoConfig);

                    result.success(retValue);
                    break;
                }

                case "publishStream": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.publishStream(type);

                    result.success(retValue);
                    break;
                }

                case "unpublishStream": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.unpublishStream(type);

                    result.success(retValue);
                    break;
                }

                case "publishScreen": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.publishScreen(type);

                    result.success(retValue);
                    break;
                }

                case "unpublishScreen": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.unpublishScreen(type);

                    result.success(retValue);
                    break;
                }

                case "subscribeStream": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.subscribeStream(userId, type);

                    result.success(retValue);
                    break;
                }

                case "subscribeAllStreams": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.subscribeAllStreams(type);

                    result.success(retValue);
                    break;
                }

                case "unsubscribeStream": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.unsubscribeStream(userId, type);

                    result.success(retValue);
                    break;
                }

                case "unsubscribeAllStreams": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.unsubscribeAllStreams(type);

                    result.success(retValue);
                    break;
                }

                case "subscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.subscribeScreen(userId, type);

                    result.success(retValue);
                    break;
                }

                case "unsubscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retValue = room.unsubscribeScreen(userId, type);

                    result.success(retValue);
                    break;
                }

                case "pauseAllSubscribedStream": {
                    PauseResumeControlMediaType mediaType = RTCType.toPauseResumeControlMediaType(arguments.optInt("mediaType"));
                    int retValue = room.pauseAllSubscribedStream(mediaType);

                    result.success(retValue);
                    break;
                }

                case "resumeAllSubscribedStream": {
                    PauseResumeControlMediaType mediaType = RTCType.toPauseResumeControlMediaType(arguments.optInt("mediaType"));
                    int retValue = room.resumeAllSubscribedStream(mediaType);

                    result.success(retValue);
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
                    int retValue = room.startForwardStreamToRooms(forwardStreamInfos);

                    result.success(retValue);
                    break;
                }

                case "updateForwardStreamToRooms": {
                    List<ForwardStreamInfo> forwardStreamInfos = RTCType.toForwardStreamInfoList(arguments.getList("forwardStreamInfos"));
                    int retValue = room.updateForwardStreamToRooms(forwardStreamInfos);

                    result.success(retValue);
                    break;
                }

                case "stopForwardStreamToRooms": {
                    int retValue = room.stopForwardStreamToRooms();

                    result.success(retValue);
                    break;
                }

                case "pauseForwardStreamToAllRooms": {
                    int retValue = room.pauseForwardStreamToAllRooms();

                    result.success(retValue);
                    break;
                }

                case "resumeForwardStreamToAllRooms": {
                    int retValue = room.resumeForwardStreamToAllRooms();

                    result.success(retValue);
                    break;
                }

                case "setRemoteRoomAudioPlaybackVolume": {
                    int volume = arguments.optInt("volume");
                    int retValue = room.setRemoteRoomAudioPlaybackVolume(volume);

                    result.success(retValue);
                    break;
                }

                case "setAudioSelectionConfig": {
                    int retValue = room.setAudioSelectionConfig(RTCType.toAudioSelectionPriority(arguments.optInt("audioSelectionPriority")));
                    result.success(retValue);
                    break;
                }

                case "setRoomExtraInfo": {
                    long retValue = room.setRoomExtraInfo(
                            arguments.optString("key"),
                            arguments.optString("value"));
                    result.success(retValue);
                    break;
                }

                case "startSubtitle": {
                    int retValue = room.startSubtitle(RTCType.toSubtitleConfig(arguments.optBox("subtitleConfig")));
                    result.success(retValue);
                    break;
                }

                case "stopSubtitle": {
                    int retValue = room.stopSubtitle();
                    result.success(retValue);
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

