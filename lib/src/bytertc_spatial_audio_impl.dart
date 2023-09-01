// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_spatial_audio_api.dart';

class RTCSpatialAudioImpl implements RTCSpatialAudio {
  late final MethodChannel _methodChannel;
  final int _insId;

  RTCSpatialAudioImpl(int insId) : _insId = insId {
    _methodChannel = MethodChannel('com.bytedance.ve_rtc_spatial_audio$insId');
  }

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
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
    return _invokeMethod<int>('updateSelfOrientation', {
      'insId': _insId,
      'orientation': orientation.toMap(),
    });
  }

  @override
  Future<void> disableRemoteOrientation() {
    return _invokeMethod<void>('disableRemoteOrientation', {
      'insId': _insId,
    });
  }

  @override
  Future<int?> updateListenerPosition(Position pos) =>
      _invokeMethod<int>('updateListenerPosition', {
        'insId': _insId,
        'pos': pos.toMap(),
      });

  @override
  Future<int?> updateListenerOrientation(HumanOrientation orientation) =>
      _invokeMethod<int>('updateListenerOrientation', {
        'insId': _insId,
        'orientation': orientation.toMap(),
      });

  @override
  Future<int?> updateSelfPosition(PositionInfo positionInfo) {
    return _invokeMethod<int>('updateSelfPosition', {
      'insId': _insId,
      'positionInfo': positionInfo.toMap(),
    });
  }

  @override
  Future<int?> updateRemotePosition(
      {required String uid, required PositionInfo positionInfo}) {
    return _invokeMethod<int>('updateRemotePosition', {
      'insId': _insId,
      'uid': uid,
      'positionInfo': positionInfo.toMap(),
    });
  }

  @override
  Future<int?> removeRemotePosition(String uid) {
    return _invokeMethod<int>('removeRemotePosition', {
      'insId': _insId,
      'uid': uid,
    });
  }

  @override
  Future<int?> removeAllRemotePosition() {
    return _invokeMethod<int>('removeAllRemotePosition', {
      'insId': _insId,
    });
  }
}
