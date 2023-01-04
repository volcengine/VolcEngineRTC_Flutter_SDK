// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_audio_mixing_api.dart';
import '../api/bytertc_asr_engine_event_handler.dart';
import '../api/bytertc_common_defines.dart';
import '../api/bytertc_face_detection_observer.dart';
import '../api/bytertc_live_transcoding_observer.dart';
import '../api/bytertc_push_single_stream_to_cdn_observer.dart';
import '../api/bytertc_video_api.dart';
import '../api/bytertc_video_defines.dart';
import '../api/bytertc_video_event_handler.dart';
import 'bytertc_asr_engine_impl.dart';
import 'bytertc_audio_mixing_impl.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_face_detection_impl.dart';
import 'bytertc_live_transcoding_impl.dart';
import 'bytertc_push_single_stream_to_cdn_impl.dart';
import 'bytertc_room_impl.dart';
import 'bytertc_video_event_impl.dart';

class RTCVideoImpl implements RTCVideo {
  static const MethodChannel _staticChannel =
      MethodChannel('com.bytedance.ve_rtc_video');
  static RTCVideoImpl? _instance;
  static int _roomInsId = 0;

  static RTCVideoImpl? get instance => _instance;

  RTCAudioMixingManagerImpl? _audioMixingManagerImpl;

  late final RTCEventChannel _eventChannel;
  RTCVideoEventHandler? _eventHandler;

  RTCEventChannel? _liveTranscodingChannel;
  RTCLiveTranscodingObserver? _liveTranscodingObserver;

  RTCEventChannel? _pushSingleStreamToCDNChannel;
  RTCPushSingleStreamToCDNObserver? _pushSingleStreamToCDNObserver;

  RTCEventChannel? _asrChannel;
  RTCASREngineEventHandler? _asrEventHandler;

  RTCEventChannel? _faceDetectionChannel;
  RTCFaceDetectionObserver? _faceDetectionObserver;

  RTCVideoImpl._() {
    _eventChannel = RTCEventChannel('com.bytedance.ve_rtc_video_event');
  }

  void _listenEngineEvent() {
    _eventChannel.subscription ??
        _eventChannel.listen((String methodName, Map<dynamic, dynamic> dic) {
          _eventHandler?.process(methodName, dic);
        });
  }

