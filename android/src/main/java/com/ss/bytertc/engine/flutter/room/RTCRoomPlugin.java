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
                    room.setMultiDeviceAVSync(audioUserId);

                    result.success(null);
                    break;
                }

                case "leaveRoom": {
                    room.leaveRoom();

                    result.success(null);
                    break;
                }

                case "updateToken": {
                    String token = arguments.optString("token");
                    int retCode = room.updateToken(token);

                    result.success(retCode);
                    break;
                }

                case "setRemoteVideoConfig": {
                    String userId = arguments.optString("uid");
                    RemoteVideoConfig remoteVideoConfig = RTCType.toRemoteVideoConfig(arguments.optBox("videoConfig"));
                    int retCode = room.setRemoteVideoConfig(userId, remoteVideoConfig);

                    result.success(retCode);
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
                    int retCode = room.subscribeStream(userId, type);

                    result.success(retCode);
                    break;
                }

                case "subscribeAllStreams": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retCode = room.subscribeAllStreams(type);

                    result.success(retCode);
                    break;
                }

                case "unsubscribeStream": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retCode = room.unsubscribeStream(userId, type);

                    result.success(retCode);
                    break;
                }

                case "unsubscribeAllStreams": {
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retCode = room.unsubscribeAllStreams(type);

                    result.success(retCode);
                    break;
                }

                case "subscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retCode = room.subscribeScreen(userId, type);

                    result.success(retCode);
                    break;
                }

                case "unsubscribeScreen": {
                    String userId = arguments.optString("uid");
                    MediaStreamType type = RTCType.toMediaStreamType(arguments.optInt("type"));
                    int retCode = room.unsubscribeScreen(userId, type);

                    result.success(retCode);
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
                    int retCode = room.startForwardStreamToRooms(forwardStreamInfos);

                    result.success(retCode);
                    break;
                }

                case "updateForwardStreamToRooms": {
                    List<ForwardStreamInfo> forwardStreamInfos = RTCType.toForwardStreamInfoList(arguments.getList("forwardStreamInfos"));
                    int retCode = room.updateForwardStreamToRooms(forwardStreamInfos);

                    result.success(retCode);
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

                case "setRemoteRoomAudioPlaybackVolume": {
                    int volume = arguments.optInt("volume");
                    room.setRemoteRoomAudioPlaybackVolume(volume);

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

