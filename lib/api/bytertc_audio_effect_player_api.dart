// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';
import 'bytertc_video_api.dart';

/// 混音配置
class AudioEffectPlayerConfig {
  /// 混音播放类型。
  final AudioMixingType type;

  /// 混音播放次数。
  /// + play_count <= 0：无限循环
  /// + play_count == 1：播放一次（默认）
  /// + play_count > 1：播放 play_count 次
  final int playCount;

  /// 混音起始位置。默认值为 0，单位为毫秒。
  final int startPos;

  /// 与音乐文件原始音调相比的升高/降低值，取值范围为 `[-12，12]`，默认值为 0。每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调。
  final int pitch;

  /// @nodoc
  const AudioEffectPlayerConfig({
    this.type = AudioMixingType.playoutAndPublish,
    this.playCount = 1,
    this.startPos = 0,
    this.pitch = 0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.index,
      'playCount': playCount,
      'startPos': startPos,
      'pitch': pitch,
    };
  }
}

/// [effectId]：[RTCAudioEffectPlayer] 的 ID。通过 [RTCVideo.getAudioEffectPlayer] 设置。
///
/// [state]： 混音状态。
///
/// [error]： 错误码。
typedef OnAudioEffectPlayerStateChangedType = void Function(
    int effectId, PlayerState state, PlayerError error);

/// [RTCAudioEffectPlayer] 对应的回调句柄。你必须调用 [RTCAudioEffectPlayer.setEventHandler] 完成设置后，才能收到对应回调。
///
/// v3.54 新增。
class RTCAudioEffectPlayerEventHandler {
  /// 播放状态改变时回调。
  OnAudioEffectPlayerStateChangedType? onAudioEffectPlayerStateChanged;

  /// @nodoc
  RTCAudioEffectPlayerEventHandler({
    this.onAudioEffectPlayerStateChanged,
  });
}

/// 音效播放器。
///
/// v3.54 新增。
///
/// 调用 [RTCAudioEffectPlayer.setEventHandler] 设置回调句柄以获取相关回调。
abstract class RTCAudioEffectPlayer {
  /// 开始播放音效文件。<br>
  /// 可以通过传入不同的 effectId 和 filePath 多次调用本方法，以实现同时播放多个音效文件，实现音效叠加。
  ///
  /// [effectId]：音效 ID。用于标识音效，请保证音效 ID 唯一性。<br>
  /// 如果使用相同的 ID 重复调用本方法后，上一个音效会停止，下一个音效开始，并收到 [RTCAudioEffectPlayerEventHandler.onAudioEffectPlayerStateChanged]。
  ///
  /// [filePath]：音效文件路径。<br>
  /// 支持在线文件的 URL、本地文件的 URI、本地文件的绝对路径或以 `/assets/` 开头的本地文件路径。对于在线文件的 URL，仅支持 https 协议。<br>
  /// 推荐的音效文件采样率：8KHz、16KHz、22.05KHz、44.1KHz、48KHz。<br>
  /// 不同平台支持的本地音效文件格式：
  /// <table border>
  ///    <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th><th>ts</th><th>wma</th></tr>
  ///    <tr><td>Android</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td></tr>
  ///    <tr><td>iOS/macOS</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>Windows</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td></tr>
  /// </table>
  /// 不同平台支持的在线音效文件格式：
  /// <table border>
  ///    <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th><th>ts</th><th>wma</th></tr>
  ///    <tr><td>Android</td><td>Y</td><td></td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>iOS/macOS</td><td>Y</td><td></td><td>Y</td><td>Y</td><td></td><td>Y</td><td></td><td></td><td></td></tr>
  ///    <tr><td>Windows</td><td>Y</td><td></td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td></td><td>Y</td><td>Y</td></tr>
  /// </table>
  ///
  /// [config]：音效配置，详见 [AudioEffectPlayerConfig]。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 如果已经通过 [RTCAudioEffectPlayer.preload] 将文件加载至内存，确保此处的 ID 与 [RTCAudioEffectPlayer.preload] 设置的 ID 相同。
  /// + 开始播放音效文件后，可以调用 [RTCAudioEffectPlayer.stop] 方法停止播放音效文件。
  Future<int?> start(
    int effectId, {
    required String filePath,
    AudioEffectPlayerConfig config = const AudioEffectPlayerConfig(),
  });

  /// 停止播放音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 调用 [RTCAudioEffectPlayer.start] 方法开始播放音效文件后，可以调用本方法停止播放音效文件。
  /// + 调用本方法停止播放音效文件后，该音效文件会被自动卸载。
  Future<int?> stop(int effectId);

  /// 停止播放所有音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 调用 [RTCAudioEffectPlayer.start] 方法开始播放音效文件后，可以调用本方法停止播放所有音效文件。
  /// + 调用本方法停止播放所有音效文件后，该音效文件会被自动卸载。
  Future<int?> stopAll();

