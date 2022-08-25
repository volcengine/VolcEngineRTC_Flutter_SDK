// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';

/// 回调警告码
///
/// 警告码说明 SDK 内部遇到问题正在尝试恢复。<br>
/// 警告码仅作通知。
enum WarningCode {
  /// 未知警告码
  unknown,

  /// 进房失败
  ///
  /// 初次进房或者由于网络状况不佳断网重连时，由于服务器错误导致进房失败。<br>
  /// SDK 会自动重试进房。
  joinRoomFailed,

  /// 发布音视频流失败
  ///
  /// 当你在所在房间中发布音视频流时，由于服务器错误导致发布失败。<br>
  /// SDK 会自动重试发布。
  publishStreamFailed,

  /// 当前房间中找不到订阅的音视频流导致订阅失败
  ///
  /// SDK 会自动重试订阅，若仍订阅失败则建议你退出重试。
  subscribeStreamFailed404,

  /// 服务器错误导致订阅失败
  ///
  /// SDK 会自动重试订阅。
  subscribeStreamFailed5xx,

  /// 当调用 [RTCRoom.setUserVisibility] 将自身可见性设置为 false 后，再尝试发布流会触发此警告
  publishStreamForbidden,

  /// 发送自定义广播消息失败, 本地用户未在房间中
  sendCustomMessage,

  /// 当房间内人数超过 500 人时，停止向房间内已有用户发送 [RTCRoomEventHandler.onUserJoined] 和 [RTCRoomEventHandler.onUserLeave] 回调，并通过广播提示房间内所有用户
  receiveUserNotifyStop,

  /// 用户已经在其他房间发布过流，或者用户正在发布公共流
  userInPublish,

  /// 同样 roomId 的房间已经存在
  roomIdAlreadyExist,

  /// 相同 roomId 的新房间已替代旧房间
  oldRoomBeenReplaced,

  /// 当前正在进行回路测试，该接口调用无效
  inEchoTestMode,

  /// 摄像头权限异常，当前应用没有获取摄像头权限
  noCameraPermission,

  /// 不支持在 [RTCRoom.publishScreen] 之后，切换屏幕音频采集源
  setScreenAudioSourceTypeFailed,

  /// 不支持在 [RTCRoom.publishScreen] 之后，调用 [RTCVideo.setScreenAudioStreamIndex] 设置屏幕音频共享发布类型
  setScreenAudioStreamIndexFailed,

  /// 设置语音音高不合法
  invalidVoicePitch,

  /// 外部音频源新旧接口混用
  invalidCallForExtAudio,

  /// 适用于iOS，指定的内部渲染画布句柄无效
  invalidCanvasHandle,
}

/// 回调错误码
///
/// SDK 内部遇到不可恢复的错误时，会通过 [RTCVideoEventHandler.onError] 回调通知用户。
enum ErrorCode {
  /// 未知错误码
  unknown,

  /// Token 无效
  ///
  /// 进房时使用的 Token 无效或过期失效，需要用户重新获取 Token，并调用 [RTCRoom.updateToken] 方法更新 Token。
  invalidToken,

  /// 加入房间错误
  ///
  /// 进房时发生未知错误导致加入房间失败，需要用户重新加入房间。
  joinRoom,

  /// 没有发布音视频流权限
  ///
  /// 用户在所在房间中发布音视频流失败，失败原因为用户没有发布流的权限。
  noPublishPermission,

  /// 没有订阅音视频流权限
  ///
  /// 用户订阅所在房间中的音视频流失败，失败原因为用户没有订阅流的权限。
  noSubscribePermission,

  /// 有相同用户 ID 的用户加入本房间，导致当前用户被踢出房间
  duplicateLogin,

  /// App ID 参数异常，Android 适用
  ///
  /// 创建引擎时传入的 App ID 参数为空。
  appIdNull,

  /// 服务端调用 OpenAPI 将当前用户踢出房间
  kickedOut,

  /// 当调用 [RTCVideo.createRTCRoom] 时传入的 roomId 非法，会返回 null，并抛出该错误
  roomIdIllegal,

  /// Token 过期
  ///
  /// 用户需使用新的 Token 重新加入房间。
  tokenExpired,

  /// 调用 [RTCRoom.updateToken] 传入的 Token 无效
  updateTokenWithInvalidToken,

  /// 服务端调用 OpenAPI 解散房间，所有用户被移出房间。
  roomDismiss,

  /// 进房时，LICENSE 计费账号未使用 LICENSE_AUTHENTICATE SDK，导致加入房间错误。
  joinRoomWithoutLicenseAuthenticateSDK,

  /// 通话回路检测已存在同样 roomId 的房间
  roomAlreadyExist,

  /// 订阅音视频流失败，订阅音视频流总数超过上限
  ///
  /// 游戏场景下为了保证音视频通话的性能和质量，服务器会限制用户订阅的音视频流的总数。<br>
  /// 当用户订阅的音视频流总数已达上限时，继续订阅更多流时会失败，同时用户会收到此错误通知。
  overStreamSubscribeLimit,

  /// 发布流失败，发布流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的总流数，总流数包括视频流、音频流和屏幕流。<br>
  /// 如果房间内发布流数已达上限时，本地用户再向房间中发布流时会失败，同时会收到此错误通知。
  overStreamPublishLimit,

  /// 发布屏幕流失败，发布流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的总流数，总流数包括视频流、音频流和屏幕流。<br>
  /// 如果房间内发布流数已达上限时，本地用户再向房间中发布流时会失败，同时会收到此错误通知。
  overScreenPublishLimit,

  /// 发布视频流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的视频流数。<br>
  /// 如果房间内发布视频流数已达上限时，本地用户再向房间中发布视频流时会失败，同时会收到此错误通知。
  overVideoPublishLimit,

  /// 音视频同步失败
  ///
  /// 当前音频源已与其他视频源关联同步关系。<br>
  /// 单个音频源不支持与多个视频源同时同步。
  invalidAudioSyncUidRepeated,

  /// 服务端异常状态导致退出房间。
  ///
  /// SDK与信令服务器断开，并不再自动重连，可联系技术支持。
  abnormalServerStatus,
}

/// 远端用户离开房间的原因
enum UserOfflineReason {
  /// 远端用户调用 [RTCRoom.leaveRoom] 方法主动退出房间
  quit,

  /// 远端用户因网络等原因掉线
  dropped,

  /// 远端用户切换至隐身状态
  switchToInvisible,

  /// 服务端调用 OpenAPI，将远端用户踢出房间
  kickedByAdmin,
}

/// 房间内远端流移除原因
enum StreamRemoveReason {
  /// 远端用户停止发布流
  unpublish,

  /// 远端用户发布流失败
  publishFailed,

  /// 保活失败
  keepLiveFailed,

  /// 远端用户断网
  clientDisconnected,

  /// 远端用户重新发布流
  republish,

  /// 其他原因
  other,
}

/// 登录结果
///
/// 调用 [RTCVideo.login] 登录的结果，会通过 [RTCVideoEventHandler.onLoginResult] 回调通知用户。
enum LoginErrorCode {
  /// 登录成功
  success,

  /// Token 无效或过期失效，需要用户重新获取 Token
  invalidToken,

  /// 发生未知错误导致登录失败，需要重新登录
  loginFailed,

  /// 调用 [RTCVideo.login] 传入的用户 ID 有问题
  invalidUserId,

  /// 登录时服务器发生错误
  codeServerError,
}

/// 发送消息的可靠有序性
enum MessageConfig {
  /// 低延时可靠有序消息
  reliableOrdered,

  /// 超低延时有序消息
  unreliableOrdered,

  /// 超低延时无序消息
  unreliableUnordered,
}

/// 消息发送结果
enum UserMessageSendResult {
  /// 发送成功
  success,

  /// 发送超时，没有发送
  timeout,

  /// 通道断开，没有发送
  broken,

  /// 找不到接收方
  noReceiver,

  /// 获取级联路径失败
  noRelayPath,

  /// 发送端用户未加入房间
  notJoin,

  /// 连接未完成初始化
  init,

  /// 没有可用的数据传输通道连接
  noConnection,

  /// 消息超过最大长度（64KB）
  exceedMaxLength,

