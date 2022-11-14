// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';

/// 混音管理类
///
/// 在 iOS 端使用混音功能时，你必须通过 [setActive:withOptions:error:](https://developer.apple.com/documentation/avfaudio/avaudiosession/1616627-setactive?language=objc) 激活应用的 audio session。直到彻底退出混音功能后，才可以关闭 audio session。
abstract class RTCAudioMixingManager {
  /// 开始播放音乐文件及混音
  ///
  /// [mixId] 区分混音任务的唯一标志。<br>
  /// 如果已经通过 [RTCAudioMixingManager.preloadAudioMixing] 预加载音乐文件，请确保两者 ID 相同。<br>
  /// 如果使用相同的 ID 重复调用本方法，前一次混音会停止，后一次混音开始，且会收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  ///
  /// [filePath] 需要混音的本地文件的绝对路径。<br>
  /// 支持在线文件的 URL、本地文件的 URI、本地文件的绝对路径或以 `/assets/` 开头的本地文件路径。对于在线文件的 URL，仅支持 https 协议。
  /// 推荐的音频文件采样率：8KHz、16KHz、22.05KHz、44.1KHz、48KHz。
  /// 不同平台支持的音乐文件格式如下:
  /// <table border>
  /// <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th>
  /// <tr><td>Android</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td>
  /// <tr><td>iOS</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td>
  /// </table>
  /// <br>
  ///
  /// 注意：
  /// + 可以通过传入不同的 mixId 和 filePath 多次调用本方法，以同时播放多个混音文件，实现混音叠加。
  /// + 调用本方法成功播放音乐文件后，会收到 [RTCVideoEventHandler.onAudioMixingStateChanged] 提示当前的混音状态。
  /// + 开始播放音乐文件及混音后，可以调用 [RTCAudioMixingManager.stopAudioMixing] 停止播放音乐文件。
  Future<void> startAudioMixing({
    required int mixId,
    required String filePath,
    required AudioMixingConfig config,
  });

  /// 停止指定的混音任务
  ///
  /// 注意：
  /// + 调用本方法停止播放音乐文件后，会收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  /// + 调用本方法停止播放音乐文件后，该音乐文件会被自动卸载。
  Future<void> stopAudioMixing(int mixId);

  /// 暂停指定的混音任务
  ///
  /// 注意：
  /// + 调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件及混音后，可以调用本方法暂停混音任务。
  /// + 可以调用 [RTCAudioMixingManager.resumeAudioMixing] 恢复混音任务。
  /// + 调用本方法暂停混音任务后，会收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  Future<void> pauseAudioMixing(int mixId);

  /// 恢复指定的混音任务
  ///
  /// 注意：
  /// + 调用 [RTCAudioMixingManager.pauseAudioMixing] 暂停混音任务后，可以通过调用此方法恢复。
  /// + 调用本方法恢复混音任务后，会收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  Future<void> resumeAudioMixing(int mixId);

  /// 预加载指定音乐文件到内存中，以避免频繁播放同一文件时的重复加载，减少 CPU 占用。
  ///
  /// 如果先调用 [RTCAudioMixingManager.startAudioMixing]，再使用相同的 ID 调用本方法，会先停止当前混音任务，然后加载混音文件。<br>
  /// 调用本方法预加载 A.mp3 后，如果需要使用相同的 ID 播放 B.mp3，请先调用 [RTCAudioMixingManager.unloadAudioMixing] 卸载 A.mp3。
  ///
  /// [filePath] 需要混音的本地文件的绝对路径。<br>
  /// 支持在线文件的 URL、本地文件的 URI、本地文件的绝对路径或以 `/assets/` 开头的本地文件路径。对于在线文件的 URL，仅支持 https 协议。<br>
  /// 不同平台支持的音乐文件格式如下:
  /// <table border>
  /// <tr><th></th><th>mp3</th><th>mp4</th><th>aac</th><th>m4a</th><th>3gp</th><th>wav</th><th>ogg</th></tr>
  /// <tr><td>Android</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td></tr>
  /// <tr><td>iOS</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td><td>Y</td></tr>
  /// </table>
  ///
  /// 如果音乐文件长度超过 20s，会回调加载失败，收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  ///
  /// 注意：
  /// + 调用本方法预加载音乐文件后，会收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  /// + 调用本方法预加载的指定音乐文件可以通过 [RTCAudioMixingManager.unloadAudioMixing] 卸载。
  Future<void> preloadAudioMixing({
    required int mixId,
    required String filePath,
  });

