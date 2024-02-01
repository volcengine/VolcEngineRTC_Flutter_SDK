// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:collection';
import 'dart:ffi';
import 'dart:typed_data';

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_audio_defines.dart';
import 'bytertc_media_defines.dart';
import 'bytertc_room_api.dart';
import 'bytertc_video_api.dart';
import 'bytertc_video_event_handler.dart';

/// 用于初始化 RTCVideo 的配置
class RTCVideoContext {
  /// 每个应用的唯一标识符，由 RTC 控制台随机生成的。
  ///
  /// 不同的 AppId 生成的实例在 RTC 中进行音视频通话完全独立，无法互通。
  String appId;

  /// SDK 回调给应用层的 Handler
  RTCVideoEventHandler? eventHandler;

  /// 私有参数。如需使用请联系技术支持人员。
  Map<String, dynamic>? parameters;

  /// @nodoc
  RTCVideoContext(
    this.appId, {
    this.eventHandler,
    this.parameters,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    HashMap<String, dynamic> dic = HashMap();
    dic['appId'] = appId;
    if (parameters != null) {
      dic['parameters'] = parameters;
    }
    return dic;
  }
}

/// 移动端摄像头
enum CameraId {
  /// 前置摄像头
  front,

  /// 后置摄像头（默认设置）
  back,

  /// @nodoc('Not available')
  /// 外接摄像头
  external
}

/// 视频渲染的缩放模式
enum VideoRenderMode {
  /// 视窗填满优先
  ///
  /// 视频帧等比缩放，直至视窗被视频填满。如果视频帧长宽比例与视窗不同，视频帧的多出部分将无法显示。<br>
  /// 缩放完成后，视频帧的一边长和视窗的对应边长一致，另一边长大于等于视窗对应边长。
  hidden,

  /// 视频帧内容全部显示优先
  ///
  /// 视频帧等比缩放，直至视频帧能够在视窗上全部显示。如果视频帧长宽比例与视窗不同，视窗上未被视频帧填满区域将被涂黑。<br>
  /// 缩放完成后，视频帧的一边长和视窗的对应边长一致，另一边长小于等于视窗对应边长。
  fit,

  /// 视频帧自适应画布
  ///
  /// 视频尺寸非等比例缩放，把窗口充满。在此过程中，视频帧的长宽比例可能会发生变化
  adaptive,
}

/// 镜像类型
enum MirrorType {
  /// 本地渲染和编码传输时均无镜像效果
  none,

  /// 本地渲染时有镜像效果，编码传输时无镜像效果
  render,

  /// 本地渲染和编码传输时均有镜像效果
  renderAndEncoder,
}

/// 远端镜像类型
enum RemoteMirrorType {
  /// （默认值）远端视频渲染无镜像效果
  none,

  /// 远端视频渲染有镜像效果
  render,
}

/// 基础美颜模式
enum EffectBeautyMode {
  /// 美白
  whiteMode,

  /// 磨皮
  smoothMode,

  /// 锐化
  sharpenMode,

  /// 清晰
  clearMode
}

/// 视频帧旋转角度
enum VideoRotation {
  /// 顺时针旋转 0 度
  rotation0,

  /// 顺时针旋转 90 度
  rotation90,

  /// 顺时针旋转 180 度
  rotation180,

  /// 顺时针旋转 270 度
  rotation270
}

/// 视频帧缩放模式，可设置缩放以适应视窗。
enum ScaleMode {
  /// 自动模式，默认值为 `stretch`
  auto,

  /// 对视频帧进行缩放，直至视频帧和视窗分辨率一致为止。这一过程不保证等比缩放。
  stretch,

  /// 视窗填满优先。
  ///
  /// 视频帧等比缩放，直至视窗被视频填满。如果视频帧长宽比例与视窗不同，视频帧的多出部分将无法显示。<br>
  /// 缩放完成后，视频帧的一边长和视窗的对应边长一致，另一边长大于等于视窗对应边长。
  fitWithCropping,

  /// 视频帧内容全部显示优先。
  ///
  /// 视频帧等比缩放，直至视频帧能够在视窗上全部显示。如果视频帧长宽比例与视窗不同，视窗上未被视频帧填满区域将被涂黑。<br>
  /// 缩放完成后，视频帧的一边长和视窗的对应边长一致，另一边长小于等于视窗对应边长。
  fitWithFilling
}

/// 编码策略偏好
enum VideoEncoderPreference {
  /// 无偏好
  disable,

  /// 帧率优先
  maintainFrameRate,

  /// 质量优先
  maintainQuality,

  /// 平衡质量与帧率
  balance,
}

/// 屏幕流编码模式。默认采用清晰模式。
enum ScreenVideoEncoderPreference {
  /// 流畅模式，优先保障帧率。适用于共享游戏、视频等动态画面。
  maintainFrameRate,

  /// 清晰模式，优先保障分辨率。适用于共享PPT、文档、图片等静态画面。
  maintainQuality,
}

/// 暂停/恢复接收远端的媒体流类型
enum PauseResumeControlMediaType {
  /// 只控制音频，不影响视频
  audio,

  /// 只控制视频，不影响音频
  video,

  /// 同时控制音频和视频
  videoAndAudio,
}

/// 流切换信息
///
/// 本地用户订阅的远端流触发回退策略时的流切换信息。
class RemoteStreamSwitch {
  /// 订阅的音视频流的发布者的用户 ID
  final String? uid;

  /// 是否是屏幕共享流
  final bool? isScreen;

  /// 流切换前订阅视频流的分辨率对应的索引
  final int? beforeVideoIndex;

  /// 流切换后订阅视频流的分辨率对应的索引
  final int? afterVideoIndex;

  /// 流切换前是否有视频流
  final bool? beforeEnable;

  /// 流切换后是否有视频流
  final bool? afterEnable;

  /// 触发流回退的原因
  final FallbackOrRecoverReason? reason;

  /// @nodoc
  const RemoteStreamSwitch({
    this.uid,
    this.isScreen,
    this.beforeVideoIndex,
    this.afterVideoIndex,
    this.beforeEnable,
    this.afterEnable,
    this.reason,
  });

  /// @nodoc
  factory RemoteStreamSwitch.fromMap(Map<dynamic, dynamic> map) {
    return RemoteStreamSwitch(
      uid: map['uid'],
      isScreen: map['isScreen'],
      beforeVideoIndex: map['beforeVideoIndex'],
      afterVideoIndex: map['afterVideoIndex'],
      beforeEnable: map['beforeEnable'],
      afterEnable: map['afterEnable'],
      reason: (map['reason'] as int).fallbackOrRecoverReason,
    );
  }
}

/// 合流类型
enum StreamMixingType {
  /// 服务端合流
  byServer,

  /// @nodoc(`Not available`)
  /// 端云一体合流。SDK 智能决策在客户端或服务端完成合流。
  byClient,
}

/// 转推直播任务状态
enum StreamMixingEvent {
  /// @nodoc('For internal use')
  /// 未定义状态
  base,

  /// 请求发起转推直播任务
  start,

  /// 发起转推直播任务成功
  startSuccess,

  /// 发起转推直播任务失败
  startFailed,

  /// 请求更新转推直播任务配置
  update,

  /// 成功更新转推直播任务配置
  updateSuccess,

  /// 更新转推直播任务配置失败
  updateFailed,

  /// 请求结束转推直播任务
  stop,

  /// 结束转推直播任务成功
  stopSuccess,

  /// 结束转推直播任务失败
  stopFailed,

  /// 更新转推直播任务配置的请求超时
  changeMixType,

  /// 得到客户端合流音频首帧
  firstAudioFrameByClientMix,

  /// 收到客户端合流视频首帧
  firstVideoFrameByClientMix,

  /// 更新转推直播任务配置超时
  updateTimeout,

  /// 发起转推直播任务配置超时
  startTimeout,

  /// 合流布局参数错误
  requestParamError,

  /// 合流加图片
  mixImage,
}

/// 服务端合流转推 SEI 内容
enum MixedStreamSEIContentMode {
  /// 视频流中包含全部的 SEI 信息。默认设置。
  defaultMode,

  /// 随非关键帧传输的 SEI 数据中仅包含音量信息
  /// 当设置 [MixedStreamServerControlConfig.enableVolumeIndication] 为 true 时，此参数设置生效
  enableVolumeIndicationMode,
}

/// 服务端合流转推发起模式
enum MixedStreamPushMode {
  /// 无用户发布媒体流时，发起合流任务无效。默认设置。
  ///
  /// 当有用户发布媒体流时，才能发起合流任务。
  onStreamMode,