  /// 消息接收的单个用户 ID 为空
  emptyUser,

  /// 房间外或应用服务器消息发送方没有登录
  notLogin,

  /// 发送消息给业务方服务器之前没有设置参数
  serverParamsNotSet,

  /// 发送失败，错误未知
  unknown,
}

/// 用户在线状态
enum UserOnlineStatus {
  /// 对端用户离线
  ///
  /// 对端用户已登出或尚未登录
  offline,

  /// 对端用户在线
  ///
  /// 对端已登录并且连接状态正常
  online,

  /// 无法获取对端用户在线状态
  ///
  /// 发生级联错误、对端用户在线状态异常时返回
  unreachable,
}

/// 房间内群发消息结果
enum RoomMessageSendResult {
  /// 发送成功
  success,

  /// 发送失败，消息发送方没有加入房间
  notJoin,

  /// 发送失败，连接未完成初始化
  init,

  /// 发送失败，没有可用的数据传输通道连接
  noConnection,

  /// 发送失败，消息超过最大长度（64KB）
  exceedMaxLength,

  /// 发送失败，错误未知
  unknown,
}

/// SDK 与 RTC 服务器连接状态
enum RTCConnectionState {
  /// 连接断开，且断开时长超过 12s，SDK 会自动重连
  disconnected,

  /// 首次请求建立连接，正在连接中
  connecting,

  /// 首次连接成功
  connected,

  /// 涵盖以下情况：
  /// + 首次连接时，10 秒内未连接成功；
  /// + 连接成功后，断连 10 秒。自动重连中。
  reconnecting,

  /// 连接断开后，重连成功
  reconnected,

  /// 处于 `disconnected` 状态超过 10 秒，且期间重连未成功，SDK 仍将继续尝试重连
  lost,

  /// 连接失败，服务端状态异常
  ///
  /// SDK 不会自动重连，请重新进房，或联系技术支持
  failed,
}

/// 网络类型
enum NetworkType {
  /// 未知网络链接类型
  unknown,

  /// 网络连接已断开
  disconnected,

  /// LAN
  lan,

  /// Wi-Fi，包含热点连接
  wifi,

  /// 2G 移动网络
  mobile2G,

  /// 3G 移动网络
  mobile3G,

  /// 4G 移动网络
  mobile4G,

  /// 5G 移动网络
  mobile5G,
}

/// 开启通话前网络探测的结果
enum NetworkDetectionStartReturn {
  /// 成功开启网络探测
  success,

  /// 开始探测失败
  ///
  /// 参数错误，上下行网络探测均为 `false`，或期望带宽超过了范围 [100,10000]
  paramError,

  /// 开始探测失败，本地已经开始推拉流
  streaming,

  /// 已经开始探测，无需重复开启
  started,

  /// 不支持该功能
  notSupport,
}

/// 通话前网络探测停止的原因
enum NetworkDetectionStopReason {
  /// 用户主动停止
  user,

  /// 开启探测时长已超过 3 分钟，已自动停止
  timeout,

  /// 探测网络连接断开
  ///
  /// 当超过 12s 没有收到回复，SDK 将断开网络连接，并且不再尝试重连
  connectionLost,

  /// 本地开始推拉流，停止探测
  streaming,

  /// 内部异常导致网络探测失败
  innerErr,
}

/// 通话前探测的网络类型
enum NetworkDetectionLinkType {
  /// 上行网络
  up,

  /// 下行网络
  down,
}

/// 所属用户的媒体流网络质量
enum NetworkQuality {
  /// 媒体流网络质量未知
  unKnown,

  /// 媒体流网络质量极好
  excellent,

  /// 媒体流网络质量较好
  good,

  /// 媒体流网络质量较差，但不影响沟通
  poor,

  /// 媒体流网络质量较差，沟通不顺畅
  bad,

  /// 媒体流网络质量极差
  veryBad,
}

/// 上行/下行网络质量相关数据
class NetworkQualityStats {
  /// 用户 ID
  String uid;

  /// 丢包率，范围 [0.0,1.0]
  /// + 当 `uid` 为本地用户时，该值代表本地发布流的上行丢包率；
  /// + 当 `uid` 为远端用户时，该值代表本地接收所有订阅的远端流的下行丢包率。
  double fractionLost;

  /// 当 `uid` 为本地用户时有效，客户端到服务端的往返延时，单位：ms
  int rtt;

  /// 本端的音视频 RTP 包 2 秒内的平均传输速率，单位：bps
  /// + 当 `uid` 为本地用户时，代表发送速率；
  /// + 当 `uid` 为远端用户时，代表所有订阅流的接收速率。
  int totalBandwidth;

  /// 上行网络质量分，范围 [0,5]，分数越高网络质量越差
  NetworkQuality txQuality;

  /// 下行网络质量分，范围 [0,5]，分数越高网络质量越差
  NetworkQuality rxQuality;

  NetworkQualityStats(
      {required this.uid,
      required this.fractionLost,
      required this.rtt,
      required this.totalBandwidth,
      required this.txQuality,
      required this.rxQuality});

  factory NetworkQualityStats.fromMap(Map<dynamic, dynamic> map) {
    return NetworkQualityStats(
        uid: map['uid'],
        fractionLost: map['fractionLost'],
        rtt: map['rtt'],
        totalBandwidth: map['totalBandwidth'],
        txQuality: (map['txQuality'] as int).networkQuality,
        rxQuality: (map['rxQuality'] as int).networkQuality);
  }
}

/// 房间模式
enum RoomProfile {
  /// 通信模式（默认）
  communication,

  @Deprecated('use interactivePodcast instead')
  liveBroadCasting,

  /// 游戏模式
  ///
  /// 低功耗、低流量消耗。
  /// 为低端机提供了额外的性能优化，并提升了游戏录屏对 iOS 其他进程的兼容性。
  game,

  /// 云游戏模式
  ///
  /// 适用于低延迟、高码率的业务场景。
  /// 该模式下，音视频通话延时会明显降低，但同时弱网抗性、通话音质等均会受到一定影响，因此在使用此模式前，强烈建议咨询技术支持同学。
  cloudGame,

  /// 云渲染模式
  ///
  /// 超低延时配置，适用于非游戏但又对延时要求较高的场景。
  /// 该模式下，音视频通话延时会明显降低，但同时弱网抗性、通话音质等均会受到一定影响。
  lowLatency,

  /// 适用于 1 vs 1 音视频通话场景
  chat,

  /// 适用于 3 人及以上纯语音通话
  ///
  /// 音视频通话为媒体模式，上麦时切换为通话模式
  chatRoom,

  /// 实现多端同步播放音视频，适用于 “一起看” 或 “一起听” 场景
  ///
  /// 该场景中，使用 RTC 信令同步播放进度，共享的音频内容不通过 RTC 进行传输。
  lwTogether,

  /// 适用于对音质要求较高的游戏场景，优化音频 3A 策略，只通过媒体模式播放音频
  gameHD,

  /// 适用于直播中主播之间连麦的场景
  ///
  /// 该场景中，直播时使用 CDN，发起连麦 PK 时使用 RTC。
  coHost,

  /// 适用于单主播和观众进行音视频互动的直播
  ///
  /// 使用通话模式，并且上下麦不会有模式切换，避免音量突变现象。
  interactivePodcast,

  /// 线上 KTV 场景
  ///
  /// 音乐音质，低延迟。
  /// 使用 RTC 传输伴奏音乐、混音后的歌声，适合独唱或单通合唱。
  ktv,

  /// 适合在线实时合唱场景
  ///
  /// 高音质，超低延迟。
  /// 使用此模式前请联系技术支持协助完成其他配置。
  chorus,

  /// 适用于 VR 场景
  ///
  /// 支持最高 192 KHz 音频采样率，可开启球形立体声。
  /// 346 及之后版本支持使用该模式。
  vrChat,

  /// 适用于 1 vs 1 游戏串流，支持公网或局域网
  gameStreaming,

  /// 适用于局域网的 1 对多视频直播
  ///
  /// 最高支持分辨率为 8K，帧率为 60fps，码率为 100 Mbps。
  /// 需要在局域网配置私有化部署媒体服务器。
  lanLiveStreaming,

