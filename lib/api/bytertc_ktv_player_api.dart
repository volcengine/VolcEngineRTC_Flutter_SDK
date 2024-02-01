// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_ktv_defines.dart';

/// [musicId]：音乐 ID。
///
/// [progress]：音乐播放进度，单位为毫秒。
typedef OnPlayProgressType = void Function(String musicId, int progress);

/// [musicId]：音乐 ID。
///
/// [playState]：音乐播放状态。
///
/// [errorCode]：音乐播放错误码。
typedef OnPlayStateChangedType = void Function(
    String musicId, PlayState playState, KTVPlayerErrorCode errorCode);

/// KTV 播放器回调类
class RTCKTVPlayerEventHandler {
  /// 音乐播放进度回调
  OnPlayProgressType? onPlayProgress;

  /// 音乐播放状态改变回调
  ///
  /// 此回调被触发的时机汇总如下：
  /// + 调用 [RTCKTVPlayer.playMusic] 成功后，会触发 playState 值为 playing 的回调；否则会触发 playState 值为 failed 的回调。
  /// + 使用相同的音乐 ID 重复调用 [RTCKTVPlayer.playMusic] 后，后一次播放会覆盖前一次，且会触发 playState 值为 playing 的回调，表示后一次音乐播放已开始。
  /// + 调用 [RTCKTVPlayer.pauseMusic] 方法暂停播放成功后，会触发 playState 值为 paused 的回调；否则触发 playState 值为 failed 的回调。
  /// + 调用 [RTCKTVPlayer.resumeMusic] 方法恢复播放成功后，会触发 playState 值为 playing 的回调；否则触发 playState 值为 failed 的回调。
  /// + 调用 [RTCKTVPlayer.stopMusic] 方法停止播放成功后，会触发 playState 值为 stopped 的回调；否则触发 playState 值为 failed 的回调。
  /// + 音乐播放结束会触发 playState 值为 finished 的回调。
  OnPlayStateChangedType? onPlayStateChanged;

  /// @nodoc
  RTCKTVPlayerEventHandler({
    this.onPlayProgress,
    this.onPlayStateChanged,
  });
}

/// KTV 播放器接口类
abstract class RTCKTVPlayer {
  /// 设置 KTV 播放器进度及状态回调类
  void setPlayerEventHandler(RTCKTVPlayerEventHandler? eventHandler);

  /// 播放歌曲
  ///
  /// [musicId]：音乐 ID。<br>
  /// 若同一 musicId 的歌曲正在播放，再次调用接口会从开始位置重新播放。<br>
  /// 若 musicId 对应的音频文件不存在会触发报错。
  ///
  /// [trackType]：原唱伴唱类型。
  ///
  /// [playType]：音乐播放类型。
  ///
  /// 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> playMusic(
    String musicId, {
    required AudioTrackType trackType,
    required AudioPlayType playType,
  });

  /// 暂停播放歌曲
  ///
  /// 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> pauseMusic(String musicId);

  /// 继续播放歌曲
  ///
  /// 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> resumeMusic(String musicId);

  /// 停止播放歌曲。
  ///
  /// 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> stopMusic(String musicId);

  /// 设置音乐文件的起始播放位置
  ///
  /// [musicId]：音乐 ID。<br>
  /// [position]：音乐起始位置，单位为毫秒，取值小于音乐文件总时长。
  ///
  /// 注意：
  /// + 调用该接口时音乐必须处于播放中状态。
  /// + 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> seekMusic(
    String musicId, {
    required int position,
  });

  /// 设置歌曲播放音量，只能在开始播放后进行设置
  ///
  /// [musicId]：音乐 ID。<br>
  /// [volume]：歌曲播放音量，调节范围：`[0,400]`。
  /// + 0：静音。
  /// + 100：原始音量。
  /// + 400：原始音量的 4 倍(自带溢出保护)。
  ///
  /// 注意：
  /// + 调用本接口时音乐必须处于播放中状态。
  /// + 若设置的音量大于 400，则按最大值 400 进行调整；若设置的音量小于 0，则按最小值 0 进行调整。
  /// + 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> setMusicVolume(
    String musicId, {
    required int volume,
  });

  /// 切换歌曲原唱伴唱
  ///
  /// 调用该接口时音乐必须处于播放中状态。
  Future<void> switchAudioTrackType(String musicId);

  /// 对播放中的音乐设置升降调信息
  ///
  /// [musicId]：音乐 ID。<br>
  /// [pitch]：相对于音乐文件原始音调的升高/降低值，取值范围 `[-12，12]`，默认值为 0，即不做调整。<br>
  /// 若设置的 pitch 大于 12，则按最大值 12 进行调整；若设置的 pitch 小于 –12，，则按最小值 –12 进行调整。<br>
  /// 取值范围内每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调，设置的绝对值越大表示音调升高或降低越多。
  ///
  /// 注意：
  /// + 调用本接口时音乐必须处于播放中状态。
  /// + 调用该接口后，你可以通过 [RTCKTVPlayerEventHandler.onPlayStateChanged] 回调感知歌曲播放状态。
  Future<void> setMusicPitch(
    String musicId, {
    required int pitch,
  });
}
