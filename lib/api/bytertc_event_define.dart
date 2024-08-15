// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:typed_data';

import 'bytertc_audio_defines.dart';
import 'bytertc_media_defines.dart';
import 'bytertc_room_api.dart';
import 'bytertc_rts_defines.dart';
import 'bytertc_video_api.dart';
import 'bytertc_video_defines.dart';

typedef EmptyCallbackType = void Function();

/// [reason]：登出原因
typedef OnLogoutType = void Function(LogoutReason reason);

/// [code]：警告码
typedef OnWarningType = void Function(WarningCode code);

/// [code]：错误码
typedef OnErrorType = void Function(ErrorCode code);

/// [roomId]：发生错误的房间 ID
///
/// [errorCode]：创建房间错误码
typedef OnCreateRoomStateChangedType = void Function(
    String roomId, int errorCode);

/// [state]：当前 SDK 与信令服务器连接状态
typedef OnConnectionStateChanged = void Function(RTCConnectionState state);

/// [streamIndex]：流属性
///
/// [videoFrameInfo]：视频信息
typedef OnFirstLocalVideoFrameCapturedType = void Function(
    StreamIndex streamIndex, VideoFrameInfo videoFrameInfo);

/// [index]：音频流属性
typedef OnFirstLocalAudioFrameType = void Function(StreamIndex index);

/// [streamKey]：远端音频流信息
typedef OnFirstRemoteAudioFrameType = void Function(RemoteStreamKey streamKey);

/// [streamKey]：远端流信息
///
/// [videoFrameInfo]：视频帧信息
typedef OnFirstRemoteVideoFrameRenderedType = void Function(
    RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo);

/// [roomId]：开关采集的远端用户所在的房间 ID
///
/// [uid]：开关采集的远端用户 ID
typedef OnUserOperateMediaCaptureType = void Function(
    String roomId, String uid);

/// [audioPropertiesInfos]：本地音频信息
typedef OnLocalAudioPropertiesReportType = void Function(
    List<LocalAudioPropertiesInfo> audioPropertiesInfos);

/// [audioPropertiesInfos]：远端音频信息
///
/// [totalRemoteVolume]：订阅的所有远端流的总音量
typedef OnRemoteAudioPropertiesReportType = void Function(
    List<RemoteAudioPropertiesInfo> audioPropertiesInfos,
    int totalRemoteVolume);

/// [mixId]：混音任务 ID
///
/// [state]：混音状态
///
/// [error]：混音错误码
typedef OnAudioMixingStateChangedType = void Function(
    int mixId, AudioMixingState state, AudioMixingError error);

/// [mixId]：混音任务 ID
///
/// [progress]：当前混音音频文件播放进度，单位毫秒
typedef OnAudioMixingPlayingProgressType = void Function(
    int mixId, int progress);

/// [type]：当前网络连接类型
typedef OnNetworkTypeChangedType = void Function(NetworkType type);

/// [streamKey]：包含 SEI 发送者的用户名，所在的房间名和媒体流
///
/// [message]：收到的 SEI 消息内容
typedef OnSEIMessageReceivedType = void Function(
    RemoteStreamKey streamKey, Uint8List message);

/// [streamKey]：远端流信息
///
/// [event]：黑帧视频流状态
typedef OnSEIStreamUpdateType = void Function(
    RemoteStreamKey streamKey, SEIStreamUpdateEvent event);

/// [streamKey]：远端流信息
///
/// [streamType] ：媒体流类型
///
/// [data]：消息内容
typedef OnStreamSyncInfoReceivedType = void Function(
    RemoteStreamKey streamKey, SyncInfoStreamType streamType, Uint8List data);

/// [mode]：指示本地是否开启发布回退功能
///
/// [roomId]：未开启发布性能回退时，roomId 为空；开启发布性能回退时，roomId 是告警影响的房间 ID
///
/// [reason]：告警原因
///
/// [data]：性能回退相关数据
typedef OnPerformanceAlarmsType = void Function(PerformanceAlarmMode mode,
    String roomId, PerformanceAlarmReason reason, SourceWantedData data);

/// [event]：音视频流发生变化的信息
typedef OnSimulcastSubscribeFallbackType = void Function(
    RemoteStreamSwitch event);

