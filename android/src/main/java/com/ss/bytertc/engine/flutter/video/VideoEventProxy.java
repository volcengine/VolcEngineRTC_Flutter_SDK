/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.SysStats;
import com.ss.bytertc.engine.data.AudioMixingError;
import com.ss.bytertc.engine.data.AudioMixingState;
import com.ss.bytertc.engine.data.AudioRoute;
import com.ss.bytertc.engine.data.LocalAudioPropertiesInfo;
import com.ss.bytertc.engine.data.LocalAudioStreamError;
import com.ss.bytertc.engine.data.LocalAudioStreamState;
import com.ss.bytertc.engine.data.RecordingInfo;
import com.ss.bytertc.engine.data.RecordingProgress;
import com.ss.bytertc.engine.data.RemoteAudioPropertiesInfo;
import com.ss.bytertc.engine.data.RemoteAudioState;
import com.ss.bytertc.engine.data.RemoteAudioStateChangeReason;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.data.StreamSycnInfoConfig;
import com.ss.bytertc.engine.data.VideoFrameInfo;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.handler.IRTCVideoEventHandler;
import com.ss.bytertc.engine.type.AudioDeviceType;
import com.ss.bytertc.engine.type.EchoTestResult;
import com.ss.bytertc.engine.type.FirstFramePlayState;
import com.ss.bytertc.engine.type.FirstFrameSendState;
import com.ss.bytertc.engine.type.LocalVideoStreamError;
import com.ss.bytertc.engine.type.LocalVideoStreamState;
import com.ss.bytertc.engine.type.NetworkDetectionLinkType;
import com.ss.bytertc.engine.type.NetworkDetectionStopReason;
import com.ss.bytertc.engine.type.PerformanceAlarmMode;
import com.ss.bytertc.engine.type.PerformanceAlarmReason;
import com.ss.bytertc.engine.type.PublicStreamErrorCode;
import com.ss.bytertc.engine.type.RecordingErrorCode;
import com.ss.bytertc.engine.type.RecordingState;
import com.ss.bytertc.engine.type.RemoteStreamSwitch;
import com.ss.bytertc.engine.type.RemoteVideoState;
import com.ss.bytertc.engine.type.RemoteVideoStateChangeReason;
import com.ss.bytertc.engine.type.RtcUser;
import com.ss.bytertc.engine.type.SEIStreamUpdateEvent;
import com.ss.bytertc.engine.type.SourceWantedData;
import com.ss.bytertc.engine.type.VideoDeviceType;
import com.ss.bytertc.engine.utils.LogUtil;

