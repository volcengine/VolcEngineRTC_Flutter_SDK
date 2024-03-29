// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';

/// 空间音频接口实例
abstract class RTCSpatialAudio {
  /// 开启/关闭空间音频功能
  ///
  /// 该方法仅开启空间音频功能，你须调用 [RTCSpatialAudio.updateSelfPosition] 设置自身位置坐标后方可收听空间音频效果。<br>
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  Future<void> enableSpatialAudio(bool enable);

  /// 更新本地用户在房间内空间直角坐标系中的位置坐标
  ///
  /// [pos]： 三维坐标的值，默认为 `[0, 0, 0]`。
  ///
  /// 注意：调用该接口更新坐标前，你需调用 [RTCSpatialAudio.enableSpatialAudio] 开启空间音频功能。 <br>
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  @Deprecated('Deprecated since v3.54, use updateSelfPosition instead')
  Future<int?> updatePosition(Position pos);

  /// 更新本地用户在空间音频坐标系下的朝向
  ///
  /// 注意：
  /// + 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。<br>
  /// + 调用 [RTCSpatialAudio.disableRemoteOrientation] 可忽略远端用户朝向。
  @Deprecated('Deprecated since v3.54, use updateSelfPosition instead')
  Future<int?> updateSelfOrientation(HumanOrientation orientation);

  /// 参与通话的各端调用本接口后，将忽略远端用户的朝向，认为所有远端用户都面向本地用户
  ///
  /// 如果此后调用 [RTCSpatialAudio.updateSelfPosition] 更新本地用户朝向，远端用户无法感知这些变化，但本地用户接收音频时可以感知自身朝向改变带来的音频效果变化。
  ///
  /// 注意：
  /// + 进房前后都可以调用该接口。
  /// + 调用本接口关闭朝向功能后，在当前的空间音频实例的生命周期内无法再次开启。
  Future<void> disableRemoteOrientation();

  /// 更新在房间内收听音频时的位置<br>
  /// 通过此接口，你可以设定本地发声位置和收听位置不同。
  ///
  /// [pos]：空间直角坐标系下的坐标值。<br>
  /// 如果未调用此接口设定收听位置，那么默认值为通过 [RTCSpatialAudio.updatePosition] 设定的值。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + !0：失败。
  ///
  /// 注意：
  /// + 调用此接口前，你需调用 [RTCSpatialAudio.enableSpatialAudio] 开启空间音频功能。
  /// + 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  @Deprecated('Deprecated since v3.54, use updateRemotePosition instead')
  Future<int?> updateListenerPosition(Position pos);

  /// 更新在房间内收听音频时的朝向<br>
  /// 通过此接口，你可以设定本地用户的发声朝向和收听朝向不同。
  ///
  /// [orientation]：自身朝向信息。<br>
  /// 如果未调用此接口设定收听朝向，那么默认值为通过 [RTCSpatialAudio.updateSelfOrientation] 设定的值。
  ///
  ///返回值：
  /// + 0：成功；
  /// + !0：失败
  ///
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  @Deprecated('Deprecated since v3.54, use updateRemotePosition instead')
  Future<int?> updateListenerOrientation(HumanOrientation orientation);

  /// 设置本地用户在自建空间直角坐标系中的收听坐标和收听朝向，以实现本地用户预期的空间音频收听效果。
  ///
  /// v3.54 新增。
  ///
  /// [positionInfo]：空间音频位置信息。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  /// + `-2`：失败，原因是校验本地用户的三维朝向信息时，三个向量没有两两垂直。
  ///
  /// 注意：
  /// + 该方法需在进房后调用。调用该接口更新坐标前，你需调用 [RTCSpatialAudio.enableSpatialAudio] 开启空间音频功能。空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  /// + 调用此接口在本地进行的设定对其他用户的空间音频收听效果不会产生任何影响。
  Future<int?> updateSelfPosition(PositionInfo positionInfo);

  /// 设置房间内某一远端用户在本地用户自建的空间音频坐标系中的发声位置和发声朝向，以实现本地用户预期的空间音频收听效果。
  ///
  /// v3.54 新增。
  ///
  /// [uid]：用户 ID。
  ///
  /// [positionInfo]：远端用户的空间音频位置信息。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `< 0：失败。
  /// + `-2`：失败，原因是校验远端用户的三维朝向信息时，三个向量没有两两垂直。
  ///
  /// 注意：
  /// + 该方法需在创建房间后调用。
  /// + 调用此接口在本地进行的设定对其他用户的空间音频收听效果不会产生任何影响。
  Future<int?> updateRemotePosition({
    required String uid,
    required PositionInfo positionInfo,
  });

  /// 移除调用 [RTCSpatialAudio.updateRemotePosition] 为某一远端用户设置的空间音频效果。
  ///
  /// v3.54 新增。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  Future<int?> removeRemotePosition(String uid);

  /// 移除调用 [RTCSpatialAudio.updateRemotePosition] 为所有远端用户设置的空间音频效果。
  ///
  /// v3.54 新增。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  Future<int?> removeAllRemotePosition();
}