  /// 无用户发布媒体流时，可以使用占位图发起合流任务。
  ///
  /// 占位图设置参看 [MixedStreamLayoutRegionConfig.alternateImageUrl]、[MixedStreamLayoutRegionConfig.alternateImageFillMode]。
  onStartRequestMode,
}

/// 转推直播错误码
enum StreamMixingErrorCode {
  /// 推流成功
  ok,

  /// 未定义的合流错误
  base,

  /// 客户端 SDK 检测到无效推流参数
  invalidParam,

  /// 状态错误，需要在状态机正常状态下发起操作
  invalidState,

  /// 无效操作
  invalidOperator,

  /// 转推直播任务处理超时，请检查网络状态并重试
  timeOut,

  /// 服务端检测到错误的推流参数
  invalidParamByServer,

  /// 对流的订阅超时
  subTimeoutByServer,

  /// 合流服务端内部错误
  invalidStateByServer,

  /// 合流服务端推 CDN 失败
  authenticationByCDN,

  /// 服务端接收信令超时，请检查网络状态并重试
  timeoutBySignaling,

  /// 图片合流失败
  mixImageFail,

  /// 服务端未知错误
  unKnownErrorByServer,
}

/// 合流输出内容类型
enum TranscoderContentControlType {
  /// 输出的混流包含音频和视频
  hasAudioAndVideo,

  /// 输出的混流只包含音频
  hasAudioOnly,

  /// 输出的混流只包含视频
  hasVideoOnly,
}

/// 合流布局区域类型
enum TranscoderLayoutRegionType {
  /// 合流布局区域类型为视频
  videoStream,

  /// 合流布局区域类型为图片
  image,
}

/// 视频编码格式。
enum TranscodingVideoCodec {
  /// H.264 格式，默认值。
  h264,

  /// ByteVC1 格式。
  byteVC1,
}

/// 音频编码格式。
enum TranscodingAudioCodec {
  /// AAC 格式。
  aac,
}

/// AAC 编码类型
enum AACProfile {
  /// 编码等级 AAC-LC
  lc,

  /// 编码等级 HE-AAC v1
  hev1,

  /// 编码等级 HE-AAC v2
  hev2,
}

/// 转推视频配置。
class LiveTranscodingVideoConfig {
  /// 视频编码格式，默认值为 `h264`。本参数不支持过程中更新。
  TranscodingVideoCodec codec;

  /// 合流视频帧率。单位为 FPS，取值范围为 `[1,60]`， 默认值为 15 FPS。
  int fps;

  /// 视频 I 帧时间间隔。单位为秒，取值范围为 `[1, 5]`，默认值为 2 秒。
  int gop;

  /// 是否使用B帧。
  bool bFrame;

  /// 合流视频码率。单位为 Kbps，取值范围为 `[1,10000]`，默认值为自适应模式。
  int kBitrate;

  /// 合流视频宽度。单位为 px，范围为 `[2, 1920]`，必须是偶数。默认值为 640 px。设置值为非偶数时，自动向上取偶数。
  int width;

  /// 合流视频高度。单位为 px，范围为 `[2, 1920]`，必须是偶数。默认值为 360 px。设置值为非偶数时，自动向上取偶数。
  int height;

  /// @nodoc
  LiveTranscodingVideoConfig({
    this.codec = TranscodingVideoCodec.h264,
    this.fps = 30,
    this.gop = 2,
    this.bFrame = false,
    this.kBitrate = 500,
    this.width = 360,
    this.height = 640,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codec': codec.value,
      'fps': fps,
      'gop': gop,
      'bFrame': bFrame,
      'kBitrate': kBitrate,
      'width': width,
      'height': height,
    };
  }
}

/// 转推音频配置。
class LiveTranscodingAudioConfig {
  /// 音频编码格式，默认值为 `aac`。
  TranscodingAudioCodec codec;

  /// 音频码率，单位 Kbps。可取范围 `[32, 192]`，默认值为 64 Kbps。
  int kBitrate;

  /// 音频采样率，单位 Hz。可取 32000 Hz、44100 Hz、48000 Hz，默认值为 48000 Hz。
  int sampleRate;

  /// 音频声道数。可取 1（单声道）、2（双声道），默认值为 2。
  int channels;

  /// AAC 规格，默认值为 `lc`。
  AACProfile aacProfile;

  /// @nodoc
  LiveTranscodingAudioConfig({
    this.codec = TranscodingAudioCodec.aac,
    this.kBitrate = 64,
    this.sampleRate = 48000,
    this.channels = 2,
    this.aacProfile = AACProfile.lc,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codec': codec.value,
      'kBitrate': kBitrate,
      'sampleRate': sampleRate,
      'channels': channels,
      'aacProfile': aacProfile.value,
    };
  }
}

/// 图片合流相关参数
class TranscoderLayoutRegionDataParam {
  /// 原始图片的宽度，单位为 px
  int imageWidth;

  /// 原始图片的高度，单位为 px。
  int imageHeight;

  /// @nodoc
  TranscoderLayoutRegionDataParam({
    required this.imageWidth,
    required this.imageHeight,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    };
  }
}

/// 单个视频流在合流中的布局信息。
class LiveTranscodingRegion {
  /// 视频流发布用户的用户 ID 。
  String uid;

  /// 房间 ID 。必填。
  String roomId;

  /// 用户视频布局相对画布左侧的偏移量。相对值，范围为 `[0.0, 1.0]`。
  double x;

  /// 用户视频布局相对画布顶端的偏移量。相对值，范围为 `[0.0, 1.0]`。
  double y;

  /// 用户视频宽度相对用户原始视频宽度的比例。相对值，范围为 `[0.0, 1.0]`。
  double w;

  /// 用户视频高度相对用户原始视频高度的比例。相对值，范围为 `[0.0, 1.0]`。
  double h;

  /// 用户视频布局在画布中的层级。0为底层，值越大越上层，范围为 `[0, 100]`。
  int zorder;

  /// 透明度，范围为 `[0.0, 1.0]`。
  double alpha;

  /// 圆角半径相对画布宽度的比例。默认值为 `0.0`。
  ///
  /// 做范围判定时，首先根据画布的宽高，将 `width`，`height`，和 `cornerRadius` 分别转换为像素值：`width_px`，`height_px`，和 `cornerRadius_px`。然后判定是否满足 `cornerRadius_px < min(width_px/2, height_px/2)`：若满足，则设置成功；若不满足，则将 `cornerRadius_px` 设定为 `min(width_px/2, height_px/2)`，然后将 `cornerRadius` 设定为 `cornerRadius_px` 相对画布宽度的比例值。
  double cornerRadius;

  /// 合流转推包含内容
  TranscoderContentControlType contentControl;

  /// 渲染模式
  VideoRenderMode renderMode;

  /// 是否是本地用户
  bool localUser;

  /// 是否是屏幕共享流
  bool isScreen;

  /// 合流布局区域类型
  TranscoderLayoutRegionType type;

  /// 图片合流区域类型对应的数据
  Uint8List? data;

  /// 合流布局区域数据的对应参数
  TranscoderLayoutRegionDataParam? dataParam;

  /// 空间位置
  Position spatialPosition;

  /// 设置某用户是否应用空间音频效果。
  bool applySpatialAudio;

  /// @nodoc
  LiveTranscodingRegion({
    required this.uid,
    required this.roomId,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.zorder = 0,
    this.alpha = 1.0,
    this.cornerRadius = 0.0,
    this.contentControl = TranscoderContentControlType.hasAudioAndVideo,
    this.renderMode = VideoRenderMode.hidden,
    required this.localUser,
    this.isScreen = false,
    this.type = TranscoderLayoutRegionType.videoStream,
    this.data,
    this.dataParam,
    this.spatialPosition = const Position.zero(),
    this.applySpatialAudio = true,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    HashMap<String, dynamic> dic = HashMap.of({
      'uid': uid,
      'roomId': roomId,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'zorder': zorder,
      'alpha': alpha,
      'cornerRadius': cornerRadius,
      'contentControl': contentControl.index,
      'renderMode': renderMode.value,
      'localUser': localUser,
      'isScreen': isScreen,
      'type': type.index,
      'spatialPosition': spatialPosition.toMap(),
      'applySpatialAudio': applySpatialAudio,
    });
    if (data != null) {
      dic['data'] = data;
    }
    if (dataParam != null) {
      dic['dataParam'] = dataParam?.toMap();
    }
    return dic;
  }
}

/// 转推流布局设置。
class LiveTranscodingLayout {
  /// 合流转推布局信息。
  List<LiveTranscodingRegion> regions;