import org.json.JSONObject;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class VideoEventProxy extends IRTCVideoEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    /**
     * Enable SysStats to Flutter
     * For performance reason
     *
     * @see #onSysStats(SysStats)
     * @see #setSwitches(String, boolean)
     */
    private boolean enableSysStats = false;

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_video_event");
    }

    public void onLoggerMessage(LogUtil.LogLevel level, String msg, Throwable throwable) {
        // Ignored
    }

    public void onWarning(int warn) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("code", warn);
        emitter.emit("onWarning", map);
    }

    public void onError(int err) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("code", err);
        emitter.emit("onError", map);
    }

    public void onSysStats(SysStats stats) {
        if (!enableSysStats) {
            return;
        }
        final HashMap<String, Object> map = new HashMap<>();
        map.put("stats", RTCMap.from(stats));
        emitter.emit("onSysStats", map);
    }

    public void onNetworkTypeChanged(int type) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("type", type);
        emitter.emit("onNetworkTypeChanged", map);
    }


    public void onUserStartVideoCapture(String roomId, String uid) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        emitter.emit("onUserStartVideoCapture", map);
    }

    public void onUserStopVideoCapture(String roomId, String uid) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        emitter.emit("onUserStopVideoCapture", map);
    }

    public void onCreateRoomStateChanged(String roomId, int errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("errorCode", errorCode);
        emitter.emit("onCreateRoomStateChanged", map);
    }

    public void onUserStartAudioCapture(String roomId, String uid) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        emitter.emit("onUserStartAudioCapture", map);
    }

    public void onUserStopAudioCapture(String roomId, String uid) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        emitter.emit("onUserStopAudioCapture", map);
    }

    public void onLocalAudioStateChanged(LocalAudioStreamState state, LocalAudioStreamError error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state.value());
        map.put("error", error.value());
        emitter.emit("onLocalAudioStateChanged", map);
    }

    public void onRemoteAudioStateChanged(RemoteStreamKey key, RemoteAudioState state, RemoteAudioStateChangeReason reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(key));
        map.put("state", state.value());
        map.put("reason", reason.value());
        emitter.emit("onRemoteAudioStateChanged", map);
    }

    public void onLocalVideoStateChanged(StreamIndex streamIndex, LocalVideoStreamState state, LocalVideoStreamError error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("index", streamIndex.value());
        map.put("state", state.value());
        map.put("error", error.value());
        emitter.emit("onLocalVideoStateChanged", map);
    }

    public void onRemoteVideoStateChanged(RemoteStreamKey streamKey, RemoteVideoState videoState, RemoteVideoStateChangeReason videoStateReason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(streamKey));
        map.put("state", videoState.value());
        map.put("reason", videoStateReason.value());
        emitter.emit("onRemoteVideoStateChanged", map);
    }

    public void onFirstRemoteVideoFrameRendered(RemoteStreamKey remoteStreamKey, VideoFrameInfo frameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        map.put("videoFrame", RTCMap.from(frameInfo));
        emitter.emit("onFirstRemoteVideoFrameRendered", map);
    }

    public void onFirstRemoteVideoFrameDecoded(RemoteStreamKey remoteStreamKey, VideoFrameInfo frameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        map.put("videoFrame", RTCMap.from(frameInfo));
        emitter.emit("onFirstRemoteVideoFrameDecoded", map);
    }

    public void onFirstLocalVideoFrameCaptured(StreamIndex streamIndex, VideoFrameInfo frameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("index", streamIndex.value());
        map.put("videoFrame", RTCMap.from(frameInfo));
        emitter.emit("onFirstLocalVideoFrameCaptured", map);
    }

    public void onLocalVideoSizeChanged(StreamIndex streamIndex, VideoFrameInfo frameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("index", streamIndex.value());
        map.put("videoFrame", RTCMap.from(frameInfo));
        emitter.emit("onLocalVideoSizeChanged", map);
    }

    public void onRemoteVideoSizeChanged(RemoteStreamKey remoteStreamKey, VideoFrameInfo frameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        map.put("videoFrame", RTCMap.from(frameInfo));
        emitter.emit("onRemoteVideoSizeChanged", map);
    }

    public void onConnectionStateChanged(int state, int reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state);
        map.put("reason", reason);
        emitter.emit("onConnectionStateChanged", map);
    }

    public void onAudioRouteChanged(AudioRoute route) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("route", route.value());
        emitter.emit("onAudioRouteChanged", map);
    }

    public void onFirstLocalAudioFrame(StreamIndex streamIndex) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("index", streamIndex.value());
        emitter.emit("onFirstLocalAudioFrame", map);
    }

    public void onFirstRemoteAudioFrame(RemoteStreamKey remoteStreamKey) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        emitter.emit("onFirstRemoteAudioFrame", map);
    }

    public void onLogReport(String logType, JSONObject logContent) {
        // Ignored
    }

    public void onSEIMessageReceived(RemoteStreamKey remoteStreamKey, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        map.put("message", message.array());
        emitter.emit("onSEIMessageReceived", map);
    }

    public void onSEIStreamUpdate(RemoteStreamKey remoteStreamKey, SEIStreamUpdateEvent event) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(remoteStreamKey));
        map.put("event", event.value());
        emitter.emit("onSEIStreamUpdate", map);
    }

    public void onLoginResult(String uid, int error_code, int elapsed) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("errorCode", error_code);
        map.put("elapsed", elapsed);
        emitter.emit("onLoginResult", map);
    }

    public void onLogout() {
        final HashMap<String, Object> map = new HashMap<>();
        emitter.emit("onLogout", map);
    }

    public void onServerParamsSetResult(int error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", error);
        emitter.emit("onServerParamsSetResult", map);
    }

    public void onGetPeerOnlineStatus(String peerUserId, int status) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", peerUserId);
        map.put("status", status);
        emitter.emit("onGetPeerOnlineStatus", map);
    }

    public void onUserMessageReceivedOutsideRoom(String uid, String message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message);
        emitter.emit("onUserMessageReceivedOutsideRoom", map);
    }

    public void onUserBinaryMessageReceivedOutsideRoom(String uid, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", uid);
        map.put("message", message.array());
        emitter.emit("onUserBinaryMessageReceivedOutsideRoom", map);
    }

    public void onUserMessageSendResultOutsideRoom(long msgid, int error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("msgid", msgid);
        map.put("error", error);
        emitter.emit("onUserMessageSendResultOutsideRoom", map);
    }

    public void onServerMessageSendResult(long msgid, int error, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("msgid", msgid);
        map.put("error", error);
        map.put("message", message.array());
        emitter.emit("onServerMessageSendResult", map);
    }

    public void onNetworkDetectionResult(NetworkDetectionLinkType type, int quality, int rtt, double lost_rate, int bitrate, int jitter) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("type", type.value());
        map.put("quality", quality);
        map.put("rtt", rtt);
        map.put("lostRate", lost_rate);
        map.put("bitrate", bitrate);
        map.put("jitter", jitter);
        emitter.emit("onNetworkDetectionResult", map);
    }

    public void onNetworkDetectionStopped(NetworkDetectionStopReason reason) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("reason", reason.value());
        emitter.emit("onNetworkDetectionStopped", map);
    }

    public void onSimulcastSubscribeFallback(RemoteStreamSwitch event) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("event", RTCMap.from(event));
        emitter.emit("onSimulcastSubscribeFallback", map);
    }

    public void onPerformanceAlarms(PerformanceAlarmMode mode, String roomId, PerformanceAlarmReason reason, SourceWantedData data) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("mode", mode.ordinal());
        map.put("roomId", roomId);
        map.put("reason", reason.ordinal());
        map.put("data", RTCMap.from(data));
        emitter.emit("onPerformanceAlarms", map);
    }

    public void onAudioFrameSendStateChanged(String roomId, RtcUser user, FirstFrameSendState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onAudioFrameSendStateChanged", map);
    }

    public void onVideoFrameSendStateChanged(String roomId, RtcUser user, FirstFrameSendState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onVideoFrameSendStateChanged", map);
    }

    public void onScreenVideoFrameSendStateChanged(String roomId, RtcUser user, FirstFrameSendState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onScreenVideoFrameSendStateChanged", map);
    }

    public void onAudioFramePlayStateChanged(String roomId, RtcUser user, FirstFramePlayState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onAudioFramePlayStateChanged", map);
    }

    public void onVideoFramePlayStateChanged(String roomId, RtcUser user, FirstFramePlayState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onVideoFramePlayStateChanged", map);
    }

    public void onScreenVideoFramePlayStateChanged(String roomId, RtcUser user, FirstFramePlayState state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("userInfo", RTCMap.from(user));
        map.put("state", state.value());
        emitter.emit("onScreenVideoFramePlayStateChanged", map);
    }


    public void onAudioDeviceStateChanged(String device_id, AudioDeviceType device_type, int device_state, int device_error) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceId", device_id);
        map.put("deviceType", device_type.value());
        map.put("deviceState", device_state);
        map.put("deviceError", device_error);
        emitter.emit("onAudioDeviceStateChanged", map);
    }

    public void onVideoDeviceStateChanged(String device_id, VideoDeviceType device_type, int device_state, int device_error) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceId", device_id);
        map.put("deviceType", device_type.value());
        map.put("deviceState", device_state);
        map.put("deviceError", device_error);
        emitter.emit("onVideoDeviceStateChanged", map);
    }

    public void onAudioDeviceWarning(String device_id, AudioDeviceType device_type, int device_warning) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceId", device_id);
        map.put("deviceType", device_type.value());
        map.put("deviceWarning", device_warning);
        emitter.emit("onAudioDeviceWarning", map);
    }

    public void onVideoDeviceWarning(String device_id, VideoDeviceType device_type, int device_warning) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("deviceId", device_id);
        map.put("deviceType", device_type.value());
        map.put("deviceWarning", device_warning);
        emitter.emit("onVideoDeviceWarning", map);
    }

    public void onHttpProxyState(int state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state);
        emitter.emit("onHttpProxyState", map);
    }

    public void onHttpsProxyState(int state) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state);
        emitter.emit("onHttpsProxyState", map);
    }

    public void onSocks5ProxyState(int state, String cmd, String proxy_address, String local_address, String remote_address) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("state", state);
        map.put("cmd", cmd);
        map.put("proxyAddress", proxy_address);
        map.put("localAddress", local_address);
        map.put("remoteAddress", remote_address);
        emitter.emit("onSocks5ProxyState", map);
    }

    public void onRecordingStateUpdate(StreamIndex type, RecordingState state, RecordingErrorCode errorCode, RecordingInfo info) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("type", type.value());
        map.put("state", state.value());
        map.put("errorCode", errorCode.value());
        map.put("info", RTCMap.from(info));
        emitter.emit("onRecordingStateUpdate", map);
    }

    public void onRecordingProgressUpdate(StreamIndex type, RecordingProgress progress, RecordingInfo info) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("type", type.value());
        map.put("progress", RTCMap.from(progress));
        map.put("info", RTCMap.from(info));
        emitter.emit("onRecordingProgressUpdate", map);
    }

    public void onAudioMixingStateChanged(int mixId, AudioMixingState state, AudioMixingError error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("mixId", mixId);
        map.put("state", state.value());
        map.put("error", error.value());
        emitter.emit("onAudioMixingStateChanged", map);
    }

    public void onAudioMixingPlayingProgress(int mixId, long progress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("mixId", mixId);
        map.put("progress", progress);
        emitter.emit("onAudioMixingPlayingProgress", map);
    }

    public void onLocalAudioPropertiesReport(LocalAudioPropertiesInfo[] audioPropertiesInfos) {
        ArrayList<HashMap<String, Object>> list = new ArrayList<>();
        for (LocalAudioPropertiesInfo info : audioPropertiesInfos) {
            HashMap<String, Object> obj = new HashMap<>();
            obj.put("type", info.streamIndex.value());
            obj.put("audioPropertiesInfo", RTCMap.from(info.audioPropertiesInfo));
            list.add(obj);
        }

        final HashMap<String, Object> map = new HashMap<>();
        map.put("infos", list);
        emitter.emit("onLocalAudioPropertiesReport", map);
    }

    public void onRemoteAudioPropertiesReport(RemoteAudioPropertiesInfo[] audioPropertiesInfos, int totalRemoteVolume) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("infos", RTCMap.from(audioPropertiesInfos));
        map.put("totalRemoteVolume", totalRemoteVolume);
        emitter.emit("onRemoteAudioPropertiesReport", map);
    }

    public void onActiveSpeaker(String roomId, String uid) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("uid", uid);
        emitter.emit("onActiveSpeaker", map);
    }

    public void onStreamSyncInfoReceived(RemoteStreamKey streamKey, StreamSycnInfoConfig.SyncInfoStreamType streamType, ByteBuffer data) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("streamKey", RTCMap.from(streamKey));
        map.put("streamType", streamType.ordinal());
        map.put("data", data.array());
        emitter.emit("onStreamSyncInfoReceived", map);
    }

    public void onPushPublicStreamResult(String roomId, String publicStreamId, PublicStreamErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", roomId);
        map.put("publicStreamId", publicStreamId);
        map.put("errorCode", errorCode.value());
        emitter.emit("onPushPublicStreamResult", map);
    }

    public void onPlayPublicStreamResult(String publicStreamId, PublicStreamErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("publicStreamId", publicStreamId);
        map.put("errorCode", errorCode.value());
        emitter.emit("onPlayPublicStreamResult", map);
    }

    public void onPublicStreamSEIMessageReceived(String publicStreamId, ByteBuffer message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("publicStreamId", publicStreamId);
        map.put("message", message.array());
        emitter.emit("onPublicStreamSEIMessageReceived", map);
    }

    public void onFirstPublicStreamVideoFrameDecoded(String publicStreamId, VideoFrameInfo videoFrameInfo) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("publicStreamId", publicStreamId);
        map.put("videoFrame", RTCMap.from(videoFrameInfo));
        emitter.emit("onFirstPublicStreamVideoFrameDecoded", map);
    }

    public void onFirstPublicStreamAudioFrame(String publicStreamId) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("publicStreamId", publicStreamId);
        emitter.emit("onFirstPublicStreamAudioFrame", map);
    }

    public void onEchoTestResult(EchoTestResult result) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("result", result.value());
        emitter.emit("onEchoTestResult", map);
    }

    public void onCloudProxyConnected(int interval) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("interval", interval);
        emitter.emit("onCloudProxyConnected", map);
    }


    void setSwitches(RTCTypeBox box) {
        enableSysStats = box.optBoolean("enableSysStats", enableSysStats);
    }
}
