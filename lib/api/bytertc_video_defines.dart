// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:collection';
import 'dart:typed_data';

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_audio_defines.dart';
import 'bytertc_media_defines.dart';
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

/// 基础美颜模式
enum EffectBeautyMode {
  /// 美白
  whiteMode,

  /// 磨皮
  smoothMode,

  /// 锐化
  sharpenMode,
}

/// 视频帧旋转角度
enum VideoRotation {
  /// 顺时针旋转 0 度(默认设置）
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

  /// 客户端合流
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
  changeMixeType,

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

/// 转推直播错误码
enum TranscoderErrorCode {
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
      'contentControl': contentControl.value,
      'renderMode': renderMode.value,
      'localUser': localUser,
      'isScreen': isScreen,
      'type': type.value,
      'spatialPosition': spatialPosition.toMap(),
    });
    if (this.data != null) {
      dic['data'] = data;
    }
    if (this.dataParam != null) {
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

  const LiveTranscodingSpatialConfig({
    this.audienceSpatialOrientation = const HumanOrientation.origin(),
    this.audienceSpatialPosition = const Position.zero(),
    this.enableSpatialRender = false,
  });

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

  LiveTranscoding({
    this.mixType = StreamMixingType.byServer,
    required this.url,
    required this.roomId,
    required this.uid,
    required this.video,
    required this.layout,
    required this.audio,
    this.spatialConfig = const LiveTranscodingSpatialConfig.disabled(),
  });

  /// @nodoc
  Map<String, dynamic> toMap() => {
        'url': url,
        'roomId': roomId,
        'uid': uid,
        'mixType': mixType.value,
        'video': video.toMap(),
        'layout': layout.toMap(),
        'audio': audio.toMap(),
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

  VirtualBackgroundSource({
    required this.sourceType,
    this.sourceColor = 0,
    this.sourcePath = '',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sourceType': sourceType.value,
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

  VideoCaptureConfig({
    this.capturePreference = VideoCapturePreference.auto,
    this.width = 0,
    this.height = 0,
    this.frameRate = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'capturePreference': capturePreference.value,
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
      'encoderPreference': encoderPreference.value,
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
      'profile': profile.value,
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

  const Watermark({
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
  });

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
      'streamType': streamType.value,
      'mediaType': mediaType.value,
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
  /// + `0`: 补最后一帧<br>
  /// + `1`: 补背景图片，如果没有设置背景图片则补黑帧
  int interpolationMode;

  /// 公共流布局模式，`2`: 自定义模式。
  int layoutMode;

  /// 画布的背景图片地址
  String backgroundImage;

  /// 背景颜色。格式为 RGB 定义下的 Hex 值，如 #FFB6C1 表示浅粉色。默认值 #000000，表示为黑色
  String backgroundColor;

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
  /// + `1`: 单声道，默认值<br>
  /// + `2`: 双声道
  int channels;

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
