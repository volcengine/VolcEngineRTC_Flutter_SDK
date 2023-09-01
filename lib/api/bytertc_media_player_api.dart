// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';
import 'bytertc_video_api.dart';

/// 混音配置
class MediaPlayerConfig {
  /// 混音播放类型。
  final AudioMixingType type;

  /// 混音播放次数
  /// + play_count <= 0: 无限循环
  /// + play_count == 1: 播放一次（默认）
  /// + play_count > 1: 播放 play_count 次
  final int playCount;

  /// 混音起始位置。默认值为 0，单位为毫秒。
  final int startPos;

  /// 设置音频文件混音时，收到 [RTCMediaPlayerEventHandler.onMediaPlayerPlayingProgress] 的间隔。单位毫秒。
  /// + interval > 0 时，触发回调。实际间隔是 `10*(mod(10)+1)`。
  /// + interval <= 0 时，不会触发回调。
  final int callbackOnProgressInterval;

  /// 在采集音频数据时，附带本地混音文件播放进度的时间戳。启用此功能会提升远端人声和音频文件混音播放时的同步效果。
  /// + 仅在单个音频文件混音时使用有效；
  /// + `true` 时开启此功能，`false` 时关闭此功能，默认为关闭。
  final bool syncProgressToRecordFrame;

  /// 是否自动播放。如果不自动播放，调用 [RTCMediaPlayer.start] 播放音乐文件。
  final bool autoPlay;

  /// @nodoc
  const MediaPlayerConfig({
    this.type = AudioMixingType.playoutAndPublish,
    this.playCount = 1,
    this.startPos = 0,
    this.callbackOnProgressInterval = 0,
    this.syncProgressToRecordFrame = false,
    this.autoPlay = true,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.index,
      'playCount': playCount,
      'startPos': startPos,
      'callbackOnProgressInterval': callbackOnProgressInterval,
      'syncProgressToRecordFrame': syncProgressToRecordFrame,
      'autoPlay': autoPlay,
    };
  }
}

/// [playerId]：[RTCMediaPlayer] 的 ID。通过 [RTCVideo.getMediaPlayer] 设置。
///
/// [state]：混音状态。
///
/// [error]：混音错误码。
typedef OnMediaPlayerStateChangedType = void Function(
    int playerId, PlayerState state, PlayerError error);

/// [playerId]：[RTCMediaPlayer] 的 ID。通过 [RTCVideo.getMediaPlayer] 设置。
///
/// [progress]：进度。单位 ms。
typedef OnMediaPlayerPlayingProgressType = void Function(
    int playerId, int progress);

/// [RTCMediaPlayer] 对应的回调句柄。你必须调用 [RTCMediaPlayer.setEventHandler] 完成设置后，才能收到对应回调。
class RTCMediaPlayerEventHandler {
  /// 播放状态改变时回调。
  OnMediaPlayerStateChangedType? onMediaPlayerStateChanged;

  /// 播放进度周期性回调。回调周期通过 [RTCMediaPlayer.setProgressInterval] 设置。
  OnMediaPlayerPlayingProgressType? onMediaPlayerPlayingProgress;

  /// @nodoc
  RTCMediaPlayerEventHandler({
    this.onMediaPlayerStateChanged,
    this.onMediaPlayerPlayingProgress,
  });
}

/// 音乐播放器。
///
/// 调用 [RTCMediaPlayer.setEventHandler] 设置回调句柄以获取相关回调。
///
/// v3.54.1 新增
abstract class RTCMediaPlayer {
  /// 打开音乐文件。<br>
  /// 一个播放器实例仅能够同时打开一个音乐文件。如果需要同时打开多个音乐文件，请创建多个音乐播放器实例。
  ///
  /// [filePath]：音乐文件路径。<br>
  /// 支持在线文件的 URL、本地文件的 URI、本地文件的绝对路径或以 `/assets/` 开头的本地文件路径。对于在线文件的 URL，仅支持 https 协议。<br>
  /// 推荐的采样率：8KHz、16KHz、22.05KHz、44.1KHz、48KHz。<br>
  /// 不同平台支持的本地文件格式:
  /// <table border>
  ///    <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th><th>ts</th><th>wma</th></tr>
  ///    <tr><td>Android</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td></tr>
  ///    <tr><td>iOS/macOS</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>Windows</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td></tr>
  /// </table>
  /// 不同平台支持的在线文件格式:
  /// <table border>
  ///    <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th><th>ts</th><th>wma</th></tr>
  ///    <tr><td>Android</td><td>Y</td><td></td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>iOS/macOS</td><td>Y</td><td></td><td>Y</td><td>Y</td><td></td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>Windows</td><td>Y</td><td></td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td></tr>
  /// </table>
  ///
  /// [config]：播放配置。
  Future<int?> open({
    required String filePath,
    MediaPlayerConfig config = const MediaPlayerConfig(),
  });

  /// 播放音乐。你仅需要在调用 [RTCMediaPlayer.open]，且未开启自动播放时，调用此方法。
  ///
  /// 调用本方法播放音频文件后，可调用 [RTCMediaPlayer.stop] 方法暂停播放。
  Future<int?> start();

