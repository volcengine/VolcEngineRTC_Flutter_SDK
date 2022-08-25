// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_face_detection_observer.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCFaceDetectionProcessor on RTCFaceDetectionObserver {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onFaceDetectResult':
        final data = OnFaceDetectResultData.fromMap(dic);
        onFaceDetectResult?.call(data.result);
        break;
      default:
        break;
    }
  }
}
