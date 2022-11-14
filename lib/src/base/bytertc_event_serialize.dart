// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:typed_data';
import '../../api/bytertc_audio_defines.dart';
import '../../api/bytertc_common_defines.dart';
import '../../api/bytertc_video_defines.dart';
import 'bytertc_enum_convert.dart';

class OnWarningData {
  final WarningCode code;
  const OnWarningData({required this.code});
  factory OnWarningData.fromMap(Map<dynamic, dynamic> map) {
    return OnWarningData(code: (map['code'] as int).warningCode);
  }
}

class OnErrorData {
  final ErrorCode code;
  const OnErrorData({required this.code});
  factory OnErrorData.fromMap(Map<dynamic, dynamic> map) {
    return OnErrorData(code: (map['code'] as int).errorCode);
  }
}

class OnCreateRoomStateChangedData {
  final String roomId;
  final int errorCode;
  const OnCreateRoomStateChangedData(
      {required this.roomId, required this.errorCode});
  factory OnCreateRoomStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnCreateRoomStateChangedData(
        roomId: map['roomId'] as String, errorCode: map['errorCode'] as int);
  }
}

class OnConnectionStateChangedData {
  final RTCConnectionState state;
  const OnConnectionStateChangedData({required this.state});
  factory OnConnectionStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnConnectionStateChangedData(
        state: (map['state'] as int).connectionState);
  }
}

class OnRoomStateChangedData {
  final String roomId;
  final String uid;
  final int state;
  final String extraInfo;
  const OnRoomStateChangedData({
    required this.roomId,
    required this.uid,
    required this.state,
    required this.extraInfo,
  });
  factory OnRoomStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnRoomStateChangedData(
        roomId: map['roomId'] as String,
        uid: map['uid'] as String,
        state: map['state'] as int,
        extraInfo: map['extraInfo'] as String);
  }
}

class OnLeaveRoomData {
  final RTCRoomStats rtcRoomStats;
  const OnLeaveRoomData({required this.rtcRoomStats});
  factory OnLeaveRoomData.fromMap(Map<dynamic, dynamic> map) {
    if (map['stats'] == null) {
      return OnLeaveRoomData(rtcRoomStats: RTCRoomStats());
    }
    return OnLeaveRoomData(rtcRoomStats: RTCRoomStats.fromMap(map['stats']));
  }
}

class OnUserJoinedData {
  final UserInfo userInfo;
  final int elapsed;
  const OnUserJoinedData({required this.userInfo, required this.elapsed});
  factory OnUserJoinedData.fromMap(Map<dynamic, dynamic> map) {
    return OnUserJoinedData(
        userInfo: UserInfo.fromMap(map['userInfo']), elapsed: map['elapsed']);
  }
}

class OnUserLeaveData {
  final String uid;
  final UserOfflineReason reason;
  const OnUserLeaveData({required this.uid, required this.reason});
  factory OnUserLeaveData.fromMap(Map<dynamic, dynamic> map) {
    return OnUserLeaveData(
        uid: map['uid'], reason: (map['reason'] as int).userOfflineReason);
  }
}

class OnMediaFrameSendStateChangedData {
  final String roomId;
  final UserInfo userInfo;
  final FirstFrameSendState state;
  const OnMediaFrameSendStateChangedData(
      {required this.roomId, required this.userInfo, required this.state});
  factory OnMediaFrameSendStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnMediaFrameSendStateChangedData(
        roomId: map['roomId'] as String,
        userInfo: UserInfo.fromMap(map['userInfo']),
        state: (map['state'] as int).firstFrameSendState);
  }
}

class OnMediaFramePlayStateChangedData {
  final String roomId;
  final UserInfo userInfo;
  final FirstFramePlayState state;
  const OnMediaFramePlayStateChangedData(
      {required this.roomId, required this.userInfo, required this.state});
  factory OnMediaFramePlayStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnMediaFramePlayStateChangedData(
        roomId: map['roomId'] as String,
        userInfo: UserInfo.fromMap(map['userInfo']),
        state: (map['state'] as int).firstFramePlayState);
  }
}