  /// SEI 信息，长度不得超 4096 bytes。
  String appData;

  /// 视频的背景颜色。格式为 RGB 定义下的 Hex 值。默认值 `#000000`。
  String backgroundColor;

  /// @nodoc
  LiveTranscodingLayout({
    required this.regions,
    this.appData = '',
    this.backgroundColor = '#000000',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'appData': appData,
      'backgroundColor': backgroundColor,
      'regions': regions.map((e) => e.toMap()).toList(),
    };
  }
}

/// 推流 CDN 的空间音频参数
class LiveTranscodingSpatialConfig {
  /// 听众的空间朝向
  ///
  /// 听众指收听来自 CDN 的音频流的用户。
  final HumanOrientation audienceSpatialOrientation;

  /// 听众的空间位置
  ///
  /// 听众指收听来自 CDN 的音频流的用户。
  final Position audienceSpatialPosition;

  /// 是否开启推流 CDN 时的空间音频效果。
  ///
  /// 当你启用此效果时，你需要设定推流中各个 [LiveTranscodingSpatialConfig] 的 `audienceSpatialPosition` 值，实现空间音频效果。
  final bool enableSpatialRender;

  /// @nodoc
  const LiveTranscodingSpatialConfig({
    this.audienceSpatialOrientation = const HumanOrientation.origin(),
    this.audienceSpatialPosition = const Position.zero(),
    this.enableSpatialRender = false,
  });

  /// @nodoc
  const LiveTranscodingSpatialConfig.disabled() : this();

  /// @nodoc
  Map<String, dynamic> toMap() => {
        'orientation': audienceSpatialOrientation.toMap(),
        'position': audienceSpatialPosition.toMap(),
        'enableSpatialRender': enableSpatialRender,
      };
}

/// 转推直播配置参数。
class LiveTranscoding {
  /// 设置合流类型。本参数不支持过程中更新。
  StreamMixingType mixType;

  /// 推流地址。本参数不支持过程中更新。
  String url;

  /// 房间 ID。本参数不支持过程中更新。
  String roomId;

  /// 用户 ID。本参数不支持过程中更新。
  String uid;

  /// 视频设置
  LiveTranscodingVideoConfig video;

  /// 音频设置。本参数不支持过程中更新。
  LiveTranscodingAudioConfig audio;

  /// 布局设置
  LiveTranscodingLayout layout;

  /// 空间音频信息
  LiveTranscodingSpatialConfig spatialConfig;

  /// @nodoc
  LiveTranscoding({
    this.mixType = StreamMixingType.byServer,
    required this.url,
    required this.roomId,
    required this.uid,
    required this.video,
    required this.audio,
    required this.layout,
    this.spatialConfig = const LiveTranscodingSpatialConfig.disabled(),
  });

  /// @nodoc
  Map<String, dynamic> toMap() => {
        'url': url,
        'roomId': roomId,
        'uid': uid,
        'mixType': mixType.index,
        'video': video.toMap(),
        'audio': audio.toMap(),
        'layout': layout.toMap(),
        'spatialConfig': spatialConfig.toMap(),
      };
}

/// 单流转推直播状态
enum StreamSinglePushEvent {
  /// @nodoc('For internal use')
  /// 未定义
  base,

  /// 发起单流转推直播请求
  start,

  /// 单流转推直播成功
  success,

  /// 单流转推直播失败
  failed,

  /// 单流转推直播停止
  stop,

  /// 单流转推直播请求超时
  timeout,

  /// 单流转推直播参数错误
  paramError,
}

/// 单流转推直播配置参数
class PushSingleStreamParam {
  /// 媒体流所在的房间 ID
  String roomId;

  /// 媒体流所属的用户 ID
  String uid;

  /// 推流地址
  String url;

  /// 媒体流是否为屏幕流
  bool isScreen;

  /// @nodoc
  PushSingleStreamParam({
    required this.roomId,
    required this.uid,
    required this.url,
    this.isScreen = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'uid': uid,
      'url': url,
      'isScreen': isScreen,
    };
  }
}

/// 性能回退相关数据
class SourceWantedData {
  /// 未开启发布回退时，此值表示推荐的视频输入宽度；当回退模式为大小流模式时，表示当前推流的最大宽度
  final int? width;

  /// 如果未开启发送性能回退，此值表示推荐的视频输入高度；如果开启了发送性能回退，此值表示当前推流的最大高度。
  final int? height;

  /// 如果未开启发送性能回退，此值表示推荐的视频输入帧率，单位 fps；如果开启了发送性能回退，此值表示当前推流的最大帧率，单位 fps。
  final int? frameRate;

  /// @nodoc
  const SourceWantedData({
    this.width,
    this.height,
    this.frameRate,
  });

  /// @nodoc
  factory SourceWantedData.fromMap(Map<dynamic, dynamic> map) {
    return SourceWantedData(
      width: map['width'],
      height: map['height'],
      frameRate: map['frameRate'],
    );
  }
}

/// 订阅配置
class SubscribeConfig {
  /// 是否是屏幕流
  final bool? isScreen;

  /// 是否订阅视频
  final bool? subVideo;

  /// 是否订阅音频
  final bool? subAudio;

  /// 订阅的视频流分辨率下标，Android 暂不可用
  ///
  /// 用户可以通过调用 [RTCVideo.setVideoEncoderConfig] 方法发布多个不同分辨率的视频。因此订阅流时，需要指定订阅的具体分辨率。此参数即用于指定需订阅的分辨率的下标，默认值为 0。
  final int? videoIndex;

  /// 视频宽度，单位：px
  final int? subWidth;

  /// 视频高度，单位：px
  final int? subHeight;

  /// @nodoc('Not available')
  final int? subVideoIndex;

  /// 订阅的视频流时域分层，默认值为 0，Android 暂不可用
  final int? svcLayer;

  /// 期望订阅的最高帧率，单位：fps，默认值为 0，设为大于 0 的值时开始生效
  ///
  /// 当发布端帧率低于设定帧率，或订阅端开启性能回退后下行弱网，则帧率会相应下降。  <br>
  /// 仅码流支持 SVC 分级编码特性时方可生效。
  final int? frameRate;

  /// @nodoc
  const SubscribeConfig({
    this.isScreen,
    this.subVideo,
    this.subAudio,
    this.videoIndex,
    this.subWidth,
    this.subHeight,
    this.subVideoIndex,
    this.svcLayer,
    this.frameRate,
  });

  /// @nodoc
  factory SubscribeConfig.fromMap(Map<dynamic, dynamic> map) {
    return SubscribeConfig(
      isScreen: map['isScreen'],
      subVideo: map['subVideo'],
      subAudio: map['subAudio'],
      videoIndex: map['videoIndex'],
      subWidth: map['subWidth'],
      subHeight: map['subHeight'],
      subVideoIndex: map['subVideoIndex'],
      svcLayer: map['svcLayer'],
      frameRate: map['frameRate'],
    );
  }
}

/// 矩形区域
class Rectangle {
  /// 矩形区域左上角的 x 坐标
  final int? x;

  /// 矩形区域左上角的 y 坐标
  final int? y;

  /// 矩形宽度(px)
  final int? width;

  /// 矩形高度(px)
  final int? height;

  /// @nodoc
  const Rectangle({
    this.x,
    this.y,
    this.width,
    this.height,
  });

  /// @nodoc
  factory Rectangle.fromMap(Map<dynamic, dynamic> map) {
    return Rectangle(
      x: map['x'],
      y: map['y'],
      width: map['width'],
      height: map['height'],
    );
  }
}

/// 人脸检测结果
class FaceDetectionResult {
  /// 人脸检测结果：
  /// + 0：检测成功；
  /// + !0：检测失败，失败原因详见[CV 错误码](https://www.volcengine.com/docs/6705/102042)。
  final int? detectResult;

  /// 原始图片宽度(px)。
  final int? imageWidth;

  /// 原始图片高度(px)。
  final int? imageHeight;

  /// 识别到人脸的矩形框。数组的长度和检测到的人脸数量一致。
  final List<Rectangle>? faces;

  /// 进行人脸识别的视频帧的时间戳。
  final int? frameTimestampUs;

  /// @nodoc
  const FaceDetectionResult({
    this.detectResult,
    this.imageWidth,
    this.imageHeight,
    this.faces,
    this.frameTimestampUs,
  });