  /// 调用 [RTCMediaPlayer.open] 或 [RTCMediaPlayer.start] 开始播放后，可以调用本方法停止。
  Future<int?> stop();

  /// 调用 [RTCMediaPlayer.open] 或 [RTCMediaPlayer.start] 开始播放音频文件后，调用本方法暂停播放。
  ///
  /// 调用本方法暂停播放后，可调用 [RTCMediaPlayer.resume] 恢复播放。
  Future<int?> pause();

  /// 调用 [RTCMediaPlayer.pause] 暂停音频播放后，调用本方法恢复播放。
  Future<int?> resume();

  /// 调节指定混音的音量大小。
  ///
  /// [volume]：播放音量相对原音量的比值。单位为 %。范围为 `[0, 400]`，建议范围是 `[0, 100]`。带溢出保护。
  ///
  /// [type]：播放类型，标识本地/远端播放。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setVolume({
    required int volume,
    AudioMixingType type = AudioMixingType.playoutAndPublish,
  });

  /// 获取当前音量。
  ///
  /// 返回值：
  /// + >0：成功, 当前音量值。  <br>
  /// + < 0：失败
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> getVolume([
    AudioMixingType type = AudioMixingType.playoutAndPublish,
  ]);

  /// 获取音乐文件时长。
  ///
  /// 返回值：
  /// + `>0`：成功, 音乐文件时长，单位为毫秒。
  /// + `<0`：失败
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> getTotalDuration();

  /// 获取混音音乐文件的实际播放时长，单位为毫秒。
  ///
  /// 返回值：
  /// + `>0`：实际播放时长。
  /// + `<0`：失败。
  ///
  /// 注意：
  /// + 实际播放时长指的是歌曲不受停止、跳转、倍速、卡顿影响的播放时长。例如，若歌曲正常播放到 1:30 时停止播放 30s 或跳转进度到 2:00, 随后继续正常播放 2分钟，则实际播放时长为 3分30秒。
  /// + 仅在音频播放进行状态时，调用此方法。
  Future<int?> getPlaybackDuration();

  /// 获取音乐文件播放进度。
  ///
  /// 返回值：
  /// + `>0`：成功, 音乐文件播放进度，单位为毫秒；
  /// + `<0`：失败。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> getPosition();

  /// 开启变调功能，多用于 K 歌场景。
  ///
  /// [pitch]：与音乐文件原始音调相比的升高/降低值，取值范围为 `[-12，12]`，默认值为 0。每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setAudioPitch(int pitch);

  /// 设置音乐文件的起始播放位置。
  ///
  /// [position]：音乐文件起始播放位置，单位为毫秒。  <br>
  /// 你可以通过 [RTCMediaPlayer.getTotalDuration] 获取音乐文件总时长，position 的值应小于音乐文件总时长。
  ///
  /// 在播放在线文件时，调用此接口可能造成播放延迟的现象。
  Future<int?> setPosition(int position);

  /// 设置当前音乐文件的声道模式。
  ///
  /// [mode]：声道模式。默认的声道模式和源文件一致。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setAudioDualMonoMode(AudioMixingDualMonoMode mode);

  /// 获取当前音乐文件的音轨数。
  ///
  /// 返回值：
  /// + `>= 0`：成功，返回当前音乐文件的音轨数；
  /// + `<0`：方法调用失败。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> getAudioTrackCount();

  /// 指定当前音乐文件的播放音轨。
  ///
  /// [index]：指定的播放音轨，从 0 开始，取值范围为 `[0, getAudioTrackCount()-1]`。<br>
  /// 设置的参数值需要小于 [RTCMediaPlayer.getAudioTrackCount] 的返回值。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> selectAudioTrack(int index);

  /// 设置播放速度。
  ///
  /// [speed]：播放速度与原始文件速度的比例，单位：%，取值范围为 `[50,200]`，默认值为 100。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setPlaybackSpeed(int speed);

  /// 设置音频文件混音时，收到 [RTCMediaPlayerEventHandler.onMediaPlayerPlayingProgress] 的间隔。
  ///
  /// [interval]：时间间隔，单位毫秒。
  /// + interval > 0 时，触发回调。实际间隔是 `10*(mod(10)+1)`。
  /// + interval <= 0 时，不会触发回调。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setProgressInterval(int interval);

  /// 如果你需要使用 [RTCVideo.enableVocalInstrumentBalance] 对音频文件设置音量均衡，你必须通过此接口传入其原始响度。
  ///
  /// [loudness]：原始响度，单位：lufs，取值范围为 `[-70.0, 0.0]`。<br>
  /// 当设置的值小于 -70.0lufs 时，则默认调整为 -70.0lufs，大于 0.0lufs 时，则不对该响度做音量均衡处理。默认值为 1.0lufs，即不做处理。
  ///
  /// 仅在音频播放进行状态时，调用此方法。
  Future<int?> setLoudness(double loudness);

  /// 设置回调句柄。
  void setEventHandler(RTCMediaPlayerEventHandler? handler);
}