  /// 卸载指定音乐文件
  ///
  /// 不论音乐文件是否播放，调用本方法卸载该文件后，混音任务会停止，并收到 [RTCVideoEventHandler.onAudioMixingStateChanged]。
  Future<void> unloadAudioMixing(int mixId);

  /// 调节音乐文件在本地和远端播放的音量大小
  ///
  /// [volume] 是播放音量和原始音量的比值，取值范围是 `[0, 400]`，单位是 %。<br>
  /// 为保证更好的音量，建议设置为 `[0, 100]`。
  /// + 0：静音  <br>
  /// + 100：原始音量（默认值）  <br>
  /// + 400: 最大可调音量 (自带溢出保护)
  ///
  /// 注意：调用本方法设置音量前，请先调用 [RTCAudioMixingManager.preloadAudioMixing] 或 [RTCAudioMixingManager.startAudioMixing]
  Future<void> setAudioMixingVolume({
    required int mixId,
    required int volume,
    required AudioMixingType type,
  });

  /// 获取音乐文件时长 (ms)
  ///
  /// 返回值：接口调用结果
  /// + `>0`：成功，返回音乐文件时长；
  /// + `<0`：失败
  ///
  /// 注意：调用本方法获取音乐文件时长前，需要先调用 [RTCAudioMixingManager.preloadAudioMixing] 或 [RTCAudioMixingManager.startAudioMixing]
  Future<int?> getAudioMixingDuration(int mixId);

  /// 获取音乐文件播放进度 (ms)
  ///
  /// 返回值：接口调用结果
  /// + `>0`：成功，返回音乐文件播放进度；
  /// + `<0`：失败
  ///
  /// 注意：调用本方法获取音乐文件播放进度前，需要先调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件。
  Future<int?> getAudioMixingCurrentPosition(int mixId);

  /// 设置音乐文件的起始播放位置 (ms)
  ///
  /// [position] 音乐文件起始播放位置。你可以通过 [RTCAudioMixingManager.getAudioMixingDuration] 获取音乐文件的总时长，position 的值应小于音乐文件总时长。
  ///
  /// 注意：调用本方法设置音乐文件的播放位置前，需要先调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件。
  Future<void> setAudioMixingPosition({
    required int mixId,
    required int position,
  });

  /// 设置当前音乐文件的声道模式，默认与源文件一致
  ///
  /// 注意：设置声道模式前，需先调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件。
  Future<void> setAudioMixingDualMonoMode({
    required int mixId,
    required AudioMixingDualMonoMode mode,
  });

  /// 对混音时本地播放的音乐文件进行升/降调调整
  ///
  /// [pitch] 调整后的音调比原始音调升高/降低的值，取值范围[-12，12]，默认值为 0，即不做调整。  <br>
  /// 取值范围内每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调，设置的绝对值越大表示音调升高或降低越多。<br>
  /// 超出取值范围则设置失败，并且会触发 [RTCVideoEventHandler.onAudioMixingStateChanged] 回调，提示 [AudioMixingState] 状态为 `failed` 混音播放失败，[AudioMixingError] 错误码为 `idTypeInvalidPitch` 混音文件音调设置无效。
  ///
  /// 注意：本方法需在调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件之后，调用 [RTCAudioMixingManager.stopAudioMixing] 停止播放音乐文件前使用。
  Future<void> setAudioMixingPitch({
    required int mixId,
    required int pitch,
  });