class OnRemoteAudioStateChangedData {
  final RemoteStreamKey streamKey;
  final RemoteAudioState state;
  final RemoteAudioStateChangeReason reason;
  const OnRemoteAudioStateChangedData(
      {required this.streamKey, required this.state, required this.reason});
  factory OnRemoteAudioStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnRemoteAudioStateChangedData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        state: (map['state'] as int).remoteAudioState,
        reason: (map['reason'] as int).remoteAudioStateChangeReason);
  }
}

class OnLocalAudioStateChangedData {
  final LocalAudioStreamState state;
  final LocalAudioStreamError error;
  const OnLocalAudioStateChangedData(
      {required this.state, required this.error});
  factory OnLocalAudioStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnLocalAudioStateChangedData(
        state: (map['state'] as int).localAudioStreamState,
        error: (map['error'] as int).localAudioStreamError);
  }
}

class OnFirstLocalAudioFrameData {
  final StreamIndex index;
  const OnFirstLocalAudioFrameData({required this.index});
  factory OnFirstLocalAudioFrameData.fromMap(Map<dynamic, dynamic> map) {
    return OnFirstLocalAudioFrameData(index: (map['index'] as int).streamIndex);
  }
}

class OnFirstRemoteAudioFrameData {
  final RemoteStreamKey streamKey;
  const OnFirstRemoteAudioFrameData({required this.streamKey});
  factory OnFirstRemoteAudioFrameData.fromMap(Map<dynamic, dynamic> map) {
    return OnFirstRemoteAudioFrameData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']));
  }
}

class OnLocalVideoStateChangedData {
  final StreamIndex index;
  final LocalVideoStreamState state;
  final LocalVideoStreamError error;
  const OnLocalVideoStateChangedData(
      {required this.index, required this.state, required this.error});
  factory OnLocalVideoStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnLocalVideoStateChangedData(
        index: (map['index'] as int).streamIndex,
        state: (map['state'] as int).localVideoStreamState,
        error: (map['error'] as int).localVideoStreamError);
  }
}

class OnRemoteVideoStateChangedData {
  final RemoteStreamKey streamKey;
  final RemoteVideoState state;
  final RemoteVideoStateChangedReason reason;
  const OnRemoteVideoStateChangedData(
      {required this.streamKey, required this.state, required this.reason});
  factory OnRemoteVideoStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnRemoteVideoStateChangedData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        state: (map['state'] as int).remoteVideoState,
        reason: (map['reason'] as int).remoteVideoStateChangedReason);
  }
}

class OnFirstRemoteVideoFrameRenderedData {
  final RemoteStreamKey streamKey;
  final VideoFrameInfo videoFrameInfo;
  const OnFirstRemoteVideoFrameRenderedData(
      {required this.streamKey, required this.videoFrameInfo});
  factory OnFirstRemoteVideoFrameRenderedData.fromMap(
      Map<dynamic, dynamic> map) {
    return OnFirstRemoteVideoFrameRenderedData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        videoFrameInfo: VideoFrameInfo.fromMap(map['videoFrame']));
  }
}

class OnFirstLocalVideoFrameCapturedData {
  final StreamIndex index;
  final VideoFrameInfo videoFrameInfo;
  const OnFirstLocalVideoFrameCapturedData(
      {required this.index, required this.videoFrameInfo});
  factory OnFirstLocalVideoFrameCapturedData.fromMap(
      Map<dynamic, dynamic> map) {
    return OnFirstLocalVideoFrameCapturedData(
        index: (map['index'] as int).streamIndex,
        videoFrameInfo: VideoFrameInfo.fromMap(map['videoFrame']));
  }
}

class OnUserOperateMediaCaptureData {
  final String roomId;
  final String uid;
  const OnUserOperateMediaCaptureData(
      {required this.roomId, required this.uid});
  factory OnUserOperateMediaCaptureData.fromMap(Map<dynamic, dynamic> map) {
    return OnUserOperateMediaCaptureData(
        roomId: map['roomId'] as String, uid: map['uid'] as String);
  }
}

class OnLocalStreamStatsData {
  final LocalStreamStats stats;
  const OnLocalStreamStatsData({required this.stats});
  factory OnLocalStreamStatsData.fromMap(Map<dynamic, dynamic> map) {
    return OnLocalStreamStatsData(
        stats: LocalStreamStats.fromMap(map['stats']));
  }
}

