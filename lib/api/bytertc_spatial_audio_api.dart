// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';

/// 空间音频接口实例
abstract class RTCSpatialAudio {
  /// 开启/关闭空间音频功能
  ///
  /// 该方法仅开启空间音频功能，你须调用 [RTCSpatialAudio.updatePosition] 设置自身位置坐标后方可收听空间音频效果。<br>
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  Future<void> enableSpatialAudio(bool enable);

  /// 更新本地用户在房间内空间直角坐标系中的位置坐标
  ///
  /// [pos]： 三维坐标的值，默认为 [0, 0, 0]。
  ///
  /// 注意：调用该接口更新坐标前，你需调用 [RTCSpatialAudio.enableSpatialAudio] 开启空间音频功能。 <br>
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  Future<int?> updatePosition(Position pos);

  /// 更新本地用户在空间音频坐标系下的朝向
  ///
  /// 注意：
  /// + 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。<br>
  /// + 调用 [RTCSpatialAudio.disableRemoteOrientation] 可忽略远端用户朝向。
  Future<int?> updateSelfOrientation(HumanOrientation orientation);

  /// 参与通话的各端调用本接口后，将忽略远端用户的朝向，认为所有远端用户都面向本地用户
  ///
  /// 如果此后调用 [RTCSpatialAudio.updateSelfOrientation] 更新本地用户朝向，远端用户无法感知这些变化，但本地用户接收音频时可以感知自身朝向改变带来的音频效果变化。
  ///
  /// 注意：
  /// + 进房前后都可以调用该接口。
  /// + 调用本接口关闭朝向功能后，在当前的空间音频实例的生命周期内无法再次开启。
  Future<void> disableRemoteOrientation();
}
