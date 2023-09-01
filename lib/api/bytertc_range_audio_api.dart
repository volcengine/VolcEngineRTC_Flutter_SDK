// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_audio_defines.dart';

/// 范围语音接口实例
abstract class RTCRangeAudio {
  /// 开启/关闭范围语音功能
  ///
  /// 范围语音是指，在同一 RTC 房间中设定的音频接收距离范围内，本地用户收听到的远端用户音频音量会随着远端用户的靠近/远离而放大/衰减；若远端用户在房间内的位置超出设定范围，则本地用户无法接收其音频。音频接收范围设置参看 [RTCRangeAudio.updateReceiveRange]。
  ///
  /// 注意：该方法进房前后都可调用，为保证进房后范围语音效果的平滑切换，你需在该方法前先调用 [RTCRangeAudio.updatePosition] 设置自身位置坐标，然后开启该方法收听范围语音效果。
  Future<void> enableRangeAudio(bool enable);

  /// 更新本地用户的音频收听范围
  ///
  /// [range] 音频收听范围
  ///
  /// 返回值：方法调用结果
  /// + 0：成功；
  /// + !0: 失败。
  Future<int?> updateReceiveRange(ReceiveRange range);

  /// 更新本地用户在房间内空间直角坐标系中的位置坐标
  ///
  /// [pos] 三维坐标的值，默认为 `[0, 0, 0]`
  ///
  /// 返回值：方法调用结果
  /// + 0：成功；
  /// + !0：失败。
  ///
  /// 注意：调用该接口更新坐标后，你需调用 [RTCRangeAudio.enableRangeAudio] 开启范围语音功能以收听范围语音效果。
  Future<int?> updatePosition(Position pos);

  /// 设置范围语音的音量衰减模式
  ///
  /// [type] 音量衰减模式，默认为线性衰减。
  ///
  /// [coefficient] 指数衰减模式下的音量衰减系数，默认值为 1。
  /// 范围 `[0.1,100]`，推荐设置为 `50`。
  /// 数值越大，音量的衰减速度越快。
  ///
  /// 返回值：方法调用结果
  /// + `0`：成功；
  /// + `-1`：失败，原因是在调用 [RTCRangeAudio.enableRangeAudio] 开启范围语音前或进房前调用了本接口。
  ///
  /// 注意：音量衰减范围通过 [RTCRangeAudio.updateReceiveRange] 进行设置。
  Future<int?> setAttenuationModel({
    required AttenuationType type,
    required double coefficient,
  });

  /// 添加标签组，用于标记相互之间通话不衰减的用户组。
  ///
  /// 在同一个 RTC 房间中，如果多个用户的标签组之间有交集，那么，他们之间互相通话时，通话不衰减。<br>
  /// 比如，用户身处多个队伍，队伍成员间通话不衰减。那么，可以为每个队伍绑定专属标签，每个用户的标签组包含用户所属各个队伍的标签。
  ///
  /// [flags]：标签组。
  Future<void> setNoAttenuationFlags(List<String> flags);
}
