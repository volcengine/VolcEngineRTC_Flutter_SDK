// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_common_defines.dart';

/// 音频设备类型
enum AudioDeviceType {
  /// 未知设备
  unknown,

  /// 音频渲染设备
  renderDevice,

  /// 音频采集设备
  captureDevice,

  /// 屏幕流音频采集设备
  screenCaptureDevice,
}

/// 音频播放路由
enum AudioRoute {
  /// 未知设备
  unknown,

  /// 有线耳机
  headset,

  /// 设备自带听筒，一般用于通话的播放硬件。
  earpiece,

  /// 设备自带扬声器，一般用于免提播放的硬件。
  speakerphone,

  /// 蓝牙耳机
  headsetBluetooth,

  /// USB 设备
  headsetUSB,
}

/// 音频场景类型
///
/// 选择音频场景后，SDK 会自动根据客户端音频采集播放设备和状态，适用通话音量/媒体音量。
/// 如果以下音频场景类型无法满足你的业务需要，请联系技术支持人员。
enum AudioScenario {
  /// 音乐场景(默认)
  ///
  /// 此场景适用于对音乐表现力有要求的场景，如音乐直播等。
  /// 音频采集播放设备和采集播放状态，到音量类型的映射如下：
  /// <table>
  /// <tr><th></th><th>不采集音频</th><th>采集音频</th><th>备注</th></tr>
  /// <tr><td>设备自带麦克风和扬声器/听筒</td><td>媒体音量</td><td>通话音量</td><td>/</td></tr>
  /// <tr><td>有线耳机</td><td>媒体音量</td><td>媒体音量</td><td></td></tr>
  /// <tr><td>蓝牙耳机</td><td>媒体音量</td><td>媒体音量</td><td>媒体音量</td><td>即使蓝牙耳机有麦克风，也只能使用设备自带麦克风进行本地音频采集</td></tr>
  /// </table>
  music,

  /// 高质量通话场景
  ///
  /// 此场景适用于对音乐表现力有要求，但又希望能够使用蓝牙耳机上自带的麦克风进行音频采集的场景。
  /// 此场景可以兼顾外放/使用蓝牙耳机时的音频体验，并避免使用蓝牙耳机时音量类型切换导致的听感突变。
  /// 音频采集播放设备和采集播放状态，到音量类型的映射如下：
  /// <table>
  /// <tr><th></th><th>不采集音频</th><th>采集音频</th><th>备注</th></tr>
  /// <tr><td>设备自带麦克风和扬声器/听筒</td><td>媒体音量</td><td>通话音量</td><td>/</td></tr>
  /// <tr><td>有线耳机</td><td>媒体音量</td><td>媒体音量</td><td>/</td></tr>
  /// <tr><td>蓝牙耳机</td><td>通话音量</td><td>通话音量</td><td>通话音量</td><td>能够使用蓝牙耳机上自带的麦克风进行音频采集</td></tr>
  /// </table>
  highQualityCommunication,

  /// 纯通话音量场景
  ///
  /// 此场景下，无论客户端音频采集播放设备和采集播放状态，全程使用通话音量。
  /// 适用于需要频繁上下麦的通话或会议场景。
  /// 此场景可以保持统一的音频模式，不会有音量突变的听感；最大程度地消除回声，使通话清晰度达到最优。
  /// 使用蓝牙耳机时，能够使用蓝牙耳机上自带的麦克风进行音频采集。
  /// 但是，此场景会压低使用媒体音量进行播放的其他音频的音量，且音质会变差。
  communication,

  /// 纯媒体场景。一般不建议使用。
  ///
  /// 此场景下，无论客户端音频采集播放设备和采集播放状态，全程使用媒体音量。
  /// 外放通话时，可能出现回声和啸叫，请联系技术支持人员。
  media,

  /// 游戏媒体场景。
  ///
  /// 此场景下，蓝牙耳机使用通话音量，其它设备使用媒体音量。
  /// 若外放通话且无游戏音效消除优化时音质不理想，请联系技术支持人员。
  gameStreaming
}

/// 变声特效类型
enum VoiceChangerType {
  /// 原声，无特效
  original,

  /// 巨人
  giant,

  /// 花栗鼠
  chipmunk,

  /// 小黄人
  minions,

  /// 颤音
  vibrato,