  /// @nodoc
  factory FaceDetectionResult.fromMap(Map<dynamic, dynamic> map) {
    return FaceDetectionResult(
      detectResult: map['detectResult'],
      imageWidth: map['imageWidth'],
      imageHeight: map['imageHeight'],
      frameTimestampUs: map['frameTimestampUs'],
      faces: (map['faces'] as List<dynamic>)
          .map((e) => Rectangle.fromMap(e))
          .toList(),
    );
  }
}

/// 虚拟背景类型
enum VirtualBackgroundSourceType {
  /// 使用纯色背景替换视频原有背景
  color,

  /// 使用自定义图片背景替换视频原有背景
  image,
}

/// 背景贴纸对象
class VirtualBackgroundSource {
  /// 虚拟背景类型
  VirtualBackgroundSourceType sourceType;

  /// 纯色背景使用的颜色，格式为 0xAARRGGBB
  int sourceColor;

  /// 自定义背景图片的绝对路径
  ///
  /// + 支持本地文件绝对路径 (file://xxx) 和 Asset 资源路径 (asset://xxx)。
  /// + 支持的格式为 jpg、jpeg、png。
  /// + 图片分辨率超过 1080P 时，图片会被等比缩放至和视频一致。
  /// + 图片和视频宽高比一致时，图片会被直接缩放至和视频一致。
  /// + 图片和视频长宽比不一致时，为保证图片内容不变形，图片按短边缩放至与视频帧一致，使图片填满视频帧，对多出的高或宽进行剪裁。
  /// + 自定义图片带有局部透明效果时，透明部分由黑色代替。
  String sourcePath;

  /// @nodoc
  VirtualBackgroundSource({
    required this.sourceType,
    this.sourceColor = 0,
    this.sourcePath = '',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceType': sourceType.index,
      'sourceColor': sourceColor,
      'sourcePath': sourcePath,
    };
  }
}

/// 视频帧信息
class VideoFrameInfo {
  /// 宽（像素）
  final int? width;

  /// 高（像素）
  final int? height;

  /// 视频帧顺时针旋转角度
  final VideoRotation? rotation;

  /// @nodoc
  const VideoFrameInfo({
    this.width,
    this.height,
    this.rotation,
  });

  /// @nodoc
  factory VideoFrameInfo.fromMap(Map<dynamic, dynamic> map) {
    return VideoFrameInfo(
      width: map['width'],
      height: map['height'],
      rotation: (map['rotation'] as int).videoRotation,
    );
  }
}

/// 视频采集模式
enum VideoCapturePreference {
  /// 自动设置采集参数（默认）
  ///
  /// SDK在开启采集时根据服务端下发的采集配置结合编码参数设置最佳采集参数
  auto,

  /// 手动设置采集参数，包括采集分辨率、帧率
  manual,

  /// 采集参数与编码参数一致
  autoPerformance,
}

/// 视频采集配置参数
class VideoCaptureConfig {
  /// 视频采集模式
  VideoCapturePreference capturePreference;

  /// 宽度（px)
  int width = 0;

  /// 高度（px）
  int height = 0;

  /// 视频采集帧率 (fps)
  int frameRate = 0;

  /// @nodoc
  VideoCaptureConfig({
    this.capturePreference = VideoCapturePreference.auto,
    this.width = 0,
    this.height = 0,
    this.frameRate = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capturePreference': capturePreference.index,
      'width': width,
      'height': height,
      'frameRate': frameRate,
    };
  }
}

/// 当前视频设备类型
enum VideoDeviceType {
  /// 未知设备类型
  unknown,

  /// 视频渲染设备类型
  renderDevice,

  /// 视频采集设备类型
  captureDevice,

  /// 屏幕流视频设备
  screenCaptureDevice,
}

/// 视频旋转模式
enum VideoRotationMode {
  /// App 方向
  followApp,

  /// 重力方向
  followGSensor,
}

/// 视频帧朝向
enum VideoOrientation {
  /// （默认）使用相机输出的原始视频帧的角度，不对视频帧进行额外旋转
  adaptive,

  /// 固定为竖屏，将相机采集到的视频帧转换为竖屏，在整个 RTC 链路中传递竖屏帧
  portrait,

  /// 固定为横屏，将相机采集到的视频帧转换为横屏，在整个 RTC 链路中传递横屏帧
  landscape,
}

/// 超分状态改变原因
enum VideoSuperResolutionModeChangedReason {
  /// 成功关闭超分。
  apiOff,

  /// 成功开启超分。
  apiOn,

  /// 开启超分失败，远端视频流的原始视频分辨率超过 640 × 360 px。
  resolutionExceed,

  /// 开启超分失败，已对一路远端流开启超分。
  overUse,

  /// 设备不支持使用超分辨率。
  deviceNotSupport,

  /// 当前设备性能存在风险，已动态关闭超分。
  dynamicClose,

  /// 超分因其他原因关闭。
  otherSettingDisabled,

  /// 超分因其他原因开启。
  otherSettingEnabled,

  /// SDK 没有编译超分组件。
  noComponent,

  /// 远端流不存在。房间 ID 或用户 ID 无效，或对方没有发布流。
  streamNotExist,
}

/// 视频降噪模式状态改变原因
enum VideoDenoiseModeChangedReason {
  /// 成功关闭视频降噪。
  apiOff,

  /// 成功开启视频降噪。
  apiOn,

  /// 后台未配置视频降噪，视频降噪开启失败，请联系技术人员解决。
  configDisabled,

  /// 后台配置开启了视频降噪。
  configEnabled,

  /// 由于内部发生了异常，视频降噪关闭。
  internalException,

  /// 当前设备性能过载，已动态关闭视频降噪。
  dynamicClose,

  /// 当前设备性能裕量充足，已动态开启视频降噪。
  dynamicOpen,

  /// 分辨率导致视频降噪状态发生改变。分辨率过高会导致性能消耗过大，从而导致视频降噪关闭。<br>
  /// 若希望继续使用视频降噪，可选择降低分辨率。
  resolution,
}

/// 相机闪光灯状态
enum TorchState {
  /// 关闭
  off,

  /// 打开
  on,
}

/// 媒体流类型
enum MediaStreamType {
  /// 只控制音频
  audio,

  /// 只控制视频
  video,

  /// 同时控制音频和视频
  both,
}

/// 视频流参数描述
class VideoEncoderConfig {
  /// 视频宽度，单位：px
  int width;

  /// 视频高度，单位：px
  int height;

  /// 视频帧率，单位：fps
  int frameRate;

  /// 最大编码码率，使用 SDK 内部采集时可选设置，自定义采集时必须设置，单位：kbps
  ///
  /// 内部采集模式下默认值为 -1，即适配码率模式，系统将根据输入的分辨率和帧率自动计算适用的码率。 <br>
  /// 设为 0 则不对视频流进行编码发送。
  int maxBitrate;

  /// 视频最小编码码率, 单位 kbps。编码码率不会低于 `minBitrate`。<br>
  ///
  /// 默认值为 `0`。<br>
  /// 范围：`[0, maxBitrate)`，当 `maxBitrate` < `minBitrate` 时，为适配码率模式。
  ///
  /// 注意，以下情况，设置本参数无效：
  /// + 当 `maxBitrate` 为 `0` 时，不对视频流进行编码发送。
  /// + 当 `maxBitrate` < `0` 时，适配码率模式。
  int minBitrate;

  /// 编码策略偏好
  VideoEncoderPreference encoderPreference;

  /// @nodoc
  VideoEncoderConfig({
    required this.width,
    required this.height,
    required this.frameRate,
    this.maxBitrate = -1,
    this.minBitrate = 0,
    this.encoderPreference = VideoEncoderPreference.maintainFrameRate,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
      'frameRate': frameRate,
      'maxBitrate': maxBitrate,
      'minBitrate': minBitrate,
      'encoderPreference': encoderPreference.index,
    };
  }
}

/// 屏幕流编码配置。参考 [设置视频发布参数](https://www.volcengine.com/docs/6348/70122)。
class ScreenVideoEncoderConfig {
  /// 视频宽度，单位：px
  int width;

  /// 视频高度，单位：px
  int height;

  /// 视频帧率，单位：fps
  int frameRate;

  /// 最大编码码率，使用 SDK 内部采集时可选设置，自定义采集时必须设置，单位：kbps
  ///
  /// 内部采集模式下默认值为 -1，即适配码率模式，系统将根据输入的分辨率和帧率自动计算适用的码率。 <br>
  /// 设为 0 则不对视频流进行编码发送。
  int maxBitrate;

