// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/bytertc_video_event_impl.dart';
import 'bytertc_event_define.dart';

/// RTCVideo 事件回调接口
class RTCVideoEventHandler with RTCVideoEventValue {
  /// 发生警告回调
  ///
  /// 该回调方法表示 SDK 运行时出现了（网络或媒体相关的）警告。通常情况下，警告信息可以忽略，SDK 会自动恢复。
  OnWarningType? onWarning;

  /// 发生错误回调
  ///
  /// 当 SDK 运行时出现了网络或媒体相关的错误，且无法自动恢复时触发此回调。
  OnErrorType? onError;

  /// 创建房间失败回调
  OnCreateRoomStateChangedType? onCreateRoomStateChanged;

  /// 当 SDK 与 RTC 服务器的网络连接状态改变时，收到该回调
  OnConnectionStateChanged? onConnectionStateChanged;

  /// 当客户端的网络连接类型发生改变时，收到此回调
  OnNetworkTypeChangedType? onNetworkTypeChanged;

  /// 远端用户调用 [RTCVideo.startAudioCapture] 开启音频设备采集时，房间内其他人会收到这个回调
  OnUserOperateMediaCaptureType? onUserStartAudioCapture;

  /// 房间内的用户调用 [RTCVideo.stopAudioCapture] 关闭音频采集时，房间内其他用户会收到此回调
  OnUserOperateMediaCaptureType? onUserStopAudioCapture;

  /// 本地采集到第一帧音频帧时，收到此回调
  OnFirstLocalAudioFrameType? onFirstLocalAudioFrame;

  /// 接收到来自远端音频流的第一帧时，收到该回调
  OnFirstRemoteAudioFrameType? onFirstRemoteAudioFrame;

  /// 调用 [RTCVideo.enableAudioPropertiesReport] 后，会周期性收到此回调，获取本地麦克风和屏幕采集的音量信息
  OnLocalAudioPropertiesReportType? onLocalAudioPropertiesReport;

  /// 调用 [RTCVideo.enableAudioPropertiesReport] 后，会周期性收到此回调，获取远端内部采集或自定义采集的音量信息
  ///
  /// 远端用户的音频包括使用 RTC SDK 内部机制/自定义机制采集的麦克风音频和屏幕音频。
  OnRemoteAudioPropertiesReportType? onRemoteAudioPropertiesReport;

  /// 调用 [RTCVideo.enableAudioPropertiesReport] 后，你会周期性地收到此回调，获取房间内的最活跃用户信息
  OnActiveSpeakerType? onActiveSpeaker;

  /// 房间内的用户调用 [RTCVideo.startVideoCapture] 开启视频采集时，房间内其他用户会收到此回调
  OnUserOperateMediaCaptureType? onUserStartVideoCapture;

  /// 房间内的用户调用 [RTCVideo.stopVideoCapture] 关闭视频采集时，房间内其他用户会收到此回调
  OnUserOperateMediaCaptureType? onUserStopVideoCapture;

  /// 第一帧本地采集的视频/屏幕共享画面在本地视图渲染完成后，收到此回调
  OnFirstLocalVideoFrameCapturedType? onFirstLocalVideoFrameCaptured;

  /// 第一帧远端视频流在视图上渲染成功后，收到此回调
  OnFirstRemoteVideoFrameRenderedType? onFirstRemoteVideoFrameRendered;

  /// 第一帧远端视频流成功解码后，收到此回调
  OnFirstRemoteVideoFrameRenderedType? onFirstRemoteVideoFrameDecoded;

  /// 远端视频大小或旋转配置发生改变时，房间内订阅此视频流的用户会收到此回调
  OnRemoteVideoSizeChangedType? onRemoteVideoSizeChanged;

  /// 本地视频大小或旋转信息发生改变时，收到此回调
  OnLocalVideoSizeChangedType? onLocalVideoSizeChanged;

  /// 音频设备状态回调
  OnAudioDeviceStateChangedType? onAudioDeviceStateChanged;

  /// 视频设备状态回调
  OnVideoDeviceStateChangedType? onVideoDeviceStateChanged;