  /// 适用于云端会议中的个人设备
  meeting,

  /// 适用于云端会议中的会议室终端设备
  meetingRoom,

  /// 适用于课堂互动，房间内所有成员都可以进行音视频互动
  ///
  /// 当应用场景中超过 10 人需要同时进行互动时建议使用此模式。
  classroom,
}

/// 订阅媒体流状态
enum SubscribeState {
  /// 订阅/取消订阅流成功
  success,

  /// 订阅/取消订阅流失败，本地用户未在房间中
  failedNotInRoom,

  /// 订阅/取消订阅流失败，房间内未找到指定的音视频流
  failedStreamNotFound,

  /// 订阅流数超上限
  failedOverLimit,
}

/// 远端用户优先级，在性能不足需要回退时，会先回退优先级低的用户的音视频流
enum RemoteUserPriority {
  /// 低优先级（默认）
  low,

  /// 优先级为正常
  medium,

  /// 高优先级
  high,
}

/// 发布端音视频流回退选项
enum PublishFallbackOption {
  /// 上行网络不佳或设备性能不足时，不对音视频流作回退处理，默认设置。
  disable,

  /// 上行网络不佳或设备性能不足时，发布的视频流会从大流到小流依次降级，直到与当前网络性能匹配
  simulcastSmallVideoOnly
}

/// 订阅端音视频流回退选项
enum SubscribeFallbackOption {
  /// 下行网络不佳或设备性能不足时，不对音视频流作回退处理，默认设置。
  disable,

  /// 下行网络不佳或设备性能不足时，对视频流做降级处理
  ///
  /// 该设置仅对发布端调用 [RTCVideo.enableSimulcastMode] 开启发送多路流功能的情况生效。
  streamLow,

  /// 下行网络不佳或设备性能不足时，取消接收视频，仅接收音频
  audioOnly
}

/// 远端订阅流发生回退或从回退中恢复的原因
enum FallbackOrRecoverReason {
  /// 其他原因，非带宽和性能原因引起的回退或恢复，默认值
  unknown,

  /// 由带宽不足导致的订阅端音视频流回退
  subscribeFallbackByBandwidth,

  /// 由性能不足导致的订阅端音视频流回退
  subscribeFallbackByPerformance,

  /// 由带宽恢复导致的订阅端音视频流恢复
  subscribeRecoverByBandwidth,

  /// 由性能恢复导致的订阅端音视频流恢复
  subscribeRecoverByPerformance,

  /// 由带宽不足导致的发布端音视频流回退
  publishFallbackByBandwidth,

  /// 由性能不足导致的发布端音视频流回退
  publishFallbackByPerformance,

  /// 由带宽恢复导致的发布端音视频流恢复
  publishRecoverByBandwidth,

  /// 由性能恢复导致的发布端音视频流恢复
  publishRecoverByPerformance,
}

/// 性能相关的告警原因
enum PerformanceAlarmReason {
  /// 网络原因差，造成了发送性能回退
  ///
  /// 仅在开启发送性能回退时，会收到此原因。
  bandwidthFallbacked,

  /// 网络性能恢复，发送性能回退恢复
  ///
  /// 仅在开启发送性能回退时，会收到此原因。
  bandwidthResumed,

  /// 如果未开启发送性能回退，收到此告警时，意味着性能不足；如果开启了发送性能回退，收到此告警时，意味着性能不足，且已发生发送性能回退
  performanceFallbacked,

  /// 如果未开启发送性能回退，收到此告警时，意味着性能不足已恢复；如果开启了发送性能回退，收到此告警时，意味着性能不足已恢复，且已发生发送性能回退恢复。
  performanceResumed
}

/// 是否开启发布性能回退
enum PerformanceAlarmMode {
  /// 未开启发布性能回退
  normal,

  /// 已开启发布性能回退
  simulcast,
}

/// 本地音频流状态，及在 [LocalAudioStreamError] 中对应的错误码
enum LocalAudioStreamState {
  /// 本地音频默认初始状态
  ///
  /// 麦克风停止工作时回调该状态，对应错误码 `ok`
  stopped,

  /// 本地音频录制设备启动成功
  ///
  /// 采集到音频首帧时回调该状态，对应错误码 `ok`
  recording,

  /// 本地音频首帧编码成功。
  ///
  /// 音频首帧编码成功时回调该状态，对应错误码 `ok`
  encoding,

  ///  本地音频启动失败，在以下时机回调该状态：
  /// + 本地录音设备启动失败，对应错误码 `recordFailure`
  /// + 检测到没有录音设备权限，对应错误码 `deviceNoPermission`
  /// + 音频编码失败，对应错误码 `encodeFailure`
  failed
}

/// 本地音频流状态改变时的错误码
enum LocalAudioStreamError {
  /// 本地音频状态正常
  ok,

  /// 本地音频出错原因未知
  failure,

  /// 没有权限启动本地音频录制设备
  deviceNoPermission,

  /// 本地音频录制设备已经在使用中
  ///
  /// 该错误码暂未使用
  deviceBusy,

  /// 本地音频录制失败，建议你检查录制设备是否正常工作
  recordFailure,

  /// 本地音频编码失败
  encodeFailure,

  /// 没有可用的音频录制设备
  noRecordingDevice
}

/// 本地视频流状态，及在 [LocalVideoStreamError] 中对应的错误码
enum LocalVideoStreamState {
  /// 本地视频采集停止状态（默认初始状态）
  ///
  /// 对应错误码 `ok`
  stopped,

  /// 本地视频采集设备启动成功
  ///
  /// 对应错误码 `ok`
  recording,

  /// 本地视频采集后，首帧编码成功
  ///
  /// 对应错误码 `ok`
  encoding,

  /// 本地视频启动失败
  ///
  /// + 本地视频采集设备启动失败，对应错误码 `failure`
  /// + 检测到没有视频采集设备权限，对应错误码 `没有权限启动本地视频采集设备`
  /// + 视频编码失败，对应错误码 `本地视频编码失败`
  failed
}

/// 本地视频状态改变时的错误码
enum LocalVideoStreamError {
  /// 状态正常（本地视频状态改变正常时默认返回值）
  ok,

  /// 本地视频流发布失败
  failure,

  /// 没有权限启动本地视频采集设备
  deviceNoPermission,

  /// 本地视频采集设备被占用
  deviceBusy,

  /// 本地视频采集设备不存在或已移除
  deviceNotFound,

  /// 本地视频采集失败，建议检查采集设备是否正常工作
  captureFailure,

  /// 本地视频编码失败
  encodeFailure,

  /// 本地视频采集设备被移除
  deviceDisconnected,
}

/// 用户订阅的远端音频流状态，及在 [RemoteAudioStateChangeReason] 中对应的原因
enum RemoteAudioState {
  /// 远端音频流默认初始状态，该状态回调时机包括：
  /// + 本地用户停止接收远端音频流，对应原因是 `localMuted`
  /// + 远端用户停止发送音频流，对应原因是 `remoteMuted`
  /// + 远端用户离开房间，对应原因是 `remoteOffline`
  stopped,

  /// 开始接收远端音频流首包
  ///
  /// 刚收到远端音频流首包时，会触发回调 [RTCVideoEventHandler.onRemoteAudioStateChanged]，对应原因是 `localUnmuted`。
  starting,

  /// 远端音频流正在解码，正常播放，该状态回调时机包括：
  /// + 成功解码远端音频首帧，对应原因是 `localUnmuted`
  /// + 网络由阻塞恢复正常，对应原因是 `networkRecovery`
  /// + 本地用户恢复接收远端音频流，对应原因是 `localUnmuted`
  /// + 远端用户恢复发送音频流，对应原因是 `remoteUnmuted`
  decoding,

  /// 远端音频流卡顿。
  ///
  /// 网络阻塞导致丢包率大于 40% 时回调该状态，对应原因是 `networkCongestion`
  frozen,

  /// 远端音频流播放失败
  ///
  /// 该错误码暂未使用
  failed
}

/// 远端音频流状态改变的原因
enum RemoteAudioStateChangeReason {
  /// 内部原因
  internal,

  /// 网络阻塞
  networkCongestion,

  /// 网络恢复正常
  networkRecovery,