class OnRemoteStreamStatsData {
  final RemoteStreamStats stats;
  const OnRemoteStreamStatsData({required this.stats});
  factory OnRemoteStreamStatsData.fromMap(Map<dynamic, dynamic> map) {
    return OnRemoteStreamStatsData(
        stats: RemoteStreamStats.fromMap(map['stats']));
  }
}

class OnLocalVideoSizeChangedData {
  final StreamIndex streamIndex;
  final VideoFrameInfo videoFrameInfo;

  const OnLocalVideoSizeChangedData(
      {required this.streamIndex, required this.videoFrameInfo});
  factory OnLocalVideoSizeChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnLocalVideoSizeChangedData(
        streamIndex: (map['index'] as int).streamIndex,
        videoFrameInfo: VideoFrameInfo.fromMap(map['videoFrame']));
  }
}

class OnRemoteVideoSizeChangedData {
  final RemoteStreamKey streamKey;
  final VideoFrameInfo videoFrameInfo;

  const OnRemoteVideoSizeChangedData(
      {required this.streamKey, required this.videoFrameInfo});
  factory OnRemoteVideoSizeChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnRemoteVideoSizeChangedData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        videoFrameInfo: VideoFrameInfo.fromMap(map['videoFrame']));
  }
}

/// liveTranscodingObserver
class OnStreamMixingEventData {
  final StreamMixingEvent eventType;
  final String taskId;
  final TranscoderErrorCode error;
  final StreamMixingType mixType;
  const OnStreamMixingEventData(
      {required this.eventType,
      required this.taskId,
      required this.error,
      required this.mixType});
  factory OnStreamMixingEventData.fromMap(Map<dynamic, dynamic> map) {
    return OnStreamMixingEventData(
        eventType: (map['eventType'] as int).streamMixingEvent,
        taskId: map['taskId'],
        error: (map['error'] as int).transcoderErrorCode,
        mixType: (map['mixType'] as int).streamMixingType);
  }
}

class OnRoomStatsData {
  final RTCRoomStats stats;
  const OnRoomStatsData({required this.stats});
  factory OnRoomStatsData.fromMap(Map<dynamic, dynamic> map) {
    return OnRoomStatsData(stats: RTCRoomStats.fromMap(map['stats']));
  }
}

class OnMessageSendResultData {
  final int msgid;
  final UserMessageSendResult error;
  const OnMessageSendResultData({required this.msgid, required this.error});
  factory OnMessageSendResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnMessageSendResultData(
        msgid: map['msgid'],
        error: (map['error'] as int).userMessageSendResult);
  }
}

class OnRoomMessageSendResultData {
  final int msgid;
  final RoomMessageSendResult error;
  const OnRoomMessageSendResultData({required this.msgid, required this.error});
  factory OnRoomMessageSendResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnRoomMessageSendResultData(
        msgid: map['msgid'],
        error: (map['error'] as int).roomMessageSendResult);
  }
}

class OnServerMessageSendResultData {
  final int msgid;
  final UserMessageSendResult error;
  final Uint8List message;
  const OnServerMessageSendResultData(
      {required this.msgid, required this.error, required this.message});
  factory OnServerMessageSendResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnServerMessageSendResultData(
        msgid: map['msgid'],
        error: (map['error'] as int).userMessageSendResult,
        message: map['message']);
  }
}

class OnMessageReceivedData {
  final String uid;
  final String message;
  const OnMessageReceivedData({required this.uid, required this.message});
  factory OnMessageReceivedData.fromMap(Map<dynamic, dynamic> map) {
    return OnMessageReceivedData(uid: map['uid'], message: map['message']);
  }
}

class OnBinaryMessageReceivedData {
  final String uid;
  final Uint8List message;
  const OnBinaryMessageReceivedData({required this.uid, required this.message});
  factory OnBinaryMessageReceivedData.fromMap(Map<dynamic, dynamic> map) {
    return OnBinaryMessageReceivedData(
        uid: map['uid'], message: map['message']);
  }
}

class OnVideoStreamBannedData {
  final String uid;
  final bool banned;
  const OnVideoStreamBannedData({required this.uid, required this.banned});
  factory OnVideoStreamBannedData.fromMap(Map<dynamic, dynamic> map) {
    return OnVideoStreamBannedData(uid: map['uid'], banned: map['banned']);
  }
}

