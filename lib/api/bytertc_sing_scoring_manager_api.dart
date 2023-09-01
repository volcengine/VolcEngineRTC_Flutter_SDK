// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_audio_defines.dart';
import 'bytertc_media_player_api.dart';

/// K 歌打分维度。
enum MulDimSingScoringMode {
  /// 按照音高进行评分。
  note,
}

/// 实时评分信息。
class SingScoringRealtimeInfo {
  /// 当前播放进度。
  final int currentPosition;

  /// 演唱者的音高。
  final int userPitch;

  /// 标准音高。
  final int standardPitch;

  /// 歌词分句索引。
  final int sentenceIndex;

  /// 上一句歌词的评分。
  final int sentenceScore;

  /// 当前演唱的累计分数。
  final int totalScore;

  /// 当前演唱的平均分数。
  final int averageScore;

  /// @nodoc
  const SingScoringRealtimeInfo({
    required this.currentPosition,
    required this.userPitch,
    required this.standardPitch,
    required this.sentenceIndex,
    required this.sentenceScore,
    required this.totalScore,
    required this.averageScore,
  });

  /// @nodoc
  factory SingScoringRealtimeInfo.fromMap(Map<dynamic, dynamic> map) {
    return SingScoringRealtimeInfo(
      currentPosition: map['currentPosition'],
      userPitch: map['userPitch'],
      standardPitch: map['standardPitch'],
      sentenceIndex: map['sentenceIndex'],
      sentenceScore: map['sentenceScore'],
      totalScore: map['totalScore'],
      averageScore: map['averageScore'],
    );
  }
}

/// 标准音高数据数组。
class StandardPitchInfo {
  /// 开始时间，单位 ms。
  final int startTime;

  /// 持续时间，单位 ms。
  final int duration;

  /// 音高。
  final int pitch;

  /// @nodoc
  const StandardPitchInfo({
    required this.startTime,
    required this.duration,
    required this.pitch,
  });

  /// @nodoc
  factory StandardPitchInfo.fromMap(Map<dynamic, dynamic> map) {
    return StandardPitchInfo(
      startTime: map['startTime'],
      duration: map['duration'],
      pitch: map['pitch'],
    );
  }
}

/// K 歌评分配置。
class SingScoringConfig {
  /// 音频采样率。仅支持 44100 Hz、48000 Hz。
  AudioSampleRate sampleRate;

  /// 打分维度，详见 [MulDimSingScoringMode]。
  MulDimSingScoringMode mode;

  /// 歌词文件路径。打分功能仅支持 KRC 歌词文件。
  String lyricsFilepath;

  /// 歌曲 midi 文件路径。
  String midiFilepath;

  /// @nodoc
  SingScoringConfig({
    required this.sampleRate,
    this.mode = MulDimSingScoringMode.note,
    required this.lyricsFilepath,
    required this.midiFilepath,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sampleRate': sampleRate.value,
      'mode': mode.index,
      'lyricsFilepath': lyricsFilepath,
      'midiFilepath': midiFilepath,
    };
  }
}

/// [info]：实时评分信息。详见 [SingScoringRealtimeInfo]。
typedef OnCurrentScoringInfoType = void Function(SingScoringRealtimeInfo? info);

/// K 歌评分事件回调类。
class RTCSingScoringEventHandler {
  /// 实时评分信息回调。
  ///
  /// 调用 [RTCSingScoringManager.startSingScoring] 后，会收到该回调。
  OnCurrentScoringInfoType? onCurrentScoringInfo;

  /// @nodoc
  RTCSingScoringEventHandler({
    this.onCurrentScoringInfo,
  });
}

/// K 歌评分管理接口。
abstract class RTCSingScoringManager {
  /// 初始化 K 歌评分。
  ///
  /// [singScoringAppKey]：K 歌评分 AppKey，用于鉴权验证 K 歌功能是否开通。
  ///
  /// [singScoringToken]：K 歌评分 Token，用于鉴权验证 K 歌功能是否开通。
  ///
  /// [handler]：K 歌评分事件回调类。
  ///
  /// 返回值：
  /// + 0：配置成功。
  /// + -1：接口调用失败。
  /// + -2：未集成 K 歌评分模块。
  /// + >0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6489/148198)。
  ///
  /// 注意：输入正确的鉴权信息才可以使用 K 歌评分相关的功能，鉴权方式为离线鉴权，根据包名（bundleID）绑定 AppKey 及 Token，K 歌评分密钥请联系技术支持人员申请。
  Future<int?> initSingScoring({
    required String singScoringAppKey,
    required String singScoringToken,
    RTCSingScoringEventHandler? handler,
  });

  /// 设置 K 歌评分参数。
  ///
  /// [config]：K 歌评分的各项参数。
  ///
  /// 方法调用结果：
  /// + 0：配置成功。
  /// + -1：接口调用失败。
  /// + -2：未集成 K 歌评分模块。
  /// + >0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6489/148198)。
  Future<int?> setSingScoringConfig(SingScoringConfig config);

  ///  获取标准音高数据。
  ///
  /// [midiFilepath]：歌曲 midi 文件路径。
  ///
  /// 返回值：[StandardPitchInfo] 标准音高数据数组。
  ///
  /// 注意：请保证此接口传入的 midi 文件路径与 [RTCSingScoringManager.setSingScoringConfig] 接口中传入的路径一致。
  Future<List<StandardPitchInfo>?> getStandardPitchInfo(String midiFilepath);

  /// 开始 K 歌评分。
  ///
  /// [position]：开始评分时，音乐的播放进度，单位：ms。
  ///
  /// [scoringInfoInterval]：实时回调的时间间隔，单位：ms；默认 50 ms。最低间隔为 20 ms。
  ///
  /// 返回值：
  /// + 0：配置成功。
  /// + -1：接口调用失败。
  /// + -2：未集成 K 歌评分模块。
  /// + >0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6489/148198)。
  ///
  /// 注意：
  /// + 在调用 [RTCSingScoringManager.initSingScoring] 初始化 K 歌评分功能后调用该接口。
  /// + 调用该接口后，将会根据设置的回调时间间隔，收到评分结果 [RTCSingScoringEventHandler.onCurrentScoringInfo] 回调。
  /// + 如果调用 [RTCMediaPlayer.start] 接口播放音频文件，请在收到 [RTCMediaPlayerEventHandler.onMediaPlayerStateChanged] (playing) 之后调用此接口。
  Future<int?> startSingScoring({
    int position,
    int scoringInfoInterval,
  });

  /// 停止 K 歌评分。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  Future<int?> stopSingScoring();

  /// 获取上一句的演唱评分。
  ///
  /// 调用 [RTCSingScoringManager.startSingScoring] 开始评分后可以调用该接口。
  ///
  /// 返回值：
  /// + `<0`：获取评分失败。
  /// + `>=0`：上一句歌词的演唱评分。
  Future<int?> getLastSentenceScore();

  /// 获取当前演唱总分。
  ///
  /// 调用 [RTCSingScoringManager.startSingScoring] 开始评分后可以调用该接口。
  ///
  /// 返回值：
  /// + <0：获取总分失败。
  /// + >=0：当前演唱总分。
  Future<int?> getTotalScore();

  /// 获取当前演唱歌曲的平均分。
  ///
  /// 返回值：
  /// + `<0`：获取平均分失败。
  /// + `>=0`：当前演唱平均分。
  Future<int?> getAverageScore();
}