  /// 最小编码码率，使用 SDK 内部采集时可选设置，自定义采集时必须设置，单位：kbps。
  ///
  /// 最小编码码率必须小于或等于最大编码，否则不对视频流进行编码发送。
  int minBitrate;

  /// 屏幕流编码模式。参见 [ScreenVideoEncoderPreference].
  ScreenVideoEncoderPreference encoderPreference;

  /// @nodoc
  ScreenVideoEncoderConfig({
    required this.width,
    required this.height,
    required this.frameRate,
    this.maxBitrate = -1,
    this.minBitrate = 0,
    this.encoderPreference = ScreenVideoEncoderPreference.maintainFrameRate,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'width': width,
      'height': height,
      'frameRate': frameRate,
      'maxBitrate': maxBitrate,
      'minBitrate': minBitrate,
      'encoderPreference': encoderPreference.value,
    };
  }
}

/// 远端视频帧信息
class RemoteVideoConfig {
  /// 期望订阅的最高帧率，单位：fps，默认值为 0 即满帧订阅，设为大于 0 的值时开始生效
  ///
  /// 当发布端帧率低于设定帧率，或订阅端开启性能回退后下行弱网，则帧率会相应下降。  <br>
  /// 仅码流支持 SVC 分级编码特性时方可生效。
  int frameRate;

  /// 视频宽度，单位：px
  int width;

  /// 视频高度，单位：px
  int height;

  /// @nodoc
  RemoteVideoConfig({
    this.frameRate = 0,
    this.width = 0,
    this.height = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'frameRate': frameRate,
      'width': width,
      'height': height,
    };
  }
}

/// 房间参数配置
class RoomConfig {
  /// 房间模式，默认为普通音视频通话模式，进房后不可更改
  RoomProfile profile;

  /// 是否自动发布音视频流，默认为自动发布
  ///
  /// 若调用 [RTCRoom.setUserVisibility] 将自身可见性设为 false，无论是默认的自动发布流还是手动设置的自动发布流都不会进行发布，你需要将自身可见性设为 true 后方可发布。<br>
  /// 创建和加入多房间时，只能将其中一个房间设置为自动发布。若每个房间均不做设置，则默认在第一个加入的房间内自动发布流。
  bool isAutoPublish;

  /// 是否自动订阅音频流，默认为自动订阅
  bool isAutoSubscribeAudio;

  /// 是否自动订阅主视频流，默认为自动订阅
  bool isAutoSubscribeVideo;

  /// 远端视频流参数
  RemoteVideoConfig? remoteVideoConfig;

  /// @nodoc
  RoomConfig({
    this.profile = RoomProfile.communication,
    this.isAutoPublish = true,
    this.isAutoSubscribeAudio = true,
    this.isAutoSubscribeVideo = true,
    this.remoteVideoConfig,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profile': profile.index,
      'isAutoPublish': isAutoPublish,
      'isAutoSubscribeAudio': isAutoSubscribeAudio,
      'isAutoSubscribeVideo': isAutoSubscribeVideo,
      'remoteVideoConfig': remoteVideoConfig != null
          ? remoteVideoConfig!.toMap()
          : RemoteVideoConfig().toMap(),
    };
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

/// 屏幕采集媒体类型
enum ScreenMediaType {
  /// 仅采集视频
  videoOnly,

  /// 仅采集音频
  audioOnly,

  /// 采集音频和视频
  videoAndAudio,
}

/// 水印图片相对视频流的位置和大小
class Watermark {
  /// 水印图片相对视频流左上角的横向偏移与视频流宽度的比值，取值范围为 [0,1)
  final double x;

  /// 水印图片相对视频流左上角的纵向偏移与视频流高度的比值，取值范围为 [0,1)
  final double y;

  /// 水印图片宽度与视频流宽度的比值，取值范围 [0,1)
  final double width;

  /// 水印图片高度与视频流高度的比值，取值范围为 [0,1)
  final double height;

  /// @nodoc
  const Watermark({
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
  });

  /// @nodoc
  const Watermark.none() : this();

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }
}

/// 水印参数
class WatermarkConfig {
  /// 水印是否在视频预览中可见，默认可见
  bool visibleInPreview;

  /// 横屏时的水印位置和大小
  Watermark positionInLandscapeMode;

  /// 竖屏时的水印位置和大小
  Watermark positionInPortraitMode;

  /// @nodoc
  WatermarkConfig({
    this.visibleInPreview = true,
    this.positionInLandscapeMode = const Watermark.none(),
    this.positionInPortraitMode = const Watermark.none(),
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visibleInPreview': visibleInPreview,
      'positionInLandscapeMode': positionInLandscapeMode.toMap(),
      'positionInPortraitMode': positionInPortraitMode.toMap(),
    };
  }
}

/// 视频裁剪参数
class SourceCrop {
  /// 裁剪后得到的视频帧左上角横坐标相对于裁剪前整体画面的归一化比例，取值范围[0.0, 1.0)
  double locationX;

  /// 裁剪后得到的视频帧左上角纵坐标相对于裁剪前整体画面的归一化比例，取值范围[0.0, 1.0)
  double locationY;

  /// 裁剪后得到的视频帧宽度相对于裁剪前整体画面的归一化比例，取值范围(0.0, 1.0]
  double widthProportion;

  /// 裁剪后得到的视频帧高度相对于裁剪前整体画面的归一化比例，取值范围(0.0, 1.0]
  double heightProportion;

  /// @nodoc
  SourceCrop({
    this.locationX = 0,
    this.locationY = 0,
    this.widthProportion = 1,
    this.heightProportion = 1,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locationX': locationX,
      'locationY': locationY,
      'widthProportion': widthProportion,
      'heightProportion': heightProportion,
    };
  }
}

/// 合成公共流的每条流的布局信息
class PublicStreamingRegion {
  /// 视频流发布用户的用户 ID。必填
  String uid;

  /// 媒体流所在房间的房间 ID。必填
  String roomId;

  /// 背景图片地址，iOS 适用
  String alternateImage;

  /// 视频流对应区域左上角的横坐标相对整体画面的比例，取值的范围为 `[0.0, 1.0)`。必填
  double x;

  /// 视频流对应区域左上角的纵坐标相对整体画面的比例，取值的范围为 `[0.0, 1.0)`。必填
  double y;

  /// 视频流对应区域宽度相对整体画面的比例，取值的范围为 `(0.0, 1.0]`。必填
  double w;

  /// 视频流对应区域高度相对整体画面的比例，取值的范围为 `(0.0, 1.0]`。必填
  double h;

  /// 用户视频布局在画布中的层级，取值范围为 `[0, 100]`
  ///
  /// 0为底层，值越大越上层。
  int zorder;

  /// 透明度，可选范围为 `[0.0, 1.0]`。必填
  double alpha;

  /// 公共流媒体类型。必填
  StreamIndex streamType;

  /// 公共流内容类型。必填
  TranscoderContentControlType mediaType;

  /// 视频显示模式。必填
  VideoRenderMode renderMode;

  /// 用户视频布局的相对位置和大小
  SourceCrop sourceCrop;

  /// @nodoc
  PublicStreamingRegion({
    required this.uid,
    required this.roomId,
    this.alternateImage = '',
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.zorder = 0,
    this.alpha = 1.0,
    this.streamType = StreamIndex.main,
    this.mediaType = TranscoderContentControlType.hasAudioAndVideo,
    this.renderMode = VideoRenderMode.hidden,
    required this.sourceCrop,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'roomId': roomId,
      'alternateImage': alternateImage,
      'x': x,
      'y': y,
      'w': w,
      'h': h,
      'zorder': zorder,
      'alpha': alpha,
      'streamType': streamType.index,
      'mediaType': mediaType.index,
      'renderMode': renderMode.value,
      'sourceCrop': sourceCrop.toMap()
    };
  }
}

/// 公共流布局
class PublicStreamingLayout {
  /// 合成公共流的每条流的布局信息
  List<PublicStreamingRegion> regions;

  /// 插帧模式：
  /// + `0`：补最后一帧
  /// + `1`：补背景图片，如果没有设置背景图片则补黑帧
  int interpolationMode;

  /// 公共流布局模式，`2`：自定义模式。
  int layoutMode;

  /// 画布的背景图片地址
  String backgroundImage;

  /// 背景颜色。格式为 RGB 定义下的 Hex 值，如 #FFB6C1 表示浅粉色。默认值 #000000，表示为黑色
  String backgroundColor;