/// [state]：当前 HTTP 代理连接状态
typedef OnHttpProxyStateType = void Function(int state);

/// [state]：当前 HTTPS 代理连接状态
typedef OnHttpsProxyStateType = void Function(int state);

/// [state]：当前 SOCKS5 代理连接状态
typedef OnSocks5ProxyStateType = void Function(int state, String cmd,
    String proxyAddress, String localAddress, String remoteAddress);

/// [type]：录制流的流属性
///
/// [state]：录制状态
///
/// [errorCode]：录制错误码
///
/// [info]：录制文件的详细信息
typedef OnRecordingStateUpdateType = void Function(StreamIndex type,
    RecordingState state, RecordingErrorCode errorCode, RecordingInfo info);

/// [type]：录制流的流属性
///
/// [progress]：录制进度
///
/// [info]：录制文件的详细信息
typedef OnRecordingProgressUpdateType = void Function(
    StreamIndex type, RecordingProgress progress, RecordingInfo info);

/// [state]：录制状态
///
/// [errorCode]：录制错误码
typedef OnAudioRecordingStateUpdateType = void Function(
    AudioRecordingState state, AudioRecordingErrorCode errorCode);

/// [stats]：CPU，内存信息
typedef OnSysStatsType = void Function(SysStats stats);

/// [stats]：房间内的汇总统计数据
typedef OnRoomStatsType = void Function(RTCRoomStats stats);

/// [stats]：音视频流以及网络状况统计信息
typedef OnLocalStreamStatsType = void Function(LocalStreamStats stats);

/// [stats]：音视频流以及网络状况统计信息
typedef OnRemoteStreamStatsType = void Function(RemoteStreamStats stats);

/// [roomId]：发生状态改变的房间 ID
///
/// [uid]：发生状态改变的用户 ID
///
/// [state]：房间状态码
/// + 0：成功；
/// + !0：失败，具体原因参看 [ErrorCode] 及 [WarningCode]
///
/// [extraInfo]：额外信息
/// + `joinType`表示加入房间的类型，`0`为首次进房，`1`为重连进房。
/// + `elapsed`表示加入房间耗时，即本地用户从调用 [RTCRoom.joinRoom] 到加入房间成功所经历的时间间隔，单位为 ms。
typedef OnRoomStateChangedType = void Function(
    String roomId, String uid, int state, String extraInfo);

/// [stats]：保留参数，目前为空。
typedef OnLeaveRoomType = void Function(RTCRoomStats stats);

/// [userInfo]：用户信息
///
/// [elapsed]：可见用户调用 [RTCRoom.joinRoom] 加入房间到房间内其他用户收到该事件经历的时间，单位为 ms
typedef OnUserJoinedType = void Function(UserInfo userInfo, int elapsed);

/// [uid]：离开房间，或切至不可见的的远端用户 ID
///
/// [reason]：远端用户离开的原因
typedef OnUserLeaveType = void Function(String uid, UserOfflineReason reason);

/// [eventType]：转推直播任务状态
///
/// [taskId]：转推直播任务 ID
///
/// [error]：转推直播错误码
///
/// [mixType]：转推直播类型
typedef OnStreamMixingEventType = void Function(StreamMixingEvent eventType,
    String taskId, StreamMixingErrorCode error, StreamMixingType mixType);

/// [roomId]：流发布用户所在的房间 ID
///
/// [userInfo]：用户信息
///
/// [state]：首帧发送状态
typedef OnMediaFrameSendStateChangedType = void Function(
    String roomId, UserInfo userInfo, FirstFrameSendState state);

/// [roomId]：流发布用户所在的房间 ID
///
/// [userInfo]：用户信息
///
/// [state]：首帧播放状态
typedef OnMediaFramePlayStateChangedType = void Function(
    String roomId, UserInfo userInfo, FirstFramePlayState state);

/// [streamIndex]：流属性
///
/// [videoFrameInfo]：视频帧信息
typedef OnLocalVideoSizeChangedType = void Function(
    StreamIndex streamIndex, VideoFrameInfo videoFrameInfo);

/// [streamKey]：远端流信息
///
/// [videoFrameInfo]：视频帧信息
typedef OnRemoteVideoSizeChangedType = void Function(
    RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo);

