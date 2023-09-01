/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.room;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.SubscribeConfig;
import com.ss.bytertc.engine.UserInfo;
import com.ss.bytertc.engine.data.AVSyncState;
import com.ss.bytertc.engine.data.ForwardStreamEventInfo;
import com.ss.bytertc.engine.data.ForwardStreamStateInfo;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.handler.IRTCRoomEventHandler;
import com.ss.bytertc.engine.type.LocalStreamStats;
import com.ss.bytertc.engine.type.MediaStreamType;
import com.ss.bytertc.engine.type.NetworkQualityStats;
import com.ss.bytertc.engine.type.RTCRoomStats;
import com.ss.bytertc.engine.type.RemoteStreamStats;
import com.ss.bytertc.engine.type.SetRoomExtraInfoResult;
import com.ss.bytertc.engine.type.StreamRemoveReason;
import com.ss.bytertc.engine.type.SubtitleErrorCode;
import com.ss.bytertc.engine.type.SubtitleMessage;
import com.ss.bytertc.engine.type.SubtitleState;
import com.ss.bytertc.engine.type.UserVisibilityChangeError;

import java.nio.ByteBuffer;
import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCRoomEventProxy extends IRTCRoomEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    /**
     * Enable SysStats to Flutter
     * For performance reason
     *
     * @see #onRoomStats(RTCRoomStats)
     * @see #setSwitch(RTCTypeBox)
     */
    private boolean enableRoomStats = false;
    /**
     * Enable SysStats to Flutter
     * For performance reason
     *
     * @see #onLocalStreamStats(LocalStreamStats)
     * @see #setSwitch(RTCTypeBox)
     */
    private boolean enableLocalStreamStats = false;
    /**
     * Enable onRemoteStreamStats to Flutter
     * For performance reason
     *
     * @see #onRemoteStreamStats(RemoteStreamStats)
     * @see #setSwitch(RTCTypeBox)
     */
    private boolean enableRemoteStreamStats = false;
    /**
     * Enable onNetworkQuality to Flutter
     * For performance reason
     *
     * @see #onNetworkQuality(NetworkQualityStats, NetworkQualityStats[])
     * @see #setSwitch(RTCTypeBox)
     */
    private boolean enableNetworkQualityStats = false;

    public void registerEvent(BinaryMessenger binaryMessenger, int instanceId) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_room_event" + instanceId);
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onLeaveRoom(RTCRoomStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stats", RTCMap.from(stats));
        emitter.emit("onLeaveRoom", map);
    }

    @Override
    public void onRoomStateChanged(String roomId, String uid, int state, String extraInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        map.put("state", state);
        map.put("extraInfo", extraInfo);
        emitter.emit("onRoomStateChanged", map);
    }

    @Override
    public void onStreamStateChanged(String roomId, String uid, int state, String extraInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        map.put("state", state);
        map.put("extraInfo", extraInfo);
        emitter.emit("onStreamStateChanged", map);
    }

    @Override
    public void onAVSyncStateChange(AVSyncState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state.value());
        emitter.emit("onAVSyncStateChange", map);
    }

    @Override
    public void onRoomStats(RTCRoomStats stats) {
        if (!enableRoomStats) {
            return;
        }
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stats", RTCMap.from(stats));
        emitter.emit("onRoomStats", map);
    }

    @Override
    public void onUserJoined(UserInfo userInfo, int elapsed) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("userInfo", RTCMap.from(userInfo));
        map.put("elapsed", elapsed);
        emitter.emit("onUserJoined", map);
    }

    @Override
    public void onUserLeave(String uid, int reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("reason", reason);
        emitter.emit("onUserLeave", map);
    }

    @Override
    public void onTokenWillExpire() {
        emitter.emit("onTokenWillExpire", new HashMap<>());
    }

    @Override
    public void onPublishPrivilegeTokenWillExpire() {
        emitter.emit("onPublishPrivilegeTokenWillExpire", new HashMap<>());
    }

    @Override
    public void onSubscribePrivilegeTokenWillExpire() {
        emitter.emit("onSubscribePrivilegeTokenWillExpire", new HashMap<>());
    }

    @Override
    public void onUserPublishStream(String uid, MediaStreamType type) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("type", type.value);
        emitter.emit("onUserPublishStream", map);
    }

    @Override
    public void onUserUnpublishStream(String uid, MediaStreamType type, StreamRemoveReason reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("type", type.value);
        map.put("reason", reason.value());
        emitter.emit("onUserUnpublishStream", map);
    }

    @Override
    public void onUserPublishScreen(String uid, MediaStreamType type) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("type", type.value);
        emitter.emit("onUserPublishScreen", map);
    }

    @Override
    public void onUserUnpublishScreen(String uid, MediaStreamType type, StreamRemoveReason reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("type", type.value);
        map.put("reason", reason.value());
        emitter.emit("onUserUnpublishScreen", map);
    }

    @Override
    public void onLocalStreamStats(LocalStreamStats stats) {
        if (!enableLocalStreamStats) {
            return;
        }
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stats", RTCMap.from(stats));
        emitter.emit("onLocalStreamStats", map);
    }

    @Override
    public void onRemoteStreamStats(RemoteStreamStats stats) {
        if (!enableRemoteStreamStats) {
            return;
        }
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stats", RTCMap.from(stats));
        emitter.emit("onRemoteStreamStats", map);
    }

    @Override
    public void onStreamSubscribed(int stateCode, String userId, SubscribeConfig info) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stateCode", stateCode);
        map.put("uid", userId);
        map.put("info", RTCMap.from(info));
        emitter.emit("onStreamSubscribed", map);
    }

    @Override
    public void onStreamPublishSuccess(String uid, boolean isScreen) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("isScreen", isScreen);
        emitter.emit("onStreamPublishSuccess", map);
    }

    @Override
    public void onRoomMessageReceived(String uid, String message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message);
        emitter.emit("onRoomMessageReceived", map);
    }

    @Override
    public void onRoomBinaryMessageReceived(String uid, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message.array());
        emitter.emit("onRoomBinaryMessageReceived", map);
    }

    @Override
    public void onUserMessageReceived(String uid, String message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message);
        emitter.emit("onUserMessageReceived", map);
    }

    @Override
    public void onUserBinaryMessageReceived(String uid, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message.array());
        emitter.emit("onUserBinaryMessageReceived", map);
    }

    @Override
    public void onUserMessageSendResult(long msgid, int error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("msgid", msgid);
        map.put("error", error);
        emitter.emit("onUserMessageSendResult", map);
    }

    @Override
    public void onRoomMessageSendResult(long msgid, int error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("msgid", msgid);
        map.put("error", error);
        emitter.emit("onRoomMessageSendResult", map);
    }

    @Override
    public void onVideoStreamBanned(String uid, boolean banned) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("banned", banned);
        emitter.emit("onVideoStreamBanned", map);
    }

    @Override
    public void onAudioStreamBanned(String uid, boolean banned) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("banned", banned);
        emitter.emit("onAudioStreamBanned", map);
    }

    @Override
    public void onForwardStreamEvent(ForwardStreamEventInfo[] eventInfos) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("eventInfos", RTCMap.from(eventInfos));
        emitter.emit("onForwardStreamEvent", map);
    }

    @Override
    public void onForwardStreamStateChanged(ForwardStreamStateInfo[] stateInfos) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stateInfos", RTCMap.from(stateInfos));
        emitter.emit("onForwardStreamStateChanged", map);
    }

    @Override
    public void onNetworkQuality(NetworkQualityStats localQuality, NetworkQualityStats[] remoteQualities) {
        if (!enableNetworkQualityStats) {
            return;
        }
        final HashMap<String, Object> map = new HashMap<>();
        map.put("localQuality", RTCMap.from(localQuality));
        map.put("remoteQualities", RTCMap.from(remoteQualities));
        emitter.emit("onNetworkQuality", map);
    }

    @Override
    public void onSetRoomExtraInfoResult(long taskId, SetRoomExtraInfoResult error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("taskId", taskId);
        map.put("error", error.value());
        emitter.emit("onSetRoomExtraInfoResult", map);
    }

    @Override
    public void onRoomExtraInfoUpdate(String key, String value, String lastUpdateUserId, long lastUpdateTimeMs) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("key", key);
        map.put("value",value);
        map.put("lastUpdateUserId",lastUpdateUserId);
        map.put("lastUpdateTimeMs",lastUpdateTimeMs);
        emitter.emit("onRoomExtraInfoUpdate", map);
    }

    @Override
    public void onUserVisibilityChanged(boolean currentUserVisibility, UserVisibilityChangeError errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("currentUserVisibility", currentUserVisibility);
        map.put("errorCode", errorCode.value());
        emitter.emit("onUserVisibilityChanged", map);
    }

    @Override
    public void onSubtitleStateChanged(SubtitleState state, SubtitleErrorCode errorCode, String errorMessage) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state.value());
        map.put("errorCode", errorCode.value());
        map.put("errorMessage",errorMessage);
        emitter.emit("onSubtitleStateChanged", map);
    }

    @Override
    public void onSubtitleMessageReceived(SubtitleMessage[] subtitles) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("subtitles", RTCMap.from(subtitles));
        emitter.emit("onSubtitleMessageReceived", map);
    }

    void setSwitch(RTCTypeBox box) {
        enableNetworkQualityStats = box.optBoolean("enableNetworkQualityStats", enableNetworkQualityStats);
        enableLocalStreamStats = box.optBoolean("enableLocalStreamStats", enableLocalStreamStats);
        enableRemoteStreamStats = box.optBoolean("enableRemoteStreamStats", enableRemoteStreamStats);
        enableRoomStats = box.optBoolean("enableRoomStats", enableRoomStats);
    }
}
