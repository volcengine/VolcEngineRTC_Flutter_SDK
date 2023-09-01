// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_room_api.dart';
import 'bytertc_room_event_handler.dart';
import 'bytertc_rts_defines.dart';
import 'bytertc_video_api.dart';
import 'bytertc_video_event_handler.dart';

/// 方法调用结果。
enum ReturnStatus {
  /// 成功。
  success,

  /// 失败。
  failure,

  /// 参数错误。
  parameterErr,

  /// 接口状态错误。
  wrongState,

  /// 失败，用户已在房间内。
  hasInRoom,

  /// 失败，用户已登录。
  hasInLogin,

  /// 失败，用户已经在进行通话回路测试中。
  hasInEchoTest,

  /// 失败，音视频均未采集。
  neitherVideoNorAudio,

  /// 失败，该 roomId 已被使用。
  roomIdInUse,

  /// 失败，屏幕流不支持。
  screenNotSupport,

  /// 失败，不支持该操作。
  notSupport,

  /// 失败，资源已占用。
  resourceOverflow,

  /// 失败，没有音频帧。
  audioNoFrame,

  /// 失败，未实现。
  audioNotImplemented,

  /// 失败，采集设备无麦克风权限，尝试初始化设备失败。
  audioNoPermission,

  /// 失败，设备不存在。当前没有设备或设备被移除时返回该值。
  audioDeviceNotExists,

  /// 失败，设备音频格式不支持。
  audioDeviceFormatNotSupport,

  /// 失败，系统无可用设备。
  audioDeviceNoDevice,

  /// 失败，当前设备不可用，需更换设备。
  audioDeviceCannotUse,

  /// 系统错误，设备初始化失败。
  audioDeviceInitFailed,

  /// 系统错误，设备开启失败。
  audioDeviceStartFailed,

  /// 失败。底层未初始化，engine 无效。
  nativeInValid,
}

/// @nodoc
extension RTCTypeReturnStatus on int? {
  /// @nodoc
  ReturnStatus get returnStatus {
    switch (this) {
      case 0:
        return ReturnStatus.success;
      case -1:
        return ReturnStatus.failure;
      case -2:
        return ReturnStatus.parameterErr;
      case -3:
        return ReturnStatus.wrongState;
      case -4:
        return ReturnStatus.hasInRoom;
      case -5:
        return ReturnStatus.hasInLogin;
      case -6:
        return ReturnStatus.hasInEchoTest;
      case -7:
        return ReturnStatus.neitherVideoNorAudio;
      case -8:
        return ReturnStatus.roomIdInUse;
      case -9:
        return ReturnStatus.screenNotSupport;
      case -10:
        return ReturnStatus.notSupport;
      case -11:
        return ReturnStatus.resourceOverflow;
      case -101:
        return ReturnStatus.audioNoFrame;
      case -102:
        return ReturnStatus.audioNotImplemented;
      case -103:
        return ReturnStatus.audioNoPermission;
      case -104:
        return ReturnStatus.audioDeviceNotExists;
      case -105:
        return ReturnStatus.audioDeviceFormatNotSupport;
      case -106:
        return ReturnStatus.audioDeviceNoDevice;
      case -107:
        return ReturnStatus.audioDeviceCannotUse;
      case -108:
        return ReturnStatus.audioDeviceInitFailed;
      case -109:
        return ReturnStatus.audioDeviceStartFailed;
      case -201:
        return ReturnStatus.nativeInValid;
      default:
        return ReturnStatus.failure;
    }
  }
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

  /// 远端用户 Token 发布权限过期
  publishPrivilegeExpired,
}

/// 房间模式
enum RoomProfile {
  /// 通信模式（默认）
  communication,

  /// @nodoc
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use interactivePodcast instead')
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
  /// 通话中，闭麦时为是媒体模式，上麦后切换为通话模式。
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

/// SEI 信息来源
enum DataMessageSourceType {
  /// 用户自定义(默认值)
  def,

  /// 系统定义，包含：音量指示信息
  system,
}

/// SEI 发送模式
enum SEICountPerFrame {
  /// 单发模式，即在 1 帧间隔内多次发送 SEI 数据时，多个 SEI 按队列逐帧发送。
  single,

  /// 多发模式。即在 1 帧间隔内多次发送 SEI 数据时，多个 SEI 随下个视频帧同时发送。
  multi,
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

  /// 加入多个房间时使用了不同的 uid
  ///
  /// 同一个引擎实例中，用户需使用同一个 uid 加入不同的房间
  userIdDifferent,

  /// 服务端license过期，拒绝进房
  joinRoomServerLicenseExpired,

  /// 超过服务端license许可的并发量上限，拒绝进房
  joinRoomExceedsTheUpperLimit,

  /// license参数错误，拒绝进房
  joinRoomLicenseParameterError,

  /// license证书路径错误
  joinRoomLicenseFilePathError,

  /// license证书不合法
  joinRoomLicenseIllegal,

  /// license证书已经过期，拒绝进房
  joinRoomLicenseExpired,

  /// license证书内容不匹配
  joinRoomLicenseInformationNotMatch,

  /// license当前证书与缓存证书不匹配
  joinRoomLicenseNotMatchWithCache,

  /// 房间被封禁。
  joinRoomRoomForbidden,

  /// 用户被封禁。
  joinRoomUserForbidden,

  /// license 计费方法没有加载成功。可能是因为 license 相关插件未正确集成。
  joinRoomLicenseFunctionNotFound,