/// [state]：本地音频设备的状态
///
/// [error]：本地音频流状态改变时的错误码
typedef OnLocalAudioStateChangedType = void Function(
    LocalAudioStreamState state, LocalAudioStreamError error);

/// @nodoc('Not available')
/// [streamKey]：远端流信息
///
/// [state]：远端音频流状态
///
/// [reason]：远端音频流状态改变的原因
typedef OnRemoteAudioStateChangedType = void Function(RemoteStreamKey streamKey,
    RemoteAudioState state, RemoteAudioStateChangeReason reason);

/// [index]：流属性
///
/// [state]：本地视频流状态
///
/// [error]：本地视频状态改变时的错误码
typedef OnLocalVideoStateChangedType = void Function(StreamIndex index,
    LocalVideoStreamState state, LocalVideoStreamError error);

/// @nodoc('Not available')
/// [streamKey]：远端视频流信息
///
/// [state]：远端视频流状态
///
/// [reason]：远端视频流状态改变原因
typedef OnRemoteVideoStateChangedType = void Function(RemoteStreamKey streamKey,
    RemoteVideoState state, RemoteVideoStateChangeReason reason);

/// [streamKey]：远端视频流信息
///
/// [mode]： 超分模式
///
/// [reason]：超分模式改变原因
typedef OnRemoteVideoSuperResolutionModeChangedType = void Function(
    RemoteStreamKey streamKey,
    VideoSuperResolutionMode mode,
    VideoSuperResolutionModeChangedReason reason);

/// [mode]：视频降噪模式
///
/// [reason]：视频降噪模式改变的原因
typedef OnVideoDenoiseModeChangedType = void Function(
    VideoDenoiseMode mode, VideoDenoiseModeChangedReason reason);

/// [uid]：登录用户 ID
///
/// [errorCode]：登录结果
///
/// [elapsed]：从调用 [RTCVideo.login] 接口开始到返回结果所用时长
typedef OnLoginResultType = void Function(
    String uid, LoginErrorCode errorCode, int elapsed);

/// [error]：设置结果
/// + 200：设置成功
/// + 其他：设置失败，详见 [UserMessageSendResult]
typedef OnServerParamsSetResultType = void Function(int error);

/// [peerUid]：需要查询的用户 ID
///
/// [status]：查询的用户登录状态
typedef OnGetPeerOnlineStatusType = void Function(
    String peerUid, UserOnlineStatus status);

/// [msgid]：本条消息的 ID
///
/// [error]：文本或二进制消息发送结果
typedef OnMessageSendResultType = void Function(
    int msgid, UserMessageSendResult error);

/// [msgid]：本条消息的 ID
///
/// [error]：文本或二进制消息发送结果
typedef OnRoomMessageSendResultType = void Function(
    int msgid, RoomMessageSendResult error);

/// [msgid]：本条消息的 ID
///
/// [error]：消息发送结果
///
/// [message]：应用服务器收到 HTTP 请求后，在 ACK 中返回的信息。消息不超过 64 KB。
typedef OnServerMessageSendResultType = void Function(
    int msgid, UserMessageSendResult error, Uint8List message);

/// [uid]：消息发送用户的 ID
///
/// [message]：收到的消息内容
typedef OnMessageReceivedType = void Function(String uid, String message);

/// [uid]：消息发送用户的 ID
///
/// [message]：收到的消息内容
typedef OnBinaryMessageReceivedType = void Function(
    String uid, Uint8List message);

/// [uid]：被封禁/解禁的视频流用户 ID
///
/// [banned]：视频流发送状态
/// + true：视频流发送被封禁
/// + false：视频流发送被解禁
typedef OnVideoStreamBannedType = void Function(String uid, bool banned);

/// [uid]：被封禁/解禁的音频流用户 ID
///
/// [banned]：音频流发送状态
/// + true：音频流发送被封禁
/// + false：音频流发送被解禁
typedef OnAudioStreamBannedType = void Function(String uid, bool banned);

/// [message]：识别完成后得到的文字消息
typedef OnMessageType = void Function(String message);