  /// 音频设备警告回调
  OnAudioDeviceWarningType? onAudioDeviceWarning;

  /// 视频设备警告回调
  OnVideoDeviceWarningType? onVideoDeviceWarning;

  /// 音频首帧发送状态改变回调
  OnMediaFrameSendStateChangedType? onAudioFrameSendStateChanged;

  /// 视频首帧发送状态改变回调
  OnMediaFrameSendStateChangedType? onVideoFrameSendStateChanged;

  /// 屏幕共享流视频首帧发送状态改变回调
  OnMediaFrameSendStateChangedType? onScreenVideoFrameSendStateChanged;

  /// 音频首帧播放状态改变回调
  OnMediaFramePlayStateChangedType? onAudioFramePlayStateChanged;

  /// 视频首帧播放状态改变回调
  OnMediaFramePlayStateChangedType? onVideoFramePlayStateChanged;

  /// 屏幕共享流视频首帧播放状态改变回调
  OnMediaFramePlayStateChangedType? onScreenVideoFramePlayStateChanged;

  /// 音频播放路由变化时，收到该回调
  ///
  /// 插拔音频外设，或调用 [RTCVideo.setAudioRoute] 都可能触发音频路由切换，详见[音频路由](https://www.volcengine.com/docs/6348/117386)
  OnAudioRouteChangedType? onAudioRouteChanged;

  /// 收到带有 SEI 消息的视频帧时，收到此回调
  OnSEIMessageReceivedType? onSEIMessageReceived;

  /// 黑帧视频流发布状态回调
  ///
  /// 在语音通话场景下，本地用户调用 [RTCVideo.sendSEIMessage] 通过黑帧视频流发送 SEI 数据时，流的发送状态会通过该回调通知远端用户。 <br>
  /// 你可以通过此回调判断携带 SEI 数据的视频帧为黑帧，从而不对该视频帧进行渲染。
  OnSEIStreamUpdateType? onSEIStreamUpdate;

  /// 收到远端用户调用 [RTCVideo.sendStreamSyncInfo] 发送的音频流同步消息后，收到此回调。
  OnStreamSyncInfoReceivedType? onStreamSyncInfoReceived;

  /// 周期性（2s）收到此回调，获取当前 CPU 与内存的使用率
  OnSysStatsType? get onSysStats;
  set onSysStats(OnSysStatsType? onSysStats);

  /// 本地音频的状态发生改变时，收到此回调。
  OnLocalAudioStateChangedType? onLocalAudioStateChanged;

  /// 用户订阅来自远端的音频流状态发生改变时，收到此回调。
  OnRemoteAudioStateChangedType? onRemoteAudioStateChanged;

  /// 本地视频流的状态发生改变时，收到此回调。
  OnLocalVideoStateChangedType? onLocalVideoStateChanged;

  /// 远端视频流的状态发生改变时，房间内订阅此流的用户收到此回调。
  OnRemoteVideoStateChangedType? onRemoteVideoStateChanged;

  /// 调用 [RTCVideo.login] 后，收到此回调。
  OnLoginResultType? onLoginResult;

  /// 调用 [RTCVideo.logout] 后，收到此回调。
  EmptyCallbackType? onLogout;

  /// 调用 [RTCVideo.setServerParams] 后，收到此回调。
  OnServerParamsSetResultType? onServerParamsSetResult;

  /// 调用 [RTCVideo.getPeerOnlineStatus] 后，收到此回调。
  OnGetPeerOnlineStatusType? onGetPeerOnlineStatus;

  /// 收到房间外用户调用 [RTCVideo.sendUserMessageOutsideRoom] 发来的文本消息时，会收到此回调
  OnMessageReceivedType? onUserMessageReceivedOutsideRoom;

  /// 收到房间外用户调用 [RTCVideo.sendUserBinaryMessageOutsideRoom] 发来的二进制消息时，会收到此回调
  OnBinaryMessageReceivedType? onUserBinaryMessageReceivedOutsideRoom;

  /// 收到房间外用户调用 [RTCVideo.sendUserMessageOutsideRoom] 发来的二进制消息时，会收到此回调
  OnMessageSendResultType? onUserMessageSendResultOutsideRoom;