  /// 订阅音视频流失败，订阅音视频流总数超过上限
  ///
  /// 游戏场景下为了保证音视频通话的性能和质量，服务器会限制用户订阅的音视频流的总数。<br>
  /// 当用户订阅的音视频流总数已达上限时，继续订阅更多流时会失败，同时用户会收到此错误通知。
  overStreamSubscribeLimit,

  /// @nodoc('For internal use')
  /// 仅供内部使用
  loadSOLib,

  /// 发布流失败，发布流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的总流数，总流数包括视频流、音频流和屏幕流。<br>
  /// 如果房间内发布流数已达上限时，本地用户再向房间中发布流时会失败，同时会收到此错误通知。
  overStreamPublishLimit,

  /// 发布屏幕流失败，发布流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的总流数，总流数包括视频流、音频流和屏幕流。<br>
  /// 如果房间内发布流数已达上限时，本地用户再向房间中发布流时会失败，同时会收到此错误通知。
  @Deprecated('Deprecated since v3.54.1, use overStreamPublishLimit instead')
  overScreenPublishLimit,

  /// 发布视频流总数超过上限
  ///
  /// RTC 系统会限制单个房间内发布的视频流数。<br>
  /// 如果房间内发布视频流数已达上限时，本地用户再向房间中发布视频流时会失败，同时会收到此错误通知。
  @Deprecated('Deprecated since v3.54.1, use overStreamPublishLimit instead')
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

  /// 麦克风权限异常，当前应用没有获取麦克风权限
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  noMicrophonePermission,

  /// 音频采集设备启动失败。
  ///
  /// 启动音频采集设备失败，当前设备可能被其他应用占用。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  audioDeviceManagerRecordingStartFail,

  /// 音频播放设备启动失败警告。
  ///
  /// 可能由于系统资源不足，或参数错误。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  audioDeviceManagerPlayoutStartFail,

  /// 无可用音频采集设备。
  ///
  /// 启动音频采集设备失败，请插入可用的音频采集设备。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  noRecordingDevice,

  /// 无可用音频播放设备。
  ///
  /// 启动音频播放设备失败，请插入可用的音频播放设备。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  noPlayoutDevice,

  /// 当前音频设备没有采集到有效的声音数据，请检查更换音频采集设备。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  recordingSilence,

  /// 媒体设备误操作警告。
  ///
  /// 使用自定义采集时，不可调用内部采集开关，调用时触发此警告。
  @Deprecated(
      'Deprecated since v3.45.1 and will be deleted in v3.52.1, use MediaDeviceWarning instead')
  mediaDeviceOperationDenied,

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

  /// [音频技术](https://www.volcengine.com/docs/6489/71986) SDK 鉴权失效。联系技术支持人员。
  invalidSamiAppKeyOrToken,

  /// [音频技术](https://www.volcengine.com/docs/6489/71986) 资源加载失败。传入正确的 DAT 路径，或联系技术支持人员。
  invalidSamiResourcePath,

  /// [音频技术](https://www.volcengine.com/docs/6489/71986) 库加载失败。使用正确的库，或联系技术支持人员。
  loadSamiLibraryFailed,

  /// [音频技术](https://www.volcengine.com/docs/6489/71986) 不支持此音效。联系技术支持人员。
  invalidSamiEffectType,
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

/// 远端用户优先级，在性能不足需要回退时，会先回退优先级低的用户的音视频流
enum RemoteUserPriority {
  /// 低优先级（默认）
  low,

  /// 优先级为正常
  medium,

  /// 高优先级
  high,
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

  /// @nodoc('Not available')
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

  /// 本地视频采集设备已被占用
  deviceBusy,

  /// 本地视频采集设备不存在或已移除
  deviceNotFound,

  /// 本地视频采集失败，建议检查采集设备是否正常工作
  captureFailure,

  /// 本地视频编码失败
  encodeFailure,

  /// 通话过程中本地视频采集设备被其他程序抢占，导致设备连接中断
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

  /// @nodoc('Not available')
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

/// 远端视频流状态，及在 [RemoteVideoStateChangeReason] 中对应的原因
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
  /// + 网络由阻塞恢复正常，对应错误码 `networkRecovery`
  /// + 本地用户恢复接收远端视频流，对应错误码 `localUnmuted`
  /// + 远端用户恢复发送视频流，对应错误码 `remoteUnmuted`
  decoding,

  /// 远端视频流卡顿
  ///
  /// 网络阻塞、丢包率大于 40% 时回调该状态，对应错误码 `networkCongestion`
  frozen,

  /// 远端视频流播放失败
  ///
  /// 如果内部处理远端视频流失败，则会回调该方法，对应错误码 `internal`
  failed,
}

/// 远端视频流状态改变的原因
enum RemoteVideoStateChangeReason {
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

  /// iOS 视频采集中断：因用户使用系统相机，应用切换到后台运行，导致采集中断。
  notAvailableInBackground,

  /// iOS 视频采集中断：可能由于其他应用占用系统相机，导致视频设备暂时不可用，从而造成采集中断。
  videoInUseByAnotherClient,

  /// iOS 视频采集中断：当前应用处于侧拉、分屏或者画中画模式时，导致采集中断。
  notAvailableWithMultipleForegroundApps,

  /// iOS 视频采集中断：由于系统性能不足导致中断，比如设备过热。
  notAvailableDueToSystemPressure,
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