  /// @nodoc
  PublicStreamingLayout({
    required this.regions,
    this.interpolationMode = 0,
    this.layoutMode = 2,
    this.backgroundImage = '',
    this.backgroundColor = '#000000',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'regions': regions.map((e) => e.toMap()).toList(),
      'interpolationMode': interpolationMode,
      'layoutMode': layoutMode,
      'backgroundImage': backgroundImage,
      'backgroundColor': backgroundColor,
    };
  }
}

/// 公共流的视频编码参数
class PublicStreamingVideoConfig {
  /// 公共流视频帧率。必填。范围：`[1, 60]`
  int fps;

  /// 视频码率，必填。范围：`[1,10000000]`。单位为 bps
  int kBitrate;

  /// 公共流视频宽度，必填。单位为 px，范围为 `[16, 1920]`，必须是偶数。
  int width;

  /// 公共流视频高度，必填。单位为 px，范围为 `[16, 1280]`，必须是偶数。
  int height;

  /// @nodoc
  PublicStreamingVideoConfig({
    this.fps = 30,
    this.kBitrate = 500,
    this.width = 360,
    this.height = 640,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fps': fps,
      'kBitrate': kBitrate,
      'width': width,
      'height': height,
    };
  }
}

/// 公共流的音频参数
class PublicStreamingAudioConfig {
  /// 音频码率，必填。单位为 kbps。正整数，可选取值：16, 32, 64。
  int kBitrate;

  /// 音频采样率，必填。单位为 Hz。可选取值：16000, 32000, 44100 和 48000
  int sampleRate;

  /// 音频声道数，必填。<br>
  /// + `1`：单声道，默认值
  /// + `2`：双声道
  int channels;

  /// @nodoc
  PublicStreamingAudioConfig({
    this.kBitrate = 16,
    this.sampleRate = 44100,
    this.channels = 1,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kBitrate': kBitrate,
      'sampleRate': sampleRate,
      'channels': channels,
    };
  }
}

/// 公共流参数
class PublicStreaming {
  /// @nodoc('Not available')
  /// 推公共流的房间 ID。暂不可用。
  String roomId;

  /// 视频编码参数，必填。
  PublicStreamingVideoConfig video;

  /// @nodoc('Not available')
  /// 音频编码参数，必填。暂不可用。
  PublicStreamingAudioConfig audio;

  /// 公共流布局，必填。
  PublicStreamingLayout layout;

  /// @nodoc
  PublicStreaming({
    required this.roomId,
    required this.video,
    required this.audio,
    required this.layout,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomId': roomId,
      'video': video.toMap(),
      'audio': audio.toMap(),
      'layout': layout.toMap(),
    };
  }
}

/// 本地截图结果
class LocalSnapshot {
  /// 截图任务 ID
  int taskId;

  /// 流属性
  final StreamIndex streamIndex;

  /// 截图结果文件路径
  final String filePath;

  /// 图片宽度
  int width;

  /// 图片高度
  int height;

  /// @nodoc
  LocalSnapshot({
    this.taskId = 0,
    required this.streamIndex,
    required this.filePath,
    this.width = 0,
    this.height = 0,
  });
}

/// 远端截图
class RemoteSnapshot {
  /// 截图任务 ID
  int taskId;

  /// 远端流信息
  final RemoteStreamKey streamKey;

  /// 截图结果文件路径
  final String filePath;

  /// 图片宽度
  int width;

  /// 图片高度
  int height;

  /// @nodoc
  RemoteSnapshot({
    this.taskId = 0,
    required this.streamKey,
    required this.filePath,
    this.width = 0,
    this.height = 0,
  });
}

/// 数码变焦参数类型
enum ZoomConfigType {
  /// 设置缩放系数
  focusOffset,

  /// 设置移动步长
  moveOffset,
}

/// 数字变焦操作类型
enum ZoomDirectionType {
  /// 相机向左移动
  cameraMoveLeft,

  /// 相机向右移动
  cameraMoveRight,

  /// 相机向上移动
  cameraMoveUp,

  /// 相机向下移动
  cameraMoveDown,

  /// 相机缩小焦距
  cameraZoomOut,

  /// 相机放大焦距
  cameraZoomIn,

  /// 恢复到原始画面
  cameraReset,
}

/// 蜂窝网络辅助增强应用的媒体模式。
class MediaTypeEnhancementConfig {
  /// 对信令消息，是否启用蜂窝网络辅助增强。默认不启用。
  bool enhanceSignaling;

  /// 对屏幕共享以外的其他音频，是否启用蜂窝网络辅助增强。默认不启用。
  bool enhanceAudio;

  /// 对屏幕共享视频以外的其他视频，是否启用蜂窝网络辅助增强。默认不启用。
  bool enhanceVideo;

  /// 对屏幕共享音频，是否启用蜂窝网络辅助增强。默认不启用。
  bool enhanceScreenAudio;

  /// 对屏幕共享视频，是否启用蜂窝网络辅助增强。默认不启用。
  bool enhanceScreenVideo;

  /// @nodoc
  MediaTypeEnhancementConfig({
    this.enhanceSignaling = false,
    this.enhanceAudio = false,
    this.enhanceVideo = false,
    this.enhanceScreenAudio = false,
    this.enhanceScreenVideo = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enhanceSignaling': enhanceSignaling,
      'enhanceAudio': enhanceAudio,
      'enhanceVideo': enhanceVideo,
      'enhanceScreenAudio': enhanceScreenAudio,
      'enhanceScreenVideo': enhanceScreenVideo,
    };
  }
}

/// 视频编码格式(新)。
enum MixedStreamVideoCodecType {
  /// H.264 格式，默认值。
  h264,

  /// ByteVC1 格式。
  byteVC1,
}

/// 超分模式
enum VideoSuperResolutionMode {
  /// 关闭超分
  off,

  /// 开启超分
  on,
}

/// 视频降噪模式
enum VideoDenoiseMode {
  /// 视频降噪关闭
  off,

  /// 视频降噪开启，由 ByteRTC 后台配置视频降噪算法。
  on,
}

/// 视频转码配置参数(新)。值不合法或未设置时，自动使用默认值。
class MixedStreamVideoConfig {
  /// 视频编码格式。默认值为 `0`。
  ///
  /// 本参数不支持过程中更新。
  final MixedStreamVideoCodecType videoCodec;

  /// 合流视频帧率。单位为 FPS，取值范围为 [1,60]，默认值为 15 FPS。
  final int fps;

  /// 视频 I 帧时间间隔。单位为秒，取值范围为 [1, 5]，默认值为 2 秒。
  ///
  /// 本参数不支持过程中更新。
  final int gop;

  /// 合流视频码率。单位为 Kbps，取值范围为 [1,10000]，默认值为自适应模式。
  final int bitrate;

  /// 合流视频宽度。单位为 px，范围为 [2, 1920]，必须是偶数。默认值为 640 px。<br>
  /// 设置值为非偶数时，自动向上取偶数。
  final int width;

  /// 合流视频高度。单位为 px，范围为 [2, 1920]，必须是偶数。默认值为 360 px。
  /// 设置值为非偶数时，自动向上取偶数。
  final int height;

  /// 是否在合流中开启 B 帧，仅服务端合流支持.
  final bool enableBFrame;

  /// @nodoc
  const MixedStreamVideoConfig({
    this.videoCodec = MixedStreamVideoCodecType.h264,
    this.fps = 15,
    this.gop = 2,
    this.bitrate = 500,
    this.width = 360,
    this.height = 640,
    this.enableBFrame = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoCodec': videoCodec.index,
      'fps': fps,
      'gop': gop,
      'bitrate': bitrate,
      'width': width,
      'height': height,
      'enableBFrame': enableBFrame,
    };
  }
}

/// 音频编码类型。(新)
enum MixedStreamAudioCodecType {
  /// AAC 格式。
  acc,
}

/// AAC 编码规格。(新)
enum MixedStreamAudioProfile {
  /// AAC-LC 规格，默认值。
  lc,

  /// HE-AAC v1 规格。
  hev1,

  /// HE-AAC v2 规格。
  hev2,
}

/// 音频转码配置参数。(新)<br>
/// 值不合法或未设置时，自动使用默认值。<br>
/// 本参数不支持过程中更新。
class MixedStreamAudioConfig {
  /// 音频编码格式。
  final MixedStreamAudioCodecType audioCodec;

  /// 音频码率，单位 Kbps。可取范围 [32, 192]，默认值为 64 Kbps。
  final int bitrate;