  /// 当调用 [RTCVideo.sendServerMessage] 或 [RTCVideo.sendServerBinaryMessage] 发送消息后，会收到此回调。
  OnServerMessageSendResultType? onServerMessageSendResult;

  /// 通话前网络探测结果
  ///
  /// 成功调用 [RTCVideo.startNetworkDetection] 接口开始探测后，会在 3s 内首次收到该回调，之后每 2s 收到一次该回调。
  OnNetworkDetectionResultType? onNetworkDetectionResult;

  /// 通话前网络探测结束
  ///
  /// 以下情况将停止探测并收到本一次本回调：
  /// + 调用 [RTCVideo.stopNetworkDetection] 接口停止探测；
  /// + 当收到远端/本端音频首帧后，停止探测；
  /// + 当探测超过 3 分钟后，停止探测；
  /// + 当探测链路断开一定时间之后，停止探测。
  OnNetworkDetectionStoppedType? onNetworkDetectionStopped;

  /// 音频混音文件播放状态改变时回调
  ///
  /// 此回调会被触发的时机汇总如下：
  /// + 调用 [RTCVideo.startAudioMixing] 成功；
  /// + 使用相同的 ID 重复调用 [RTCVideo.startAudioMixing]；
  /// + 调用 [RTCVideo.pauseAudioMixing] 暂停播放成功；
  /// + 调用 [RTCVideo.resumeAudioMixing]恢复播放成功；
  /// + 调用 [RTCVideo.stopAudioMixing] 暂停止播放成功；
  /// + 播放结束。
  OnAudioMixingStateChangedType? onAudioMixingStateChanged;

  /// 混音音频文件播放进度回调
  ///
  /// 调用 [RTCAudioMixingManager.setAudioMixingProgressInterval] 将时间间隔设为大于 0 的值后，或调用 [RTCAudioMixingManager.startAudioMixing] 将 `config` 中的时间间隔设为大于 0 的值后，SDK 会按照设置的时间间隔回调该事件。
  OnAudioMixingPlayingProgressType? onAudioMixingPlayingProgress;

  /// 未开启发布性能回退，检测到设备性能不足时，收到此回调；<br>
  /// 开启发布性能回退，因设备性能/网络原因，造成发布性能回退/恢复时，收到此回调。
  OnPerformanceAlarmsType? onPerformanceAlarms;

  /// 音视频流因网络环境变化等原因发生回退，或从回退中恢复时，触发该回调
  OnSimulcastSubscribeFallbackType? onSimulcastSubscribeFallback;

  /// HTTP 代理连接状态改变时，收到该回调。
  OnHttpProxyStateType? onHttpProxyState;

  /// HTTPS 代理连接状态改变时，收到该回调。
  OnHttpsProxyStateType? onHttpsProxyState;

  /// Socks5 代理状态改变时，收到该回调。
  OnSocks5ProxyStateType? onSocks5ProxyState;

  /// 调用 [RTCVideo.startFileRecording] 或 [RTCVideo.stopFileRecording] 时，收到此回调。
  OnRecordingStateUpdateType? onRecordingStateUpdate;

  /// 调用 [RTCVideo.startFileRecording] 正常进行本地录制时，会周期性（1s）收到此回调。
  OnRecordingProgressUpdateType? onRecordingProgressUpdate;

  /// 公共流发布结果回调
  ///
  /// 调用 [RTCVideo.startPushPublicStream] 接口发布公共流后，启动结果通过此回调方法通知用户。
  OnPushPublicStreamResultType? onPushPublicStreamResult;

  /// 订阅公共流的结果回调
  ///
  /// 调用 [RTCVideo.startPlayPublicStream] 接口启动拉公共流功能后，通过此回调收到启动结果和拉流过程中的错误。
  OnPlayPublicStreamResultType? onPlayPublicStreamResult;