  /// 本地用户停止接收远端音频流
  localMuted,

  /// 本地用户恢复接收远端音频流
  localUnmuted,

  /// 远端用户停止发送音频流
  remoteMuted,

  /// 远端用户恢复发送音频流
  remoteUnmuted,

  /// 远端用户离开房间
  remoteOffline,
}

/// 远端视频流状态，及在 [RemoteVideoStateChangedReason] 中对应的原因
///
/// 状态改变时，会收到回调 [RTCVideoEventHandler.onRemoteVideoStateChanged]。
enum RemoteVideoState {
  /// 远端视频流默认初始状态，该状态的回调时机包括：
  /// + 本地用户停止接收远端视频流，对应错误码 `localMuted`
  /// + 远端用户停止发送视频流，对应错误码 `remoteMuted`
  /// + 远端用户离开房间，对应错误码 `remoteOffline`
  stopped,

  /// 本地用户已接收远端视频首包
  ///
  /// 收到远端视频首包时回调该状态，对应错误码 `localUnmuted`
  starting,

  /// 远端视频流正在解码，正常播放
  ///
  /// 该状态回调时机包括：
  /// + 成功解码远端视频首帧，对应错误码 `localUnmuted`
  /// + 网络由阻塞恢复正常，对应错误码 `networkRecorvery`
  /// + 本地用户恢复接收远端视频流，对应错误码 `localUnmuted`
  /// + 远端用户恢复发送视频流，对应错误码 `remoteUnmuted`
  decoding,

  /// 远端视频流卡顿
  ///
  /// 网络阻塞、丢包率大于 40% 时回调该状态，对应错误码 `networkCongestion`
  frozen,

  /// 远端视频流播放失败
  ///
  /// 如果内部处理远端视频流失败，则会回调该方法，对应错误码 `internel`
  failed,
}

/// 远端视频流状态改变的原因
enum RemoteVideoStateChangedReason {
  /// 内部原因
  internal,

  /// 网络阻塞
  networkCongestion,

  /// 网络恢复正常
  networkRecovery,

  /// 本地用户停止接收远端视频流或本地用户禁用视频模块
  localMuted,

  /// 本地用户恢复接收远端视频流或本地用户启用视频模块
  localUnmuted,

  /// 远端用户停止发送视频流或远端用户禁用视频模块
  remoteMuted,

  /// 远端用户恢复发送视频流或远端用户启用视频模块
  remoteUnmuted,

  /// 远端用户离开房间
  ///
  /// 状态转换参看 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen]。
  remoteOffline
}

/// 黑帧视频流状态
enum SEIStreamUpdateEvent {
  /// 远端用户发布黑帧视频流
  ///
  /// 纯语音通话场景下，远端用户调用 [RTCVideo.sendSEIMessage] 发送 SEI 数据时，SDK 会自动发布一路黑帧视频流，并触发该回调。
  streamAdd,

  /// 远端黑帧视频流移除
  ///
  /// 该回调的触发时机包括：
  /// + 远端用户开启摄像头采集，由语音通话切换至视频通话，黑帧视频流停止发布；
  /// + 远端用户调用 [RTCVideo.sendSEIMessage] 后 1min 内未有 SEI 数据发送，黑帧视频流停止发布。
  streamRemove,
}

/// 性能回退相关数据
class SourceWantedData {
  /// 未开启发布回退时，此值表示推荐的视频输入宽度；当回退模式为大小流模式时，表示当前推流的最大宽度
  int width;

  /// 如果未开启发送性能回退，此值表示推荐的视频输入高度；如果开启了发送性能回退，此值表示当前推流的最大高度。
  int height;

  /// 如果未开启发送性能回退，此值表示推荐的视频输入帧率，单位 fps；如果开启了发送性能回退，此值表示当前推流的最大帧率，单位 fps。
  int frameRate;

  SourceWantedData(
      {required this.width, required this.height, required this.frameRate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
      'frameRate': frameRate,
    };
  }

  factory SourceWantedData.fromMap(Map<dynamic, dynamic> map) {
    return SourceWantedData(
      width: map['width'],
      height: map['height'],
      frameRate: map['frameRate'],
    );
  }
}

/// 用户信息
class UserInfo {
  /// 用户 ID
  ///
  /// 该字符串符合正则表达式：`[a-zA-Z0-9_@\-]{1,128}`。
  final String uid;

  /// 用户传递的额外信息
  ///
  /// 最大长度为 200 字节，会在 [RTCRoomEventHandler.onUserJoined] 中回调给远端用户。
  final String metaData;

  const UserInfo({required this.uid, this.metaData = ''});

  factory UserInfo.fromMap(Map<dynamic, dynamic> map) {
    return UserInfo(uid: map['uid'], metaData: map['metaData']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'metaData': metaData,
    };
  }
}

/// 通话相关的统计信息
class RTCRoomStats {
  /// 进房到退房之间累计时长，单位为 s
  int duration = 0;

  /// 本地用户的总发送字节数 (bytes)，累计值
  int txBytes = 0;

  /// 本地用户的总接收字节数 (bytes)，累计值
  int rxBytes = 0;

  /// 发送码率（kbps），获取该数据时的瞬时值
  int txKBitrate = 0;

  /// 接收码率（kbps），获取该数据时的瞬时值
  int rxKBitrate = 0;

  /// 音频包的发送码率（kbps），获取该数据时的瞬时值
  int txAudioKBitrate = 0;

  /// 音频接收码率（kbps），获取该数据时的瞬时值
  int rxAudioKBitrate = 0;

  /// 视频发送码率（kbps），获取该数据时的瞬时值
  int txVideoKBitrate = 0;

  /// 音频接收码率（kbps），获取该数据时的瞬时值
  int rxVideoKBitrate = 0;

  /// 屏幕发送码率（kbps），获取该数据时的瞬时值
  int txScreenKBitrate = 0;

  /// 屏幕接收码率（kbps），获取该数据时的瞬时值
  int rxScreenKBitrate = 0;

  /// 当前房间内的可见用户数
  int userCount = 0;

  /// 当前应用的上行丢包率，取值范围为 `[0, 1]`。
  double txLostrate = 0;

  /// 当前应用的下行丢包率，取值范围为 `[0, 1]`。
  double rxLostrate = 0;

  /// 客户端到服务端数据传输的往返时延（单位 ms）
  int rtt = 0;

  /// 系统上行网络抖动（ms）
  int txJitter = 0;

  /// 系统下行网络抖动（ms）
  int rxJitter = 0;

  ///
  int txCellularKBitrate = 0;
  int rxCellularKBitrate = 0;

  RTCRoomStats.empty();

  RTCRoomStats(
      {required this.duration,
      required this.txBytes,
      required this.rxBytes,
      required this.txKBitrate,
      required this.rxKBitrate,
      required this.txAudioKBitrate,
      required this.rxAudioKBitrate,
      required this.txVideoKBitrate,
      required this.rxVideoKBitrate,
      required this.txScreenKBitrate,
      required this.rxScreenKBitrate,
      required this.userCount,
      required this.txLostrate,
      required this.rxLostrate,
      required this.rtt,
      required this.txJitter,
      required this.rxJitter,
      required this.txCellularKBitrate,
      required this.rxCellularKBitrate});

  factory RTCRoomStats.fromMap(Map<dynamic, dynamic> map) {
    return RTCRoomStats(
        duration: map['duration'],
        txBytes: map['txBytes'],
        rxBytes: map['rxBytes'],
        txKBitrate: map['txKBitrate'],
        rxKBitrate: map['rxKBitrate'],
        txAudioKBitrate: map['txAudioKBitrate'],
        rxAudioKBitrate: map['rxAudioKBitrate'],
        txVideoKBitrate: map['txVideoKBitrate'],
        rxVideoKBitrate: map['rxVideoKBitrate'],
        txScreenKBitrate: map['txScreenKBitrate'],
        rxScreenKBitrate: map['rxScreenKBitrate'],
        userCount: map['userCount'],
        txLostrate: map['txLostrate'],
        rxLostrate: map['rxLostrate'],
        rtt: map['rtt'],
        txJitter: map['txJitter'],
        rxJitter: map['rxJitter'],
        txCellularKBitrate: map['txCellularKBitrate'],
        rxCellularKBitrate: map['rxCellularKBitrate']);
  }
}