  /// 设置混音时音乐文件的播放速度
  ///
  /// [speed] 播放速度与原始文件速度的比例，单位：%，取值范围为 [50,200]，默认值为 100。<br>
  /// 超出取值范围设置失败，你会收到 [RTCVideoEventHandler.onAudioMixingStateChanged] 回调，提示 [AudioMixingState] 状态为 `failed` 混音播放失败，[AudioMixingError] 错误码为 `invalidPlaybackSpeed` 混音文件播放速度设置无效。
  ///
  /// 注意：
  /// + 你需要在调用 [RTCAudioMixingManager.startAudioMixing] 开始混音，并且收到 [RTCVideoEventHandler.onAudioMixingStateChanged] 回调提示 [AudioMixingState] 状态为 `playing`，[AudioMixingError] 错误码为 `ok` 之后调用该方法。  <br>
  /// + 在 [RTCAudioMixingManager.stopAudioMixing] 停止混音或 [RTCAudioMixingManager.unloadAudioMixing] 卸载音乐文件后调用该 API，会收到状态为 `failed` 错误码为 `idNotFound` 的 [RTCVideoEventHandler.onAudioMixingStateChanged] 回调。
  Future<int?> setAudioMixingPlaybackSpeed({
    required int mixId,
    required int speed,
  });

  /// 如果你需要使用 [RTCVideo.enableVocalInstrumentBalance] 对混音使音乐文件进行音量调整，你必须通过此接口传入其原始响度。
  ///
  /// [loudness] 原始响度，单位：lufs，取值范围为 [-70.0, 0.0]。<br>
  /// 当设置的值小于 -70.0lufs 时，则默认调整为 -70.0lufs，大于 0.0lufs 时，则不对该响度做音均衡处理。默认值为 1.0lufs，即不做处理。
  ///
  /// 注意：建议在 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件之前调用该接口，以免播放过程中的音量突变导致听感体验下降。
  Future<void> setAudioMixingLoudness({
    required int mixId,
    required double loudness,
  });

  /// 设置混音时音乐文件播放进度回调的间隔
  ///
  /// [mixId] 混音 ID。可以通过多次调用本接口传入不同的 ID 对多个 ID 进行间隔设置。
  ///
  /// [interval] 音乐文件播放进度回调的时间间隔，需为大于 0 的 10 的倍数，单位为毫秒。  <br>
  /// + 当设置的值不能被 10 整除时，则默认向上取整 10，如设为 52ms 时会默认调整为 60ms。设置完成后 SDK 将会按照设置的时间间隔触发 [RTCVideoEventHandler.onAudioMixingPlayingProgress] 回调。  <br>
  /// + 当设置的值小于等于 0 时，不会触发进度回调。
  ///
  /// 注意：
  /// + 本方法需要在调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件后，调用 [RTCAudioMixingManager.stopAudioMixing] 停止播放音乐文件前使用。  <br>
  /// + 若想在音乐文件开始播放前设置播放进度回调间隔，你需调用 [RTCAudioMixingManager.startAudioMixing] 在 [AudioMixingConfig] 中设置时间间隔，开始播放后可以通过此接口更新回调间隔。
  Future<void> setAudioMixingProgressInterval({
    required int mixId,
    required int interval,
  });

  /// 获取当前音乐文件的音轨索引
  ///
  /// 返回值：方法调用结果
  /// + `≥0`：成功，返回当前音乐文件的音轨索引；
  /// + `<0`：失败
  ///
  /// 注意：调用本方法前，需要先调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件。<br>
  Future<int?> getAudioTrackCount(int mixId);

  /// 指定当前音乐文件的播放音轨
  ///
  /// [audioTrackIndex] 指定播放的音轨。<br>
  /// 该参数值需要小于或等于 [RTCAudioMixingManager.getAudioTrackCount] 的返回值。
  ///
  /// 注意：调用本方法前，需要先调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音乐文件。
  Future<void> selectAudioTrack({
    required int mixId,
    required int audioTrackIndex,
  });
}
