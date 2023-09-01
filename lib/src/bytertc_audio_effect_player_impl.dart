// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'package:flutter/services.dart';

import '../api/bytertc_audio_effect_player_api.dart';
import 'base/bytertc_event_channel.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCAudioEffectPlayerEventProcessor
    on RTCAudioEffectPlayerEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onAudioEffectPlayerStateChanged':
        final data = OnAudioEffectPlayerStateChangedData.fromMap(dic);
        onAudioEffectPlayerStateChanged?.call(
            data.effectId, data.state, data.error);
        break;
      default:
        break;
    }
  }
}

class RTCAudioEffectPlayerImpl implements RTCAudioEffectPlayer {
  final MethodChannel _methodChannel =
      const MethodChannel('com.bytedance.ve_rtc_audio_effect_player');
  final RTCEventChannel _eventChannel =
      RTCEventChannel('com.bytedance.ve_rtc_audio_effect_player_event');

  RTCAudioEffectPlayerEventHandler? _eventHandler;

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  void _listenEvent() {
    _eventChannel.subscription ??
        _eventChannel.listen((String methodName, Map<dynamic, dynamic> dic) {
          _eventHandler?.process(methodName, dic);
        });
  }

  void destroy() {
    _eventChannel.cancel();
    _eventHandler = null;
  }

  @override
  Future<int?> start(int effectId,
      {required String filePath,
      AudioEffectPlayerConfig config = const AudioEffectPlayerConfig()}) {
    return _invokeMethod<int>('start', {
      'effectId': effectId,
      'filePath': filePath,
      'config': config.toMap(),
    });
  }

  @override
  Future<int?> stop(int effectId) {
    return _invokeMethod<int>('stop', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> stopAll() {
    return _invokeMethod<int>('stopAll');
  }

  @override
  Future<int?> preload(int effectId, {required String filePath}) {
    return _invokeMethod<int>('preload', {
      'effectId': effectId,
      'filePath': filePath,
    });
  }

  @override
  Future<int?> unload(int effectId) {
    return _invokeMethod<int>('unload', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> unloadAll() {
    return _invokeMethod<int>('unloadAll');
  }

  @override
  Future<int?> pause(int effectId) {
    return _invokeMethod<int>('pause', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> pauseAll() {
    return _invokeMethod<int>('pauseAll');
  }

  @override
  Future<int?> resume(int effectId) {
    return _invokeMethod<int>('resume', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> resumeAll() {
    return _invokeMethod<int>('resumeAll');
  }

  @override
  Future<int?> setPosition(int effectId, {required int position}) {
    return _invokeMethod<int>('setPosition', {
      'effectId': effectId,
      'position': position,
    });
  }

  @override
  Future<int?> getPosition(int effectId) {
    return _invokeMethod<int>('getPosition', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> setVolume(int effectId, {required int volume}) {
    return _invokeMethod<int>('setVolume', {
      'effectId': effectId,
      'volume': volume,
    });
  }

  @override
  Future<int?> setVolumeAll(int volume) {
    return _invokeMethod<int>('setVolumeAll', {
      'volume': volume,
    });
  }

  @override
  Future<int?> getVolume(int effectId) {
    return _invokeMethod<int>('getVolume', {
      'effectId': effectId,
    });
  }

  @override
  Future<int?> getDuration(int effectId) {
    return _invokeMethod<int>('getDuration', {
      'effectId': effectId,
    });
  }

  @override
  void setEventHandler(RTCAudioEffectPlayerEventHandler? handler) {
    _eventHandler = handler;
    _listenEvent();
  }
}
