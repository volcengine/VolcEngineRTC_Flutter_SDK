// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_spatial_audio_api.dart';

class RTCSpatialAudioImpl implements RTCSpatialAudio {
  late final MethodChannel _methodChannel;
  final int _insId;

  RTCSpatialAudioImpl(int insId) : _insId = insId {
    _methodChannel = MethodChannel('com.bytedance.ve_rtc_spatial_audio$insId');
  }

  Future<T?> _invokeMethod<T>(String method, [dynamic arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  @override
  Future<void> enableSpatialAudio(bool enable) {
    return _invokeMethod<void>('enableSpatialAudio', {
      'insId': _insId,
      'enable': enable,
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
  Future<int?> updateSelfOrientation(HumanOrientation orientation) {
    return _invokeMethod<int>('updateSelfOrientation',
        {'insId': _insId, 'orientation': orientation.toMap()});
  }

  @override
  Future<void> disableRemoteOrientation() {
    return _invokeMethod<void>('disableRemoteOrientation', {
      'insId': _insId,
    });
  }
}