  /// @nodoc('For internal use')
  /// 音量过大，超过设备采集范围，建议降低麦克风音量或者降低声源音量
  ///
  /// 会议场景适用。
  detectClipping,

  /// 回声泄漏
  ///
  /// 会议场景适用。
  detectLeakEcho,

  /// @nodoc('For internal use')
  /// 低信噪比
  ///
  /// 会议场景适用。
  detectLowSNR,

  /// @nodoc('For internal use')
  /// 采集插零现象
  ///
  /// 会议场景适用。
  detectInsertSilence,

  /// @nodoc('For internal use')
  /// 设备采集静音
  ///
  /// 会议场景适用。
  captureDetectSilence,

  /// @nodoc('For internal use')
  /// 设备采集静音消失
  ///
  /// 会议场景适用。
  captureDetectSilenceDisappear,

  /// 啸叫
  ///
  /// 触发该警告的情况如下：
  /// + 不支持啸叫抑制的房间模式下，检测到啸叫；
  /// + 支持啸叫抑制的房间模式下，检测到未被抑制的啸叫。
  ///
  /// 仅 Communication、Meeting、MeetingRoom 三种房间模式支持啸叫抑制。<br>
  /// 建议提醒用户检查客户端的距离或将麦克风和扬声器调至静音。
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

  /// 非纯媒体音频场景，此时不支持切换蓝牙传输协议。待切换至纯媒体音频场景后生效
  setBluetoothModeScenarioUnsupport,

  /// 当前不支持设置 HFP
  setBluetoothModeUnsupport,
}

/// 音视频质量反馈问题类型
enum ProblemFeedbackOption {
  /// 没有问题
  none,

  /// 其他问题
  otherMessage,

  /// 连接失败
  disconnected,

  /// 耳返延迟大
  earBackDelay,

  /// 本端有杂音
  localNoise,

  /// 本端声音卡顿
  localAudioLagging,

  /// 本端无声音
  localNoAudio,

  /// 本端声音大/小
  localAudioStrength,

  /// 本端有回声
  localEcho,

  /// 本端视频模糊
  localVideoFuzzy,

  /// 本端音视频不同步
  localNotSync,

  /// 本端视频卡顿
  localVideoLagging,

  /// 本端无画面
  localNoVideo,

  /// 远端有杂音
  remoteNoise,

  /// 远端声音卡顿
  remoteAudioLagging,

  /// 远端无声音
  remoteNoAudio,

  /// 远端声音大/小
  remoteAudioStrength,

  /// 远端有回声
  remoteEcho,

  /// 远端视频模糊
  remoteVideoFuzzy,

  /// 远端音视频不同步
  remoteNotSync,

  /// 远端视频卡顿
  remoteVideoLagging,

  /// 远端无画面
  remoteNoVideo,
}

/// 通话质量反馈中的房间信息
class ProblemFeedbackRoomInfo {
  /// 房间 ID
  final String roomId;

  /// 用户 ID
  final String uid;

  /// @nodoc
  ProblemFeedbackRoomInfo({
    required this.roomId,
    required this.uid,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'uid': uid,
    };
  }
}

/// 通话质量反馈信息
class ProblemFeedbackInfo {
  /// 文字描述
  String problemDesc;

  /// 房间信息
  List<ProblemFeedbackRoomInfo>? roomInfo;

  /// @nodoc
  ProblemFeedbackInfo({
    required this.problemDesc,
    this.roomInfo,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'problemDesc': problemDesc,
      if (roomInfo != null)
        'roomInfo': roomInfo!.map((e) => e.toMap()).toList(growable: false),
    };
  }
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

/// 视频的编码类型
enum VideoCodecType {
  /// 未知类型
  auto,

  /// 标准 H264 编码格式
  h264,

  /// 标准 ByteVC1 编码格式
  bytevc1
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

/// 媒体流信息同步的流类型
enum SyncInfoStreamType {
  /// 音频流
  audio,
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

/// 本地录制文件的存储格式
enum RecordingFileType {
  /// aac 格式文件
  aac,

  /// mp4 格式文件
  mp4,
}

/// 音视频同步状态
enum AVSyncState {
  /// 音视频开始同步
  streamSyncBegin,

  /// 音视频同步过程中音频移除，但不影响当前的同步关系
  audioStreamRemove,

  /// 音视频同步过程中视频移除，但不影响当前的同步关系
  videoStreamRemove,

  /// @nodoc('Not available')
  /// 订阅端设置同步，该值暂未使用
  setAVSyncStreamId,
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

/// 公共流状态码
enum PublicStreamErrorCode {
  /// 发布或订阅成功
  success,

  /// 公共流的参数异常，请修改参数后重试
  pushParamError,

  /// 服务端状态异常，将自动重试
  pushStateError,

  /// 内部错误，不可恢复，请重试。
  pushInternalError,

  /// 推流失败，将自动重试，用户不需要处理
  pushError,

  /// 推流失败，10 s 后会重试，重试 3 次后停止重试
  pushTimeOut,