class OnAudioStreamBannedData {
  final String uid;
  final bool banned;
  const OnAudioStreamBannedData({required this.uid, required this.banned});
  factory OnAudioStreamBannedData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioStreamBannedData(uid: map['uid'], banned: map['banned']);
  }
}

class OnSimulcastSubscribeFallbackData {
  final RemoteStreamSwitch event;
  const OnSimulcastSubscribeFallbackData({required this.event});
  factory OnSimulcastSubscribeFallbackData.fromMap(Map<dynamic, dynamic> map) {
    return OnSimulcastSubscribeFallbackData(
        event: RemoteStreamSwitch.fromMap(map['event']));
  }
}

class OnAudioMixingStateChangedData {
  final int mixId;
  final AudioMixingState state;
  final AudioMixingError error;
  const OnAudioMixingStateChangedData(
      {required this.mixId, required this.state, required this.error});
  factory OnAudioMixingStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioMixingStateChangedData(
        mixId: map['mixId'],
        state: (map['state'] as int).audioMixingState,
        error: (map['error'] as int).audioMixingError);
  }
}

class OnAudioMixingPlayingProgressData {
  final int mixId;
  final int progress;
  const OnAudioMixingPlayingProgressData(
      {required this.mixId, required this.progress});
  factory OnAudioMixingPlayingProgressData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioMixingPlayingProgressData(
        mixId: map['mixId'], progress: map['progress']);
  }
}

class OnNetworkTypeChangedData {
  final NetworkType type;
  const OnNetworkTypeChangedData({required this.type});
  factory OnNetworkTypeChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnNetworkTypeChangedData(type: (map['type'] as int).networkType);
  }
}

class OnSEIMessageReceivedData {
  final RemoteStreamKey streamKey;
  final Uint8List message;
  const OnSEIMessageReceivedData(
      {required this.streamKey, required this.message});
  factory OnSEIMessageReceivedData.fromMap(Map<dynamic, dynamic> map) {
    return OnSEIMessageReceivedData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        message: map['message']);
  }
}

class OnSEIStreamUpdateData {
  final RemoteStreamKey streamKey;
  final SEIStreamUpdateEvent event;
  const OnSEIStreamUpdateData({required this.streamKey, required this.event});
  factory OnSEIStreamUpdateData.fromMap(Map<dynamic, dynamic> map) {
    return OnSEIStreamUpdateData(
        streamKey: RemoteStreamKey.fromMap(map['streamKey']),
        event: (map['event'] as int).seiStreamUpdateEvent);
  }
}

class OnServerParamsSetResultData {
  final int error;
  const OnServerParamsSetResultData({required this.error});

  factory OnServerParamsSetResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnServerParamsSetResultData(
      error: map['error'],
    );
  }
}

class OnGetPeerOnlineStatusData {
  final String peerUid;
  final UserOnlineStatus status;
  const OnGetPeerOnlineStatusData(
      {required this.peerUid, required this.status});

  factory OnGetPeerOnlineStatusData.fromMap(Map<dynamic, dynamic> map) {
    return OnGetPeerOnlineStatusData(
      peerUid: map['uid'],
      status: (map['status'] as int).userOnlineStatus,
    );
  }
}

class OnPerformanceAlarmsData {
  final PerformanceAlarmMode mode;
  final String roomId;
  final PerformanceAlarmReason reason;
  final SourceWantedData data;

  const OnPerformanceAlarmsData(
      {required this.mode,
      required this.roomId,
      required this.reason,
      required this.data});

  factory OnPerformanceAlarmsData.fromMap(Map<dynamic, dynamic> map) {
    return OnPerformanceAlarmsData(
      mode: (map['mode'] as int).performanceAlarmMode,
      roomId: map['roomId'],
      reason: (map['reason'] as int).performanceAlarmReason,
      data: SourceWantedData.fromMap(map['data']),
    );
  }
}

class OnHttpProxyStateData {
  final int state;
  const OnHttpProxyStateData({required this.state});

  factory OnHttpProxyStateData.fromMap(Map<dynamic, dynamic> map) {
    return OnHttpProxyStateData(
      state: map['state'],
    );
  }
}

