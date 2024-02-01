// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'dart:collection';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../api/bytertc_asr_engine_event_handler.dart';
import '../api/bytertc_audio_defines.dart';
import '../api/bytertc_audio_effect_player_api.dart';
import '../api/bytertc_audio_mixing_api.dart';
import '../api/bytertc_cdn_stream_observer.dart';
import '../api/bytertc_face_detection_observer.dart';
import '../api/bytertc_ktv_manager_api.dart';
import '../api/bytertc_live_transcoding_observer.dart';
import '../api/bytertc_media_defines.dart';
import '../api/bytertc_media_player_api.dart';
import '../api/bytertc_rts_defines.dart';
import '../api/bytertc_sing_scoring_manager_api.dart';
import '../api/bytertc_video_api.dart';
import '../api/bytertc_video_defines.dart';
import '../api/bytertc_video_effect_api.dart';
import '../api/bytertc_video_event_handler.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'bytertc_asr_engine_impl.dart';
import 'bytertc_audio_effect_player_impl.dart';
import 'bytertc_audio_mixing_impl.dart';
import 'bytertc_cdn_stream_observer_impl.dart';
import 'bytertc_face_detection_impl.dart';
import 'bytertc_ktv_manager_impl.dart';
import 'bytertc_live_transcoding_impl.dart';
import 'bytertc_media_player_impl.dart';
import 'bytertc_room_impl.dart';
import 'bytertc_sing_scoring_manager_impl.dart';
import 'bytertc_take_snapshot_observer_impl.dart';
import 'bytertc_video_effect_impl.dart';
import 'bytertc_video_event_impl.dart';

class RTCVideoImpl implements RTCVideo {
  static const MethodChannel _staticChannel =
      MethodChannel('com.bytedance.ve_rtc_plugin');

  static RTCVideoImpl? _instance;
  static int _roomInsId = 0;

  static RTCVideoImpl? get instance => _instance;

  final MethodChannel _channel =
      const MethodChannel('com.bytedance.ve_rtc_video');

  late final RTCEventChannel _eventChannel;
  RTCVideoEventHandler? _eventHandler;

  RTCEventChannel? _liveTranscodingChannel;
  RTCLiveTranscodingObserver? _liveTranscodingObserver;

  RTCEventChannel? _mixedStreamChannel;
  RTCMixedStreamObserver? _mixedStreamObserver;

  RTCEventChannel? _pushSingleStreamToCDNChannel;
  RTCPushSingleStreamToCDNObserver? _pushSingleStreamToCDNObserver;

  RTCEventChannel? _takeSnapshotResultChannel;
  final TakeSnapshotResultObserver _takeSnapshotResultObserver =
      TakeSnapshotResultObserver();

  RTCEventChannel? _asrChannel;
  RTCASREngineEventHandler? _asrEventHandler;

  RTCEventChannel? _faceDetectionChannel;
  RTCFaceDetectionObserver? _faceDetectionObserver;

  RTCVideoEffectImpl? _videoEffectImpl;
  RTCAudioMixingManagerImpl? _audioMixingManagerImpl;
  RTCAudioEffectPlayerImpl? _audioEffectPlayerImpl;
  RTCSingScoringManagerImpl? _singScoringManagerImpl;
  RTCKTVManagerImpl? _ktvManagerImpl;
  final Map<int, RTCMediaPlayerImpl> _mediaPlayerMap = HashMap();

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

