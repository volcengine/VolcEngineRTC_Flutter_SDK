// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// 范围语音衰减系数监测器
class RTCRangeAudioObserver {
  /// 关于当前范围语音衰减系数的回调
  ///
  /// 手动订阅的场景下，房间内任一用户调用 [IRangeAudio.updatePosition] 更新自身位置或调用 [RTCRangeAudio.updateReceiveRange] 更新语音接收范围时，该用户与房间内其他用户的相对距离都会发生改变，据此计算的衰减系数也会发生改变，并通过该回调通知用户。 <br>
  /// 你可以通过关注该回调中包含的远端用户的衰减系数决定是否订阅该远端用户的流。
  ///
  /// 注意：更新自身位置或语音接收范围后，并不会马上触发该回调。SDK 会每 500 ms 计算一次衰减系数，并且只在计算结果与上次不同，或结果相同但是距离上次计算已超过 3 秒的时候推送回调。
  OnRangeAudioInfoType? onRangeAudioInfo;

  RTCRangeAudioObserver({
    this.onRangeAudioInfo,
  });
}