class OnHttpsProxyStateData {
  final int state;
  const OnHttpsProxyStateData({required this.state});

  factory OnHttpsProxyStateData.fromMap(Map<dynamic, dynamic> map) {
    return OnHttpsProxyStateData(
      state: map['state'],
    );
  }
}

class OnSocks5ProxyStateData {
  final int state;
  final String cmd;
  final String proxyAddress;
  final String localAddress;
  final String remoteAddress;
  const OnSocks5ProxyStateData(
      {required this.state,
      required this.cmd,
      required this.proxyAddress,
      required this.localAddress,
      required this.remoteAddress});

  factory OnSocks5ProxyStateData.fromMap(Map<dynamic, dynamic> map) {
    return OnSocks5ProxyStateData(
      state: map['state'],
      cmd: map['cmd'],
      proxyAddress: map['proxyAddress'],
      localAddress: map['localAddress'],
      remoteAddress: map['remoteAddress'],
    );
  }
}

class OnRecordingStateUpdateData {
  final StreamIndex type;
  final RecordingState state;
  final RecordingErrorCode errorCode;
  final RecordingInfo info;
  const OnRecordingStateUpdateData(
      {required this.state,
      required this.type,
      required this.errorCode,
      required this.info});

  factory OnRecordingStateUpdateData.fromMap(Map<dynamic, dynamic> map) {
    return OnRecordingStateUpdateData(
      state: (map['state'] as int).recordingState,
      type: (map['type'] as int).streamIndex,
      errorCode: (map['errorCode'] as int).recordingErrorCode,
      info: RecordingInfo.fromMap(map['info']),
    );
  }
}

class OnRecordingProgressUpdateData {
  final StreamIndex type;
  final RecordingProgress progress;
  final RecordingInfo info;

  const OnRecordingProgressUpdateData(
      {required this.type, required this.progress, required this.info});

  factory OnRecordingProgressUpdateData.fromMap(Map<dynamic, dynamic> map) {
    return OnRecordingProgressUpdateData(
      type: (map['type'] as int).streamIndex,
      progress: RecordingProgress.fromMap(map['progress']),
      info: RecordingInfo.fromMap(map['info']),
    );
  }
}

class OnLocalAudioPropertiesReportData {
  final List<LocalAudioPropertiesInfo> audioPropertiesInfos;

  const OnLocalAudioPropertiesReportData({required this.audioPropertiesInfos});
  factory OnLocalAudioPropertiesReportData.fromMap(Map<dynamic, dynamic> map) {
    List<LocalAudioPropertiesInfo> infos = (map['infos'] as List<dynamic>)
        .map((e) => LocalAudioPropertiesInfo.fromMap(e))
        .toList();

    return OnLocalAudioPropertiesReportData(
      audioPropertiesInfos: infos,
    );
  }
}

class OnRemoteAudioPropertiesReportData {
  final List<RemoteAudioPropertiesInfo> audioPropertiesInfos;
  final int totalRemoteVolume;
  const OnRemoteAudioPropertiesReportData(
      {required this.audioPropertiesInfos, required this.totalRemoteVolume});
  factory OnRemoteAudioPropertiesReportData.fromMap(Map<dynamic, dynamic> map) {
    List<RemoteAudioPropertiesInfo> infos = (map['infos'] as List<dynamic>)
        .map((e) => RemoteAudioPropertiesInfo.fromMap(e))
        .toList();
    return OnRemoteAudioPropertiesReportData(
        audioPropertiesInfos: infos,
        totalRemoteVolume: map['totalRemoteVolume']);
  }
}

class OnStreamSyncInfoReceivedData {
  final RemoteStreamKey streamKey;
  final SyncInfoStreamType streamType;
  final Uint8List data;
  const OnStreamSyncInfoReceivedData(
      {required this.streamKey, required this.streamType, required this.data});
  factory OnStreamSyncInfoReceivedData.fromMap(Map<dynamic, dynamic> map) {
    return OnStreamSyncInfoReceivedData(
      streamKey: RemoteStreamKey.fromMap(map['streamKey']),
      streamType: (map['streamType'] as int).syncInfoStreamType,
      data: map['data'],
    );
  }
}