  /// 订阅失败，发布端未开始发布流。
  pullNoPushStream,
}

/// 蓝牙传输协议
///
/// 仅 iOS 适用。
enum BluetoothMode {
  /// 默认采用 auto 模式，具体如下：
  /// <table border>
  /// <tr>
  ///   <th>场景</th>
  ///   <th> HFP </th>
  ///   <th> A2DP </th>
  /// </tr>
  /// <tr>
  ///   <th>纯通话场景</th>
  ///   <th> 蓝牙设备支持 HFP </th>
  ///   <th> 蓝牙设备不支持 HFP </th>
  /// </tr>
  /// <tr>
  ///   <th>纯媒体场景</th>
  ///   <th> 使用蓝牙设备采集播放音频 </th>
  ///   <th> 使用 iOS 设备采集音频，蓝牙设备播放音频 </th>
  /// </tr>
  /// </table>
  auto,

  /// 高级音频分配配置文件（A2DP）。立体声、高音质。采用 iOS 设备进行音频采集，蓝牙设备进行播放。
  a2dp,

  /// 免提配置文件（HFP）。单声道、普通音质。音频采集和播放设备都使用蓝牙设备。
  hfp,
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
  /// + false：否。
  bool enableAudio;

  /// 是否检测视频
  ///
  /// + true：是，此时设备摄像头会自动开启；
  /// + false：否。
  ///
  /// 视频的发布参数固定为：分辨率 640px × 360px，帧率 15fps。
  bool enableVideo;

  /// 音量信息提示间隔，单位：ms，默认为 100ms
  ///
  /// + `<= 0`: 无信息提示；
  /// + `(0,100]`: 开启信息提示，不合法值，SDK 将自动设置为 100ms；
  /// + `> 100`: 开启信息提示，并将信息提示间隔设置为此值。
  int audioReportInterval;

  /// @nodoc
  EchoTestConfig({
    required this.uid,
    required this.roomId,
    required this.token,
    required this.enableAudio,
    required this.enableVideo,
    required this.audioReportInterval,
  });

  /// @nodoc
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

/// 用户信息
class UserInfo {
  /// 用户 ID
  ///
  /// 该字符串符合正则表达式：`[a-zA-Z0-9_@\-\.]{1,128}`。
  ///
  /// 你需要自行设置或管理 uid，并保证同一房间内每个 uid 的唯一性。
  final String uid;

  /// 用户传递的额外信息
  ///
  /// 最大长度为 200 字节，会在 [RTCRoomEventHandler.onUserJoined] 中回调给远端用户。
  final String extraInfo;

  /// @nodoc
  const UserInfo({
    required this.uid,
    this.extraInfo = '',
  });

  /// @nodoc
  factory UserInfo.fromMap(Map<dynamic, dynamic> map) {
    return UserInfo(
      uid: map['uid'],
      extraInfo: map['metaData'],
    );
  }

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'metaData': extraInfo,
    };
  }
}

/// 通话相关的统计信息
class RTCRoomStats {
  /// 进房到退房之间累计时长，单位为 s
  final int? duration;

  /// 本地用户的总发送字节数 (bytes)，累计值
  final int? txBytes;

  /// 本地用户的总接收字节数 (bytes)，累计值
  final int? rxBytes;

  /// 发送码率（kbps），获取该数据时的瞬时值
  final int? txKBitrate;

  /// 接收码率（kbps），获取该数据时的瞬时值
  final int? rxKBitrate;

  /// 音频包的发送码率（kbps），获取该数据时的瞬时值
  final int? txAudioKBitrate;

  /// 音频接收码率（kbps），获取该数据时的瞬时值
  final int? rxAudioKBitrate;

  /// 视频发送码率（kbps），获取该数据时的瞬时值
  final int? txVideoKBitrate;

  /// 音频接收码率（kbps），获取该数据时的瞬时值
  final int? rxVideoKBitrate;

  /// 屏幕发送码率（kbps），获取该数据时的瞬时值
  final int? txScreenKBitrate;

  /// 屏幕接收码率（kbps），获取该数据时的瞬时值
  final int? rxScreenKBitrate;

  /// 当前房间内的可见用户数
  final int? userCount;

  /// 当前应用的上行丢包率，取值范围为 `[0, 1]`。
  final double? txLostrate;

  /// 当前应用的下行丢包率，取值范围为 `[0, 1]`。
  final double? rxLostrate;

  /// 客户端到服务端数据传输的往返时延（单位 ms）
  final int? rtt;

  /// 系统上行网络抖动（ms）
  final int? txJitter;

  /// 系统下行网络抖动（ms）
  final int? rxJitter;

  /// 蜂窝路径发送的码率 (kbps)，为获取该数据时的瞬时值
  final int? txCellularKBitrate;

  /// 蜂窝路径接收码率 (kbps)，为获取该数据时的瞬时值
  final int? rxCellularKBitrate;

  /// @nodoc
  const RTCRoomStats({
    this.duration,
    this.txBytes,
    this.rxBytes,
    this.txKBitrate,
    this.rxKBitrate,
    this.txAudioKBitrate,
    this.rxAudioKBitrate,
    this.txVideoKBitrate,
    this.rxVideoKBitrate,
    this.txScreenKBitrate,
    this.rxScreenKBitrate,
    this.userCount,
    this.txLostrate,
    this.rxLostrate,
    this.rtt,
    this.txJitter,
    this.rxJitter,
    this.txCellularKBitrate,
    this.rxCellularKBitrate,
  });

  /// @nodoc
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
      rxCellularKBitrate: map['rxCellularKBitrate'],
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
  final double? sentKBitrate;

  /// 采集帧率
  ///
  /// 此次统计周期内的视频采集帧率，单位为 fps。
  final int? inputFrameRate;

  /// 发送帧率
  ///
  /// 此次统计周期内的视频发送帧率，单位为 fps。
  final int? sentFrameRate;