/// 视频的编码类型
enum VideoCodecType {
  /// 未知类型
  auto,

  /// 标准 H264 编码格式
  h264,

  /// 标准 ByteVC1 编码格式
  bytevc1
}

/// 本地音频流统计信息，统计周期为 2s
///
/// 本地用户发布音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onLocalStreamStats] 通知用户发布的音频流在此次统计周期内的发送状况，此数据结构即为回调给用户的参数类型。
class LocalAudioStats {
  /// 音频丢包率
  ///
  /// 此次统计周期内的音频上行丢包率，单位为 % ，取值范围为 `[0, 1]`。
  double? audioLossRate;

  /// 发送码率
  ///
  /// 此次统计周期内的音频发送码率，单位为 kbps。
  double? sentKBitrate;

  /// 采集采样率
  ///
  /// 此次统计周期内的音频采集采样率信息，单位为 Hz。
  int? recordSampleRate;

  /// 统计间隔
  ///
  /// 此次统计周期的间隔，单位为 ms。
  /// 此字段用于设置回调的统计周期，默认设置为 2000ms。
  int? statsInterval;

  /// 往返时延，单位为 ms
  int? rtt;

  /// 音频声道数
  int? numChannels;

  /// 音频发送采样率
  ///
  /// 此次统计周期内的音频发送采样率信息，单位为 Hz。
  int? sentSampleRate;

  LocalAudioStats(
      {this.audioLossRate,
      this.sentKBitrate,
      this.recordSampleRate,
      this.statsInterval,
      this.rtt,
      this.numChannels,
      this.sentSampleRate});

  factory LocalAudioStats.fromMap(Map<dynamic, dynamic> map) {
    return LocalAudioStats(
        audioLossRate: map['audioLossRate'],
        sentKBitrate: map['sentKBitrate'],
        recordSampleRate: map['recordSampleRate'],
        statsInterval: map['statsInterval'],
        rtt: map['rtt'],
        numChannels: map['numChannels'],
        sentSampleRate: map['sentSampleRate']);
  }
}

/// 远端音频流统计信息，统计周期为 2s。
///
/// 本地用户订阅远端音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onRemoteStreamStats] 通知本地用户订阅的音频流在此次统计周期内的接收状况，此数据结构即为回调给本地用户的参数类型。
class RemoteAudioStats {
  /// 音频丢包率
  ///
  /// 此次统计周期内的音频下行丢包率，取值范围为 `[0, 1]`。
  double? audioLossRate;

  /// 接收码率
  ///
  /// 此次统计周期内的音频接收码率，单位为 kbps。
  double? receivedKBitrate;

  /// 音频卡顿次数
  ///
  /// 此次统计周期内的卡顿次数。
  int? stallCount;

  /// 音频卡顿时长
  ///
  /// 此次统计周期内的卡顿时长，单位为 ms。
  int? stallDuration;

  /// 用户体验级别的端到端延时
  ///
  /// 从发送端采集完成编码开始到接收端解码完成渲染开始的延时，单位为 ms。
  int? e2eDelay;

  /// 播放采样率
  ///
  /// 统计周期内的音频播放采样率信息，单位为 Hz。
  int? playoutSampleRate;

  /// 统计间隔
  ///
  /// 此次统计周期的间隔，单位为 ms。
  int? statsInterval;

  /// 客户端到服务端数据传输的往返时延，单位为 ms。
  int? rtt;

  /// 发送端——服务端——接收端全链路数据传输往返时延，单位为 ms。
  int? totalRtt;

  /// 远端用户发送的音频流质量
  ///
  /// 值含义参考 [NetworkQuality]
  int? quality;

  /// 因引入 jitter buffer 机制导致的延时，单位为 ms 。
  int? jitterBufferDelay;

  /// 音频声道数。
  int? numChannels;

  /// 音频接收采样率
  ///
  /// 此次统计周期内接收到的远端音频采样率信息，单位为 Hz。
  int? receivedSampleRate;

  /// 远端用户在加入房间后发生音频卡顿的累计时长占音频总有效时长的百分比
  ///
  /// 音频有效时长是指远端用户进房发布音频流后，除停止发送音频流和禁用音频模块之外的音频时长。
  int? frozenRate;

  /// 音频丢包补偿（PLC）样点总个数
  int? concealedSamples;

  /// PLC 累计次数
  int? concealmentEvent;

  /// 音频解码采样率
  ///
  /// 此次统计周期内的音频解码采样率信息，单位为 Hz。
  int? decSampleRate;

  /// 解码时长
  ///
  /// 对此次统计周期内接收的远端音频流进行解码的总耗时，单位为 s。
  int? decDuration;

  RemoteAudioStats(
      {this.audioLossRate,
      this.receivedKBitrate,
      this.stallCount,
      this.stallDuration,
      this.e2eDelay,
      this.playoutSampleRate,
      this.statsInterval,
      this.rtt,
      this.totalRtt,
      this.quality,
      this.jitterBufferDelay,
      this.numChannels,
      this.receivedSampleRate,
      this.frozenRate,
      this.concealedSamples,
      this.concealmentEvent,
      this.decSampleRate,
      this.decDuration});

  factory RemoteAudioStats.fromMap(Map<dynamic, dynamic> map) {
    return RemoteAudioStats(
      audioLossRate: map['audioLossRate'],
      receivedKBitrate: map['receivedKBitrate'],
      stallCount: map['stallCount'],
      stallDuration: map['stallDuration'],
      e2eDelay: map['e2eDelay'],
      playoutSampleRate: map['playoutSampleRate'],
      statsInterval: map['statsInterval'],
      rtt: map['rtt'],
      totalRtt: map['totalRtt'],
      quality: map['quality'],
      jitterBufferDelay: map['jitterBufferDelay'],
      numChannels: map['numChannels'],
      receivedSampleRate: map['receivedSampleRate'],
      frozenRate: map['frozenRate'],
      concealedSamples: map['concealedSamples'],
      concealmentEvent: map['concealmentEvent'],
      decSampleRate: map['decSampleRate'],
      decDuration: map['decDuration'],
    );
  }
}

/// 本地视频流统计信息，统计周期为 2s
///
/// 本地用户发布视频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onLocalStreamStats] 通知用户发布的视频流在此次统计周期内的发送状况，此数据结构即为回调给用户的参数类型。
class LocalVideoStats {
  /// 发送码率
  ///
  /// 此次统计周期内实际发送的分辨率最大的视频流的发送码率，单位为 Kbps
  double? sentKBitrate;

  /// 采集帧率
  ///
  /// 此次统计周期内的视频采集帧率，单位为 fps。
  int? inputFrameRate;

  /// 发送帧率
  ///
  /// 此次统计周期内的视频发送帧率，单位为 fps。
  int? sentFrameRate;

  /// 编码器输出帧率
  ///
  /// 当前编码器在此次统计周期内的输出帧率，单位为 fps。
  int? encoderOutputFrameRate;

  /// 本地渲染帧率
  ///
  /// 此次统计周期内的本地视频渲染帧率，单位为 fps。
  int? renderOutputFrameRate;

  /// 统计间隔，默认为 2000ms。
  ///
  /// 此字段用于设置回调的统计周期，单位为 ms。
  int? statsInterval;

  /// 视频丢包率
  ///
  /// 此次统计周期内的视频上行丢包率，取值范围：`[0, 1]`。
  double? videoLossRate;

  /// 往返时延，单位为 ms
  int? rtt;

  /// 视频编码码率
  ///
  /// 此次统计周期内的实际发送的分辨率最大的视频流视频编码码率，单位为 kbps。
  int? encodedBitrate;

  /// 实际发送的分辨率最大的视频流的视频编码宽度，单位为 px
  int? encodedFrameWidth;

  /// 实际发送的分辨率最大的视频流的视频编码高度，单位为 px
  int? encodedFrameHeight;

  /// 此次统计周期内实际发送的分辨率最大的视频流的发送的视频帧总数
  int? encodedFrameCount;

  /// 视频的编码类型
  int? codecType;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  bool? isScreen;