class OnSysStatsData {
  final SysStats stats;
  const OnSysStatsData({required this.stats});
  factory OnSysStatsData.fromMap(Map<dynamic, dynamic> map) {
    return OnSysStatsData(stats: SysStats.fromMap(map['stats']));
  }
}

class OnMeesageData {
  final String message;
  const OnMeesageData({required this.message});
  factory OnMeesageData.fromMap(Map<dynamic, dynamic> map) {
    return OnMeesageData(message: map['message']);
  }
}

class OnErrorMsgData {
  final int errorCode;
  final String errorMessage;

  const OnErrorMsgData({required this.errorCode, required this.errorMessage});
  factory OnErrorMsgData.fromMap(Map<dynamic, dynamic> map) {
    return OnErrorMsgData(
        errorCode: map['errorCode'], errorMessage: map['errorMessage']);
  }
}

class OnLoginResultData {
  final String uid;
  final LoginErrorCode errorCode;
  final int elapsed;

  const OnLoginResultData(
      {required this.uid, required this.errorCode, required this.elapsed});
  factory OnLoginResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnLoginResultData(
        uid: map['uid'],
        errorCode: (map['errorCode'] as int).loginErrorCode,
        elapsed: map['elapsed']);
  }
}

class OnFaceDetectResultData {
  final FaceDetectionResult result;

  const OnFaceDetectResultData({required this.result});

  factory OnFaceDetectResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnFaceDetectResultData(
        result: FaceDetectionResult.fromMap(map['result']));
  }
}

class OnUserPublishStreamData {
  final String uid;
  final MediaStreamType type;

  const OnUserPublishStreamData({required this.uid, required this.type});

  factory OnUserPublishStreamData.fromMap(Map<dynamic, dynamic> map) {
    return OnUserPublishStreamData(
        uid: map['uid'], type: (map['type'] as int).mediaStreamType);
  }
}

class OnUserUnpublishStreamData {
  final String uid;
  final MediaStreamType type;
  final StreamRemoveReason reason;

  const OnUserUnpublishStreamData(
      {required this.uid, required this.type, required this.reason});

  factory OnUserUnpublishStreamData.fromMap(Map<dynamic, dynamic> map) {
    return OnUserUnpublishStreamData(
        uid: map['uid'],
        type: (map['type'] as int).mediaStreamType,
        reason: (map['reason'] as int).streamRemoveReason);
  }
}

class OnAudioDeviceStateChangedData {
  final String deviceId;
  final AudioDeviceType deviceType;
  final MediaDeviceState deviceState;
  final MediaDeviceError deviceError;

  const OnAudioDeviceStateChangedData(
      {required this.deviceId,
      required this.deviceType,
      required this.deviceState,
      required this.deviceError});

  factory OnAudioDeviceStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioDeviceStateChangedData(
        deviceId: map['deviceId'],
        deviceType: (map['deviceType'] as int).audioDeviceType,
        deviceState: (map['deviceState'] as int).mediaDeviceState,
        deviceError: (map['deviceError'] as int).mediaDeviceError);
  }
}

class OnVideoDeviceStateChangedData {
  final String deviceId;
  final VideoDeviceType deviceType;
  final MediaDeviceState deviceState;
  final MediaDeviceError deviceError;

  const OnVideoDeviceStateChangedData(
      {required this.deviceId,
      required this.deviceType,
      required this.deviceState,
      required this.deviceError});

  factory OnVideoDeviceStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnVideoDeviceStateChangedData(
        deviceId: map['deviceId'],
        deviceType: (map['deviceType'] as int).videoDeviceType,
        deviceState: (map['deviceState'] as int).mediaDeviceState,
        deviceError: (map['deviceError'] as int).mediaDeviceError);
  }
}

class OnAudioDeviceWarningData {
  final String deviceId;
  final AudioDeviceType deviceType;
  final MediaDeviceWarning deviceWarning;

  const OnAudioDeviceWarningData(
      {required this.deviceId,
      required this.deviceType,
      required this.deviceWarning});

  factory OnAudioDeviceWarningData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioDeviceWarningData(
        deviceId: map['deviceId'],
        deviceType: (map['deviceType'] as int).audioDeviceType,
        deviceWarning: (map['deviceWarning'] as int).mediaDeviceWarning);
  }
}

class OnVideoDeviceWarningData {
  final String deviceId;
  final VideoDeviceType deviceType;
  final MediaDeviceWarning deviceWarning;