  /// 编码器输出帧率
  ///
  /// 当前编码器在此次统计周期内的输出帧率，单位为 fps。
  final int? encoderOutputFrameRate;

  /// 本地渲染帧率
  ///
  /// 此次统计周期内的本地视频渲染帧率，单位为 fps。
  final int? renderOutputFrameRate;

  /// 统计间隔，默认为 2000ms。
  ///
  /// 此字段用于设置回调的统计周期，单位为 ms。
  final int? statsInterval;

  /// 视频丢包率
  ///
  /// 此次统计周期内的视频上行丢包率，取值范围：`[0, 1]`。
  final double? videoLossRate;

  /// 往返时延，单位为 ms
  final int? rtt;

  /// 视频编码码率
  ///
  /// 此次统计周期内的实际发送的分辨率最大的视频流视频编码码率，单位为 kbps。
  final int? encodedBitrate;

  /// 实际发送的分辨率最大的视频流的视频编码宽度，单位为 px
  final int? encodedFrameWidth;

  /// 实际发送的分辨率最大的视频流的视频编码高度，单位为 px
  final int? encodedFrameHeight;

  /// 此次统计周期内实际发送的分辨率最大的视频流的发送的视频帧总数
  final int? encodedFrameCount;

  /// 视频的编码类型
  final VideoCodecType? codecType;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  final bool? isScreen;

  /// @nodoc
  const LocalVideoStats({
    this.sentKBitrate,
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
    this.isScreen,
  });

  /// @nodoc
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
      codecType: (map['codecType'] as int?).videoCodecType,
      isScreen: map['isScreen'],
    );
  }
}

/// 远端视频流统计信息，统计周期为 2s
///
/// 本地用户订阅远端音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onRemoteStreamStats] 通知本地用户订阅的远端视频流在此次统计周期内的接收状况，此数据结构即为回调给本地用户的参数类型。
class RemoteVideoStats {
  /// 远端视频流宽度
  final int? width;

  /// 远端视频流高度
  final int? height;

  /// 视频丢包率
  ///
  /// 此次统计周期内的视频下行丢包率，单位为 % ，取值范围为 `[0, 1]`。
  final double? videoLossRate;

  /// 接收码率
  ///
  /// 此次统计周期内的视频接收码率，单位为 kbps。
  final double? receivedKBitrate;

  /// 解码器输出帧率
  ///
  /// 此次统计周期内的视频解码器输出帧率，单位 fps。
  final int? decoderOutputFrameRate;

  /// 渲染帧率
  ///
  /// 统计周期内的视频渲染帧率，单位 fps。
  final int? renderOutputFrameRate;

  /// 卡顿次数
  ///
  /// 统计周期内的卡顿次数。
  final int? stallCount;

  /// 卡顿时长
  ///
  /// 统计周期内的视频卡顿总时长。单位 ms。
  final int? stallDuration;

  /// 用户体验级别的端到端延时
  ///
  /// 从发送端采集完成编码开始到接收端解码完成渲染开始的延时，单位为 ms
  final int? e2eDelay;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  final bool? isScreen;

  /// 统计间隔，默认为 2000ms
  ///
  /// 此字段用于设置回调的统计周期，单位为 ms。
  final int? statsInterval;

  /// 往返时延，单位为 ms 。
  final int? rtt;

  /// 远端用户在进房后发生视频卡顿的累计时长占视频总有效时长的百分比（%）
  ///
  /// 视频有效时长是指远端用户进房发布视频流后，除停止发送视频流和禁用视频模块之外的视频时长。
  final int? frozenRate;

  /// 视频的编码类型
  final VideoCodecType? codecType;

  /// 对应多种分辨率的流的下标
  final int? videoIndex;

  /// @nodoc
  const RemoteVideoStats({
    this.width,
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
    this.videoIndex,
  });

  /// @nodoc
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
      videoIndex: map['videoIndex'],
    );
  }
}

/// 本地音频流统计信息，统计周期为 2s
///
/// 本地用户发布音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onLocalStreamStats] 通知用户发布的音频流在此次统计周期内的发送状况，此数据结构即为回调给用户的参数类型。
class LocalAudioStats {
  /// 音频丢包率
  ///
  /// 此次统计周期内的音频上行丢包率，单位为 % ，取值范围为 `[0, 1]`。
  final double? audioLossRate;

  /// 发送码率
  ///
  /// 此次统计周期内的音频发送码率，单位为 kbps。
  final double? sentKBitrate;

  /// 采集采样率
  ///
  /// 此次统计周期内的音频采集采样率信息，单位为 Hz。
  final int? recordSampleRate;

  /// 统计间隔
  ///
  /// 此次统计周期的间隔，单位为 ms。
  /// 此字段用于设置回调的统计周期，默认设置为 2000ms。
  final int? statsInterval;

  /// 往返时延，单位为 ms
  final int? rtt;

  /// 音频声道数
  final int? numChannels;

  /// 音频发送采样率
  ///
  /// 此次统计周期内的音频发送采样率信息，单位为 Hz。
  final int? sentSampleRate;

  /// @nodoc
  const LocalAudioStats({
    this.audioLossRate,
    this.sentKBitrate,
    this.recordSampleRate,
    this.statsInterval,
    this.rtt,
    this.numChannels,
    this.sentSampleRate,
  });

