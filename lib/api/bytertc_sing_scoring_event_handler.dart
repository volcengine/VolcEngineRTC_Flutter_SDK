// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// K 歌评分事件回调类。
class RTCSingScoringEventHandler {
  /// 实时评分信息回调。
  ///
  /// 调用 [RTCSingScoringManager.startSingScoring] 后，会收到该回调。
  OnCurrentScoringInfoType? onCurrentScoringInfo;

  RTCSingScoringEventHandler({
    this.onCurrentScoringInfo,
  });
}