  const OnVideoDeviceWarningData(
      {required this.deviceId,
      required this.deviceType,
      required this.deviceWarning});

  factory OnVideoDeviceWarningData.fromMap(Map<dynamic, dynamic> map) {
    return OnVideoDeviceWarningData(
        deviceId: map['deviceId'],
        deviceType: (map['deviceType'] as int).videoDeviceType,
        deviceWarning: (map['deviceWarning'] as int).mediaDeviceWarning);
  }
}

class OnAudioRouteChangedData {
  final AudioRoute route;
  const OnAudioRouteChangedData({required this.route});
  factory OnAudioRouteChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnAudioRouteChangedData(route: (map['route'] as int).audioRoute);
  }
}

class OnActiveSpeakerData {
  final String roomId;
  final String uid;
  const OnActiveSpeakerData({required this.roomId, required this.uid});
  factory OnActiveSpeakerData.fromMap(Map<dynamic, dynamic> map) {
    return OnActiveSpeakerData(roomId: map['roomId'], uid: map['uid']);
  }
}

class OnStreamSubscribedData {
  final SubscribeState stateCode;
  final String uid;
  final SubscribeConfig info;
  const OnStreamSubscribedData(
      {required this.stateCode, required this.uid, required this.info});
  factory OnStreamSubscribedData.fromMap(Map<dynamic, dynamic> map) {
    return OnStreamSubscribedData(
        stateCode: (map['stateCode'] as int).subscribeState,
        uid: map['uid'],
        info: SubscribeConfig.fromMap(map['info']));
  }
}

class OnNetworkDetectionResultData {
  final NetworkDetectionLinkType type;
  final NetworkQuality quality;
  final int rtt;
  final double lostRate;
  final int bitrate;
  final int jitter;

  const OnNetworkDetectionResultData(
      {required this.type,
      required this.quality,
      required this.rtt,
      required this.lostRate,
      required this.bitrate,
      required this.jitter});

  factory OnNetworkDetectionResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnNetworkDetectionResultData(
      type: (map['type'] as int).networkDetectionLinkType,
      quality: (map['quality'] as int).networkQuality,
      rtt: map['rtt'],
      lostRate: map['lostRate'],
      bitrate: map['bitrate'],
      jitter: map['jitter'],
    );
  }
}

class OnNetworkDetectionStoppedData {
  final NetworkDetectionStopReason reason;
  const OnNetworkDetectionStoppedData({required this.reason});
  factory OnNetworkDetectionStoppedData.fromMap(Map<dynamic, dynamic> map) {
    return OnNetworkDetectionStoppedData(
        reason: (map['reason'] as int).networkDetectionStopReason);
  }
}

class OnForwardStreamStateChangedData {
  final List<ForwardStreamStateInfo> stateInfos;
  const OnForwardStreamStateChangedData({required this.stateInfos});
  factory OnForwardStreamStateChangedData.fromMap(Map<dynamic, dynamic> map) {
    return OnForwardStreamStateChangedData(
        stateInfos: (map['stateInfos'] as List<dynamic>)
            .map((e) => ForwardStreamStateInfo.fromMap(e))
            .toList());
  }
}

class OnForwardStreamEventData {
  final List<ForwardStreamEventInfo> eventInfos;
  const OnForwardStreamEventData({required this.eventInfos});
  factory OnForwardStreamEventData.fromMap(Map<dynamic, dynamic> map) {
    return OnForwardStreamEventData(
        eventInfos: (map['eventInfos'] as List<dynamic>)
            .map((e) => ForwardStreamEventInfo.fromMap(e))
            .toList());
  }
}

class OnNetworkQualityData {
  final NetworkQualityStats localQuality;
  final List<NetworkQualityStats> remoteQualities;
  const OnNetworkQualityData(
      {required this.localQuality, required this.remoteQualities});
  factory OnNetworkQualityData.fromMap(Map<dynamic, dynamic> map) {
    return OnNetworkQualityData(
        localQuality: NetworkQualityStats.fromMap(map['localQuality']),
        remoteQualities: (map['remoteQualities'] as List<dynamic>)
            .map((e) => NetworkQualityStats.fromMap(e))
            .toList());
  }
}

