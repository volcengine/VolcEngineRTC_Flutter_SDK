// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// 单流转推直播观察者
class RTCPushSingleStreamToCDNObserver {
  /// 单流转推直播状态回调
  OnStreamPushEventType? onStreamPushEvent;

  /// @nodoc
  RTCPushSingleStreamToCDNObserver({
    this.onStreamPushEvent,
  });
}

/// 转推直播观察者。
///
/// v3.54 新增。
class RTCMixedStreamObserver {
  /// 转推直播状态回调。
  OnStreamMixingEventType? onMixingEvent;

  /// @nodoc
  RTCMixedStreamObserver({
    this.onMixingEvent,
  });
}
