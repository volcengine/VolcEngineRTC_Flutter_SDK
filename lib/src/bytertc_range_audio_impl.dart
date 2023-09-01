// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_range_audio_api.dart';

class RTCRangeAudioImpl implements RTCRangeAudio {
  late final MethodChannel _methodChannel;
  final int _insId;

  RTCRangeAudioImpl(int insId) : _insId = insId {
    _methodChannel = MethodChannel('com.bytedance.ve_rtc_range_audio$insId');
  }

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
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
  Future<int?> setAttenuationModel(
      {required AttenuationType type, required double coefficient}) {
    return _invokeMethod<int>('setAttenuationModel', {
      'insId': _insId,
      'type': type.index,
      'coefficient': coefficient,
    });
  }

  @override
  Future<void> setNoAttenuationFlags(List<String> flags) {
    return _invokeMethod<void>('setNoAttenuationFlags', {
      'insId': _insId,
      'flags': flags,
    });
  }
}
