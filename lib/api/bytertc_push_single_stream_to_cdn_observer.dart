// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// 单流转推直播观察者
class RTCPushSingleStreamToCDNObserver {
  /// 单流转推直播状态回调
  OnStreamPushEventType? onStreamPushEvent;

  RTCPushSingleStreamToCDNObserver({
    this.onStreamPushEvent,
  });
}