  /// @nodoc
  factory LocalAudioStats.fromMap(Map<dynamic, dynamic> map) {
    return LocalAudioStats(
      audioLossRate: map['audioLossRate'],
      sentKBitrate: map['sentKBitrate'],
      recordSampleRate: map['recordSampleRate'],
      statsInterval: map['statsInterval'],
      rtt: map['rtt'],
      numChannels: map['numChannels'],
      sentSampleRate: map['sentSampleRate'],
    );
  }
}

/// 远端音频流统计信息，统计周期为 2s。
///
/// 本地用户订阅远端音频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onRemoteStreamStats] 通知本地用户订阅的音频流在此次统计周期内的接收状况，此数据结构即为回调给本地用户的参数类型。
class RemoteAudioStats {
  /// 音频丢包率
  ///
  /// 此次统计周期内的音频下行丢包率，取值范围为 `[0, 1]`。
  final double? audioLossRate;

  /// 接收码率
  ///
  /// 此次统计周期内的音频接收码率，单位为 kbps。
  final double? receivedKBitrate;

  /// 音频卡顿次数
  ///
  /// 此次统计周期内的卡顿次数。
  final int? stallCount;

  /// 音频卡顿时长
  ///
  /// 此次统计周期内的卡顿时长，单位为 ms。
  final int? stallDuration;

  /// 用户体验级别的端到端延时
  ///
  /// 从发送端采集完成编码开始到接收端解码完成渲染开始的延时，单位为 ms。
  final int? e2eDelay;

  /// 播放采样率
  ///
  /// 统计周期内的音频播放采样率信息，单位为 Hz。
  final int? playoutSampleRate;

  /// 统计间隔
  ///
  /// 此次统计周期的间隔，单位为 ms。
  final int? statsInterval;

  /// 客户端到服务端数据传输的往返时延，单位为 ms。
  final int? rtt;

  /// 发送端——服务端——接收端全链路数据传输往返时延，单位为 ms。
  final int? totalRtt;

  /// 远端用户发送的音频流质量
  ///
  /// 值含义参考 [NetworkQuality]
  final int? quality;

  /// 因引入 jitter buffer 机制导致的延时，单位为 ms 。
  final int? jitterBufferDelay;

  /// 音频声道数。
  final int? numChannels;

  /// 音频接收采样率
  ///
  /// 此次统计周期内接收到的远端音频采样率信息，单位为 Hz。
  final int? receivedSampleRate;

  /// 远端用户在加入房间后发生音频卡顿的累计时长占音频总有效时长的百分比
  ///
  /// 音频有效时长是指远端用户进房发布音频流后，除停止发送音频流和禁用音频模块之外的音频时长。
  final int? frozenRate;

  /// 音频丢包补偿（PLC）样点总个数
  final int? concealedSamples;

  /// PLC 累计次数
  final int? concealmentEvent;

  /// 音频解码采样率
  ///
  /// 此次统计周期内的音频解码采样率信息，单位为 Hz。
  final int? decSampleRate;

  /// 此次订阅中，对远端音频流进行解码的累计耗时。单位为 s。
  final int? decDuration;

  ///音频下行网络抖动，单位为 ms
  final int? jitter;

  /// @nodoc
  const RemoteAudioStats({
    this.audioLossRate,
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
    this.decDuration,
    this.jitter,
  });

  /// @nodoc
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
      jitter: map['jitter'],
    );
  }
}

/// 本地音/视频流统计信息以及网络状况，统计周期为 2s
///
/// 本地用户发布音/视频流成功后，SDK 会周期性地通过 [RTCRoomEventHandler.onLocalStreamStats] 通知本地用户发布的音/视频流在此次统计周期内的发送状况，此数据结构即为回调给用户的参数类型。
class LocalStreamStats {
  /// 本地设备发送音频流的统计信息
  final LocalAudioStats? audioStats;

  /// 本地设备发送视频流的统计信息
  final LocalVideoStats? videoStats;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  final bool? isScreen;

  /// @nodoc
  const LocalStreamStats({
    this.audioStats,
    this.videoStats,
    this.isScreen,
  });

  /// @nodoc
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
  final String? uid;

  /// 远端音频流的统计信息
  final RemoteAudioStats? audioStats;

  /// 远端视频流的统计信息
  final RemoteVideoStats? videoStats;

  /// 所属用户的媒体流是否为屏幕流
  ///
  /// 你可以知道当前统计数据来自主流还是屏幕流。
  final bool? isScreen;

  /// @nodoc
  const RemoteStreamStats({
    this.uid,
    this.audioStats,
    this.videoStats,
    this.isScreen,
  });

  /// @nodoc
  factory RemoteStreamStats.fromMap(Map<dynamic, dynamic> map) {
    return RemoteStreamStats(
      audioStats: RemoteAudioStats.fromMap(map['audioStats']),
      videoStats: RemoteVideoStats.fromMap(map['videoStats']),
      uid: map['uid'],
      isScreen: map['isScreen'],
    );
  }
}

/// 远端流信息
class RemoteStreamKey {
  /// 房间 ID
  final String roomId;

  /// 用户 ID
  final String uid;

  /// 流属性，包括主流、屏幕流。
  final StreamIndex streamIndex;

  /// @nodoc
  const RemoteStreamKey({
    required this.roomId,
    required this.uid,
    required this.streamIndex,
  });

