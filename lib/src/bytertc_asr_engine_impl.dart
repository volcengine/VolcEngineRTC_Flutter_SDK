// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import '../api/bytertc_asr_engine_event_handler.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCASREngineEventProcessor on RTCASREngineEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onSuccess':
        onSuccess?.call();
        break;
      case 'onMessage':
        final data = OnMeesageData.fromMap(dic);
        onMessage?.call(data.message);
        break;
      case 'onError':
        final data = OnErrorMsgData.fromMap(dic);
        onErrorMsg?.call(data.errorCode, data.errorMessage);
        break;
      default:
        break;
    }
  }
}
