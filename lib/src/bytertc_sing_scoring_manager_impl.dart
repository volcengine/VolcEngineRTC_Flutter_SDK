// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'package:flutter/services.dart';

import '../api/bytertc_sing_scoring_manager_api.dart';
import 'base/bytertc_event_channel.dart';
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

class RTCSingScoringManagerImpl implements RTCSingScoringManager {
  final MethodChannel _methodChannel =
      const MethodChannel('com.bytedance.ve_rtc_sing_scoring_manager');
  RTCEventChannel? _eventChannel;
  RTCSingScoringEventHandler? _eventHandler;

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  void _listenEvent() {
    _eventChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_sing_scoring_event_handler');
    _eventChannel?.subscription ??
        _eventChannel?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _eventHandler?.process(methodName, dic);
        });
  }

  void destroy() {
    _eventChannel?.cancel();
    _eventHandler = null;
  }

  @override
  Future<int?> initSingScoring(
      {required String singScoringAppKey,
      required String singScoringToken,
      RTCSingScoringEventHandler? handler}) {
    return _invokeMethod<int>('initSingScoring', {
      'singScoringAppKey': singScoringAppKey,
      'singScoringToken': singScoringToken,
      'handler': handler != null,
    }).then((value) {
      _eventHandler = handler;
      if (handler != null) {
        _listenEvent();
      } else {
        _eventChannel?.cancel();
      }
      return value;
    });
  }

  @override
  Future<int?> setSingScoringConfig(SingScoringConfig config) {
    return _invokeMethod<int>('setSingScoringConfig', {
      'config': config.toMap(),
    });
  }

  @override
  Future<List<StandardPitchInfo>?> getStandardPitchInfo(
      String midiFilepath) async {
    List<dynamic>? res =
        await _invokeMethod<List<dynamic>>('getStandardPitchInfo', {
      'midiFilepath': midiFilepath,
    });
    if (res == null) {
      return Future.value(null);
    }
    return Future.value(
        res.map((e) => StandardPitchInfo.fromMap(e)).toList(growable: false));
  }

  @override
  Future<int?> startSingScoring(
      {int position = 0, int scoringInfoInterval = 50}) {
    return _invokeMethod<int>('startSingScoring', {
      'position': position,
      'scoringInfoInterval': scoringInfoInterval,
    });
  }

  @override
  Future<int?> stopSingScoring() {
    return _invokeMethod<int>('stopSingScoring');
  }

  @override
  Future<int?> getLastSentenceScore() {
    return _invokeMethod<int>('getLastSentenceScore');
  }

  @override
  Future<int?> getTotalScore() {
    return _invokeMethod<int>('getTotalScore');
  }

  @override
  Future<int?> getAverageScore() {
    return _invokeMethod<int>('getAverageScore');
  }
}