  void _listenMixedStreamEvent() {
    _mixedStreamChannel ??= RTCEventChannel('com.bytedance.ve_rtc_mix_stream');
    _mixedStreamChannel?.subscription ??
        _mixedStreamChannel
            ?.listen((String methodName, Map<dynamic, dynamic> dic) {
          _mixedStreamObserver?.process(methodName, dic);
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

  void _listenTakeSnapshotResultEvent() {
    _takeSnapshotResultChannel ??=
        (RTCEventChannel('com.bytedance.ve_rtc_snapshot_result')
          ..listen((methodName, dic) =>
              _takeSnapshotResultObserver.process(methodName, dic)));
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

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  void _destroy() {
    _eventChannel.cancel();
    _asrChannel?.cancel();
    _faceDetectionChannel?.cancel();
    _liveTranscodingChannel?.cancel();
    _mixedStreamChannel?.cancel();
    _pushSingleStreamToCDNChannel?.cancel();
    _takeSnapshotResultChannel?.cancel();
    _videoEffectImpl?.destroy();
    _singScoringManagerImpl?.destroy();
    _ktvManagerImpl?.destroy();
    _audioEffectPlayerImpl?.destroy();
    _mediaPlayerMap.forEach((key, value) {
      value.destroy();
    });
    _mediaPlayerMap.clear();
    _eventHandler = null;
    _asrEventHandler = null;
    _faceDetectionObserver = null;
    _liveTranscodingObserver = null;
    _mixedStreamObserver = null;
    _pushSingleStreamToCDNObserver = null;
    _takeSnapshotResultChannel = null;
    _instance = null;
  }

  Future<T?> invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    return _invokeMethod<T>(method, arguments);
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

  static Future<String?> getSDKVersion() {
    return _staticChannel.invokeMethod<String>('getSDKVersion');
  }

  static Future<int?> setLogConfig(RTCLogConfig logConfig) {
    return _staticChannel
        .invokeMethod<int>('setLogConfig', {'logConfig': logConfig.toMap()});
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
      _staticChannel.invokeMethod('eventHandlerSwitches', arguments);
    };
    _listenEngineEvent();
  }

  @override
  Future<int?> startAudioCapture() {
    return _invokeMethod<int>('startAudioCapture');
  }

  @override
  Future<int?> stopAudioCapture() {
    return _invokeMethod<int>('stopAudioCapture');
  }

  @override
  Future<int?> setAudioScenario(AudioScenario audioScenario) {
    return _invokeMethod<int>(
        'setAudioScenario', {'audioScenario': audioScenario.index});
  }

  @override
  Future<int?> setAudioScene(AudioSceneType audioScene) {
    return _invokeMethod<int>(
        'setAudioScene', {'audioScene': audioScene.index});
  }

  @override
  Future<int?> setAudioProfile(AudioProfileType audioProfile) {
    return _invokeMethod<int>(
        'setAudioProfile', {'audioProfile': audioProfile.index});
  }

  @override
  Future<int?> setAnsMode(AnsMode ansMode) {
    return _invokeMethod<int>('setAnsMode', {'ansMode': ansMode.index});
  }

  @override
  Future<int?> setVoiceChangerType(VoiceChangerType voiceChanger) {
    return _invokeMethod<int>(
        'setVoiceChangerType', {'voiceChanger': voiceChanger.index});
  }

  @override
  Future<int?> setVoiceReverbType(VoiceReverbType voiceReverb) {
    return _invokeMethod<int>(
        'setVoiceReverbType', {'voiceReverb': voiceReverb.index});
  }

  @override
  Future<int?> setLocalVoiceEqualization(VoiceEqualizationConfig config) =>
      _invokeMethod<int>(
          'setLocalVoiceEqualization', {'config': config.toMap()});

  @override
  Future<int?> setLocalVoiceReverbParam(VoiceReverbConfig config) =>
      _invokeMethod<int>(
          'setLocalVoiceReverbParam', {'config': config.toMap()});

  @override
  Future<int?> enableLocalVoiceReverb(bool enable) =>
      _invokeMethod<int>('enableLocalVoiceReverb', {'enable': enable});

  @override
  Future<int?> setCaptureVolume(
      {StreamIndex index = StreamIndex.main, required int volume}) {
    return _invokeMethod<int>(
        'setCaptureVolume', {'index': index.index, 'volume': volume});
  }

  @override
  Future<int?> setPlaybackVolume(int volume) {
    return _invokeMethod<int>('setPlaybackVolume', {'volume': volume});
  }

  @override
  Future<int?> enableAudioPropertiesReport(AudioPropertiesConfig config) {
    return _invokeMethod<int>('enableAudioPropertiesReport', {
      'config': config.toMap(),
    });
  }

  @override
  Future<int?> setRemoteAudioPlaybackVolume(
      {required String roomId, required String uid, required int volume}) {
    return _invokeMethod<int>('setRemoteAudioPlaybackVolume', {
      'roomId': roomId,
      'uid': uid,
      'volume': volume,
    });
  }

  @override
  Future<int?> setEarMonitorMode(EarMonitorMode mode) {
    return _invokeMethod<int>('setEarMonitorMode', {'mode': mode.index});
  }

  @override
  Future<int?> setEarMonitorVolume(int volume) {
    return _invokeMethod<int>('setEarMonitorVolume', {'volume': volume});
  }

  @override
  Future<int?> setBluetoothMode(BluetoothMode mode) {
    if (Platform.isIOS) {
      // Only Support on iOS
      return _invokeMethod<int>('setBluetoothMode', {
        'mode': mode.index,
      });
    } else {
      return Future.value(-1);
    }
  }

  @override
  Future<int?> setLocalVoicePitch(int pitch) {
    return _invokeMethod<int>('setLocalVoicePitch', {'pitch': pitch});
  }

  @override
  Future<int?> enableVocalInstrumentBalance(bool enable) {
    return _invokeMethod<int>(
        'enableVocalInstrumentBalance', {'enable': enable});
  }

  @override
  Future<int?> enablePlaybackDucking(bool enable) {
    return _invokeMethod<int>('enablePlaybackDucking', {'enable': enable});
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
  Future<int?> setScreenVideoEncoderConfig(
      ScreenVideoEncoderConfig screenSolution) {
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
  Future<int?> removeLocalVideo([StreamIndex streamType = StreamIndex.main]) {
    return _invokeMethod<int>('removeLocalVideo', {
      'streamType': streamType.index,
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
      'streamType': streamType.index,
    });
  }

  @override
  Future<int?> startVideoCapture() {
    return _invokeMethod<int>('startVideoCapture');
  }

  @override
  Future<int?> stopVideoCapture() {
    return _invokeMethod<int>('stopVideoCapture');
  }

  @override
  Future<int?> setLocalVideoMirrorType(MirrorType mirrorType) {
    return _invokeMethod<int>('setLocalVideoMirrorType', {
      'mirrorType': mirrorType.value,
    });
  }

  @override
  Future<int?> setRemoteVideoMirrorType(
      RemoteStreamKey streamKey, RemoteMirrorType mirrorType) {
    return _invokeMethod<int>('setRemoteVideoMirrorType', {
      'streamKey': streamKey.toMap(),
      'mirrorType': mirrorType.value,
    });
  }

  @override
  Future<int?> setVideoRotationMode(VideoRotationMode rotationMode) {
    return _invokeMethod<int>('setVideoRotationMode', {
      'rotationMode': rotationMode.index,
    });
  }

  @override
  Future<int?> setVideoOrientation(VideoOrientation orientation) {
    return _invokeMethod<int>('setVideoOrientation', {
      'orientation': orientation.index,
    });
  }

  @override
  Future<int?> setVideoCaptureRotation(VideoRotation rotation) {
    return _invokeMethod<int>('setVideoCaptureRotation', {
      'rotation': rotation.value,
    });
  }

  @override
  Future<int?> switchCamera(CameraId cameraId) {
    return _invokeMethod<int>('switchCamera', {'cameraId': cameraId.index});
  }

  @override
  RTCVideoEffect get videoEffectInterface {
    return _videoEffectImpl ??= RTCVideoEffectImpl();
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
  Future<int?> setVideoEffectAlgoModelPath(String modelPath) {
    return _invokeMethod<int>('setVideoEffectAlgoModelPath', {
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
    return _invokeMethod<int>('setBackgroundSticker', {
      if (modelPath != null) 'modelPath': modelPath,
      if (source != null) 'source': source.toMap(),
    });
  }

  @override
  Future<int?> enableEffectBeauty(bool enable) {
    return _invokeMethod<int>('enableEffectBeauty', {'enable': enable});
  }

  @override
  Future<int?> setBeautyIntensity(
      {required EffectBeautyMode beautyMode, required double intensity}) {
    return _invokeMethod<int>('setBeautyIntensity',
        {'beautyMode': beautyMode.index, 'intensity': intensity});
  }

  @override
  Future<int?> setRemoteVideoSuperResolution({
    required RemoteStreamKey streamKey,
    required VideoSuperResolutionMode mode,
  }) {
    return _invokeMethod<int>('setRemoteVideoSuperResolution',
        {'streamKey': streamKey.toMap(), 'mode': mode.index});
  }

  @override
  Future<int?> setVideoDenoiser({
    required VideoDenoiseMode mode,
  }) {
    return _invokeMethod<int>('setVideoDenoiser', {'mode': mode.index});
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
    return _invokeMethod<double>('getCameraZoomMaxRatio');
  }

  @override
  Future<bool?> isCameraZoomSupported() {
    return _invokeMethod<bool>('isCameraZoomSupported');
  }

  @override
  Future<bool?> isCameraTorchSupported() {
    return _invokeMethod<bool>('isCameraTorchSupported');
  }

  @override
  Future<int?> setCameraTorch(TorchState torchState) {
    return _invokeMethod<int>('setCameraTorch', {
      'torchState': torchState.index,
    });
  }

  @override
  Future<bool?> isCameraFocusPositionSupported() {
    return _invokeMethod<bool>('isCameraFocusPositionSupported');
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
    return _invokeMethod<bool>('isCameraExposurePositionSupported');
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
  Future<int?> enableCameraAutoExposureFaceMode(bool enable) {
    return _invokeMethod<int>('enableCameraAutoExposureFaceMode', {
      'enable': enable,
    });
  }

  @override
  Future<int?> setCameraAdaptiveMinimumFrameRate(int framerate) {
    return _invokeMethod<int>('setCameraAdaptiveMinimumFrameRate', {
      'framerate': framerate,
    });
  }

  @override
  Future<int?> sendSEIMessage(
      {StreamIndex streamIndex = StreamIndex.main,
      required Uint8List message,
      required int repeatCount,
      SEICountPerFrame mode = SEICountPerFrame.single}) {
    return _invokeMethod<int>('sendSEIMessage', {
      'streamIndex': streamIndex.index,
      'message': message,
      'repeatCount': repeatCount,
      'mode': mode.index,
    });
  }

  @override
  Future<int?> sendPublicStreamSEIMessage(
      {StreamIndex streamIndex = StreamIndex.main,
      required int channelId,
      required Uint8List message,
      required int repeatCount,
      SEICountPerFrame mode = SEICountPerFrame.single}) {
    return _invokeMethod<int>('sendPublicStreamSEIMessage', {
      'streamIndex': streamIndex.index,
      'channelId': channelId,
      'message': message,
      'repeatCount': repeatCount,
      'mode': mode.index,
    });
  }

  @override
  Future<int?> setVideoDigitalZoomConfig(
      {required ZoomConfigType type, double size = 0.0}) {
    return _invokeMethod<int>('setVideoDigitalZoomConfig', {
      'type': type.index,
      'size': size,
    });
  }

  @override
  Future<int?> setVideoDigitalZoomControl(ZoomDirectionType direction) {
    return _invokeMethod<int>('setVideoDigitalZoomControl', {
      'direction': direction.index,
    });
  }

  @override
  Future<int?> startVideoDigitalZoomControl(ZoomDirectionType direction) {
    return _invokeMethod<int>('startVideoDigitalZoomControl', {
      'direction': direction.index,
    });
  }

  @override
  Future<int?> stopVideoDigitalZoomControl() {
    return _invokeMethod<int>('stopVideoDigitalZoomControl');
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
    return _invokeMethod<int>('getAudioRoute').then((value) {
      return value?.audioRoute ?? AudioRoute.routeDefault;
    });
  }

  @override
  Future<int?> enableExternalSoundCard(bool enable) {
    return _invokeMethod<int>('enableExternalSoundCard', {
      'enable': enable,
    });
  }

  @override
  Future<int?> startLiveTranscoding(
      {required String taskId,
      required LiveTranscoding transcoding,
      required RTCLiveTranscodingObserver observer}) {
    _liveTranscodingObserver = observer;
    _listenLiveTranscodingEvent();
    return _invokeMethod<int>('startLiveTranscoding', {
      'taskId': taskId,
      'transcoding': transcoding.toMap(),
    });
  }

  @override
  Future<int?> stopLiveTranscoding(String taskId) {
    return _invokeMethod<int>('stopLiveTranscoding', {
      'taskId': taskId,
    });
  }

  @override
  Future<int?> updateLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
  }) {
    return _invokeMethod<int>('updateLiveTranscoding',
        {'taskId': taskId, 'transcoding': transcoding.toMap()});
  }

  @override
  Future<int?> startPushMixedStreamToCDN(
      {required String taskId,
      required MixedStreamConfig mixedConfig,
      RTCMixedStreamObserver? observer}) {
    _mixedStreamObserver = observer;
    _listenMixedStreamEvent();
    return _invokeMethod<int>('startPushMixedStreamToCDN', {
      'taskId': taskId,
      'mixedConfig': mixedConfig.toMap(),
    });
  }

  @override
  Future<int?> updatePushMixedStreamToCDN(
      {required String taskId, required MixedStreamConfig mixedConfig}) {
    return _invokeMethod<int>('updatePushMixedStreamToCDN', {
      'taskId': taskId,
      'mixedConfig': mixedConfig.toMap(),
    });
  }

  @override
  Future<int?> startPushSingleStreamToCDN(
      {required String taskId,
      required PushSingleStreamParam param,
      required RTCPushSingleStreamToCDNObserver observer}) {
    _pushSingleStreamToCDNObserver = observer;
    _listenPushSingleStreamToCDNEvent();
    return _invokeMethod<int>('startPushSingleStreamToCDN',
        {'taskId': taskId, 'param': param.toMap()});
  }

  @override
  Future<int?> stopPushStreamToCDN(String taskId) {
    return _invokeMethod<int>('stopPushStreamToCDN', {'taskId': taskId});
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
  Future<int?> setPublicStreamAudioPlaybackVolume(
      {required String publicStreamId, required int volume}) {
    return _invokeMethod<int>('setPublicStreamAudioPlaybackVolume', {
      'publicStreamId': publicStreamId,
      'volume': volume,
    });
  }

  @override
  Future<int?> setBusinessId(String businessId) {
    return _invokeMethod<int>('setBusinessId', {
      'businessId': businessId,
    });
  }

  @override
  Future<int?> feedback(
      {required List<ProblemFeedbackOption> types, ProblemFeedbackInfo? info}) {
    return _invokeMethod<int>('feedback', {
      'types': types.map((e) => e.value).toList(),
      if (info != null) 'info': info.toMap(),
    });
  }

  @override
  Future<int?> setPublishFallbackOption(PublishFallbackOption option) {
    return _invokeMethod<int>('setPublishFallbackOption', {
      'option': option.index,
    });
  }

  @override
  Future<int?> setSubscribeFallbackOption(SubscribeFallbackOption option) {
    return _invokeMethod<int>('setSubscribeFallbackOption', {
      'option': option.index,
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
  Future<int?> setEncryptInfo(
      {required EncryptType aesType, required String key}) {
    return _invokeMethod<int>('setEncryptInfo', {
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
  Future<int?> startScreenCapture(ScreenMediaType type) {
    return _invokeMethod<int>('startScreenCapture', {
      'type': type.index,
    });
  }

  @override
  Future<int?> updateScreenCapture(ScreenMediaType type) {
    return _invokeMethod<int>('updateScreenCapture', {
      'type': type.index,
    });
  }

  @override
  Future<int?> stopScreenCapture() {
    return _invokeMethod<int>('stopScreenCapture');
  }

  /// Only iOS
  @override
  Future<int?> sendScreenCaptureExtensionMessage(Uint8List message) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return Future<int?>.value(-1);
    }
    return _invokeMethod<int>('sendScreenCaptureExtensionMessage', {
      'message': message,
    });
  }

  @override
  Future<int?> setRuntimeParameters(Map<String, dynamic> params) {
    return _invokeMethod<int>('setRuntimeParameters', {
      'params': params,
    });
  }

  @override
  Future<int?> startASR(
      {required RTCASRConfig asrConfig,
      required RTCASREngineEventHandler handler}) {
    _asrEventHandler = handler;
    _listenAsrEvent();
    return _invokeMethod<int>('startASR', {
      'asrConfig': asrConfig.toMap(),
    });
  }

  @override
  Future<int?> stopASR() {
    return _invokeMethod<int>('stopASR');
  }

  @override
  Future<int?> startFileRecording(
      {StreamIndex streamIndex = StreamIndex.main,
      required RecordingConfig config,
      required RecordingType recordingType}) {
    return _invokeMethod<int>('startFileRecording', {
      'streamIndex': streamIndex.index,
      'config': config.toMap(),
      'recordingType': recordingType.index,
    });
  }

  @override
  Future<int?> stopFileRecording([StreamIndex streamIndex = StreamIndex.main]) {
    return _invokeMethod<int>('stopFileRecording', {
      'streamIndex': streamIndex.index,
    });
  }

  @override
  Future<int?> startAudioRecording(AudioRecordingConfig config) =>
      _invokeMethod<int>('startAudioRecording', {
        'config': config.toMap(),
      });

  @override
  Future<int?> stopAudioRecording() => _invokeMethod<int>('stopAudioRecording');

  @override
  RTCAudioMixingManager get audioMixingManager {
    return _audioMixingManagerImpl ??= RTCAudioMixingManagerImpl();
  }

  @override
  FutureOr<RTCAudioEffectPlayer?> getAudioEffectPlayer() {
    if (_audioEffectPlayerImpl != null) return _audioEffectPlayerImpl;
    return _invokeMethod<bool>('getAudioEffectPlayer').then((value) {
      if (value != true) return null;
      return _audioEffectPlayerImpl ??= RTCAudioEffectPlayerImpl();
    });
  }

  @override
  FutureOr<RTCMediaPlayer?> getMediaPlayer(int playerId) {
    RTCMediaPlayerImpl? player = _mediaPlayerMap[playerId];
    if (player != null) return player;
    return _invokeMethod<bool>('getMediaPlayer', {
      'playerId': playerId,
    }).then((value) {
      if (value != true) return null;
      RTCMediaPlayerImpl player = RTCMediaPlayerImpl(playerId);
      _mediaPlayerMap[playerId] = player;
      return player;
    });
  }

  @override
  Future<int?> login({required String token, required String uid}) {
    return _invokeMethod<int>('login', {
      'token': token,
      'uid': uid,
    });
  }

  @override
  Future<int?> logout() {
    return _invokeMethod<int>('logout');
  }

  @override
  Future<int?> updateLoginToken(String token) {
    return _invokeMethod<int>('updateLoginToken', {
      'token': token,
    });
  }

  @override
  Future<int?> setServerParams(
      {required String signature, required String url}) {
    return _invokeMethod<int>('setServerParams', {
      'signature': signature,
      'url': url,
    });
  }

  @override
  Future<int?> getPeerOnlineStatus(String peerUid) {
    return _invokeMethod<int>('getPeerOnlineStatus', {
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
      'config': config.index,
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
      'config': config.index,
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
  Future<int?> startNetworkDetection(
      {required bool isTestUplink,
      required int expectedUplinkBitrate,
      required bool isTestDownlink,
      required int expectedDownlinkBitrate}) {
    return _invokeMethod<int>('startNetworkDetection', {
      'isTestUplink': isTestUplink,
      'expectedUplinkBitrate': expectedUplinkBitrate,
      'isTestDownlink': isTestDownlink,
      'expectedDownlinkBitrate': expectedDownlinkBitrate,
    });
  }

  @override
  Future<int?> stopNetworkDetection() {
    return _invokeMethod<int>('stopNetworkDetection');
  }

  @override
  Future<int?> setScreenAudioStreamIndex(StreamIndex index) {
    return _invokeMethod<int>('setScreenAudioStreamIndex', {
      'streamIndex': index.index,
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
  Future<int?> muteAudioPlayback(bool muteState) {
    return _invokeMethod<int>('muteAudioPlayback', {
      'muteState': muteState ? 1 : 0,
    });
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
    return _invokeMethod<int>('stopEchoTest');
  }

  @override
  Future<int?> setVideoWatermark(
      {StreamIndex streamIndex = StreamIndex.main,
      required String imagePath,
      required WatermarkConfig watermarkConfig}) {
    return _invokeMethod<int>('setVideoWatermark', {
      'streamIndex': streamIndex.index,
      'imagePath': imagePath,
      'watermarkConfig': watermarkConfig.toMap(),
    });
  }

  @override
  Future<int?> clearVideoWatermark(
      [StreamIndex streamIndex = StreamIndex.main]) {
    return _invokeMethod<int>('clearVideoWatermark', {
      'streamIndex': streamIndex.index,
    });
  }

  @override
  CancelableOperation<LocalSnapshot> takeLocalSnapshot(
      StreamIndex streamIndex, String filePath) {
    _listenTakeSnapshotResultEvent();

    int? _taskId;
    CancelableCompleter<LocalSnapshot> completer =
        CancelableCompleter(onCancel: () {
      var taskId = _taskId;
      if (taskId != null) {
        _takeSnapshotResultObserver.removeLocal(taskId);
      }
    });

    _invokeMethod<int>('takeLocalSnapshot', {
      'streamIndex': streamIndex.index,
      'filePath': filePath,
    }).then((value) {
      if (value != null) {
        if (completer.isCanceled || completer.isCompleted) {
          return;
        }
        _taskId = value;
        _takeSnapshotResultObserver.putLocal(value, completer);
      } else {
        completer.completeError(TakeSnapshotResultObserver.errorNoTaskId);
      }
    }, onError: (error) {
      completer.completeError(TakeSnapshotResultObserver.errorException);
    });

    return completer.operation;
  }

  @override
  CancelableOperation<RemoteSnapshot> takeRemoteSnapshot(
      RemoteStreamKey streamKey, String filePath) {
    _listenTakeSnapshotResultEvent();

    int? _taskId;
    final CancelableCompleter<RemoteSnapshot> completer =
        CancelableCompleter(onCancel: () {
      var taskId = _taskId;
      if (taskId != null) {
        _takeSnapshotResultObserver.removeRemote(taskId);
      }
    });

    _invokeMethod<int>('takeRemoteSnapshot', {
      'streamKey': streamKey.toMap(),
      'filePath': filePath,
    }).then((value) {
      if (value != null) {
        if (completer.isCanceled || completer.isCompleted) {
          return;
        }
        _taskId = value;
        _takeSnapshotResultObserver.putRemote(value, completer);
      } else {
        completer.completeError(TakeSnapshotResultObserver.errorNoTaskId);
      }
    }, onError: (error) {
      completer.completeError(TakeSnapshotResultObserver.errorException);
    });

    return completer.operation;
  }

  @override
  Future<int?> startCloudProxy(List<CloudProxyInfo> cloudProxiesInfo) {
    return _invokeMethod<int>('startCloudProxy', {
      'cloudProxiesInfo': cloudProxiesInfo.map((e) => e.toMap()).toList(),
    });
  }

  @override
  Future<int?> stopCloudProxy() {
    return _invokeMethod<int>('stopCloudProxy');
  }

  @override
  FutureOr<RTCSingScoringManager?> getSingScoringManager() {
    if (_singScoringManagerImpl != null) return _singScoringManagerImpl;
    return _invokeMethod<bool>('getSingScoringManager').then((value) {
      if (value != true) return null;
      return _singScoringManagerImpl ??= RTCSingScoringManagerImpl();
    });
  }

  @override
  Future<int?> setDummyCaptureImagePath(String filePath) {
    return _invokeMethod<int>('setDummyCaptureImagePath', {
      'filePath': filePath,
    });
  }

  @override
  Future<NetworkTimeInfo?> getNetworkTimeInfo() {
    return _invokeMethod<Map<dynamic, dynamic>>('getNetworkTimeInfo')
        .then((value) {
      if (value == null) {
        return null;
      }
      return NetworkTimeInfo.fromMap(value);
    });
  }

  @override
  Future<int?> setAudioAlignmentProperty({
    required RemoteStreamKey streamKey,
    required AudioAlignmentMode mode,
  }) {
    return _invokeMethod<int>('setAudioAlignmentProperty', {
      'streamKey': streamKey.toMap(),
      'mode': mode.index,
    });
  }

  @override
  Future<int?> invokeExperimentalAPI(String param) {
    return _invokeMethod<int>('invokeExperimentalAPI', {
      'param': param,
    });
  }

  @override
  FutureOr<RTCKTVManager?> getKTVManager() {
    if (_ktvManagerImpl != null) return _ktvManagerImpl;
    return _invokeMethod<bool>('getKTVManager').then((value) {
      if (value != true) return null;
      return _ktvManagerImpl ??= RTCKTVManagerImpl();
    });
  }

  @override
  Future<int?> startHardwareEchoDetection(String testAudioFilePath) {
    return _invokeMethod<int>('startHardwareEchoDetection', {
      'testAudioFilePath': testAudioFilePath,
    });
  }

  @override
  Future<int?> stopHardwareEchoDetection() {
    return _invokeMethod<int>('stopHardwareEchoDetection');
  }

  @override
  Future<int?> setCellularEnhancement(MediaTypeEnhancementConfig config) {
    return _invokeMethod<int>('setCellularEnhancement', {
      'config': config.toMap(),
    });
  }

  @override
  Future<int?> setLocalProxy(List<LocalProxyConfiguration>? configurations) {
    return _invokeMethod<int>('setLocalProxy', {
      if (configurations != null)
        'configurations':
            configurations.map((e) => e.toMap()).toList(growable: false),
    });
  }
}
