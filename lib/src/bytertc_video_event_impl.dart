// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_event_define.dart';
import '../api/bytertc_video_event_handler.dart';
import 'base/bytertc_event_serialize.dart';

class RTCVideoEventValue {
  void Function(Map<String, dynamic>)? _valueObserver;

  set valueObserver(Function(Map<String, dynamic>)? valueObserver) {
    _valueObserver = valueObserver;
    if (valueObserver == null) return;
    _valueObserver?.call({'enableSysStats': onSysStats != null});
  }

  OnSysStatsType? _onSysStats;

  OnSysStatsType? get onSysStats => _onSysStats;

  set onSysStats(OnSysStatsType? onSysStats) {
    _onSysStats = onSysStats;
    _valueObserver?.call({'enableSysStats': onSysStats != null});
  }
}

extension RTCVideoEventProcessor on RTCVideoEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onWarning':
        final data = OnWarningData.fromMap(dic);
        onWarning?.call(data.code);
        break;
      case 'onError':
        final data = OnErrorData.fromMap(dic);
        onError?.call(data.code);
        break;
      case 'onCreateRoomStateChanged':
        final data = OnCreateRoomStateChangedData.fromMap(dic);
        onCreateRoomStateChanged?.call(data.roomId, data.errorCode);
        break;
      case 'onConnectionStateChanged':
        final data = OnConnectionStateChangedData.fromMap(dic);
        onConnectionStateChanged?.call(data.state);
        break;
      case 'onNetworkTypeChanged':
        final data = OnNetworkTypeChangedData.fromMap(dic);
        onNetworkTypeChanged?.call(data.type);
        break;
      case 'onUserStartAudioCapture':
        final data = OnUserOperateMediaCaptureData.fromMap(dic);
        onUserStartAudioCapture?.call(data.roomId, data.uid);
        break;
      case 'onUserStopAudioCapture':
        final data = OnUserOperateMediaCaptureData.fromMap(dic);
        onUserStopAudioCapture?.call(data.roomId, data.uid);
        break;
      case 'onFirstLocalAudioFrame':
        final data = OnFirstLocalAudioFrameData.fromMap(dic);
        onFirstLocalAudioFrame?.call(data.index);
        break;
      case 'onFirstRemoteAudioFrame':
        final data = OnFirstRemoteAudioFrameData.fromMap(dic);
        onFirstRemoteAudioFrame?.call(data.streamKey);
        break;
      case 'onLocalAudioPropertiesReport':
        final data = OnLocalAudioPropertiesReportData.fromMap(dic);
        onLocalAudioPropertiesReport?.call(data.audioPropertiesInfos);
        break;
      case 'onRemoteAudioPropertiesReport':
        final data = OnRemoteAudioPropertiesReportData.fromMap(dic);
        onRemoteAudioPropertiesReport?.call(
            data.audioPropertiesInfos, data.totalRemoteVolume);
        break;
      case 'onActiveSpeaker':
        final data = OnActiveSpeakerData.fromMap(dic);
        onActiveSpeaker?.call(data.roomId, data.uid);
        break;
      case 'onUserStartVideoCapture':
        final data = OnUserOperateMediaCaptureData.fromMap(dic);
        onUserStartVideoCapture?.call(data.roomId, data.uid);
        break;
      case 'onUserStopVideoCapture':
        final data = OnUserOperateMediaCaptureData.fromMap(dic);
        onUserStopVideoCapture?.call(data.roomId, data.uid);
        break;
      case 'onFirstLocalVideoFrameCaptured':
        final data = OnFirstLocalVideoFrameCapturedData.fromMap(dic);
        onFirstLocalVideoFrameCaptured?.call(data.index, data.videoFrameInfo);
        break;
      case 'onFirstRemoteVideoFrameRendered':
        final data = OnFirstRemoteVideoFrameRenderedData.fromMap(dic);
        onFirstRemoteVideoFrameRendered?.call(
            data.streamKey, data.videoFrameInfo);
        break;
      case 'onFirstRemoteVideoFrameDecoded':
        final data = OnFirstRemoteVideoFrameRenderedData.fromMap(dic);
        onFirstRemoteVideoFrameDecoded?.call(
            data.streamKey, data.videoFrameInfo);
        break;
      case 'onRemoteVideoSizeChanged':
        final data = OnRemoteVideoSizeChangedData.fromMap(dic);
        onRemoteVideoSizeChanged?.call(data.streamKey, data.videoFrameInfo);
        break;
      case 'onLocalVideoSizeChanged':
        final data = OnLocalVideoSizeChangedData.fromMap(dic);
        onLocalVideoSizeChanged?.call(data.streamIndex, data.videoFrameInfo);
        break;
      case 'onAudioDeviceStateChanged':
        final data = OnAudioDeviceStateChangedData.fromMap(dic);
        onAudioDeviceStateChanged?.call(
            data.deviceId, data.deviceType, data.deviceState, data.deviceError);
        break;
      case 'onVideoDeviceStateChanged':
        final data = OnVideoDeviceStateChangedData.fromMap(dic);
        onVideoDeviceStateChanged?.call(
            data.deviceId, data.deviceType, data.deviceState, data.deviceError);
        break;
      case 'onAudioDeviceWarning':
        final data = OnAudioDeviceWarningData.fromMap(dic);
        onAudioDeviceWarning?.call(
            data.deviceId, data.deviceType, data.deviceWarning);
        break;
      case 'onVideoDeviceWarning':
        final data = OnVideoDeviceWarningData.fromMap(dic);
        onVideoDeviceWarning?.call(
            data.deviceId, data.deviceType, data.deviceWarning);
        break;
      case 'onAudioFrameSendStateChanged':
        final data = OnMediaFrameSendStateChangedData.fromMap(dic);
        onAudioFrameSendStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onVideoFrameSendStateChanged':
        final data = OnMediaFrameSendStateChangedData.fromMap(dic);
        onVideoFrameSendStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onScreenVideoFrameSendStateChanged':
        final data = OnMediaFrameSendStateChangedData.fromMap(dic);
        onScreenVideoFrameSendStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onAudioFramePlayStateChanged':
        final data = OnMediaFramePlayStateChangedData.fromMap(dic);
        onAudioFramePlayStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onVideoFramePlayStateChanged':
        final data = OnMediaFramePlayStateChangedData.fromMap(dic);
        onVideoFramePlayStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onScreenVideoFramePlayStateChanged':
        final data = OnMediaFramePlayStateChangedData.fromMap(dic);
        onScreenVideoFramePlayStateChanged?.call(
            data.roomId, data.userInfo, data.state);
        break;
      case 'onAudioRouteChanged':
        final data = OnAudioRouteChangedData.fromMap(dic);
        onAudioRouteChanged?.call(data.route);
        break;
      case 'onSEIMessageReceived':
        final data = OnSEIMessageReceivedData.fromMap(dic);
        onSEIMessageReceived?.call(data.streamKey, data.message);
        break;
      case 'onSEIStreamUpdate':
        final data = OnSEIStreamUpdateData.fromMap(dic);
        onSEIStreamUpdate?.call(data.streamKey, data.event);
        break;
      case 'onStreamSyncInfoReceived':
        final data = OnStreamSyncInfoReceivedData.fromMap(dic);
        onStreamSyncInfoReceived?.call(
            data.streamKey, data.streamType, data.data);
        break;
      case 'onSysStats':
        final data = OnSysStatsData.fromMap(dic);
        onSysStats?.call(data.stats);
        break;
      case 'onLocalAudioStateChanged':
        final data = OnLocalAudioStateChangedData.fromMap(dic);
        onLocalAudioStateChanged?.call(data.state, data.error);
        break;
      case 'onRemoteAudioStateChanged':
        final data = OnRemoteAudioStateChangedData.fromMap(dic);
        onRemoteAudioStateChanged?.call(
            data.streamKey, data.state, data.reason);
        break;
      case 'onLocalVideoStateChanged':
        final data = OnLocalVideoStateChangedData.fromMap(dic);
        onLocalVideoStateChanged?.call(data.index, data.state, data.error);
        break;
      case 'onRemoteVideoStateChanged':
        final data = OnRemoteVideoStateChangedData.fromMap(dic);
        onRemoteVideoStateChanged?.call(
            data.streamKey, data.state, data.reason);
        break;
      case 'onLoginResult':
        final data = OnLoginResultData.fromMap(dic);
        onLoginResult?.call(data.uid, data.errorCode, data.elapsed);
        break;
      case 'onLogout':
        onLogout?.call();
        break;
      case 'onServerParamsSetResult':
        final data = OnServerParamsSetResultData.fromMap(dic);
        onServerParamsSetResult?.call(data.error);
        break;
      case 'onGetPeerOnlineStatus':
        final data = OnGetPeerOnlineStatusData.fromMap(dic);
        onGetPeerOnlineStatus?.call(data.peerUid, data.status);
        break;
      case 'onUserMessageReceivedOutsideRoom':
        final data = OnMessageReceivedData.fromMap(dic);
        onUserMessageReceivedOutsideRoom?.call(data.uid, data.message);
        break;
      case 'onUserBinaryMessageReceivedOutsideRoom':
        final data = OnBinaryMessageReceivedData.fromMap(dic);
        onUserBinaryMessageReceivedOutsideRoom?.call(data.uid, data.message);
        break;
      case 'onUserMessageSendResultOutsideRoom':
        final data = OnMessageSendResultData.fromMap(dic);
        onUserMessageSendResultOutsideRoom?.call(data.msgid, data.error);
        break;
      case 'onServerMessageSendResult':
        final data = OnServerMessageSendResultData.fromMap(dic);
        onServerMessageSendResult?.call(data.msgid, data.error, data.message);
        break;
      case 'onNetworkDetectionResult':
        final data = OnNetworkDetectionResultData.fromMap(dic);
        onNetworkDetectionResult?.call(data.type, data.quality, data.rtt,
            data.lostRate, data.bitrate, data.jitter);
        break;
      case 'onNetworkDetectionStopped':
        final data = OnNetworkDetectionStoppedData.fromMap(dic);
        onNetworkDetectionStopped?.call(data.reason);
        break;
      case 'onAudioMixingStateChanged':
        final data = OnAudioMixingStateChangedData.fromMap(dic);
        onAudioMixingStateChanged?.call(data.mixId, data.state, data.error);
        break;
      case 'onAudioMixingPlayingProgress':
        final data = OnAudioMixingPlayingProgressData.fromMap(dic);
        onAudioMixingPlayingProgress?.call(data.mixId, data.progress);
        break;
      case 'onPerformanceAlarms':
        final data = OnPerformanceAlarmsData.fromMap(dic);
        onPerformanceAlarms?.call(
            data.mode, data.roomId, data.reason, data.data);
        break;
      case 'onSimulcastSubscribeFallback':
        final data = OnSimulcastSubscribeFallbackData.fromMap(dic);
        onSimulcastSubscribeFallback?.call(data.event);
        break;
      case 'onHttpProxyState':
        final data = OnHttpProxyStateData.fromMap(dic);
        onHttpProxyState?.call(data.state);
        break;
      case 'onHttpsProxyState':
        final data = OnHttpsProxyStateData.fromMap(dic);
        onHttpsProxyState?.call(data.state);
        break;
      case 'onSocks5ProxyState':
        final data = OnSocks5ProxyStateData.fromMap(dic);
        onSocks5ProxyState?.call(data.state, data.cmd, data.proxyAddress,
            data.localAddress, data.remoteAddress);
        break;
      case 'onRecordingStateUpdate':
        final data = OnRecordingStateUpdateData.fromMap(dic);
        onRecordingStateUpdate?.call(
            data.type, data.state, data.errorCode, data.info);
        break;
      case 'onRecordingProgressUpdate':
        final data = OnRecordingProgressUpdateData.fromMap(dic);
        onRecordingProgressUpdate?.call(data.type, data.progress, data.info);
        break;
      case 'onPushPublicStreamResult':
        final data = OnPushPublicStreamResultData.fromMap(dic);
        onPushPublicStreamResult?.call(
            data.roomId, data.publicStreamId, data.errorCode);
        break;
      case 'onPlayPublicStreamResult':
        final data = OnPlayPublicStreamResultData.fromMap(dic);
        onPlayPublicStreamResult?.call(data.publicStreamId, data.errorCode);
        break;
      case 'onPublicStreamSEIMessageReceived':
        final data = OnPublicStreamSEIMessageReceivedData.fromMap(dic);
        onPublicStreamSEIMessageReceived?.call(
            data.publicStreamId, data.message);
        break;
      case 'onFirstPublicStreamVideoFrameDecoded':
        final data = OnFirstPublicStreamVideoFrameDecodedData.fromMap(dic);
        onFirstPublicStreamVideoFrameDecoded?.call(
            data.publicStreamId, data.videoFrameInfo);
        break;
      case 'onFirstPublicStreamAudioFrame':
        final data = OnFirstPublicStreamAudioFrameData.fromMap(dic);
        onFirstPublicStreamAudioFrame?.call(data.publicStreamId);
        break;
      case 'onCloudProxyConnected':
        final data = OnCloudProxyConnectedData.fromMap(dic);
        onCloudProxyConnected?.call(data.interval);
        break;
      case 'onEchoTestResult':
        final data = OnEchoTestResultData.fromMap(dic);
        onEchoTestResult?.call(data.result);
        break;
      default:
        break;
    }
  }
}
