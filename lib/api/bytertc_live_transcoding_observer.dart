// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// 转推直播观察者
class RTCLiveTranscodingObserver {
  /// 转推直播状态回调
  OnStreamMixingEventType? onStreamMixingEvent;

  RTCLiveTranscodingObserver({
    this.onStreamMixingEvent,
  });
}
