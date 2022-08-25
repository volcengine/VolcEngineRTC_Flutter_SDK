// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_live_transcoding_observer.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCLiveTranscodingProcessor on RTCLiveTranscodingObserver {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onStreamMixingEvent':
        final data = OnStreamMixingEventData.fromMap(dic);
        onStreamMixingEvent?.call(
            data.eventType, data.taskId, data.error, data.mixType);
        break;
      default:
        break;
    }
  }
}