  /// 音频采样率，单位 Hz。可取 32000 Hz、44100 Hz、48000 Hz，默认值为 48000 Hz。
  final int sampleRate;

  /// 音频声道数。可取 1（单声道）、2（双声道），默认值为 2。
  final int channels;

  /// AAC 编码规格。默认值为 `0`。
  final MixedStreamAudioProfile audioProfile;

  /// @nodoc
  const MixedStreamAudioConfig({
    this.audioCodec = MixedStreamAudioCodecType.acc,
    this.bitrate = 64,
    this.sampleRate = 48000,
    this.channels = 2,
    this.audioProfile = MixedStreamAudioProfile.lc,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'audioCodec': audioCodec.index,
      'bitrate': bitrate,
      'sampleRate': sampleRate,
      'channels': channels,
      'audioProfile': audioProfile.index,
    };
  }
}

/// 推流 CDN 的空间音频参数。(新)
class MixedStreamSpatialConfig {
  /// 是否开启推流 CDN 时的空间音频效果。<br>
  /// 当你启用此效果时，你需要设定推流中各个 [MixedStreamLayoutRegionConfig] 的 `spatialPosition` 值，实现空间音频效果。
  final bool enableSpatialRender;

  /// 听众的空间位置。<br>
  /// 听众指收听来自 CDN 的音频流的用户。
  final Position audienceSpatialPosition;

  /// 听众的空间朝向。<br>
  /// 听众指收听来自 CDN 的音频流的用户。
  final HumanOrientation audienceSpatialOrientation;

  /// @nodoc
  const MixedStreamSpatialConfig({
    this.enableSpatialRender = false,
    this.audienceSpatialPosition = const Position.zero(),
    this.audienceSpatialOrientation = const HumanOrientation.origin(),
  });

  /// @nodoc
  const MixedStreamSpatialConfig.disabled() : this();

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enableSpatialRender': enableSpatialRender,
      'position': audienceSpatialPosition.toMap(),
      'orientation': audienceSpatialOrientation.toMap(),
    };
  }
}

/// 合流输出内容类型。(新)
enum MixedStreamMediaType {
  /// 输出的混流包含音频和视频。
  audioAndVideo,

  /// 输出的混流只包含音频。
  audioOnly,

  /// 输出的混流只包含视频。
  videoOnly,
}

/// 图片或视频流的缩放模式。(新)
enum MixedStreamRenderMode {
  /// 视窗填满优先，默认值。<br>
  /// 视频尺寸等比缩放，直至视窗被填满。当视频尺寸与显示窗口尺寸不一致时，多出的视频将被截掉。
  hidden,

  /// 视频帧内容全部显示优先。<br>
  /// 视频尺寸等比缩放，优先保证视频内容全部显示。当视频尺寸与显示窗口尺寸不一致时，会把窗口未被填满的区域填充成背景颜色。
  fit,

  /// 视频帧自适应画布。<br>
  /// 视频尺寸非等比例缩放，把窗口充满。在此过程中，视频帧的长宽比例可能会发生变化。
  adaptive,
}

/// 服务端合流占位图填充模式。
enum MixedStreamAlternateImageFillMode {
  /// 占位图跟随用户原始视频帧相同的比例缩放。默认设置。
  fit,

  /// 占位图不跟随用户原始视频帧相同的比例缩放，保持图片原有比例。
  fill,
}

/// region 中流的类型属性。
enum MixedStreamVideoType {
  /// 主流。由摄像头/麦克风采集到的流。
  main,

  /// 屏幕流。
  screen,
}

/// 合流布局区域类型。(新)
enum MixedStreamLayoutRegionType {
  /// 合流布局区域类型为视频。
  videoStream,

  /// 合流布局区域类型为图片。
  image,
}

/// 图片合流相关参数。(新)
class MixedStreamLayoutRegionImageWaterMarkConfig {
  /// 原始图片的宽度，单位为 px。
  final int imageWidth;

  /// 原始图片的高度，单位为 px。
  final int imageHeight;

  /// @nodoc
  const MixedStreamLayoutRegionImageWaterMarkConfig({
    this.imageWidth = 0,
    this.imageHeight = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    };
  }
}

/// 单个图片或视频流在合流中的布局信息。(新)<br>
/// 开启转推直播功能后，在多路图片或视频流合流时，你可以设置其中一路流在合流中的预设布局信息。
class MixedStreamLayoutRegionConfig {
  /// 视频流发布用户的用户 ID。必填。
  final String uid;

  /// 图片或视频流所在房间的房间 ID。必填。<br>
  /// 如果此图片或视频流是通过 [RTCRoom.startForwardStreamToRooms] 转发到你所在房间的媒体流时，你应将房间 ID 设置为你所在的房间 ID。
  final String roomId;

  /// 单个用户画面左上角在整个画布坐标系中的 X 坐标（pixel），即以画布左上角为原点，用户画面左上角相对于原点的横向位移。<br>
  /// 取值范围为 [0, 整体画布宽度)。默认值为 0。
  final int locationX;

  /// 单个用户画面左上角在整个画布坐标系中的 Y 坐标（pixel），即以画布左上角为原点，用户画面左上角相对于原点的纵向位移。<br>
  /// 取值范围为 [0, 整体画布高度)。默认值为 0。
  final int locationY;

  /// 单个用户画面的宽度。取值范围为 [0, 整体画布宽度]，默认值为 360。
  final int width;

  /// 单个用户画面的高度。取值范围为 [0, 整体画布高度]，默认值为 640。
  final int height;

  /// 用户视频布局在画布中的层级。取值范围为 [0 - 100]，0 为底层，值越大越上层。默认值为 0。
  final int zOrder;

  /// 透明度，可选范围为 (0.0, 1.0]，0.0 为全透明。默认值为 1.0。
  final double alpha;

  /// 圆角半径相对画布宽度的比例。默认值为 `0.0`。
  ///
  /// 做范围判定时，首先根据画布的宽高，将 `width`，`height`，和 `cornerRadius` 分别转换为像素值：`width_px`，`height_px`，和 `cornerRadius_px`。然后判定是否满足 `cornerRadius_px < min(width_px/2, height_px/2)`：若满足，则设置成功；若不满足，则将 `cornerRadius_px` 设定为 `min(width_px/2, height_px/2)`，然后将 `cornerRadius` 设定为 `cornerRadius_px` 相对画布宽度的比例值。
  final double cornerRadius;

  /// 合流内容控制。默认值为 `audioAndVideo`。
  final MixedStreamMediaType mediaType;

  /// 图片或视频流的缩放模式。默认值为 1。
  final MixedStreamRenderMode renderMode;

  /// 设置占位图的填充模式。
  ///
  /// v3.57 新增。
  ///
  /// 该参数用来控制当用户停止发布视频流，画面恢复为占位图后，此时占位图的填充模式。
  final MixedStreamAlternateImageFillMode alternateImageFillMode;

  /// 设置占位图的 URL，长度小于 1024 字符。
  ///
  /// v3.57 新增。
  final String alternateImageUrl;

  /// 是否为本地用户。
  final bool isLocalUser;

  /// 流类型，默认为主流。
  final MixedStreamVideoType streamType;

  /// 合流布局区域类型。
  final MixedStreamLayoutRegionType regionContentType;

  /// 图片合流布局区域类型对应的数据。类型为图片时传入图片 RGBA 数据，当类型为视频流时传空。
  final Uint8List? imageWaterMark;

  /// 合流布局区域数据的对应参数。当类型为视频流时传空，类型为图片时传入对应图片的参数。
  final MixedStreamLayoutRegionImageWaterMarkConfig? imageWaterMarkConfig;

  /// 空间位置。
  final Position spatialPosition;

  /// 设置某用户是否应用空间音频效果。
  final bool applySpatialAudio;