  /// 回调公共流中包含的 SEI 信息
  ///
  /// 调用 [RTCVideo.startPlayPublicStream] 接口启动拉公共流功能后，通过此回调收到公共流中的SEI消息。
  ///
  /// 注意，当公共流中的多路视频流均包含有 SEI 信息时：
  /// + SEI 不互相冲突时，将通过多次回调分别发送；
  /// + SEI 在同一帧有冲突时，则只有一条流中的 SEI 信息被透传并融合到公共流中。
  OnPublicStreamSEIMessageReceivedType? onPublicStreamSEIMessageReceived;

  /// 公共流的首帧视频解码成功
  OnFirstPublicStreamVideoFrameDecodedType?
      onFirstPublicStreamVideoFrameDecoded;

  /// 公共流的音频首帧解码成功的回调
  OnFirstPublicStreamAudioFrameType? onFirstPublicStreamAudioFrame;

  /// 调用 [RTCVideo.startCloudProxy] 开启云代理，SDK 首次成功连接云代理服务器时，回调此事件
  OnCloudProxyConnectedType? onCloudProxyConnected;

  /// 关于音视频回路测试结果的回调
  ///
  /// 该回调触发的时机包括：
  /// + 检测过程中采集设备发生错误时；
  /// + 检测成功后；
  /// + 非设备原因导致检测过程中未接收到音/视频回放，停止检测后。
  OnEchoTestResultType? onEchoTestResult;

  RTCVideoEventHandler({
    this.onWarning,
    this.onError,
    this.onCreateRoomStateChanged,
    this.onConnectionStateChanged,
    this.onNetworkTypeChanged,
    this.onUserStartAudioCapture,
    this.onUserStopAudioCapture,
    this.onFirstLocalAudioFrame,
    this.onFirstRemoteAudioFrame,
    this.onLocalAudioPropertiesReport,
    this.onRemoteAudioPropertiesReport,
    this.onActiveSpeaker,
    this.onUserStartVideoCapture,
    this.onUserStopVideoCapture,
    this.onFirstLocalVideoFrameCaptured,
    this.onFirstRemoteVideoFrameRendered,
    this.onFirstRemoteVideoFrameDecoded,
    this.onRemoteVideoSizeChanged,
    this.onLocalVideoSizeChanged,
    this.onAudioDeviceStateChanged,
    this.onVideoDeviceStateChanged,
    this.onAudioDeviceWarning,
    this.onVideoDeviceWarning,
    this.onAudioFrameSendStateChanged,
    this.onVideoFrameSendStateChanged,
    this.onScreenVideoFrameSendStateChanged,
    this.onAudioFramePlayStateChanged,
    this.onVideoFramePlayStateChanged,
    this.onScreenVideoFramePlayStateChanged,
    this.onAudioRouteChanged,
    this.onSEIMessageReceived,
    this.onSEIStreamUpdate,
    this.onStreamSyncInfoReceived,
    OnSysStatsType? onSysStats,
    this.onLocalAudioStateChanged,
    this.onRemoteAudioStateChanged,
    this.onLocalVideoStateChanged,
    this.onRemoteVideoStateChanged,
    this.onLoginResult,
    this.onLogout,
    this.onServerParamsSetResult,
    this.onGetPeerOnlineStatus,
    this.onUserMessageReceivedOutsideRoom,
    this.onUserBinaryMessageReceivedOutsideRoom,
    this.onUserMessageSendResultOutsideRoom,
    this.onServerMessageSendResult,
    this.onNetworkDetectionResult,
    this.onNetworkDetectionStopped,
    this.onAudioMixingStateChanged,
    this.onAudioMixingPlayingProgress,
    this.onPerformanceAlarms,
    this.onSimulcastSubscribeFallback,
    this.onHttpProxyState,
    this.onHttpsProxyState,
    this.onSocks5ProxyState,
    this.onRecordingStateUpdate,
    this.onRecordingProgressUpdate,
    this.onPushPublicStreamResult,
    this.onPlayPublicStreamResult,
    this.onPublicStreamSEIMessageReceived,
    this.onFirstPublicStreamVideoFrameDecoded,
    this.onFirstPublicStreamAudioFrame,
    this.onCloudProxyConnected,
    this.onEchoTestResult,
  }) {
    this.onSysStats = onSysStats;
  }
}