  LocalVideoStats(
      {this.sentKBitrate,
      this.inputFrameRate,
      this.sentFrameRate,
      this.encoderOutputFrameRate,
      this.renderOutputFrameRate,
      this.statsInterval,
      this.videoLossRate,
      this.rtt,
      this.encodedBitrate,
      this.encodedFrameWidth,
      this.encodedFrameHeight,
      this.encodedFrameCount,
      this.codecType,
      this.isScreen});

  factory LocalVideoStats.fromMap(Map<dynamic, dynamic> map) {
    return LocalVideoStats(
        sentKBitrate: map['sentKBitrate'],
        inputFrameRate: map['inputFrameRate'],
        sentFrameRate: map['sentFrameRate'],
        encoderOutputFrameRate: map['encoderOutputFrameRate'],
        renderOutputFrameRate: map['renderOutputFrameRate'],
        statsInterval: map['statsInterval'],
        videoLossRate: map['videoLossRate'],
        rtt: map['rtt'],
        encodedBitrate: map['encodedBitrate'],
        encodedFrameWidth: map['encodedFrameWidth'],
        encodedFrameHeight: map['encodedFrameHeight'],
        encodedFrameCount: map['encodedFrameCount'],
        codecType: map['codecType'],
        isScreen: map['isScreen']);
  }
}

/// 远端音频流统计信息，统计周期为 2s
///
/// 本地用户订阅远端音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onRemoteStreamStats] 通知本地用户订阅的远端视频流在此次统计周期内的接收状况，此数据结构即为回调给本地用户的参数类型。
class RemoteVideoStats {
  /// 远端视频流宽度
  int? width;

  /// 远端视频流高度
  int? height;

  /// 视频丢包率
  ///
  /// 此次统计周期内的视频下行丢包率，单位为 % ，取值范围为 `[0, 1]`。
  double? videoLossRate;

  /// 接收码率
  ///
  /// 此次统计周期内的视频接收码率，单位为 kbps。
  double? receivedKBitrate;

  /// 解码器输出帧率
  ///
  /// 此次统计周期内的视频解码器输出帧率，单位 fps。
  int? decoderOutputFrameRate;

  /// 渲染帧率
  ///
  /// 统计周期内的视频渲染帧率，单位 fps。
  int? renderOutputFrameRate;

  /// 卡顿次数
  ///
  /// 统计周期内的卡顿次数。
  int? stallCount;

  /// 卡顿时长
  ///
  /// 统计周期内的视频卡顿总时长。单位 ms。
  int? stallDuration;

  /// 用户体验级别的端到端延时
  ///
  /// 从发送端采集完成编码开始到接收端解码完成渲染开始的延时，单位为 ms
  int? e2eDelay;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  bool? isScreen;

  /// 统计间隔，默认为 2000ms
  ///
  /// 此字段用于设置回调的统计周期，单位为 ms。
  int? statsInterval;

  /// 往返时延，单位为 ms 。
  int? rtt;

  /// 远端用户在进房后发生视频卡顿的累计时长占视频总有效时长的百分比（%）
  ///
  /// 视频有效时长是指远端用户进房发布视频流后，除停止发送视频流和禁用视频模块之外的视频时长。
  int? frozenRate;

  /// 视频的编码类型
  VideoCodecType? codecType;

  /// 对应多种分辨率的流的下标
  int? videoIndex;

  RemoteVideoStats(
      {this.width,
      this.height,
      this.videoLossRate,
      this.receivedKBitrate,
      this.decoderOutputFrameRate,
      this.renderOutputFrameRate,
      this.stallCount,
      this.stallDuration,
      this.e2eDelay,
      this.isScreen,
      this.statsInterval,
      this.rtt,
      this.frozenRate,
      this.codecType,
      this.videoIndex});

  factory RemoteVideoStats.fromMap(Map<dynamic, dynamic> map) {
    return RemoteVideoStats(
        width: map['width'],
        height: map['height'],
        videoLossRate: map['videoLossRate'],
        receivedKBitrate: map['receivedKBitrate'],
        decoderOutputFrameRate: map['decoderOutputFrameRate'],
        renderOutputFrameRate: map['renderOutputFrameRate'],
        stallCount: map['stallCount'],
        stallDuration: map['stallDuration'],
        e2eDelay: map['e2eDelay'],
        isScreen: map['isScreen'],
        statsInterval: map['statsInterval'],
        rtt: map['rtt'],
        frozenRate: map['frozenRate'],
        codecType: (map['codecType'] as int).videoCodecType,
        videoIndex: map['videoIndex']);
  }
}

/// 本地音/视频流统计信息以及网络状况，统计周期为 2s
///
/// 本地用户发布音/视频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onLocalStreamStats] 通知本地用户发布的音/视频流在此次统计周期内的发送状况，此数据结构即为回调给用户的参数类型。
class LocalStreamStats {
  /// 本地设备发送音频流的统计信息
  LocalAudioStats? audioStats;

  /// 本地设备发送视频流的统计信息
  LocalVideoStats? videoStats;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  bool? isScreen;

  LocalStreamStats({this.audioStats, this.videoStats, this.isScreen});

  factory LocalStreamStats.fromMap(Map<dynamic, dynamic> map) {
    return LocalStreamStats(
      audioStats: LocalAudioStats.fromMap(map['audioStats']),
      videoStats: LocalVideoStats.fromMap(map['videoStats']),
      isScreen: map['isScreen'],
    );
  }
}

/// 用户订阅的远端音/视频流统计信息以及网络状况，统计周期为 2s
///
/// 订阅远端用户发布音/视频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onRemoteStreamStats] 通知本地用户订阅的远端音/视频流在此次统计周期内的接收状况，此数据结构即为回调给本地用户的参数类型。
class RemoteStreamStats {
  /// 用户 ID
  ///
  /// 音频来源的远端用户 ID。
  String? uid;

  /// 远端音频流的统计信息
  RemoteAudioStats? audioStats;

  /// 远端视频流的统计信息
  RemoteVideoStats? videoStats;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  bool? isScreen;

  RemoteStreamStats(
      {this.uid, this.audioStats, this.videoStats, this.isScreen});

  factory RemoteStreamStats.fromMap(Map<dynamic, dynamic> map) {
    return RemoteStreamStats(
      audioStats: RemoteAudioStats.fromMap(map['audioStats']),
      videoStats: RemoteVideoStats.fromMap(map['videoStats']),
      uid: map['uid'],
      isScreen: map['isScreen'],
    );
  }
}

/// 媒体设备状态
enum MediaDeviceState {
  /// 设备开启采集
  started,

  /// 设备停止采集
  stopped,

  /// 设备运行时错误
  ///
  /// 例如，当媒体设备的预期行为是正常采集，但没有收到采集数据时，将回调该状态。
  runtimeError,

  /// 设备已插入
  added,

  /// 设备被移除
  removed,

  /// 系统通话打断了音视频通话，将在通话结束后自动恢复
  interruptionBegan,

  /// 音视频通话已从被打断状态中恢复
  interruptionEnded,
}

/// 媒体设备错误类型
enum MediaDeviceError {
  /// 媒体设备正常
  ok,

  /// 没有权限启动媒体设备
  deviceNoPermission,

  /// 媒体设备已经在使用中
  deviceBusy,

  /// 媒体设备错误
  deviceFailure,

  /// 未找到指定的媒体设备
  deviceNotFound,

  /// 媒体设备被移除
  deviceDisconnected,

  /// 无采集数据
  ///
  /// 当媒体设备的预期行为是正常采集，但没有收到采集数据时，将收到该错误。
  deviceNoCallback,

  /// 设备采样率不支持
  unsupportedFormat,

  /// iOS 屏幕采集没有 group id 参数
  notFindGroupId,
}

/// 媒体设备警告
enum MediaDeviceWarning {
  /// 无警告
  ok,

  /// 非法设备操作
  ///
  /// 在使用外部设备时，调用了 SDK 内部设备 API。
  operationDenied,

  /// 采集到的数据为静音帧
  captureSilence,

  /// Android 特有的静音，系统层面的静音上报
  androidSysSilence,

  /// Android 特有的静音消失
  androidSysSilenceDisappear,