  /// 机器人
  robot,
}

/// 混响特效类型
enum VoiceReverbType {
  /// 原声，无特效
  original,

  /// 回声
  echo,

  /// 演唱会
  concert,

  /// 空灵
  ethereal,

  /// KTV
  ktv,

  /// 录音棚
  studio,
}

/// 音频混音文件播放状态
enum AudioMixingState {
  /// 混音已加载
  preloaded,

  /// 混音正在播放
  playing,

  /// 混音暂停
  paused,

  /// 混音停止
  stopped,

  /// 混音播放失败
  failed,

  /// 混音播放结束
  finished,

  /// 准备 PCM 混音
  pcmEnabled,

  /// PCM 混音播放结束
  pcmDisabled,
}

/// 音频错误码
enum AudioMixingError {
  /// 正常
  ok,

  /// 预加载失败，找不到混音文件或者文件长度超出 20s
  preloadFailed,

  /// 混音开启失败。找不到混音文件或者混音文件打开失败
  startFailed,

  /// 混音 ID 异常
  idNotFound,

  /// 设置混音文件的播放位置出错
  setPositionFailed,

  /// 音量参数不合法，仅支持将音量值设置在 `[0, 400]` 范围内
  invalidVolume,

  /// 播放的文件与预加载的文件不一致，请先使用 [RTCAudioMixingManager.unloadAudioMixing] 卸载文件
  loadConflict,

  /// 当前混音类型不支持
  idTypeNotMatch,

  /// 混音文件音调设置无效
  idTypeInvalidPitch,

  /// 混音文件音轨设置无效
  invalidAudioTrack,

  /// 混音文件正在启动中
  isStarting,

  /// 混音文件播放速度设置无效
  invalidPlaybackSpeed,
}

/// 是否开启耳返功能
enum EarMonitorMode {
  /// 不开启（默认）。
  off,

  /// 开启。
  on,
}

/// 语音识别服务鉴权方式
///
/// 详情请咨询语音识别服务相关人员
enum ASRAuthorizationType {
  /// Token 鉴权
  token,

  /// Signature 鉴权
  signature,
}

/// 使用自动语音识别服务所需校验信息
class RTCASRConfig {
  /// 用户 ID
  String uid;

  /// 访问令牌
  String accessToken;

  /// 私钥
  ///
  /// Signature 鉴权模式下不能为空，token 鉴权模式下为空。参看 [关于鉴权](https://bytedance.feishu.cn/docs/doccnMx9153dZEpfLX2I6BkFsMg#uh8x72)
  String secretKey;

  /// 鉴权方式
  ASRAuthorizationType authorizationType;

  /// 场景信息
  String cluster;

  /// 应用 ID
  String appId;

  RTCASRConfig({
    required this.uid,
    required this.accessToken,
    this.secretKey = '',
    this.authorizationType = ASRAuthorizationType.token,
    required this.cluster,
    required this.appId,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'accessToken': accessToken,
      'secretKey': secretKey,
      'authorizationType': authorizationType.value,
      'cluster': cluster,
      'appId': appId,
    };
  }
}

/// 混音播放类型
enum AudioMixingType {
  /// 仅本地播放
  playout,

  /// 仅远端播放
  publish,

  /// 本地和远端同时播放
  playoutAndPublish,
}

/// 混音配置
class AudioMixingConfig {
  /// 混音播放类型
  AudioMixingType type;

  /// 混音播放次数
  ///
  /// + playCount <= 0: 无限循环
  /// + playCount == 1: 播放一次（默认）
  /// + playCount > 1: 播放 playCount 次
  int playCount;

  /// 混音时音频文件播放进度条位置，参数为整数，单位为毫秒
  int position;

  /// 音频文件播放进度回调的时间间隔，参数为大于 0 的 10 的倍数，单位为毫秒，设置后 SDK 将按照设置的值触发 [RTCVideoEventHandler.onAudioMixingPlayingProgress] 回调，默认无回调。
  ///
  /// + 当传入的值不能被 10 整除时，则默认向上取整 10，如设为 52ms 时会默认调整为 60ms；
  /// + 当传入的值小于等于 0 时，不会触发进度回调。
  int callbackOnProgressInterval;

