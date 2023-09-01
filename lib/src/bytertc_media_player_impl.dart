// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_media_player_api.dart';
import 'base/bytertc_event_channel.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCMediaPlayerEventProcessor on RTCMediaPlayerEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onMediaPlayerStateChanged':
        final data = OnMediaPlayerStateChangedData.fromMap(dic);
        onMediaPlayerStateChanged?.call(data.playerId, data.state, data.error);
        break;
      case 'onMediaPlayerPlayingProgress':
        final data = OnMediaPlayerPlayingProgressData.fromMap(dic);
        onMediaPlayerPlayingProgress?.call(data.playerId, data.progress);
        break;
      default:
        break;
    }
  }
}

class RTCMediaPlayerImpl implements RTCMediaPlayer {
  final MethodChannel _methodChannel;
  final RTCEventChannel _eventChannel;

  RTCMediaPlayerEventHandler? _eventHandler;

  RTCMediaPlayerImpl(int playerId)
      : _methodChannel =
            MethodChannel('com.bytedance.ve_rtc_media_player_$playerId'),
        _eventChannel = RTCEventChannel(
            'com.bytedance.ve_rtc_media_player_event_$playerId');

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
  Future<int?> open({
    required String filePath,
    MediaPlayerConfig config = const MediaPlayerConfig(),
  }) {
    return _invokeMethod<int>('open', {
      'filePath': filePath,
      'config': config.toMap(),
    });
  }

  @override
  Future<int?> start() => _invokeMethod<int>('start');

  @override
  Future<int?> stop() => _invokeMethod<int>('stop');

  @override
  Future<int?> pause() => _invokeMethod<int>('pause');

  @override
  Future<int?> resume() => _invokeMethod<int>('resume');

  @override
  Future<int?> setVolume({
    required int volume,
    AudioMixingType type = AudioMixingType.playoutAndPublish,
  }) {
    return _invokeMethod<int>('setVolume', {
      'volume': volume,
      'type': type.index,
    });
  }

  @override
  Future<int?> getVolume([
    AudioMixingType type = AudioMixingType.playoutAndPublish,
  ]) {
    return _invokeMethod<int>('getVolume', {
      'type': type.index,
    });
  }

  @override
  Future<int?> getTotalDuration() => _invokeMethod<int>('getTotalDuration');

  @override
  Future<int?> getPlaybackDuration() =>
      _invokeMethod<int>('getPlaybackDuration');

  @override
  Future<int?> getPosition() => _invokeMethod<int>('getPosition');

  @override
  Future<int?> setAudioPitch(int pitch) {
    return _invokeMethod<int>('setAudioPitch', {
      'pitch': pitch,
    });
  }

  @override
  Future<int?> setPosition(int position) {
    return _invokeMethod<int>('setPosition', {
      'position': position,
    });
  }

  @override
  Future<int?> setAudioDualMonoMode(AudioMixingDualMonoMode mode) {
    return _invokeMethod<int>('setAudioDualMonoMode', {
      'mode': mode.index,
    });
  }

  @override
  Future<int?> getAudioTrackCount() => _invokeMethod<int>('getAudioTrackCount');

  @override
  Future<int?> selectAudioTrack(int index) {
    return _invokeMethod<int>('selectAudioTrack', {
      'index': index,
    });
  }

  @override
  Future<int?> setPlaybackSpeed(int speed) {
    return _invokeMethod<int>('setPlaybackSpeed', {
      'speed': speed,
    });
  }

  @override
  Future<int?> setProgressInterval(int interval) {
    return _invokeMethod<int>('setProgressInterval', {
      'interval': interval,
    });
  }

  @override
  Future<int?> setLoudness(double loudness) {
    return _invokeMethod<int>('setLoudness', {
      'loudness': loudness,
    });
  }

  @override
  void setEventHandler(RTCMediaPlayerEventHandler? handler) {
    _eventHandler = handler;
    _listenEvent();
  }
}