  /// @nodoc
  const MixedStreamLayoutRegionConfig({
    this.uid = '',
    this.roomId = '',
    this.locationX = 0,
    this.locationY = 0,
    this.width = 360,
    this.height = 640,
    this.zOrder = 0,
    this.alpha = 1.0,
    this.cornerRadius = 0.0,
    this.mediaType = MixedStreamMediaType.audioAndVideo,
    this.renderMode = MixedStreamRenderMode.hidden,
    this.alternateImageFillMode = MixedStreamAlternateImageFillMode.fit,
    this.alternateImageUrl = '',
    this.isLocalUser = false,
    this.streamType = MixedStreamVideoType.main,
    this.regionContentType = MixedStreamLayoutRegionType.videoStream,
    this.imageWaterMark,
    this.imageWaterMarkConfig,
    this.spatialPosition = const Position.zero(),
    this.applySpatialAudio = true,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'roomId': roomId,
      'locationX': locationX,
      'locationY': locationY,
      'width': width,
      'height': height,
      'zOrder': zOrder,
      'alpha': alpha,
      'cornerRadius': cornerRadius,
      'mediaType': mediaType.index,
      'renderMode': renderMode.value,
      'alternateImageFillMode': alternateImageFillMode.index,
      'alternateImageUrl': alternateImageUrl,
      'isLocalUser': isLocalUser,
      'streamType': streamType.index,
      'regionContentType': regionContentType.index,
      if (imageWaterMark != null) 'imageWaterMark': imageWaterMark,
      if (imageWaterMarkConfig != null)
        'imageWaterMarkConfig': imageWaterMarkConfig!.toMap(),
      'spatialPosition': spatialPosition.toMap(),
      'applySpatialAudio': applySpatialAudio,
    };
  }
}

/// 视频流合流整体布局信息。(新)<br>
/// 开启转推直播功能后，你可以设置参与合流的每路视频流的预设布局信息和合流背景信息等。
class MixedStreamLayoutConfig {
  /// 用户布局信息列表。每条流的具体布局参看 [MixedStreamLayoutRegionConfig]。
  ///
  /// 值不合法或未设置时，自动使用默认值。
  final List<MixedStreamLayoutRegionConfig> regions;

  /// 用户透传的额外数据。
  final String userConfigExtraInfo;

  /// 合流背景颜色，用十六进制颜色码（HEX）表示。例如，#FFFFFF 表示纯白，#000000 表示纯黑。默认值为 #000000。
  ///
  /// 值不合法或未设置时，自动使用默认值。
  final String backgroundColor;

  /// 设置合流后整体画布的背景图片 URL，长度最大为 1024 bytes。
  ///
  /// v3.57 新增。
  ///
  /// 支持的图片格式包括：JPG, JPEG, PNG。如果背景图片的宽高和整体屏幕的宽高不一致，背景图片会缩放到铺满屏幕。
  final String backgroundImageUrl;

  /// @nodoc
  const MixedStreamLayoutConfig({
    this.regions = const [],
    this.userConfigExtraInfo = '',
    this.backgroundColor = '#000000',
    this.backgroundImageUrl = '',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'regions': regions.map((e) => e.toMap()).toList(growable: false),
      'userConfigExtraInfo': userConfigExtraInfo,
      'backgroundColor': backgroundColor,
      'backgroundImageUrl': backgroundImageUrl,
    };
  }
}

/// 服务端合流控制参数
class MixedStreamServerControlConfig {
  /// 是否开启单独发送声音提示 SEI 的功能：
  /// + true：开启；
  /// + false：关闭。（默认值）
  ///
  /// v3.57 新增。
  ///
  /// 开启后，你可以通过 [MixedStreamServerControlConfig.seiContentMode] 控制 SEI 的内容是否只携带声音信息。
  final bool enableVolumeIndication;

  /// 声音提示间隔，单位为秒，取值范围为 [0.3,+∞)，默认值为 2。
  ///
  /// v3.57 新增。
  ///
  /// 此值仅取整百毫秒。若传入两位及以上小数，则四舍五入取第一位小数的值。例如，若传入 0.36，则取 0.4。
  final double volumeIndicationInterval;

  /// 有效音量大小，取值范围为 [0, 255]，默认值为 0。
  ///
  /// v3.57 新增。
  ///
  /// 超出取值范围则自动调整为默认值，即 0。
  final int talkVolume;

  /// 声音信息 SEI 是否包含音量值：
  /// + true：是；
  /// + false：否，默认值。
  ///
  /// v3.57 新增。
  final bool isAddVolumeValue;

  /// 设置 SEI 内容。
  ///
  /// v3.57 新增。
  final MixedStreamSEIContentMode seiContentMode;

  /// SEI 信息的 payload type。<br>
  /// 默认值为 100，只支持设置 5 和 100。
  ///
  /// v3.57 新增。
  ///
  /// 在转推直播的过程中，该参数不支持变更。
  final int seiPayloadType;

  /// SEI 信息的 payload UUID。
  ///
  /// v3.57 新增。
  ///
  /// 注意：
  /// + PayloadType 为 5 时，必须填写 PayloadUUID，否则会收到错误回调。
  /// + PayloadType 不是 5 时，不需要填写 PayloadUUID，如果填写会被后端忽略。
  /// + 该参数长度需为 32 位，否则会收到错误回调。
  /// + 该参数每个字符的范围需为 [0, 9] [a, f] [A, F]。
  /// + 该参数不应带有-字符，如系统自动生成的 UUID 中带有-，则应删去。
  /// + 在转推直播的过程中，该参数不支持变更。
  final String seiPayloadUuid;

  /// 设置合流推到 CDN 时输出的媒体流类型。
  ///
  /// v3.57 新增。
  ///
  /// 默认输出音视频流。支持输出纯音频流，但暂不支持输出纯视频流。
  final MixedStreamMediaType mediaType;

  /// 设置是否在没有用户发布流的情况下发起转推直播。
  ///
  /// v3.57 新增。
  ///
  /// 该参数在发起合流任务后的转推直播过程中不支持动态变更。
  final MixedStreamPushMode pushStreamMode;

  /// @nodoc
  const MixedStreamServerControlConfig({
    this.enableVolumeIndication = false,
    this.volumeIndicationInterval = 2.0,
    this.talkVolume = 0,
    this.isAddVolumeValue = false,
    this.seiContentMode = MixedStreamSEIContentMode.defaultMode,
    this.seiPayloadType = 100,
    this.seiPayloadUuid = '',
    this.mediaType = MixedStreamMediaType.audioAndVideo,
    this.pushStreamMode = MixedStreamPushMode.onStreamMode,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enableVolumeIndication': enableVolumeIndication,
      'volumeIndicationInterval': volumeIndicationInterval,
      'talkVolume': talkVolume,
      'isAddVolumeValue': isAddVolumeValue,
      'seiContentMode': seiContentMode.index,
      'seiPayloadType': seiPayloadType,
      'seiPayloadUuid': seiPayloadUuid,
      'mediaType': mediaType.index,
      'pushStreamMode': pushStreamMode.index,
    };
  }
}

/// 转推直播配置参数。(新)
class MixedStreamConfig {
  /// 推流 CDN 地址。仅支持 RTMP 协议，Url 必须满足正则 `/^rtmps?:\/\//`。
  ///
  /// 本参数不支持过程中更新。
  final String pushURL;

  /// 推流房间 ID。`roomId` 和 `uid` 长度相加不得超过 126 字节。
  ///
  /// 本参数不支持过程中更新。
  final String roomId;

  /// 推流用户 ID。`roomId` 和 `uid` 长度相加不得超过 126 字节。
  ///
  /// 本参数不支持过程中更新。
  final String uid;

  /// 合流类型。仅支持服务端合流。
  final StreamMixingType expectedMixingType;

  /// 视频合流配置参数。
  final MixedStreamVideoConfig videoConfig;

  /// 音频合流配置参数。
  final MixedStreamAudioConfig audioConfig;

  /// 转推 CDN 空间音频配置。
  final MixedStreamSpatialConfig spatialConfig;

  /// 视频流合流整体布局信息。<br>
  /// 开启转推直播功能后，你可以设置参与合流的每路视频流的预设布局信息和合流背景信息等。
  final MixedStreamLayoutConfig layout;

  /// 服务端合流控制参数
  final MixedStreamServerControlConfig serverControlConfig;

  /// @nodoc
  const MixedStreamConfig({
    required this.pushURL,
    required this.roomId,
    required this.uid,
    this.expectedMixingType = StreamMixingType.byServer,
    this.videoConfig = const MixedStreamVideoConfig(),
    this.audioConfig = const MixedStreamAudioConfig(),
    this.spatialConfig = const MixedStreamSpatialConfig.disabled(),
    this.layout = const MixedStreamLayoutConfig(),
    this.serverControlConfig = const MixedStreamServerControlConfig(),
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pushURL': pushURL,
      'roomId': roomId,
      'uid': uid,
      'expectedMixingType': expectedMixingType.index,
      'videoConfig': videoConfig.toMap(),
      'audioConfig': audioConfig.toMap(),
      'spatialConfig': spatialConfig.toMap(),
      'layout': layout.toMap(),
      'serverControlConfig': serverControlConfig.toMap(),
    };
  }
}