  AudioMixingConfig({
    this.type = AudioMixingType.playout,
    this.playCount = 0,
    this.position = 0,
    this.callbackOnProgressInterval = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.value,
      'playCount': playCount,
      'position': position,
      'callbackOnProgressInterval': callbackOnProgressInterval,
    };
  }
}

/// 混音播放声道类型
enum AudioMixingDualMonoMode {
  /// 与音频文件一致
  auto,

  /// 只能听到音频文件中左声道的音频
  left,

  /// 只能听到音频文件中右声道的音频
  right,

  /// 能同时听到音频文件中左右声道的音频
  mix,
}

/// 音频属性信息提示的相关配置
class AudioPropertiesConfig {
  /// 信息提示间隔，单位为毫秒
  ///
  /// + `<= 0`: 关闭信息提示
  /// + `(0,100]`: 开启信息提示，不合法的 interval 值，SDK 自动设置为 100ms
  /// + `> 100`: 开启信息提示，并将信息提示间隔设置为此值
  int interval;

  /// 是否开启音频频谱检测
  bool enableSpectrum;

  /// 是否开启人声检测（VAD）
  bool enableVad;

  AudioPropertiesConfig({
    this.interval = 100,
    this.enableSpectrum = false,
    this.enableVad = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'interval': interval,
      'enableSpectrum': enableSpectrum,
      'enableVad': enableVad,
    };
  }
}

/// 音频属性信息
class AudioPropertiesInfo {
  /// 线性音量，与原始音量呈线性关系，数值越大，音量越大。取值范围是：[0,255]。
  ///
  /// - [0, 25]: 无声
  /// - [26, 75]: 低音量
  /// - [76, 204]: 中音量
  /// - [205, 255]: 高音量
  final int? linearVolume;

  /// 非线性音量，由原始音量的对数值转化而来，因此在中低音量时更灵敏，可以用作 Active Speaker（房间内最活跃用户）的识别。取值范围是：[-127，0]，单位：dB。
  ///
  /// - [-127, -60]: 无声
  /// - [-59, -40]: 低音量
  /// - [-39, -20]: 中音量
  /// - [-19, 0]: 高音量
  final int? nonlinearVolume;

  /// 人声检测（VAD）结果
  ///
  /// - 1: 检测到人声
  /// - 0: 未检测到人声
  /// - -1: 未开启 VAD
  final int? vad;

  /// 频谱数组
  final List<double>? spectrum;

  const AudioPropertiesInfo({
    this.linearVolume,
    this.nonlinearVolume,
    this.vad,
    this.spectrum,
  });

  /// @nodoc
  factory AudioPropertiesInfo.fromMap(Map<dynamic, dynamic> map) {
    return AudioPropertiesInfo(
      linearVolume: map['linearVolume'],
      nonlinearVolume: map['nonlinearVolume'],
      vad: map['vad'],
      spectrum: List<double>.from(map['spectrum']),
    );
  }
}

/// 远端音频属性信息
class RemoteAudioPropertiesInfo {
  /// 远端流信息
  final RemoteStreamKey? streamKey;

  /// 音频属性信息
  final AudioPropertiesInfo? audioPropertiesInfo;

  const RemoteAudioPropertiesInfo({
    this.streamKey,
    this.audioPropertiesInfo,
  });

  /// @nodoc
  factory RemoteAudioPropertiesInfo.fromMap(Map<dynamic, dynamic> map) {
    return RemoteAudioPropertiesInfo(
      streamKey: RemoteStreamKey.fromMap(map['streamKey']),
      audioPropertiesInfo:
          AudioPropertiesInfo.fromMap(map['audioPropertiesInfo']),
    );
  }
}

/// 本地音频属性信息
class LocalAudioPropertiesInfo {
  /// 流属性，主流或屏幕共享流。
  final StreamIndex? streamIndex;

  /// 音频属性信息
  final AudioPropertiesInfo? audioPropertiesInfo;

  const LocalAudioPropertiesInfo({
    this.streamIndex,
    this.audioPropertiesInfo,
  });

  /// @nodoc
  factory LocalAudioPropertiesInfo.fromMap(Map<dynamic, dynamic> map) {
    return LocalAudioPropertiesInfo(
      streamIndex: (map['type'] as int).streamIndex,
      audioPropertiesInfo:
          AudioPropertiesInfo.fromMap(map['audioPropertiesInfo']),
    );
  }
}

