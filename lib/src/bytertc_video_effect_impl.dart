// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/services.dart';

import '../api/bytertc_face_detection_observer.dart';
import '../api/bytertc_video_defines.dart';
import '../api/bytertc_video_effect_api.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_face_detection_impl.dart';

class RTCVideoEffectImpl implements RTCVideoEffect {
  final MethodChannel _methodChannel =
      const MethodChannel('com.bytedance.ve_rtc_video_effect');
  RTCEventChannel? _faceDetectionChannel;
  RTCFaceDetectionObserver? _faceDetectionObserver;

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _methodChannel.invokeMethod(method, arguments);
  }

  void _listenFaceDetectionEvent() {
    _faceDetectionChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_video_effect_face_detection');
    _faceDetectionChannel?.subscription ??
        _faceDetectionChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _faceDetectionObserver?.process(methodName, dic);
        });
  }

  void destroy() {
    _faceDetectionChannel?.cancel();
    _faceDetectionObserver = null;
  }

  @override
  Future<int?> initCVResource(String licenseFile, String modelPath) {
    return _invokeMethod<int>('initCVResource', {
      'licenseFile': licenseFile,
      'modelPath': modelPath,
    });
  }

  @override
  Future<int?> enableVideoEffect() {
    return _invokeMethod<int>('enableVideoEffect');
  }

  @override
  Future<int?> disableVideoEffect() {
    return _invokeMethod<int>('disableVideoEffect');
  }

  @override
  Future<int?> setEffectNodes(List<String>? effectNodes) {
    return _invokeMethod<int>('setEffectNodes',
        effectNodes != null ? {'effectNodes': effectNodes} : null);
  }

  @override
  Future<int?> updateEffectNode(
      {required String effectNode,
      required String key,
      required double value}) {
    return _invokeMethod<int>('updateEffectNode',
        {'effectNode': effectNode, 'key': key, 'value': value});
  }

  @override
  Future<int?> setColorFilter(String? resFile) {
    return _invokeMethod<int>(
        'setColorFilter', resFile != null ? {'resFile': resFile} : null);
  }

  @override
  Future<int?> setColorFilterIntensity(double intensity) {
    return _invokeMethod<int>(
        'setColorFilterIntensity', {'intensity': intensity});
  }

  @override
  Future<int?> enableVirtualBackground(
      {required String modelPath, required VirtualBackgroundSource source}) {
    return _invokeMethod<int>('enableVirtualBackground',
        {'modelPath': modelPath, 'source': source.toMap()});
  }

  @override
  Future<int?> disableVirtualBackground() {
    return _invokeMethod<int>('disableVirtualBackground');
  }

  @override
  Future<int?> enableFaceDetection(
      {required RTCFaceDetectionObserver observer,
      required String modelPath,
      int interval = 0}) {
    _faceDetectionObserver = observer;
    _listenFaceDetectionEvent();
    return _invokeMethod<int>('enableFaceDetection', {
      'interval': interval,
      'modelPath': modelPath,
    });
  }

  @override
  Future<int?> disableFaceDetection() async {
    int? value = await _invokeMethod<int>('disableFaceDetection');
    _faceDetectionObserver = null;
    _faceDetectionChannel?.cancel();
    _faceDetectionChannel = null;
    return value;
  }
}