  void _listenLiveTranscodingEvent() {
    _liveTranscodingChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_live_transcoding');
    _liveTranscodingChannel?.subscription ??
        _liveTranscodingChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _liveTranscodingObserver?.process(methodName, dic);
        });
  }

  void _listenPushSingleStreamToCDNEvent() {
    _pushSingleStreamToCDNChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_push_single_stream_to_cdn');
    _pushSingleStreamToCDNChannel?.subscription ??
        _pushSingleStreamToCDNChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _pushSingleStreamToCDNObserver?.process(methodName, dic);
        });
  }

  void _listenAsrEvent() {
    _asrChannel ??= RTCEventChannel('com.bytedance.ve_rtc_asr');
    _asrChannel?.subscription ??
        _asrChannel?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _asrEventHandler?.process(methodName, dic);
        });
  }

  void _listenFaceDetectionEvent() {
    _faceDetectionChannel ??=
        RTCEventChannel('com.bytedance.ve_rtc_face_detection');
    _faceDetectionChannel?.subscription ??
        _faceDetectionChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _faceDetectionObserver?.process(methodName, dic);
        });
  }

  static Future<T?> _invokeMethod<T>(
      String method, Map<String, dynamic>? arguments) {
    return _staticChannel.invokeMethod(method, arguments);
  }

  void _destroy() {
    _eventChannel.cancel();
    _asrChannel?.cancel();
    _faceDetectionChannel?.cancel();
    _liveTranscodingChannel?.cancel();
    _pushSingleStreamToCDNChannel?.cancel();
    _eventHandler = null;
    _asrEventHandler = null;
    _faceDetectionObserver = null;
    _liveTranscodingObserver = null;
    _pushSingleStreamToCDNObserver = null;
    _instance = null;
  }

  static Future<T?> invokeMethod<T>(
      String method, Map<String, dynamic>? arguments) {
    return _invokeMethod(method, arguments);
  }

  static Future<RTCVideoImpl?> createRTCVideo(RTCVideoContext context) async {
    if (_instance != null) return _instance;
    _instance = RTCVideoImpl._();
    if (context.eventHandler != null) {
      _instance!.setRTCVideoEventHandler(context.eventHandler!);
    }
    bool? res = await _staticChannel.invokeMethod<bool>(
        'createRTCVideo', context.toMap());
    if (res != true) {
      _instance?._destroy();
    }
    return _instance;
  }

  static Future<String?> getSdkVersion() {
    return _staticChannel.invokeMethod<String>('getSdkVersion');
  }

  static Future<String?> getErrorDescription(int code) {
    return _staticChannel
        .invokeMethod<String>('getErrorDescription', {'code': code});
  }

  @override
  Future<void> destroy() {
    _destroy();
    return _staticChannel.invokeMethod('destroyRTCVideo');
  }

  @override
  void setRTCVideoEventHandler(RTCVideoEventHandler handler) {
    _eventHandler?.valueObserver = null;
    _eventHandler = handler;
    _eventHandler?.valueObserver = (Map<String, dynamic> arguments) {
      _invokeMethod('eventHandlerSwitches', arguments);
    };
    _listenEngineEvent();
  }

  @override
  Future<void> startAudioCapture() {
    return _invokeMethod('startAudioCapture', null);
  }

  @override
  Future<void> stopAudioCapture() {
    return _invokeMethod('stopAudioCapture', null);
  }

  @override
  Future<void> setAudioScenario(AudioScenario audioScenario) {
    return _invokeMethod(
        'setAudioScenario', {'audioScenario': audioScenario.value});
  }

  @override
  Future<void> setAudioProfile(AudioProfileType audioProfile) {
    return _invokeMethod<void>(
        'setAudioProfile', {'audioProfile': audioProfile.value});
  }

  @override
  Future<void> setVoiceChangerType(VoiceChangerType voiceChanger) {
    return _invokeMethod<void>(
        'setVoiceChangerType', {'voiceChanger': voiceChanger.value});
  }

  @override
  Future<void> setVoiceReverbType(VoiceReverbType voiceReverb) {
    return _invokeMethod<void>(
        'setVoiceReverbType', {'voiceReverb': voiceReverb.value});
  }

  @override
  Future<void> setCaptureVolume(
      {StreamIndex index = StreamIndex.main, required int volume}) {
    return _invokeMethod<void>(
        'setCaptureVolume', {'index': index.value, 'volume': volume});
  }

  @override
  Future<void> setPlaybackVolume(int volume) {
    return _invokeMethod<void>('setPlaybackVolume', {'volume': volume});
  }

  @override
  Future<void> enableAudioPropertiesReport(AudioPropertiesConfig config) {
    return _invokeMethod<void>('enableAudioPropertiesReport', {
      'config': config.toMap(),
    });
  }

  @override
  Future<void> setRemoteAudioPlaybackVolume(
      {required String roomId, required String uid, required int volume}) {
    return _invokeMethod<void>('setRemoteAudioPlaybackVolume', {
      'roomId': roomId,
      'uid': uid,
      'volume': volume,
    });
  }

  @override
  Future<void> setEarMonitorMode(EarMonitorMode mode) {
    return _invokeMethod<void>('setEarMonitorMode', {'mode': mode.value});
  }

  @override
  Future<void> setEarMonitorVolume(int volume) {
    return _invokeMethod<void>('setEarMonitorVolume', {'volume': volume});
  }

  @override
  Future<void> setLocalVoicePitch(int pitch) {
    return _invokeMethod<void>('setLocalVoicePitch', {'pitch': pitch});
  }

  @override
  Future<void> enableVocalInstrumentBalance(bool enable) {
    return _invokeMethod<void>(
        'enableVocalInstrumentBalance', {'enable': enable});
  }

  @override
  Future<void> enablePlaybackDucking(bool enable) {
    return _invokeMethod<void>('enablePlaybackDucking', {'enable': enable});
  }

  @override
  Future<int?> enableSimulcastMode(bool enable) {
    return _invokeMethod<int>('enableSimulcastMode', {'enable': enable});
  }

  @override
  Future<int?> setMaxVideoEncoderConfig(VideoEncoderConfig maxSolution) {
    return _invokeMethod<int>('setMaxVideoEncoderConfig', {
      'maxSolution': maxSolution.toMap(),
    });
  }

  @override
  Future<int?> setVideoEncoderConfig(
      List<VideoEncoderConfig> channelSolutions) {
    return _invokeMethod<int>('setVideoEncoderConfig', {
      'channelSolutions': channelSolutions.map((e) => e.toMap()).toList(),
    });
  }

  @override
  Future<int?> setScreenVideoEncoderConfig(VideoEncoderConfig screenSolution) {
    return _invokeMethod<int>('setScreenVideoEncoderConfig', {
      'screenSolution': screenSolution.toMap(),
    });
  }

  @override
  Future<int?> setVideoCaptureConfig(VideoCaptureConfig config) {
    return _invokeMethod<int>('setVideoCaptureConfig', {
      'config': config.toMap(),
    });
  }

  @override
  Future<int?> removeLocalVideo({StreamIndex streamType = StreamIndex.main}) {
    return _invokeMethod<int>('removeLocalVideo', {
      'streamType': streamType.value,
    });
  }

  @override
  Future<int?> removeRemoteVideo(
      {required String roomId,
      required String uid,
      StreamIndex streamType = StreamIndex.main}) {
    return _invokeMethod<int>('removeRemoteVideo', {
      'roomId': roomId,
      'uid': uid,
      'streamType': streamType.value,
    });
  }

  @override
  Future<void> startVideoCapture() {
    return _invokeMethod<void>('startVideoCapture', null);
  }

  @override
  Future<void> stopVideoCapture() {
    return _invokeMethod<void>('stopVideoCapture', null);
  }

  @override
  Future<int?> setLocalVideoMirrorType(MirrorType mirrorType) {
    return _invokeMethod<int>('setLocalVideoMirrorType', {
      'mirrorType': mirrorType.value,
    });
  }

  @override
  Future<int?> setVideoRotationMode(VideoRotationMode rotationMode) {
    return _invokeMethod<int>('setVideoRotationMode', {
      'rotationMode': rotationMode.value,
    });
  }

  @override
  Future<void> setVideoOrientation(VideoOrientation orientation) {
    return _invokeMethod<int>('setVideoOrientation', {
      'orientation': orientation.value,
    });
  }

  @override
  Future<int?> switchCamera(CameraId cameraId) {
    return _invokeMethod<int>('switchCamera', {'cameraId': cameraId.value});
  }

  @override
  Future<int?> checkVideoEffectLicense(String licenseFile) {
    return _invokeMethod<int>(
        'checkVideoEffectLicense', {'licenseFile': licenseFile});
  }

  @override
  Future<int?> enableVideoEffect(bool enable) {
    return _invokeMethod<int>('enableVideoEffect', {'enable': enable});
  }

  @override
  Future<void> setVideoEffectAlgoModelPath(String modelPath) {
    return _invokeMethod('setVideoEffectAlgoModelPath', {
      'modelPath': modelPath,
    });
  }

  @override
  Future<int?> setVideoEffectNodes(List<String>? effectNodes) {
    return _invokeMethod<int>('setVideoEffectNodes',
        effectNodes != null ? {'effectNodes': effectNodes} : null);
  }

  @override
  Future<int?> updateVideoEffectNode(
      {required String effectNode,
      required String key,
      required double value}) {
    return _invokeMethod<int>('updateVideoEffectNode',
        {'effectNode': effectNode, 'key': key, 'value': value});
  }

  @override
  Future<int?> setVideoEffectColorFilter(String? resFile) {
    return _invokeMethod<int>('setVideoEffectColorFilter',
        resFile != null ? {'resFile': resFile} : null);
  }

  @override
  Future<int?> setVideoEffectColorFilterIntensity(double intensity) {
    return _invokeMethod<int>(
        'setVideoEffectColorFilterIntensity', {'intensity': intensity});
  }

  @override
  Future<int?> setBackgroundSticker(
      {String? modelPath, VirtualBackgroundSource? source}) {
    Map<String, dynamic>? dic;
    if (modelPath != null || source != null) {
      dic = Map();
      if (modelPath != null) {
        dic['modelPath'] = modelPath;
      }
      if (source != null) {
        dic['source'] = source.toMap();
      }
    }
    return _invokeMethod<int>('setBackgroundSticker', dic);
  }

  @override
  Future<int?> enableEffectBeauty(bool enable) {
    return _invokeMethod<int>('enableEffectBeauty', {'enable': enable});
  }

  @override
  Future<int?> setBeautyIntensity(
      {required EffectBeautyMode beautyMode, required double intensity}) {
    return _invokeMethod<int>('setBeautyIntensity',
        {'beautyMode': beautyMode.value, 'intensity': intensity});
  }

  @override
  Future<int?> registerFaceDetectionObserver(
      {RTCFaceDetectionObserver? observer, int interval = 0}) {
    _faceDetectionObserver = observer;
    if (observer != null) {
      _listenFaceDetectionEvent();
    } else {
      _faceDetectionChannel?.cancel();
    }
    return _invokeMethod<int>('registerFaceDetectionObserver', {
      'observer': observer != null,
      'interval': interval,
    });
  }

  @override
  Future<int?> setCameraZoomRatio(double zoom) {
    return _invokeMethod<int>('setCameraZoomRatio', {
      'zoom': zoom,
    });
  }

  @override
  Future<double?> getCameraZoomMaxRatio() {
    return _invokeMethod<double>('getCameraZoomMaxRatio', null);
  }

  @override
  Future<bool?> isCameraZoomSupported() {
    return _invokeMethod<bool>('isCameraZoomSupported', null);
  }

  @override
  Future<bool?> isCameraTorchSupported() {
    return _invokeMethod<bool>('isCameraTorchSupported', null);
  }

  @override
  Future<int?> setCameraTorch(TorchState torchState) {
    return _invokeMethod<int>('setCameraTorch', {
      'torchState': torchState.value,
    });
  }

  @override
  Future<bool?> isCameraFocusPositionSupported() {
    return _invokeMethod<bool>('isCameraFocusPositionSupported', null);
  }

  @override
  Future<int?> setCameraFocusPosition(Offset position) {
    return _invokeMethod<int>('setCameraFocusPosition', {
      'x': position.dx,
      'y': position.dy,
    });
  }

  @override
  Future<bool?> isCameraExposurePositionSupported() {
    return _invokeMethod<bool>('isCameraExposurePositionSupported', null);
  }

  @override
  Future<int?> setCameraExposurePosition(Offset position) {
    return _invokeMethod<int>('setCameraExposurePosition', {
      'x': position.dx,
      'y': position.dy,
    });
  }

  @override
  Future<int?> setCameraExposureCompensation(double val) {
    return _invokeMethod<int>('setCameraExposureCompensation', {
      'val': val,
    });
  }

  @override
  Future<int?> sendSEIMessage(
      {StreamIndex streamIndex = StreamIndex.main,
      required Uint8List message,
      required int repeatCount}) {
    return _invokeMethod<int>('sendSEIMessage', {
      'streamIndex': streamIndex.value,
      'message': message,
      'repeatCount': repeatCount,
    });
  }

  @override
  Future<int?> setAudioRoute(AudioRoute audioRoute) {
    return _invokeMethod<int>('setAudioRoute', {
      'audioRoute': audioRoute.value,
    });
  }

  @override
  Future<int?> setDefaultAudioRoute(AudioRoute audioRoute) {
    return _invokeMethod<int>('setDefaultAudioRoute', {
      'audioRoute': audioRoute.value,
    });
  }

  @override
  Future<AudioRoute> getAudioRoute() {
    return _invokeMethod<int>('getAudioRoute', null).then((value) {
      return value?.audioRoute ?? AudioRoute.unknown;
    });
  }

  @override
  Future<void> enableExternalSoundCard(bool enable) {
    return _invokeMethod<void>('enableExternalSoundCard', {
      'enable': enable,
    });
  }

  @override
  Future<void> startLiveTranscoding(
      {required String taskId,
      required LiveTranscoding transcoding,
      required RTCLiveTranscodingObserver observer}) {
    _liveTranscodingObserver = observer;
    _listenLiveTranscodingEvent();
    return _invokeMethod<void>('startLiveTranscoding', {
      'taskId': taskId,
      'transcoding': transcoding.toMap(),
    });
  }

  @override
  Future<void> stopLiveTranscoding(String taskId) async {
    await _invokeMethod<void>('stopLiveTranscoding', {
      'taskId': taskId,
    });
    _liveTranscodingChannel?.cancel();
    _liveTranscodingObserver = null;
  }

  @override
  Future<void> updateLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
  }) {
    return _invokeMethod<void>('updateLiveTranscoding',
        {'taskId': taskId, 'transcoding': transcoding.toMap()});
  }

  @override
  Future<void> startPushSingleStreamToCDN(
      {required String taskId,
      required PushSingleStreamParam param,
      required RTCPushSingleStreamToCDNObserver observer}) {
    _pushSingleStreamToCDNObserver = observer;
    _listenPushSingleStreamToCDNEvent();
    return _invokeMethod<void>('startPushSingleStreamToCDN',
        {'taskId': taskId, 'param': param.toMap()});
  }

  @override
  Future<void> stopPushStreamToCDN(String taskId) async {
    await _invokeMethod<void>('stopPushStreamToCDN', {'taskId': taskId});
    _pushSingleStreamToCDNChannel?.cancel();
    _pushSingleStreamToCDNObserver = null;
  }

  @override
  Future<int?> startPushPublicStream(
      {required String publicStreamId,
      required PublicStreaming publicStreamParam}) {
    return _invokeMethod<int>('startPushPublicStream', {
      'publicStreamId': publicStreamId,
      'publicStreamParam': publicStreamParam.toMap(),
    });
  }

  @override
  Future<int?> stopPushPublicStream(String publicStreamId) {
    return _invokeMethod<int>('stopPushPublicStream', {
      'publicStreamId': publicStreamId,
    });
  }

  @override
  Future<int?> updatePublicStreamParam(
      {required String publicStreamId,
      required PublicStreaming publicStreamParam}) {
    return _invokeMethod<int>('updatePublicStreamParam', {
      'publicStreamId': publicStreamId,
      'publicStreamParam': publicStreamParam.toMap(),
    });
  }

  @override
  Future<int?> startPlayPublicStream(String publicStreamId) {
    return _invokeMethod<int>('startPlayPublicStream', {
      'publicStreamId': publicStreamId,
    });
  }

  @override
  Future<int?> stopPlayPublicStream(String publicStreamId) {
    return _invokeMethod<int>('stopPlayPublicStream', {
      'publicStreamId': publicStreamId,
    });
  }

  @override
  Future<int?> removePublicStreamVideo(String publicStreamId) {
    return _invokeMethod<int>('removePublicStreamVideo', {
      'publicStreamId': publicStreamId,
    });
  }

  @override
  Future<void> setBusinessId(String businessId) {
    return _invokeMethod('setBusinessId', {
      'businessId': businessId,
    });
  }

  @override
  Future<int?> feedback(
      {required List<ProblemFeedback> types, required String problemDesc}) {
    return _invokeMethod<int>('feedback', {
      'types': types.map((e) => e.value).toList(),
      'problemDesc': problemDesc,
    });
  }

  @override
  Future<int?> setPublishFallbackOption(PublishFallbackOption option) {
    return _invokeMethod<int>('setPublishFallbackOption', {
      'option': option.value,
    });
  }

  @override
  Future<int?> setSubscribeFallbackOption(SubscribeFallbackOption option) {
    return _invokeMethod<int>('setSubscribeFallbackOption', {
      'option': option.value,
    });
  }

  @override
  Future<int?> setRemoteUserPriority(
      {required String roomId,
      required String uid,
      required RemoteUserPriority priority}) {
    return _invokeMethod<int>('setRemoteUserPriority', {
      'roomId': roomId,
      'uid': uid,
      'priority': priority.value,
    });
  }

  @override
  Future<void> setEncryptInfo(
      {required EncryptType aesType, required String key}) {
    return _invokeMethod<void>('setEncryptInfo', {
      'aesType': aesType.index,
      'key': key,
    });
  }

  @override
  Future<RTCRoomImpl?> createRTCRoom(String roomId) async {
    int roomInsId = _roomInsId++;
    bool? res = await _invokeMethod<bool>(
        'createRTCRoom', {'roomInsId': roomInsId, 'roomId': roomId});
    if (res != true) {
      return null;
    }
    return RTCRoomImpl(roomInsId, roomId);
  }

  @override
  Future<void> startScreenCapture(ScreenMediaType type) {
    return _invokeMethod<void>('startScreenCapture', {
      'type': type.value,
    });
  }

  @override
  Future<void> updateScreenCapture(ScreenMediaType type) {
    return _invokeMethod<void>('updateScreenCapture', {
      'type': type.value,
    });
  }

  @override
  Future<void> stopScreenCapture() {
    return _invokeMethod<void>('stopScreenCapture', null);
  }

  /// Only iOS
  @override
  Future<void> sendScreenCaptureExtensionMessage(Uint8List message) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return Future<void>.value(null);
    }
    return _invokeMethod<void>('sendScreenCaptureExtensionMessage', {
      'message': message,
    });
  }

  @override
  Future<void> setRuntimeParameters(Map<String, dynamic> params) {
    return _invokeMethod<void>('setRuntimeParameters', {
      'params': params,
    });
  }

  @override
  Future<void> startASR(
      {required RTCASRConfig asrConfig,
      required RTCASREngineEventHandler handler}) {
    _asrEventHandler = handler;
    _listenAsrEvent();
    return _invokeMethod<void>('startASR', {
      'asrConfig': asrConfig.toMap(),
    });
  }

  @override
  Future<void> stopASR() async {
    await _invokeMethod<void>('stopASR', null);
    _asrChannel?.cancel();
    _asrEventHandler = null;
  }

  @override
  Future<int?> startFileRecording(
      {StreamIndex streamIndex = StreamIndex.main,
      required RecordingConfig config,
      required RecordingType recordingType}) {
    return _invokeMethod<int>('startFileRecording', {
      'streamIndex': streamIndex.value,
      'config': config.toMap(),
      'recordingType': recordingType.value,
    });
  }

  @override
  Future<void> stopFileRecording({StreamIndex streamIndex = StreamIndex.main}) {
    return _invokeMethod<void>('stopFileRecording', {
      'streamIndex': streamIndex.value,
    });
  }

  @override
  RTCAudioMixingManager get audioMixingManager {
    return _audioMixingManagerImpl ??= RTCAudioMixingManagerImpl();
  }

  @override
  Future<int?> login({required String token, required String uid}) {
    return _invokeMethod<int>('login', {
      'token': token,
      'uid': uid,
    });
  }

  @override
  Future<void> logout() {
    return _invokeMethod<void>('logout', null);
  }

  @override
  Future<void> updateLoginToken(String token) {
    return _invokeMethod<void>('updateLoginToken', {
      'token': token,
    });
  }

  @override
  Future<void> setServerParams(
      {required String signature, required String url}) {
    return _invokeMethod<void>('setServerParams', {
      'signature': signature,
      'url': url,
    });
  }

  @override
  Future<void> getPeerOnlineStatus(String peerUid) {
    return _invokeMethod<void>('getPeerOnlineStatus', {
      'peerUid': peerUid,
    });
  }

  @override
  Future<int?> sendUserMessageOutsideRoom(
      {required String uid,
      required String message,
      required MessageConfig config}) {
    return _invokeMethod<int>('sendUserMessageOutsideRoom', {
      'uid': uid,
      'message': message,
      'config': config.value,
    });
  }

  @override
  Future<int?> sendUserBinaryMessageOutsideRoom(
      {required String uid,
      required Uint8List message,
      required MessageConfig config}) {
    return _invokeMethod<int>('sendUserBinaryMessageOutsideRoom', {
      'uid': uid,
      'message': message,
      'config': config.value,
    });
  }

  @override
  Future<int?> sendServerMessage(String message) {
    return _invokeMethod<int>('sendServerMessage', {
      'message': message,
    });
  }

  @override
  Future<int?> sendServerBinaryMessage(Uint8List message) {
    return _invokeMethod<int>('sendServerBinaryMessage', {
      'message': message,
    });
  }

  @override
  Future<NetworkDetectionStartReturn> startNetworkDetection(
      {required bool isTestUplink,
      required int expectedUplinkBitrate,
      required bool isTestDownlink,
      required int expectedDownlinkBitrate}) {
    return _invokeMethod<int>('startNetworkDetection', {
      'isTestUplink': isTestUplink,
      'expectedUplinkBitrate': expectedUplinkBitrate,
      'isTestDownlink': isTestDownlink,
      'expectedDownlinkBitrate': expectedDownlinkBitrate,
    }).then((value) {
      return value?.networkDetectionStartReturn ??
          NetworkDetectionStartReturn.notSupport;
    });
  }

  @override
  Future<void> stopNetworkDetection() {
    return _invokeMethod<int>('stopNetworkDetection', null);
  }

  @override
  Future<void> setScreenAudioStreamIndex(StreamIndex index) {
    return _invokeMethod<void>('setScreenAudioStreamIndex', {
      'streamIndex': index.value,
    });
  }

  @override
  Future<int?> sendStreamSyncInfo(
      {required Uint8List data, required StreamSyncInfoConfig config}) {
    return _invokeMethod<int>('sendStreamSyncInfo', {
      'data': data,
      'config': config.toMap(),
    });
  }

  @override
  Future<void> muteAudioPlayback(bool muteState) {
    return _invokeMethod<void>('muteAudioPlayback', {
      'muteState': muteState ? 1 : 0,
    });
  }

  @override
  Future<void> setVideoWatermark(
      {StreamIndex streamIndex = StreamIndex.main,
      required String imagePath,
      required WatermarkConfig watermarkConfig}) {
    return _invokeMethod<void>('setVideoWatermark', {
      'streamIndex': streamIndex.value,
      'imagePath': imagePath,
      'watermarkConfig': watermarkConfig.toMap(),
    });
  }

  @override
  Future<void> clearVideoWatermark(
      {StreamIndex streamIndex = StreamIndex.main}) {
    return _invokeMethod<void>('clearVideoWatermark', {
      'streamIndex': streamIndex.value,
    });
  }

  @override
  Future<void> startCloudProxy(List<CloudProxyInfo> cloudProxiesInfo) {
    return _invokeMethod<void>('startCloudProxy', {
      'cloudProxiesInfo': cloudProxiesInfo.map((e) => e.toMap()).toList(),
    });
  }

  @override
  Future<void> stopCloudProxy() {
    return _invokeMethod<void>('stopCloudProxy', null);
  }

  @override
  Future<int?> startEchoTest(
      {required EchoTestConfig config, required int delayTime}) {
    return _invokeMethod<int>('startEchoTest', {
      'config': config.toMap(),
      'delayTime': delayTime,
    });
  }

  @override
  Future<int?> stopEchoTest() {
    return _invokeMethod<int>('stopEchoTest', null);
  }

  //@override
  Future<int?> setDummyCaptureImagePath(String filePath) {
    return _invokeMethod<int>('setDummyCaptureImagePath', {
      'filePath': filePath,
    });
  }
}