/// [errorCode]：错误码
/// + `<0`：参数错误或 API 调用顺序错误
/// + `>0`：参看 [语音识别服务错误码](https://www.volcengine.com/docs/6561/80818#_3-3-%E9%94%99%E8%AF%AF%E7%A0%81)
///
/// [errorMessage]：错误原因说明
typedef OnErrorMsgType = void Function(int errorCode, String errorMessage);

/// [result]：人脸检测结果
typedef OnFaceDetectResultType = void Function(FaceDetectionResult result);

/// [uid]：远端流发布用户的用户 ID
///
/// [type]：远端发布的媒体流类型
typedef OnUserPublishStreamType = void Function(
    String uid, MediaStreamType type);

/// [uid]：移除的远端流发布用户的用户 ID
///
/// [type]：移除的远端流类型
///
/// [reason]：远端流移除的原因
typedef OnUserUnpublishStreamType = void Function(
    String uid, MediaStreamType type, StreamRemoveReason reason);

/// [deviceId]：设备 ID
///
/// [deviceType]：设备类型
///
/// [deviceState]：设备状态
///
/// [deviceError]：设备错误类型
typedef OnAudioDeviceStateChangedType = void Function(
    String deviceId,
    AudioDeviceType deviceType,
    MediaDeviceState deviceState,
    MediaDeviceError deviceError);

/// [deviceId]：设备 ID
///
/// [deviceType]：设备类型
///
/// [deviceState]：设备状态
///
/// [deviceError]：设备错误类型
typedef OnVideoDeviceStateChangedType = void Function(
    String deviceId,
    VideoDeviceType deviceType,
    MediaDeviceState deviceState,
    MediaDeviceError deviceError);

/// [deviceId]：设备 ID
///
/// [deviceType]：设备类型
///
/// [deviceWarning]：设备警告码
typedef OnAudioDeviceWarningType = void Function(String deviceId,
    AudioDeviceType deviceType, MediaDeviceWarning deviceWarning);

/// [deviceId]：设备 ID
///
/// [deviceType]：设备类型
///
/// [deviceWarning]：设备警告码
typedef OnVideoDeviceWarningType = void Function(String deviceId,
    VideoDeviceType deviceType, MediaDeviceWarning deviceWarning);

/// [route]：新的音频播放路由
typedef OnAudioRouteChangedType = void Function(AudioRoute route);

/// [roomId]：最活跃用户所在的房间 ID
///
/// [uid]：最活跃用户（ActiveSpeaker）的用户 ID
typedef OnActiveSpeakerType = void Function(String roomId, String uid);

/// @nodoc('Useless')
typedef OnStreamSubscribedType = void Function(
    SubscribeState stateCode, String uid, SubscribeConfig info);

/// [type]：探测网络类型为上行/下行
///
/// [quality]：探测网络的质量
///
/// [rtt]：探测网络的 RTT，单位：ms
///
/// [lostRate]：探测网络的丢包率
///
/// [bitrate]：探测网络的带宽，单位：kbps
///
/// [jitter]：探测网络的抖动,单位：ms
typedef OnNetworkDetectionResultType = void Function(
    NetworkDetectionLinkType type,
    NetworkQuality quality,
    int rtt,
    double lostRate,
    int bitrate,
    int jitter);

/// [reason]：停止探测的原因类型
typedef OnNetworkDetectionStoppedType = void Function(
    NetworkDetectionStopReason reason);

/// [stateInfos]：跨房间媒体流转发目标房间信息数组
typedef OnForwardStreamStateChangedType = void Function(
    List<ForwardStreamStateInfo> stateInfos);

/// [eventInfos]：跨房间媒体流转发目标房间事件数组
typedef OnForwardStreamEventType = void Function(
    List<ForwardStreamEventInfo> eventInfos);

/// [localQuality]：本地网络质量
///
/// [remoteQualities]：已订阅用户的网络质量
typedef OnNetworkQualityType = void Function(NetworkQualityStats localQuality,
    List<NetworkQualityStats> remoteQualities);

/// [roomId]：发布公共流的房间 ID
///
/// [publicStreamId]：公共流 ID
///
/// [errorCode]：公共流发布结果
typedef OnPushPublicStreamResultType = void Function(
    String roomId, String publicStreamId, PublicStreamErrorCode errorCode);

/// [publicStreamId]：公共流 ID
///
/// [errorCode]：公共流订阅结果
typedef OnPlayPublicStreamResultType = void Function(
    String publicStreamId, PublicStreamErrorCode errorCode);

