// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_push_single_stream_to_cdn_observer.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCPushSingleStreamToCDNProcessor
    on RTCPushSingleStreamToCDNObserver {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onStreamPushEvent':
        OnStreamPushEventData data = OnStreamPushEventData.fromMap(dic);
        onStreamPushEvent?.call(data.eventType, data.taskId, data.error);
        break;
      default:
        break;
    }
  }
}