/// 音质档位
enum AudioProfileType {
  /// 默认音质
  ///
  /// 服务器下发或客户端已设置的 [ChannelProfile] 的音质配置
  def,

  /// 流畅音质
  ///
  /// 单声道，采样率为 16 kHz，编码码率为 32 Kbps。
  /// 流畅优先、低功耗、低流量消耗，适用于大部分游戏场景，如小队语音、组队语音、国战语音等。
  fluent,

  /// 单声道标准音质
  ///
  /// 采样率为 24 kHz，编码码率为 48 Kbps。
  /// 适用于对音质有一定要求的场景，同时延时、功耗和流量消耗相对适中，适合教育场景和狼人杀等游戏。
  standard,

  /// 双声道音乐音质
  ///
  /// 采样率为 48 kHz，编码码率为 128 kbps。
  /// 超高音质，同时延时、功耗和流量消耗相对较大，适用于连麦 PK 等音乐场景。
  /// 游戏场景不建议使用。
  hd,

  /// 双声道标准音质
  ///
  /// 采样率为 48 KHz，编码码率最大值为 80 Kbps。
  standardStereo,

  /// 单声道音乐音质
  ///
  /// 采样率为 48 kHz，编码码率最大值为 64 Kbps。
  hdMono,
}

/// 本地用户在房间内的位置坐标
///
/// 需自行建立空间直角坐标系
class Position {
  /// x 坐标
  int x = 0;

  /// y 坐标
  int y = 0;

  /// z 坐标
  int z = 0;

  Position({
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      'z': z,
    };
  }
}

/// 朝向信息
class RTCOrientation {
  /// 朝向向量的 x 方向分量
  double x = 0;

  /// 朝向向量的 y 方向分量
  double y = 0;

  /// 朝向向量的 z 方向分量
  double z = 0;

  RTCOrientation({
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'x': x,
      'y': y,
      'z': z,
    };
  }
}

/// 用于确定朝向的正方向基准。
///
/// 默认的正方向和位置坐标系的三个正方向一致。
/// 如果不使用默认值，需保证三个向量两两垂直。
class HumanOrientation {
  /// 正前方朝向向量
  RTCOrientation forward = RTCOrientation();

  /// 正右方朝向向量
  RTCOrientation right = RTCOrientation();

  /// 正上方朝向向量
  RTCOrientation up = RTCOrientation();

  HumanOrientation.origin()
      : forward = RTCOrientation(x: 1, y: 0, z: 0),
        right = RTCOrientation(x: 0, y: 1, z: 0),
        up = RTCOrientation(x: 0, y: 0, z: 1);

  HumanOrientation({
    required this.forward,
    required this.right,
    required this.up,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'forward': forward.toMap(),
      'right': right.toMap(),
      'up': up.toMap(),
    };
  }
}

/// 空间音频音量随距离衰减模式
enum AttenuationType {
  /// 不随距离变动衰减
  none,

  /// 线性衰减，音量随距离增大而线性减小
  linear,

  /// 指数型衰减，音量随距离增大进行指数衰减
  exponential,
}

/// 本地用户能收听到、且具有衰减效果的音频接收范围
class ReceiveRange {
  /// 最小距离值，须 ≥ 0，但 ≤ max
  ///
  /// 小于该值的范围内没有范围语音效果，即收听到的音频音量相同。
  int min;

  /// 最大距离值，该值须 > 0 且 ≥ min
  ///
  /// 当收听者和声源距离处于 [min, max) 之间时，收听到的音量根据距离呈衰减效果。
  /// 超出该值范围的音频将无法收听到。
  int max;

  ReceiveRange({
    this.min = 0,
    this.max = 1,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'min': min,
      'max': max,
    };
  }
}

/// 范围语音流信息
class RangeAudioInfo {
  /// 远端音频发布用户 ID
  final String? uid;

  /// 本地用户听到该远端音频发布用户的衰减系数，范围 [0,100]，数值为 0 时表示远端用户音频音量为 0
  final int? factor;

  const RangeAudioInfo({
    this.uid,
    this.factor,
  });

  /// @nodoc
  factory RangeAudioInfo.fromMap(Map<dynamic, dynamic> map) {
    return RangeAudioInfo(
      uid: map['uid'],
      factor: map['factor'],
    );
  }
}