  /// 音量过大，超过设备采集范围，建议降低麦克风音量或者降低声源音量
  ///
  /// 会议场景适用。
  detectClipping,

  /// 回声泄漏
  ///
  /// 会议场景适用。
  detectLeakEcho,

  /// 低信噪比
  ///
  /// 会议场景适用。
  detectLowSNR,

  /// 采集插零现象
  ///
  /// 会议场景适用。
  detectInsertSilence,

  /// 设备采集静音
  ///
  /// 会议场景适用。
  captureDetectSilence,

  /// 设备采集静音消失
  ///
  /// 会议场景适用。
  captureDetectSilenceDisappear,

  /// 啸叫
  ///
  /// 会议场景适用。
  captureDetectHowling,

  /// 当前 AudioScenario 不支持更改音频路由，设置音频路由失败
  setAudioRouteInvalidScenario,

  /// 音频设备不存在，设置音频路由失败
  ///
  /// Android 适用。
  setAudioRouteNotExists,

  /// 音频路由被系统或其他应用占用，设置音频路由失败
  setAudioRouteFailedByPriority,

  /// 当前非通话模式，不支持设置音频路由
  ///
  /// Android 适用
  setAudioRouteNotVoipMode,

  /// 音频设备未启动，设置音频路由失败
  setAudioRouteDeviceNotStart,
}

/// 音视频质量反馈问题类型
enum ProblemFeedback {
  /// 没有问题
  none,

  /// 其他问题
  otherMsg,

  /// 声音不清晰
  audioNotClear,

  /// 视频不清晰
  videoNotClear,

  /// 音视频不同步
  sync,

  /// 音频卡顿
  audioLagging,

  /// 视频卡顿
  videoDelay,

  /// 连接失败
  disconnect,

  /// 无声音
  noAudio,

  /// 无画面
  noVideo,

  /// 声音过小
  audioStrength,

  /// 回声噪音
  echo,

  /// 耳返延迟大
  earBackDelay,
}

/// CPU 和内存统计信息
class SysStats {
  /// 当前系统 CPU 核数
  int cpuCores;

  /// 当前应用的 CPU 使用率，取值范围为 `[0, 1]`
  double cpuAppUsage;

  /// 当前系统的 CPU 使用率，取值范围为 `[0, 1]`
  double cpuTotalUsage;

  /// 当前应用的内存使用量（MB）
  double memoryUsage;

  /// 设备的内存大小（MB）
  int fullMemory;

  /// 系统已使用内存（MB）
  int totalMemoryUsage;

  /// 系统当前空闲可分配内存 (MB)
  int freeMemory;

  /// 当前应用的内存使用率 (%)
  double memoryRatio;

  /// 系统内存使用率 (%)
  double totalMemoryRatio;

  SysStats(
      {required this.cpuCores,
      required this.cpuAppUsage,
      required this.cpuTotalUsage,
      required this.memoryUsage,
      required this.fullMemory,
      required this.totalMemoryUsage,
      required this.freeMemory,
      required this.memoryRatio,
      required this.totalMemoryRatio});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpuCores': cpuCores,
      'cpuAppUsage': cpuAppUsage,
      'cpuTotalUsage': cpuTotalUsage,
      'memoryUsage': memoryUsage,
      'fullMemory': fullMemory,
      'totalMemoryUsage': totalMemoryUsage,
      'freeMemory': freeMemory,
      'memoryRatio': memoryRatio,
      'totalMemoryRatio': totalMemoryRatio,
    };
  }

  factory SysStats.fromMap(Map<dynamic, dynamic> map) {
    return SysStats(
      cpuCores: map['cpuCores'],
      cpuAppUsage: map['cpuAppUsage'],
      cpuTotalUsage: map['cpuTotalUsage'],
      memoryUsage: map['memoryUsage'],
      fullMemory: map['fullMemory'],
      totalMemoryUsage: map['totalMemoryUsage'],
      freeMemory: map['freeMemory'],
      memoryRatio: map['memoryRatio'],
      totalMemoryRatio: map['totalMemoryRatio'],
    );
  }
}

/// 自定义加密类型
enum EncryptType {
  /// 不使用内置加密（默认）
  customize,

  /// AES-128-CBC 加密算法
  aes128CBC,

  /// AES-256-CBC 加密算法
  aes256CBC,

  /// AES-128-ECB 加密算法
  aes128ECB,

  /// AES-256-ECB 加密算法
  aes256ECB,
}

/// 首帧发送状态
enum FirstFrameSendState {
  /// 发送中
  sending,

  /// 发送成功
  sent,

  /// 发送失败
  end,
}

/// 首帧播放状态
enum FirstFramePlayState {
  /// 播放中
  playing,

  /// 播放成功
  played,

  /// 播放失败
  end,
}

/// 流属性
enum StreamIndex {
  /// 主流
  ///
  /// 通过默认摄像头/麦克风采集到的视频/音频。
  main,

  /// 屏幕流
  ///
  /// 屏幕共享时共享的视频流，或来自声卡的本地播放音频流。
  screen
}

/// 远端流信息
class RemoteStreamKey {
  /// 房间 ID
  final String roomId;

  /// 用户 ID
  final String uid;

  /// 流属性，包括主流、屏幕流。
  final StreamIndex streamIndex;

  const RemoteStreamKey(
      {required this.roomId, required this.uid, required this.streamIndex});

  factory RemoteStreamKey.fromMap(Map<dynamic, dynamic> map) {
    return RemoteStreamKey(
        roomId: map['roomId'],
        uid: map['uid'],
        streamIndex: (map['streamIndex'] as int).streamIndex);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'uid': uid,
      'streamIndex': streamIndex.value
    };
  }
}

/// 本地录制文件的存储格式
enum RecordingFileType {
  /// aac 格式文件
  aac,

  /// mp4 格式文件
  mp4,
}

/// 本地录制的状态
enum RecordingState {
  /// 录制异常
  error,

  /// 录制进行中
  processing,

  /// 录制文件保存成功
  ///
  /// 调用 [RTCVideo.stopFileRecording] 结束录制之后才会收到该状态码。
  success
}

/// 本地录制的错误码
enum RecordingErrorCode {
  /// 录制正常
  ok,

  /// 没有文件写权限
  noPermission,

  /// 当前版本 SDK 不支持本地录制功能，请联系技术支持人员
  notSupport,

  /// 其他异常
  noOther,
}

/// 本地录制进度
class RecordingProgress {
  /// 当前文件的累计录制时长 (ms)
  int duration;

  /// 当前录制文件的大小 (byte)
  int fileSize;

  RecordingProgress({
    required this.duration,
    required this.fileSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fileSize': fileSize,
      'duration': duration,
    };
  }

  factory RecordingProgress.fromMap(Map<dynamic, dynamic> map) {
    return RecordingProgress(
      duration: map['duration'],
      fileSize: map['fileSize'],
    );
  }
}

/// 本地录制的详细信息
class RecordingInfo {
  /// 录制文件的绝对路径，包含文件名和文件后缀
  String filePath;

  /// 录制文件的视频编码类型
  VideoCodecType videoCodecType;

  /// 录制视频的宽 (px)
  ///
  /// 纯音频录制请忽略该字段。
  int width;

  /// 录制视频的高 (px)
  ///
  /// 纯音频录制请忽略该字段。
  int height;

  RecordingInfo(
      {required this.filePath,
      required this.videoCodecType,
      required this.width,
      required this.height});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
      'filePath': filePath,
      'videoCodecType': videoCodecType.value,
    };
  }

  factory RecordingInfo.fromMap(Map<dynamic, dynamic> map) {
    return RecordingInfo(
      filePath: map['filePath'],
      videoCodecType: (map['videoCodecType'] as int).videoCodecType,
      width: map['width'],
      height: map['height'],
    );
  }
}

/// 本地录制的媒体类型
enum RecordingType {
  /// 只录制音频
  audioOnly,

  /// 只录制视频
  videoOnly,

  /// 同时录制音频和视频
  videoAndAudio,
}

/// 本地录制参数配置
class RecordingConfig {
  /// 录制文件保存的绝对路径
  ///
  /// 你需要指定一个有读写权限的合法路径。
  String dirPath;

