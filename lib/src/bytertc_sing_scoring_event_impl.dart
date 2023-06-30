// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_sing_scoring_event_handler.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCSingScoringEventProcessor on RTCSingScoringEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onCurrentScoringInfo':
        final data = OnCurrentScoringInfoData.fromMap(dic);
        onCurrentScoringInfo?.call(data.info);
        break;
      default:
        break;
    }
  }
}