  /// @nodoc
  factory RemoteStreamKey.fromMap(Map<dynamic, dynamic> map) {
    return RemoteStreamKey(
      roomId: map['roomId'],
      uid: map['uid'],
      streamIndex: (map['streamIndex'] as int).streamIndex,
    );
  }

  /// @nodoc
  Map<String, dynamic> toMap() => {
        'roomId': roomId,
        'uid': uid,
        'streamIndex': streamIndex.index,
      };
}

/// 本地录制参数配置
class RecordingConfig {
  /// 录制文件保存的绝对路径
  ///
  /// 你需要指定一个有读写权限的合法路径。
  String dirPath;

  /// 录制存储文件格式
  RecordingFileType recordingFileType;

  /// @nodoc
  RecordingConfig({
    required this.dirPath,
    this.recordingFileType = RecordingFileType.mp4,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dirPath': dirPath,
      'recordingFileType': recordingFileType.index,
    };
  }
}

/// 本地录制进度
class RecordingProgress {
  /// 当前文件的累计录制时长 (ms)
  final int? duration;

  /// 当前录制文件的大小 (byte)
  final int? fileSize;

  /// @nodoc
  const RecordingProgress({
    this.duration,
    this.fileSize,
  });

  /// @nodoc
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
  final String? filePath;

  /// 录制文件的视频编码类型
  final VideoCodecType? videoCodecType;

  /// 录制视频的宽 (px)
  ///
  /// 纯音频录制请忽略该字段。
  final int? width;

  /// 录制视频的高 (px)
  ///
  /// 纯音频录制请忽略该字段。
  final int? height;

  /// @nodoc
  const RecordingInfo({
    this.filePath,
    this.videoCodecType,
    this.width,
    this.height,
  });

  /// @nodoc
  factory RecordingInfo.fromMap(Map<dynamic, dynamic> map) {
    return RecordingInfo(
      filePath: map['filePath'],
      videoCodecType: (map['videoCodecType'] as int).videoCodecType,
      width: map['width'],
      height: map['height'],
    );
  }
}

/// 媒体流信息同步的相关配置
class StreamSyncInfoConfig {
  /// 流属性，主流或屏幕共享流
  StreamIndex streamIndex;

  /// 消息发送的重复次数，取值范围是 `[0,25]`，建议设置为 `[3,5]`。
  int repeatCount;

  /// 媒体流信息同步的流类型
  SyncInfoStreamType streamType;