  /// 预加载指定音乐文件到内存中，以避免频繁播放同一文件时的重复加载，减少 CPU 占用。
  ///
  /// [effectId]：音效 ID。用于标识音效，请保证音效 ID 唯一性。<br>
  /// 如果使用相同的 ID 重复调用本方法，后一次会覆盖前一次。<br>
  /// 如果先调用 [RTCAudioEffectPlayer.start]，再使用相同的 ID 调用本方法 ，会收到回调 [RTCAudioEffectPlayerEventHandler.onAudioEffectPlayerStateChanged]，通知前一个音效停止，然后加载下一个音效。<br>
  /// 调用本方法预加载 A.mp3 后，如果需要使用相同的 ID 调用 [RTCAudioEffectPlayer.start] 播放 B.mp3，请先调用 [RTCAudioEffectPlayer.unload] 卸载 A.mp3 ，否则会报错 "loadConflict"。
  ///
  /// [filePath]：音效文件路径。支持在线文件的 URL、本地文件的 URI、本地文件的绝对路径或以 `/assets/` 开头的本地文件路径。对于在线文件的 URL，仅支持 https 协议。<br>
  /// 预加载的文件长度不得超过 20s。<br>
  /// 不同平台支持的音效文件格式和 [RTCAudioEffectPlayer.start] 一致。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 本方法只是预加载指定音效文件，只有调用 [RTCAudioEffectPlayer.start] 方法才开始播放指定音效文件。
  /// + 调用本方法预加载的指定音效文件可以通过 [RTCAudioEffectPlayer.unload] 卸载。
  Future<int?> preload(
    int effectId, {
    required String filePath,
  });

  /// 卸载指定音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 仅在调用 [RTCAudioEffectPlayer.start] 或 [RTCAudioEffectPlayer.preload] 后调用此接口。
  Future<int?> unload(int effectId);

  /// 卸载所有音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  Future<int?> unloadAll();

  /// 暂停播放音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 调用 [RTCAudioEffectPlayer.start] 方法开始播放音效文件后，可以通过调用本方法暂停播放音效文件。
  /// + 调用本方法暂停播放音效文件后，可调用 [RTCAudioEffectPlayer.resume] 方法恢复播放。
  Future<int?> pause(int effectId);

  /// 暂停播放所有音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 调用 [RTCAudioEffectPlayer.start] 方法开始播放音效文件后，可以通过调用本方法暂停播放所有音效文件。
  /// + 调用本方法暂停播放所有音效文件后，可调用 [RTCAudioEffectPlayer.resumeAll] 方法恢复所有播放。
  Future<int?> pauseAll();

  /// 恢复播放音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// 调用 [RTCAudioEffectPlayer.pause] 方法暂停播放音效文件后，可以通过调用本方法恢复播放。
  Future<int?> resume(int effectId);

  /// 恢复播放所有音效文件。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// 调用 [RTCAudioEffectPlayer.pauseAll] 方法暂停所有正在播放音效文件后，可以通过调用本方法恢复播放。
  Future<int?> resumeAll();

  /// 设置音效文件的起始播放位置。
  ///
  /// [position]：音效文件起始播放位置，单位为毫秒。<br>
  /// 你可以通过 [RTCAudioEffectPlayer.getDuration] 获取音效文件总时长，position 的值应小于音效文件总时长。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// + 在播放在线文件时，调用此接口可能造成播放延迟的现象。
  /// + 仅在调用 [RTCAudioEffectPlayer.start] 后调用此接口。
  Future<int?> setPosition(
    int effectId, {
    required int position,
  });

  /// 获取音效文件播放进度。
  ///
  /// 返回值：
  /// + `>0`：成功, 音效文件播放进度，单位为毫秒。
  /// + `<0`：失败
  ///
  /// 注意：
  /// + 在播放在线文件时，调用此接口可能造成播放延迟的现象。
  /// + 仅在调用 [RTCAudioEffectPlayer.start] 后调用此接口。
  Future<int?> getPosition(int effectId);

  /// 调节指定音效的音量大小。
  ///
  /// [effectId] 音效 ID
  /// volume 播放音量相对原音量的比值。单位为 %。范围为 `[0, 400]`，建议范围是 `[0, 100]`，默认值为 100。自带溢出保护。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// 仅在调用 [RTCAudioEffectPlayer.start] 后调用此接口。
  Future<int?> setVolume(
    int effectId, {
    required int volume,
  });

  /// 设置所有音效的音量大小。
  ///
  /// [volume]：播放音量相对原音量的比值。单位为 %。范围为 `[0, 400]`，建议范围是 `[0, 100]`，默认值为 100。自带溢出保护。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败。
  ///
  /// 注意：
  /// 该接口的优先级低于 [RTCAudioEffectPlayer.setVolume]，即通过 [RTCAudioEffectPlayer.setVolume] 单独设置了音量的音效 ID，不受该接口设置的影响。
  Future<int?> setVolumeAll(int volume);

  /// 获取当前音量。
  ///
  /// 返回值：
  /// + `>0`：成功, 当前音量值。
  /// + `<0`：失败。
  ///
  /// 仅在调用 [RTCAudioEffectPlayer.start] 后调用此接口。
  Future<int?> getVolume(int effectId);

  /// 获取音效文件时长。
  ///
  /// 返回值：
  /// + `>0`：成功, 音效文件时长，单位为毫秒。
  /// + `<0`：失败。
  ///
  /// 仅在调用 [RTCAudioEffectPlayer.start] 后调用此接口。
  Future<int?> getDuration(int effectId);

  /// 设置回调句柄。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  void setEventHandler(RTCAudioEffectPlayerEventHandler? handler);
}
