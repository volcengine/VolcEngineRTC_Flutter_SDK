// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_audio_mixing_api.dart';
import 'base/bytertc_enum_convert.dart';

class RTCAudioMixingManagerImpl implements RTCAudioMixingManager {
  final MethodChannel _methodChannel =
      const MethodChannel('com.bytedance.ve_rtc_audio_mixing_manager');

  Future<T?> _invokeMethod<T>(String method, Map<String, dynamic>? arguments) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  @override
  Future<void> startAudioMixing(
      {required int mixId,
      required String filePath,
      required AudioMixingConfig config}) {
    return _invokeMethod<void>('startAudioMixing',
        {'mixId': mixId, 'filePath': filePath, 'config': config.toMap()});
  }

  @override
  Future<void> stopAudioMixing(int mixId) {
    return _invokeMethod<void>('stopAudioMixing', {
      'mixId': mixId,
    });
  }

  @override
  Future<void> pauseAudioMixing(int mixId) {
    return _invokeMethod<void>('pauseAudioMixing', {
      'mixId': mixId,
    });
  }

  @override
  Future<void> resumeAudioMixing(int mixId) {
    return _invokeMethod<void>('resumeAudioMixing', {
      'mixId': mixId,
    });
  }

  @override
  Future<void> preloadAudioMixing(
      {required int mixId, required String filePath}) {
    return _invokeMethod<void>(
        'preloadAudioMixing', {'mixId': mixId, 'filePath': filePath});
  }

  @override
  Future<void> unloadAudioMixing(int mixId) {
    return _invokeMethod<void>('unloadAudioMixing', {'mixId': mixId});
  }

  @override
  Future<void> setAudioMixingVolume(
      {required int mixId,
      required int volume,
      required AudioMixingType type}) {
    return _invokeMethod<void>('setAudioMixingVolume',
        {'mixId': mixId, 'volume': volume, 'type': type.value});
  }

  @override
  Future<int?> getAudioMixingDuration(int mixId) {
    return _invokeMethod<int>('getAudioMixingDuration', {'mixId': mixId});
  }

  @override
  Future<int?> getAudioMixingCurrentPosition(int mixId) {
    return _invokeMethod<int>(
        'getAudioMixingCurrentPosition', {'mixId': mixId});
  }

  @override
  Future<void> setAudioMixingPosition(
      {required int mixId, required int position}) {
    return _invokeMethod<void>('setAudioMixingPosition', {
      'mixId': mixId,
      'position': position,
    });
  }

  @override
  Future<void> setAudioMixingDualMonoMode(
      {required int mixId, required AudioMixingDualMonoMode mode}) {
    return _invokeMethod<void>('setAudioMixingDualMonoMode', {
      'mixId': mixId,
      'mode': mode.value,
    });
  }

  @override
  Future<void> setAudioMixingPitch({required int mixId, required int pitch}) {
    return _invokeMethod<void>('setAudioMixingPitch', {
      'mixId': mixId,
      'pitch': pitch,
    });
  }

  @override
  Future<int?> setAudioMixingPlaybackSpeed(
      {required int mixId, required int speed}) {
    return _invokeMethod<int>('setAudioMixingPlaybackSpeed', {
      'mixId': mixId,
      'speed': speed,
    });
  }

  @override
  Future<void> setAudioMixingLoudness(
      {required int mixId, required double loudness}) {
    return _invokeMethod<void>('setAudioMixingLoudness', {
      'mixId': mixId,
      'loudness': loudness,
    });
  }

  @override
  Future<void> setAudioMixingProgressInterval(
      {required int mixId, required int interval}) {
    return _invokeMethod<void>('setAudioMixingProgressInterval', {
      'mixId': mixId,
      'interval': interval,
    });
  }

  @override
  Future<int?> getAudioTrackCount(int mixId) {
    return _invokeMethod<int>('getAudioTrackCount', {
      'mixId': mixId,
    });
  }

  @override
  Future<void> selectAudioTrack(
      {required int mixId, required int audioTrackIndex}) {
    return _invokeMethod<void>('selectAudioTrack', {
      'mixId': mixId,
      'audioTrackIndex': audioTrackIndex,
    });
  }
}
