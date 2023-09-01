// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import '../api/bytertc_cdn_stream_observer.dart';
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

extension RTCMixedStreamProcessor on RTCMixedStreamObserver {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onMixingEvent':
        final data = OnStreamMixingEventData.fromMap(dic);
        onMixingEvent?.call(
            data.eventType, data.taskId, data.error, data.mixType);
        break;
      default:
        break;
    }
  }
}
