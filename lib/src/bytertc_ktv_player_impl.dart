// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';

import '../api/bytertc_ktv_defines.dart';
import '../api/bytertc_ktv_player_api.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_ktv_event_impl.dart';

class RTCKTVPlayerImpl implements RTCKTVPlayer {
  final MethodChannel _channel =
      MethodChannel('com.bytedance.ve_rtc_ktv_player');
  final RTCEventChannel _eventChannel =
      RTCEventChannel('com.bytedance.ve_rtc_ktv_player_event');

  RTCKTVPlayerEventHandler? _eventHandler;

  RTCKTVPlayerImpl() {
    _listenEvent();
  }

  void _listenEvent() {
    _eventChannel.subscription ??
        _eventChannel.listen((String methodName, Map<dynamic, dynamic> dic) {
          _eventHandler?.process(methodName, dic);
        });
  }

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  void destroy() {
    _eventChannel.cancel();
    _eventHandler = null;
  }

  @override
  void setPlayerEventHandler(RTCKTVPlayerEventHandler? eventHandler) {
    _eventHandler = eventHandler;
  }

  @override
  Future<void> playMusic(String musicId,
      {required KTVAudioTrackType trackType,
      required KTVAudioPlayType playType}) {
    return _invokeMethod('playMusic', {
      'musicId': musicId,
      'trackType': trackType.value,
      'playType': playType.value,
    });
  }

  @override
  Future<void> pauseMusic(String musicId) {
    return _invokeMethod('pauseMusic', {
      'musicId': musicId,
    });
  }

  @override
  Future<void> resumeMusic(String musicId) {
    return _invokeMethod('resumeMusic', {
      'musicId': musicId,
    });
  }

  @override
  Future<void> stopMusic(String musicId) {
    return _invokeMethod('stopMusic', {
      'musicId': musicId,
    });
  }

  @override
  Future<void> seekMusic(String musicId, {required int position}) {
    return _invokeMethod('seekMusic', {
      'musicId': musicId,
      'position': position,
    });
  }

  @override
  Future<void> setMusicVolume(String musicId, {required int volume}) {
    return _invokeMethod('setMusicVolume', {
      'musicId': musicId,
      'volume': volume,
    });
  }

  @override
  Future<void> switchAudioTrackType(String musicId) {
    return _invokeMethod('switchAudioTrackType', {
      'musicId': musicId,
    });
  }

  @override
  Future<void> setMusicPitch(String musicId, {required int pitch}) {
    return _invokeMethod('setMusicPitch', {
      'musicId': musicId,
      'pitch': pitch,
    });
  }
}
