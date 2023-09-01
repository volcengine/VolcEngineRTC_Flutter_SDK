// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../api/bytertc_media_defines.dart';
import '../api/bytertc_range_audio_api.dart';
import '../api/bytertc_room_api.dart';
import '../api/bytertc_room_event_handler.dart';
import '../api/bytertc_rts_defines.dart';
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

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  @override
  String get roomId => _roomId;

  @override
  Future<void> destroy() {
    _eventChannel.cancel();
    _eventHandler = null;
    return RTCVideoImpl.instance
            ?.invokeMethod('destroyRTCRoom', {'insId': _insId}) ??
        Future.value();
  }

  @override
  void setRTCRoomEventHandler(RTCRoomEventHandler eventHandler) {
    _eventHandler?.valueObserver = null;
    _eventHandler = eventHandler;
    _eventHandler?.valueObserver = (Map<String, dynamic> arguments) {
      _invokeMethod<void>('eventHandlerSwitches', arguments);
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
  Future<int?> setUserVisibility(bool enable) {
    return _invokeMethod<int>('setUserVisibility', {
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
  Future<int?> leaveRoom() {
    return _invokeMethod<int>('leaveRoom', {'insId': _insId});
  }

  @override
  Future<int?> updateToken(String token) {
    return _invokeMethod<int>('updateToken', {
      'insId': _insId,
      'token': token,
    });
  }

  @override
  Future<int?> setRemoteVideoConfig(
      {required String uid, required RemoteVideoConfig videoConfig}) {
    return _invokeMethod<int>('setRemoteVideoConfig',
        {'insId': _insId, 'uid': uid, 'videoConfig': videoConfig.toMap()});
  }

  @override
  Future<int?> publishStream(MediaStreamType type) {
    return _invokeMethod<int>(
        'publishStream', {'insId': _insId, 'type': type.value});
  }

  @override
  Future<int?> unpublishStream(MediaStreamType type) {
    return _invokeMethod<int>(
        'unpublishStream', {'insId': _insId, 'type': type.value});
  }

  @override
  Future<int?> publishScreen(MediaStreamType type) {
    return _invokeMethod<int>('publishScreen', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<int?> unpublishScreen(MediaStreamType type) {
    return _invokeMethod<int>('unpublishScreen', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<int?> subscribeStream(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<int>('subscribeStream', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<int?> subscribeAllStreams(MediaStreamType type) {
    return _invokeMethod<int>('subscribeAllStreams', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<int?> unsubscribeStream(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<int>('unsubscribeStream', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<int?> unsubscribeAllStreams(MediaStreamType type) {
    return _invokeMethod<int>('unsubscribeAllStreams', {
      'insId': _insId,
      'type': type.value,
    });
  }

  @override
  Future<int?> subscribeScreen(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<int>('subscribeScreen', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<int?> unsubscribeScreen(
      {required String uid, required MediaStreamType type}) {
    return _invokeMethod<int>('unsubscribeScreen', {
      'insId': _insId,
      'uid': uid,
      'type': type.value,
    });
  }

  @override
  Future<int?> pauseAllSubscribedStream(PauseResumeControlMediaType mediaType) {
    return _invokeMethod<int>('pauseAllSubscribedStream', {
      'insId': _insId,
      'mediaType': mediaType.index,
    });
  }

  @override
  Future<int?> resumeAllSubscribedStream(
      PauseResumeControlMediaType mediaType) {
    return _invokeMethod<int>('resumeAllSubscribedStream', {
      'insId': _insId,
      'mediaType': mediaType.index,
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
      'config': config.index,
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
      'config': config.index,
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
  Future<int?> stopForwardStreamToRooms() {
    return _invokeMethod<int>('stopForwardStreamToRooms', {
      'insId': _insId,
    });
  }

  @override
  Future<int?> pauseForwardStreamToAllRooms() {
    return _invokeMethod<int>('pauseForwardStreamToAllRooms', {
      'insId': _insId,
    });
  }

  @override
  Future<int?> resumeForwardStreamToAllRooms() {
    return _invokeMethod<int>('resumeForwardStreamToAllRooms', {
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

  @override
  Future<int?> setRemoteRoomAudioPlaybackVolume(int volume) =>
      _invokeMethod<int>('setRemoteRoomAudioPlaybackVolume', {
        'insId': _insId,
        'volume': volume,
      });

  @override
  Future<int?> setAudioSelectionConfig(
      AudioSelectionPriority audioSelectionPriority) {
    return _invokeMethod<int>('setAudioSelectionConfig', {
      'insId': _insId,
      'audioSelectionPriority': audioSelectionPriority.index,
    });
  }

  @override
  Future<int?> setRoomExtraInfo({required String key, required String value}) {
    return _invokeMethod<int>('setRoomExtraInfo', {
      'insId': _insId,
      'key': key,
      'value': value,
    });
  }

  @override
  Future<int?> startSubtitle(SubtitleConfig subtitleConfig) {
    return _invokeMethod<int>('startSubtitle', {
      'insId': _insId,
      'subtitleConfig': subtitleConfig.toMap(),
    });
  }

  @override
  Future<int?> stopSubtitle() {
    return _invokeMethod<int>('stopSubtitle', {
      'insId': _insId,
    });
  }
}