class OnPushPublicStreamResultData {
  final String roomId;
  final String publicStreamId;
  final PublicStreamErrorCode errorCode;
  const OnPushPublicStreamResultData(
      {required this.roomId,
      required this.publicStreamId,
      required this.errorCode});
  factory OnPushPublicStreamResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnPushPublicStreamResultData(
        roomId: map['roomId'],
        publicStreamId: map['publicStreamId'],
        errorCode: (map['errorCode'] as int).publicStreamErrorCode);
  }
}

class OnPlayPublicStreamResultData {
  final String publicStreamId;
  final PublicStreamErrorCode errorCode;
  const OnPlayPublicStreamResultData(
      {required this.publicStreamId, required this.errorCode});
  factory OnPlayPublicStreamResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnPlayPublicStreamResultData(
        publicStreamId: map['publicStreamId'],
        errorCode: (map['errorCode'] as int).publicStreamErrorCode);
  }
}

class OnPublicStreamSEIMessageReceivedData {
  final String publicStreamId;
  final Uint8List message;
  const OnPublicStreamSEIMessageReceivedData(
      {required this.publicStreamId, required this.message});
  factory OnPublicStreamSEIMessageReceivedData.fromMap(
      Map<dynamic, dynamic> map) {
    return OnPublicStreamSEIMessageReceivedData(
        publicStreamId: map['publicStreamId'], message: map['message']);
  }
}

class OnFirstPublicStreamVideoFrameDecodedData {
  final String publicStreamId;
  final VideoFrameInfo videoFrameInfo;
  const OnFirstPublicStreamVideoFrameDecodedData(
      {required this.publicStreamId, required this.videoFrameInfo});
  factory OnFirstPublicStreamVideoFrameDecodedData.fromMap(
      Map<dynamic, dynamic> map) {
    return OnFirstPublicStreamVideoFrameDecodedData(
        publicStreamId: map['publicStreamId'],
        videoFrameInfo: VideoFrameInfo.fromMap(map['videoFrame']));
  }
}

class OnFirstPublicStreamAudioFrameData {
  final String publicStreamId;
  const OnFirstPublicStreamAudioFrameData({required this.publicStreamId});
  factory OnFirstPublicStreamAudioFrameData.fromMap(Map<dynamic, dynamic> map) {
    return OnFirstPublicStreamAudioFrameData(
        publicStreamId: map['publicStreamId']);
  }
}

class OnAVSyncStateChangeData {
  final AVSyncState state;
  const OnAVSyncStateChangeData({required this.state});
  factory OnAVSyncStateChangeData.fromMap(Map<dynamic, dynamic> map) {
    return OnAVSyncStateChangeData(state: (map['state'] as int).avSyncState);
  }
}

class OnRangeAudioInfoData {
  final List<RangeAudioInfo> rangeAudioInfo;
  const OnRangeAudioInfoData({required this.rangeAudioInfo});
  factory OnRangeAudioInfoData.fromMap(Map<dynamic, dynamic> map) {
    return OnRangeAudioInfoData(
        rangeAudioInfo: (map['rangeAudioInfo'] as List<dynamic>)
            .map((e) => RangeAudioInfo.fromMap(e))
            .toList());
  }
}

class OnCloudProxyConnectedData {
  final int interval;
  const OnCloudProxyConnectedData({required this.interval});
  factory OnCloudProxyConnectedData.fromMap(Map<dynamic, dynamic> map) {
    return OnCloudProxyConnectedData(interval: map['interval']);
  }
}

class OnEchoTestResultData {
  final EchoTestResult result;
  const OnEchoTestResultData({required this.result});
  factory OnEchoTestResultData.fromMap(Map<dynamic, dynamic> map) {
    return OnEchoTestResultData(result: (map['result'] as int).echoTestResult);
  }
}

class OnStreamPushEventData {
  final StreamSinglePushEvent eventType;
  final String taskId;
  final int error;
  const OnStreamPushEventData(
      {required this.eventType, required this.taskId, required this.error});
  factory OnStreamPushEventData.fromMap(Map<dynamic, dynamic> map) {
    return OnStreamPushEventData(
        eventType: (map['eventType'] as int).streamSinglePushEvent,
        taskId: map['taskId'],
        error: map['error']);
  }
}
