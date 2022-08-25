// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../api/bytertc_common_defines.dart';
import '../api/bytertc_range_audio_api.dart';
import '../api/bytertc_room_api.dart';
import '../api/bytertc_room_event_handler.dart';
import '../api/bytertc_spatial_audio_api.dart';
import '../api/bytertc_video_defines.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_range_audio_impl.dart';
import 'bytertc_room_event_impl.dart';
import 'bytertc_spatial_audio_impl.dart';
import 'bytertc_video_impl.dart';

class RTCRoomImpl implements RTCRoom {
  final int _insId;
  final String _roomId;

  late final MethodChannel _channel;
  late final RTCEventChannel _eventChannel;
  RTCRoomEventHandler? _eventHandler;

  RTCRangeAudioImpl? _rangeAudioImpl;
  RTCSpatialAudioImpl? _spatialAudioImpl;

  RTCRoomImpl(int insId, String roomId)
      : _insId = insId,
        _roomId = roomId {
    _channel = MethodChannel('com.bytedance.ve_rtc_room$_insId');
    _eventChannel = RTCEventChannel('com.bytedance.ve_rtc_room_event$_insId');
  }

  void _listenRtcRoomEvent() {
    _eventChannel.subscription ??
        _eventChannel.listen((String methodName, Map<dynamic, dynamic> dic) {
          _eventHandler?.process(methodName, dic);
        });
  }

  Future<T?> _invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  @override
  String get roomId => _roomId;

  @override
  Future<void> destroy() {
    _eventChannel.cancel();
    _eventHandler = null;
    _rangeAudioImpl?.destroy();
    return RTCVideoImpl.invokeMethod('destroyRTCRoom', {'insId': _insId});
  }

  @override
  void setRTCRoomEventHandler(RTCRoomEventHandler eventHandler) {
    _eventHandler?.valueObserver = null;
    _eventHandler = eventHandler;
    _eventHandler?.valueObserver = (Map<String, dynamic> arguments) {
      _invokeMethod('eventHandlerSwitches', arguments);
    };
    _listenRtcRoomEvent();
  }

  @override
  Future<int?> joinRoom(
      {required String token,
      required UserInfo userInfo,
      required RoomConfig roomConfig}) {
    return _invokeMethod<int>('joinRoom', {
      'insId': _insId,
      'token': token,
      'userInfo': userInfo.toMap(),
      'roomConfig': roomConfig.toMap()
    });
  }

  @override
  Future<void> setUserVisibility(bool enable) {
    return _invokeMethod('setUserVisibility', {
      'insId': _insId,
      'enable': enable,
    });
  }

  @override
  Future<int?> setMultiDeviceAVSync(String audioUid) {
    return _invokeMethod<int>('setMultiDeviceAVSync', {
      'insId': _insId,
      'audioUid': audioUid,
    });
  }

  @override
  Future<void> leaveRoom() {
    return _invokeMethod<void>('leaveRoom', {'insId': _insId});
  }

  @override
  Future<void> updateToken(String token) {
    return _invokeMethod('updateToken', {
      'insId': _insId,
      'token': token,
    });
  }

  @override
  Future<void> setRemoteVideoConfig(
      {required String uid, required RemoteVideoConfig videoConfig}) {
    return _invokeMethod<void>('setRemoteVideoConfig',
        {'insId': _insId, 'uid': uid, 'videoConfig': videoConfig.toMap()});
  }

  @override
  Future<void> publishStream(MediaStreamType type) {
    return _invokeMethod<void>(
        'publishStream', {'insId': _insId, 'type': type.value});
  }

  @override
  Future<void> unpublishStream(MediaStreamType type) {
    return _invokeMethod<void>(
        'unpublishStream', {'insId': _insId, 'type': type.value});
  }

  @override
  Future<void> publishScreen(MediaStreamType type) {
    return _invokeMethod<void>('publishScreen', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<void> unpublishScreen(MediaStreamType type) {
    return _invokeMethod<void>('unpublishScreen', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<void> subscribeStream(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<void>('subscribeStream', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<void> unsubscribeStream(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<void>('unsubscribeStream', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<void> subscribeScreen(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<void>('subscribeScreen', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<void> unsubscribeScreen(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<void>('unsubscribeScreen', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<void> pauseAllSubscribedStream(PauseResumeControlMediaType mediaType) {
    return _invokeMethod<void>('pauseAllSubscribedStream', {
      'insId': _insId,
      'mediaType': mediaType.value,
    });
  }

  @override
  Future<void> resumeAllSubscribedStream(
      PauseResumeControlMediaType mediaType) {
    return _invokeMethod<void>('resumeAllSubscribedStream', {
      'insId': _insId,
      'mediaType': mediaType.value,
    });
  }

  @override
  Future<int?> sendUserMessage(
      {required String uid,
      required String message,
      required MessageConfig config}) {
    return _invokeMethod<int>('sendUserMessage', {
      'insId': _insId,
      'uid': uid,
      'message': message,
      'config': config.value,
    });
  }

  @override
  Future<int?> sendUserBinaryMessage(
      {required String uid,
      required Uint8List message,
      required MessageConfig config}) {
    return _invokeMethod<int>('sendUserBinaryMessage', {
      'insId': _insId,
      'uid': uid,
      'message': message,
      'config': config.value,
    });
  }

  @override
  Future<int?> sendRoomMessage(String message) {
    return _invokeMethod<int>('sendRoomMessage', {
      'insId': _insId,
      'message': message,
    });
  }

  @override
  Future<int?> sendRoomBinaryMessage(Uint8List message) {
    return _invokeMethod<int>('sendRoomBinaryMessage', {
      'insId': _insId,
      'message': message,
    });
  }

  @override
  Future<int?> startForwardStreamToRooms(
      List<ForwardStreamInfo> forwardStreamInfos) {
    return _invokeMethod<int>('startForwardStreamToRooms', {
      'insId': _insId,
      'forwardStreamInfos': forwardStreamInfos.map((e) => e.toMap()).toList(),
    });
  }

  @override
  Future<int?> updateForwardStreamToRooms(
      List<ForwardStreamInfo> forwardStreamInfos) {
    return _invokeMethod<int>('updateForwardStreamToRooms', {
      'insId': _insId,
      'forwardStreamInfos': forwardStreamInfos.map((e) => e.toMap()).toList(),
    });
  }

  @override
  Future<void> stopForwardStreamToRooms() {
    return _invokeMethod<void>('stopForwardStreamToRooms', {
      'insId': _insId,
    });
  }

  @override
  Future<void> pauseForwardStreamToAllRooms() {
    return _invokeMethod<void>('pauseForwardStreamToAllRooms', {
      'insId': _insId,
    });
  }

  @override
  Future<void> resumeForwardStreamToAllRooms() {
    return _invokeMethod<void>('resumeForwardStreamToAllRooms', {
      'insId': _insId,
    });
  }

  @override
  RTCRangeAudio get rangeAudio {
    return _rangeAudioImpl ??= RTCRangeAudioImpl(_insId);
  }

  @override
  RTCSpatialAudio get spatialAudio {
    return _spatialAudioImpl ??= RTCSpatialAudioImpl(_insId);
  }
}
