// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_range_audio_observer.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCRangeAudioProcessor on RTCRangeAudioObserver {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onRangeAudioInfo':
        final data = OnRangeAudioInfoData.fromMap(dic);
        onRangeAudioInfo?.call(data.rangeAudioInfo);
        break;
      default:
        break;
    }
  }
}
