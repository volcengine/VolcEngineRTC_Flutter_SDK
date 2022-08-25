// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_range_audio_api.dart';
import '../api/bytertc_range_audio_observer.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_range_audio_observer_impl.dart';

class RTCRangeAudioImpl implements RTCRangeAudio {
  late final MethodChannel _methodChannel;
  final int _insId;
  RTCEventChannel? _rangeAudioChannel;
  RTCRangeAudioObserver? _rangeAudioObserver;

  RTCRangeAudioImpl(int insId) : _insId = insId {
    _methodChannel = MethodChannel('com.bytedance.ve_rtc_range_audio$insId');
  }

  Future<T?> _invokeMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  void _listenRangeAudioEvent() {
    _rangeAudioChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_range_audio_observer$_insId');
    _rangeAudioChannel?.subscription ??
        _rangeAudioChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _rangeAudioObserver?.process(methodName, dic);
        });
  }

  void destroy() {
    _rangeAudioChannel?.cancel();
    _rangeAudioObserver = null;
  }

  @override
  Future<void> enableRangeAudio(bool enable) {
    return _invokeMethod<void>('enableRangeAudio', {
      'insId': _insId,
      'enable': enable,
    });
  }

  @override
  Future<int?> updateReceiveRange(ReceiveRange range) {
    return _invokeMethod<int>('updateReceiveRange', {
      'insId': _insId,
      'range': range.toMap(),
    });
  }

  @override
  Future<int?> updatePosition(Position pos) {
    return _invokeMethod<int>('updatePosition', {
      'insId': _insId,
      'pos': pos.toMap(),
    });
  }

  @override
  Future<void> registerRangeAudioObserver(RTCRangeAudioObserver? observer) {
    _rangeAudioObserver = observer;
    if (observer != null) {
      _listenRangeAudioEvent();
    } else {
      _rangeAudioChannel?.cancel();
    }
    return _invokeMethod<void>('registerRangeAudioObserver', {
      'insId': _insId,
      'observer': observer != null,
    });
  }

  @override
  Future<int?> setAttenuationModel(
      {required AttenuationType type, required double coefficient}) {
    return _invokeMethod<int>('setAttenuationModel', {
      'insId': _insId,
      'type': type.value,
      'coefficient': coefficient,
    });
  }
}