/// [publicStreamId]：公共流 ID
///
/// [message]：收到的 SEI/其他数据消息内容
///
/// [sourceType]：消息来源
typedef OnPublicStreamDataMessageReceivedType = void Function(
    String publicStreamId, Uint8List message, DataMessageSourceType sourceType);

/// [publicStreamId]：公共流 ID
///
/// [channelId]：SEI 的消息传输通道，取值范围 [0 - 255]。
///
/// [message]：收到的 SEI/其他数据消息内容
typedef OnPublicStreamSEIMessageReceivedWithChannelType = void Function(
    String publicStreamId, int channelId, Uint8List message);

/// [publicStreamId]：公共流 ID
///
/// [videoFrameInfo]：视频帧信息
typedef OnFirstPublicStreamVideoFrameDecodedType = void Function(
    String publicStreamId, VideoFrameInfo videoFrameInfo);

/// [publicStreamId]：公共流 ID
typedef OnFirstPublicStreamAudioFrameType = void Function(
    String publicStreamId);

/// [state]：音视频同步状态
typedef OnAVSyncStateChangeType = void Function(AVSyncState state);

/// [interval]：从开启云代理到连接成功经过的时间，单位为 ms
typedef OnCloudProxyConnectedType = void Function(int interval);

/// [result]：检测结果
typedef OnEchoTestResultType = void Function(EchoTestResult result);

/// [eventType]：任务状态
///
/// [taskId]：任务 ID
///
/// [error]：错误码
typedef OnStreamPushEventType = void Function(
    StreamSinglePushEvent eventType, String taskId, int error);

/// [days]：过期时间天数
typedef OnLicenseWillExpireType = void Function(int days);

/// @nodoc('For internal use')
/// [param]：回调内容(JSON string)
typedef OnInvokeExperimentalAPIType = void Function(String param);

/// [result]：通话前回声检测结果。详见 [HardwareEchoDetectionResult]。
typedef OnHardwareEchoDetectionResultType = void Function(
    HardwareEchoDetectionResult result);

/// [extensionName]：插件名字。
///
/// [msg]：失败说明。
typedef OnExtensionAccessErrorType = void Function(
    String extensionName, String msg);

/// [localProxyType]：本地代理类型。
///
/// [localProxyState]：本地代理状态。
///
/// [localProxyError]：本地代理错误
typedef OnLocalProxyStateChangedType = void Function(
    LocalProxyType localProxyType,
    LocalProxyState localProxyState,
    LocalProxyError localProxyError);

/// [taskId]：调用 setRoomExtraInfo 的任务编号。
///
/// [error]：设置房间附加信息的结果。
typedef OnSetRoomExtraInfoResultType = void Function(
    int taskId, SetRoomExtraInfoResult error);

/// [key]：房间附加信息的键值。
///
/// [value]：房间附加信息的内容。
///
/// [lastUpdateUserId]：最后更新本条信息的用户 ID。
///
/// [lastUpdateTimeMs]：最后更新本条信息的 Unix 时间，单位：毫秒。
typedef OnRoomExtraInfoUpdateType = void Function(
    String key, String value, String lastUpdateUserId, int lastUpdateTimeMs);

/// [state]：字幕状态。
///
/// [errorCode]：字幕任务错误码。
///
/// [errorMessage]：与第三方服务有关的错误信息。
typedef OnSubtitleStateChangedType = void Function(
    SubtitleState state, SubtitleErrorCode errorCode, String errorMessage);

/// [subtitles]：字幕消息内容。
typedef OnSubtitleMessageReceivedType = void Function(
    List<SubtitleMessage> subtitles);

/// [currentUserVisibility]：当前用户的可见性。
/// + true：可见，用户可以在房间内发布音视频流，房间中的其他用户将收到用户的行为通知，例如进房、开启视频采集和退房。
/// + false：不可见，用户不可以在房间内发布音视频流，房间中的其他用户不会收到用户的行为通知，例如进房、开启视频采集和退房。
///
/// [errorCode]：设置用户可见性错误码。
typedef OnUserVisibilityChangedType = void Function(
    bool currentUserVisibility, UserVisibilityChangeError errorCode);