  /// @nodoc
  StreamSyncInfoConfig({
    this.streamIndex = StreamIndex.main,
    this.repeatCount = 0,
    this.streamType = SyncInfoStreamType.audio,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'streamIndex': streamIndex.index,
      'repeatCount': repeatCount,
      'streamType': streamType.index,
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

  /// @nodoc
  ForwardStreamInfo({
    required this.roomId,
    required this.token,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'token': token,
    };
  }
}

/// 跨房间转发媒体流过程中的不同目标房间的状态和错误信息
class ForwardStreamStateInfo {
  /// 跨房间转发媒体流过程中目标房间 ID
  ///
  /// 空字符串代表所有目标房间。
  final String? roomId;

  /// 跨房间转发媒体流过程中该目标房间的状态
  final ForwardStreamState? state;

  /// 媒体流跨房间转发过程中的错误码
  final ForwardStreamError? error;

  /// @nodoc
  const ForwardStreamStateInfo({
    this.roomId,
    this.state,
    this.error,
  });

  /// @nodoc
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
  final String? roomId;

  /// 跨房间转发媒体流过程中该目标房间发生的事件
  final ForwardStreamEvent? event;

  /// @nodoc
  const ForwardStreamEventInfo({
    this.roomId,
    this.event,
  });

  /// @nodoc
  factory ForwardStreamEventInfo.fromMap(Map<dynamic, dynamic> map) {
    return ForwardStreamEventInfo(
      roomId: map['roomId'],
      event: (map['event'] as int).forwardStreamEvent,
    );
  }
}

/// 上行/下行网络质量相关数据
class NetworkQualityStats {
  /// 用户 ID
  final String? uid;

  /// 丢包率，范围 `[0.0,1.0]`
  /// + 当 `uid` 为本地用户时，该值代表本地发布流的上行丢包率；
  /// + 当 `uid` 为远端用户时，该值代表本地接收所有订阅的远端流的下行丢包率。
  final double? fractionLost;

  /// 当 `uid` 为本地用户时有效，客户端到服务端的往返延时，单位：ms
  final int? rtt;

  /// 本端的音视频 RTP 包 2 秒内的平均传输速率，单位：bps
  /// + 当 `uid` 为本地用户时，代表发送速率；
  /// + 当 `uid` 为远端用户时，代表所有订阅流的接收速率。
  final int? totalBandwidth;

  /// 上行网络质量分，范围 `[0,5]`，分数越高网络质量越差
  final NetworkQuality? txQuality;

  /// 下行网络质量分，范围 `[0,5]`，分数越高网络质量越差
  final NetworkQuality? rxQuality;

  /// @nodoc
  const NetworkQualityStats({
    this.uid,
    this.fractionLost,
    this.rtt,
    this.totalBandwidth,
    this.txQuality,
    this.rxQuality,
  });

  /// @nodoc
  factory NetworkQualityStats.fromMap(Map<dynamic, dynamic> map) {
    return NetworkQualityStats(
      uid: map['uid'],
      fractionLost: map['fractionLost'],
      rtt: map['rtt'],
      totalBandwidth: map['totalBandwidth'],
      txQuality: (map['txQuality'] as int).networkQuality,
      rxQuality: (map['rxQuality'] as int).networkQuality,
    );
  }
}

/// 网络时间信息
class NetworkTimeInfo {
  /// 网络时间，单位：ms
  final int timestamp;

  /// @nodoc
  const NetworkTimeInfo({
    required this.timestamp,
  });

  /// @nodoc
  factory NetworkTimeInfo.fromMap(Map<dynamic, dynamic> map) {
    return NetworkTimeInfo(
      timestamp: map['timestamp'],
    );
  }
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

/// 通话前回声检测结果
enum HardwareEchoDetectionResult {
  /// 主动调用 [RTCVideo.stopHardwareEchoDetection] 结束流程时，未有回声检测结果。
  canceled,

  /// 未检测出结果。建议重试，如果仍然失败请联系技术支持协助排查。
  unknown,

  /// 无回声。
  normal,

  /// 有回声。
  ///
  /// 可通过 UI 提示建议用户使用耳机设备入会。
  poor,
}

/// 音频选路优先级设置。
enum AudioSelectionPriority {
  /// 正常，参加音频选路。
  normal,

  /// 高优先级，跳过音频选路。
  high,
}

/// 设置房间附加消息结果。
enum SetRoomExtraInfoResult {
  /// 设置房间附加信息成功。
  success,

  /// 设置失败，尚未加入房间。
  notJoinRoom,

  /// 设置失败，key 指针为空。
  keyIsNull,

  /// 设置失败，value 指针为空
  valueIsNull,

  /// 设置失败，未知错误
  unknown,

  /// 设置失败，key 长度为 0。
  keyIsEmpty,

  /// 调用 [RTCRoom.setRoomExtraInfo] 过于频繁，建议不超过 10 次/秒。
  tooOften,

  /// 设置失败，用户已调用 [RTCRoom.setUserVisibility] 将自身设为隐身状态。
  silentUser,

  /// 设置失败，Key 长度超过 10 字节。
  keyTooLong,

  /// 设置失败，value 长度超过 128 字节
  valueTooLong,

  /// 设置失败，服务器错误。
  serverError,
}

/// 字幕任务状态。
enum SubtitleState {
  /// 开启字幕。
  started,

  /// 关闭字幕。
  stopped,

  /// 字幕任务出现错误。
  error,
}

/// 字幕模式。
enum SubtitleMode {
  /// 识别模式。在此模式下，房间内用户语音会被转为文字。
  recognition,

  /// 翻译模式。在此模式下，房间内用户语音会先被转为文字，再被翻译为目标语言。
  translation,
}

/// 字幕任务错误码。
enum SubtitleErrorCode {
  /// 客户端无法识别云端媒体处理发送的错误码。
  unknown,

  /// 字幕已开启。
  success,

  /// 云端媒体处理内部出现错误，请联系技术支持。
  postProcessError,

  /// 第三方服务连接失败，请联系技术支持。
  asrConnectionError,

  /// 第三方服务内部出现错误，请联系技术支持。
  asrServiceError,

  /// 未进房导致调用 [RTCRoom.startSubtitle] 失败。请加入房间后再调用此方法。
  beforeJoinRoom,

  /// 字幕已开启，无需重复调用 [RTCRoom.startSubtitle]。
  alreadyOn,

  /// 所选目标语言目前暂不支持。
  unsupportedLanguage,

  /// 云端媒体处理超时未响应，请联系技术支持。
  postProcessTimeout,
}

/// 字幕配置信息。
class SubtitleConfig {
  /// 字幕模式。
  ///
  /// 可以根据需要选择识别和翻译两种模式。开启识别模式，会将识别后的用户语音转化成文字；开启翻译模式，会在语音识别后进行翻译。
  SubtitleMode mode;

  /// 目标翻译语言。可点击 [语言支持](https://www.volcengine.com/docs/4640/35107#%F0%9F%93%A2%E5%AE%9E%E6%97%B6%E8%AF%AD%E9%9F%B3%E7%BF%BB%E8%AF%91) 查看翻译服务最新支持的语种信息。
  String targetLanguage;

  /// @nodoc
  SubtitleConfig({
    this.mode = SubtitleMode.recognition,
    this.targetLanguage = '',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mode': mode.index,
      'targetLanguage': targetLanguage,
    };
  }
}

/// 字幕具体内容。
class SubtitleMessage {
  /// 说话者的用户 ID。
  final String uid;

  /// 语音识别或翻译后的文本, 采用 UTF-8 编码。
  final String text;

  /// 语音识别或翻译后形成的文本的序列号，同一发言人的完整发言和不完整发言会按递增顺序单独分别编号。
  final int sequence;

  /// 语音识别出的文本是否为一段完整的一句话。 True：是；False：否。
  final bool definite;

  /// @nodoc
  const SubtitleMessage({
    required this.uid,
    required this.text,
    required this.sequence,
    required this.definite,
  });

  /// @nodoc
  factory SubtitleMessage.fromMap(Map<dynamic, dynamic> map) {
    return SubtitleMessage(
      uid: map['uid'],
      text: map['text'],
      sequence: map['sequence'],
      definite: map['definite'],
    );
  }
}

/// 用户可见性状态改变错误码。
enum UserVisibilityChangeError {
  /// 成功。
  ok,

  /// 未知错误。
  unknown,

  /// 房间内可见用户达到上限。
  tooManyVisibleUser,
}