  /// 录制存储文件格式
  RecordingFileType recordingFileType;

  RecordingConfig({
    required this.dirPath,
    this.recordingFileType = RecordingFileType.mp4,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dirPath': dirPath,
      'recordingFileType': recordingFileType.value,
    };
  }
}

/// 音视频同步状态
enum AVSyncState {
  /// 音视频开始同步
  streamSyncBegin,

  /// 音视频同步过程中音频移除，但不影响当前的同步关系
  audioStreamRemove,

  /// 音视频同步过程中视频移除，但不影响当前的同步关系
  videoStreamRemove,

  /// 订阅端设置同步，该值暂未使用
  setAVSyncStreamId,
}

/// 媒体流信息同步的流类型
enum SyncInfoStreamType {
  /// 音频流
  audio,
}

/// 媒体流信息同步的相关配置
class StreamSyncInfoConfig {
  /// 流属性，主流或屏幕共享流
  StreamIndex streamIndex;

  /// 消息发送的重复次数，取值范围是 `[0,25]`，建议设置为 `[3,5]`。
  int repeatCount;

  /// 媒体流信息同步的流类型
  SyncInfoStreamType streamType;

  StreamSyncInfoConfig({
    this.streamIndex = StreamIndex.main,
    this.repeatCount = 0,
    this.streamType = SyncInfoStreamType.audio,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'streamIndex': streamIndex.value,
      'repeatCount': repeatCount,
      'streamType': streamType.value,
    };
  }
}

/// 媒体流跨房间转发的目标房间的相关信息
class ForwardStreamInfo {
  /// 跨房间转发媒体流过程中目标房间 ID
  String roomId;

  /// 使用转发目标房间 RoomID 和 UserID 生成的 Token
  /// 测试时可使用控制台生成临时 Token，正式上线需要使用密钥 SDK 在你的服务端生成并下发 Token。<br>
  /// 如果 Token 无效，转发失败。
  String token;

  ForwardStreamInfo({
    required this.roomId,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'token': token,
    };
  }
}

/// 媒体流跨房间转发状态
enum ForwardStreamState {
  /// 空闲状态
  ///
  /// + 成功调用 [RTCRoom.stopForwardStreamToRooms] 后，所有目标房间为空闲状态。
  /// + 成功调用 [RTCRoom.updateForwardStreamToRooms] 减少目标房间后，本次减少的目标房间为空闲状态。
  idle,

  /// 开始转发
  ///
  /// + 调用 [RTCRoom.startForwardStreamToRooms] 成功向所有房间开始转发媒体流后，返回此状态。
  /// + 调用 [RTCRoom.updateForwardStreamToRooms] 后，成功向新增目标房间开始转发媒体流后，返回此状态。
  success,

  /// 转发失败，失败详情参看 [ForwardStreamError]
  ///
  /// 调用 [RTCRoom.startForwardStreamToRooms] 或 [RTCRoom.updateForwardStreamToRooms] 后，如遇转发失败，返回此状态。
  failure,
}

/// 媒体流跨房间转发过程中的错误码
enum ForwardStreamError {
  /// 正常
  ok,

  /// 参数异常
  invalidArgument,

  /// token 错误
  invalidToken,

  ///服务端异常
  response,

  /// 目标房间有相同 userID 的用户加入，转发中断
  remoteKicked,

  /// 服务端不支持跨房间转发功能
  notSupport,
}

/// 跨房间转发媒体流过程中该目标房间发生的事件
enum ForwardStreamEvent {
  /// 本端与服务器网络连接断开，暂停转发
  disconnected,

  /// 本端与服务器网络连接恢复，转发服务连接成功
  connected,

  /// 转发中断
  ///
  /// 转发过程中，如果相同 userID 的用户进入目标房间，转发中断。
  interrupt,

  /// 目标房间已更新，由 [RTCRoom.updateForwardStreamToRooms] 触发
  dstRoomUpdated,

  /// API 调用时序错误
  ///
  /// 例如，在调用 [RTCRoom.startForwardStreamToRooms] 之前调用 [RTCRoom.updateForwardStreamToRooms]。
  unexpectedAPICall,
}

/// 跨房间转发媒体流过程中的不同目标房间的状态和错误信息
class ForwardStreamStateInfo {
  /// 跨房间转发媒体流过程中目标房间 ID
  ///
  /// 空字符串代表所有目标房间。
  String roomId;

  /// 跨房间转发媒体流过程中该目标房间的状态
  ForwardStreamState state;

  /// 媒体流跨房间转发过程中的错误码
  ForwardStreamError error;

  ForwardStreamStateInfo({
    required this.roomId,
    required this.state,
    required this.error,
  });

  factory ForwardStreamStateInfo.fromMap(Map<dynamic, dynamic> map) {
    return ForwardStreamStateInfo(
      roomId: map['roomId'],
      state: (map['state'] as int).forwardStreamState,
      error: (map['error'] as int).forwardStreamError,
    );
  }
}

/// 跨房间转发媒体流过程中的不同目标房间发生的事件
class ForwardStreamEventInfo {
  /// 跨房间转发媒体流过程中的发生该事件的目标房间 ID
  ///
  /// 空字符串代表所有目标房间
  String roomId;

  /// 跨房间转发媒体流过程中该目标房间发生的事件
  ForwardStreamEvent event;

  ForwardStreamEventInfo({
    required this.roomId,
    required this.event,
  });

  factory ForwardStreamEventInfo.fromMap(Map<dynamic, dynamic> map) {
    return ForwardStreamEventInfo(
      roomId: map['roomId'],
      event: (map['event'] as int).forwardStreamEvent,
    );
  }
}

/// 云代理信息
class CloudProxyInfo {
  /// 云代理服务器 IP
  String cloudProxyIp;

  /// 云代理服务器端口
  int cloudProxyPort;

  CloudProxyInfo({required this.cloudProxyIp, required this.cloudProxyPort});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cloudProxyIp': cloudProxyIp,
      'cloudProxyPort': cloudProxyPort,
    };
  }
}

/// 音视频回路测试结果
enum EchoTestResult {
  /// 接收到采集的音视频的回放，通话回路检测成功
  success,

  /// 测试超过 60s 仍未完成，已自动停止
  timeout,

  /// 上一次测试结束和下一次测试开始之间的时间间隔少于 5s
  intervalShort,

  /// 音频采集异常
  audioDeviceError,

  /// 视频采集异常
  videoDeviceError,

  /// 音频接收异常
  audioReceiveError,

  /// 视频接收异常
  videoReceiveError,

  /// 内部错误，不可恢复
  internalError,
}

/// 音视频回路测试参数
class EchoTestConfig {
  /// 进行音视频通话回路测试的用户 ID
  String uid;

  /// 测试用户加入的房间 ID
  String roomId;

  /// 对用户进房时进行鉴权验证的动态密钥，用于保证音视频通话回路测试的安全性
  String token;

  /// 是否检测音频,检测设备为系统默认音频设备
  ///
  /// + true：是，此时设备麦克风会自动开启，并在 audioReportInterval 值大于 0 时触发 [RTCVideoEventHandler.onLocalAudioPropertiesReport] 回调，你可以根据该回调判断麦克风的工作状态；
  /// + flase：否。
  bool enableAudio;

  /// 是否检测视频
  ///
  /// + true：是，此时设备摄像头会自动开启；
  /// + flase：否。
  ///
  /// 视频的发布参数固定为：分辨率 640px × 360px，帧率 15fps。
  bool enableVideo;

  /// 音量信息提示间隔，单位：ms，默认为 100ms
  ///
  /// + `<= 0`: 无信息提示；
  /// + `(0,100]`: 开启信息提示，不合法值，SDK 将自动设置为 100ms；
  /// + `> 100`: 开启信息提示，并将信息提示间隔设置为此值。
  int audioReportInterval;

  EchoTestConfig(
      {required this.uid,
      required this.roomId,
      required this.token,
      required this.enableAudio,
      required this.enableVideo,
      required this.audioReportInterval});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'roomId': roomId,
      'token': token,
      'enableAudio': enableAudio,
      'enableVideo': enableVideo,
      'audioReportInterval': audioReportInterval,
    };
  }
}
