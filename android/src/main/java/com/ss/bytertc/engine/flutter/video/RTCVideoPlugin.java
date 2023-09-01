/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.NetworkTimeInfo;
import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.ScreenVideoEncoderConfig;
import com.ss.bytertc.engine.VideoCanvas;
import com.ss.bytertc.engine.VideoEncoderConfig;
import com.ss.bytertc.engine.audio.IAudioEffectPlayer;
import com.ss.bytertc.engine.audio.IMediaPlayer;
import com.ss.bytertc.engine.audio.ISingScoringManager;
import com.ss.bytertc.engine.data.AudioAlignmentMode;
import com.ss.bytertc.engine.data.AudioPropertiesConfig;
import com.ss.bytertc.engine.data.AudioRecordingConfig;
import com.ss.bytertc.engine.data.AudioRoute;
import com.ss.bytertc.engine.data.CameraId;
import com.ss.bytertc.engine.data.CloudProxyInfo;
import com.ss.bytertc.engine.data.EarMonitorMode;
import com.ss.bytertc.engine.data.EchoTestConfig;
import com.ss.bytertc.engine.data.EffectBeautyMode;
import com.ss.bytertc.engine.data.MirrorType;
import com.ss.bytertc.engine.data.MuteState;
import com.ss.bytertc.engine.data.RTCASRConfig;
import com.ss.bytertc.engine.data.RecordingConfig;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.SEICountPerFrame;
import com.ss.bytertc.engine.data.ScreenMediaType;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.data.StreamSycnInfoConfig;
import com.ss.bytertc.engine.data.VideoOrientation;
import com.ss.bytertc.engine.data.VideoRotationMode;
import com.ss.bytertc.engine.data.VirtualBackgroundSource;
import com.ss.bytertc.engine.data.ZoomConfigType;
import com.ss.bytertc.engine.data.ZoomDirectionType;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.ktv.KTVManagerPlugin;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.engine.flutter.render.EchoTestViewHolder;
import com.ss.bytertc.engine.flutter.room.RTCRoomPlugin;
import com.ss.bytertc.engine.flutter.screencapture.LaunchHelper;
import com.ss.bytertc.engine.live.LiveTranscoding;
import com.ss.bytertc.engine.live.MixedStreamConfig;
import com.ss.bytertc.engine.live.PushSingleStreamParam;
import com.ss.bytertc.engine.publicstream.PublicStreaming;
import com.ss.bytertc.engine.type.AnsMode;
import com.ss.bytertc.engine.type.AudioProfileType;
import com.ss.bytertc.engine.type.AudioScenarioType;
import com.ss.bytertc.engine.type.LocalProxyConfiguration;
import com.ss.bytertc.engine.type.MediaTypeEnhancementConfig;
import com.ss.bytertc.engine.type.MessageConfig;
import com.ss.bytertc.engine.type.ProblemFeedbackInfo;
import com.ss.bytertc.engine.type.ProblemFeedbackOption;
import com.ss.bytertc.engine.type.PublishFallbackOption;
import com.ss.bytertc.engine.type.RecordingType;
import com.ss.bytertc.engine.type.RemoteUserPriority;
import com.ss.bytertc.engine.type.SubscribeFallbackOptions;
import com.ss.bytertc.engine.type.TorchState;
import com.ss.bytertc.engine.type.VoiceChangerType;
import com.ss.bytertc.engine.type.VoiceEqualizationConfig;
import com.ss.bytertc.engine.type.VoiceReverbConfig;
import com.ss.bytertc.engine.type.VoiceReverbType;
import com.ss.bytertc.engine.video.RTCWatermarkConfig;
import com.ss.bytertc.engine.video.VideoCaptureConfig;
import com.ss.bytertc.ktv.IKTVManager;

import org.json.JSONObject;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCVideoPlugin extends RTCFlutterPlugin {

    private final HashMap<String, RTCFlutterPlugin> flutterPlugins = new HashMap<>();
    private final HashMap<Integer, RTCRoomPlugin> roomPlugins = new HashMap<>();

    private final FaceDetectionEventProxy faceDetectionHandler = new FaceDetectionEventProxy();
    private final LiveTranscodingEventProxy liveTranscodingEventProxy = new LiveTranscodingEventProxy();
    private final MixedStreamProxy mixedStreamProxy = new MixedStreamProxy();
    private final ASREngineEventProxy asrEventHandler = new ASREngineEventProxy();
    private final PushSingleStreamToCDNProxy pushSingleStreamToCDNProxy = new PushSingleStreamToCDNProxy();
    private final SnapshotResultCallbackProxy snapshotResultCallbackProxy = new SnapshotResultCallbackProxy();

    public RTCVideoPlugin() {
        flutterPlugins.put("AudioMixing", new AudioMixingPlugin());
        flutterPlugins.put("VideoEffect", new VideoEffectPlugin());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        for (RTCFlutterPlugin plugin: flutterPlugins.values()) {
            plugin.onAttachedToEngine(binding);
        }
        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_video");
        channel.setMethodCallHandler(callHandler);
        faceDetectionHandler.registerEvent(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_face_detection");
        liveTranscodingEventProxy.registerEvent(binding.getBinaryMessenger());
        mixedStreamProxy.registerEvent(binding.getBinaryMessenger());
        asrEventHandler.registerEvent(binding.getBinaryMessenger());
        pushSingleStreamToCDNProxy.registerEvent(binding.getBinaryMessenger());
        snapshotResultCallbackProxy.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);

        for (RTCFlutterPlugin plugin: flutterPlugins.values()) {
            plugin.onDetachedFromEngine(binding);
        }
        for (RTCRoomPlugin value : roomPlugins.values()) {
            value.onDetachedFromEngine(binding);
        }
        roomPlugins.clear();
        faceDetectionHandler.destroy();
        liveTranscodingEventProxy.destroy();
        mixedStreamProxy.destroy();
        asrEventHandler.destroy();
        pushSingleStreamToCDNProxy.destroy();
        snapshotResultCallbackProxy.destroy();
    }

    private final MethodChannel.MethodCallHandler callHandler = new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(getTAG(), "Video Call: " + call.method);
            }
            final RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);

            switch (call.method) {
// endregion
// region Object methods
                case "startAudioCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startAudioCapture();
                    result.success(retValue);
                    break;
                }

                case "stopAudioCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopAudioCapture();

                    result.success(retValue);
                    break;
                }

                case "setAudioScenario": {
                    AudioScenarioType scenario = AudioScenarioType.fromId(arguments.optInt("audioScenario"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setAudioScenario(scenario);

                    result.success(retValue);
                    break;
                }

                case "setAudioProfile": {
                    AudioProfileType profile = AudioProfileType.fromId(arguments.optInt("audioProfile"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setAudioProfile(profile);

                    result.success(retValue);
                    break;
                }

                case "setAnsMode" : {
                    AnsMode ansMode = AnsMode.fromId(arguments.optInt("ansMode"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setAnsMode(ansMode);
                    result.success(retValue);
                    break;
                }

                case "setVoiceChangerType": {
                    VoiceChangerType changerType = VoiceChangerType.fromId(arguments.optInt("voiceChanger"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVoiceChangerType(changerType);

                    result.success(retValue);
                    break;
                }

                case "setVoiceReverbType": {

                    VoiceReverbType reverbType = VoiceReverbType.fromId(arguments.optInt("voiceReverb"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVoiceReverbType(reverbType);

                    result.success(retValue);
                    break;
                }

                case "setLocalVoiceEqualization": {
                    VoiceEqualizationConfig config = RTCType.toVoiceEqualizationConfig(arguments.optBox("config"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalVoiceEqualization(config);
                    result.success(retValue);
                    break;
                }

                case "setLocalVoiceReverbParam": {
                    VoiceReverbConfig config = RTCType.toVoiceReverbConfig(arguments.optBox("config"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalVoiceReverbParam(config);
                    result.success(retValue);
                    break;
                }

                case "enableLocalVoiceReverb": {
                    boolean enabled = arguments.optBoolean("enable");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableLocalVoiceReverb(enabled);
                    result.success(retValue);
                    break;
                }

                case "setCaptureVolume": {
                    StreamIndex index = StreamIndex.fromId(arguments.optInt("index"));
                    int vol = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCaptureVolume(index, vol);

                    result.success(retValue);
                    break;
                }

                case "setPlaybackVolume": {
                    int vol = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setPlaybackVolume(vol);

                    result.success(retValue);
                    break;
                }

                case "enableAudioPropertiesReport": {
                    AudioPropertiesConfig config = RTCType.toAudioPropertiesConfig(arguments.optBox("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableAudioPropertiesReport(config);

                    result.success(retValue);
                    break;
                }

                case "setRemoteAudioPlaybackVolume": {
                    String roomId = arguments.optString("roomId");
                    String uid = arguments.optString("uid");
                    int volume = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setRemoteAudioPlaybackVolume(roomId, uid, volume);

                    result.success(retValue);
                    break;
                }

                case "setEarMonitorMode": {
                    int mode = arguments.optInt("mode");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setEarMonitorMode(EarMonitorMode.fromId(mode));

                    result.success(retValue);
                    break;
                }

                case "setEarMonitorVolume": {
                    int volume = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setEarMonitorVolume(volume);

                    result.success(retValue);
                    break;
                }

                case "setLocalVoicePitch": {
                    int pitch = arguments.optInt("pitch");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalVoicePitch(pitch);

                    result.success(retValue);
                    break;
                }

                case "enableVocalInstrumentBalance": {
                    boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableVocalInstrumentBalance(enabled);

                    result.success(retValue);
                    break;
                }

                case "enablePlaybackDucking": {
                    boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enablePlaybackDucking(enabled);

                    result.success(retValue);
                    break;
                }

                case "enableSimulcastMode": {
                    boolean enable = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableSimulcastMode(enable);

                    result.success(retValue);
                    break;
                }

                case "setMaxVideoEncoderConfig": { // Support Dart setMaxVideoEncoderConfig
                    VideoEncoderConfig maxSolution = RTCType.toVideoEncoderConfig(arguments.optBox("maxSolution"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEncoderConfig(maxSolution);

                    result.success(retValue);
                    break;
                }

                case "setVideoEncoderConfig": {
                    VideoEncoderConfig[] channelSolutions = RTCType.toVideoEncoderConfigArray(arguments.getList("channelSolutions"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEncoderConfig(channelSolutions);

                    result.success(retValue);
                    break;
                }

                case "setScreenVideoEncoderConfig": {
                    ScreenVideoEncoderConfig solution = RTCType.toScreenVideoEncoderConfig(arguments.optBox("screenSolution"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setScreenVideoEncoderConfig(solution);

                    result.success(retValue);
                    break;
                }

                case "setVideoCaptureConfig": {
                    VideoCaptureConfig videoCaptureConfig = RTCType.toVideoCaptureConfig(arguments.optBox("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoCaptureConfig(videoCaptureConfig);

                    result.success(retValue);
                    break;
                }

                case "removeLocalVideo": { // Support Dart removeLocalVideo
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamType"));
                    VideoCanvas videoCanvas = new VideoCanvas(); // Use a blank Canvas as Remove

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalVideoCanvas(streamIndex, videoCanvas);

                    result.success(retValue);
                    break;
                }

                case "removeRemoteVideo": { // Support Dart removeRemoteVideo
                    String roomId = arguments.optString("roomId");
                    String uid = arguments.optString("uid");
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamType"));
                    VideoCanvas canvas = new VideoCanvas(); // Use a blank Canvas as Remove

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    RemoteStreamKey streamKey = new RemoteStreamKey(roomId, uid, streamIndex);
                    int retValue = rtcVideo.setRemoteVideoCanvas(streamKey, canvas);

                    result.success(retValue);
                    break;
                }

                case "startVideoCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startVideoCapture();

                    result.success(retValue);
                    break;
                }

                case "stopVideoCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopVideoCapture();

                    result.success(retValue);
                    break;
                }

                case "setLocalVideoMirrorType": {
                    MirrorType mode = MirrorType.fromId(arguments.optInt("mirrorType"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalVideoMirrorType(mode);

                    result.success(retValue);
                    break;
                }

                case "setVideoRotationMode": {
                    VideoRotationMode rotationMode = VideoRotationMode.fromId(arguments.optInt("rotationMode"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoRotationMode(rotationMode);

                    result.success(retValue);
                    break;
                }

                case "switchCamera": {
                    CameraId cameraId = CameraId.fromId(arguments.optInt("cameraId"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.switchCamera(cameraId);

                    result.success(retValue);
                    break;
                }

                case "checkVideoEffectLicense": {
                    Context context = binding.getApplicationContext();
                    String licenseFile = arguments.optString("licenseFile");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.checkVideoEffectLicense(context, licenseFile);

                    result.success(retValue);
                    break;
                }

                case "enableVideoEffect": {
                    boolean enable = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableVideoEffect(enable);

                    result.success(retValue);
                    break;
                }

                case "setVideoEffectAlgoModelPath": {
                    String modelPath = arguments.optString("modelPath");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEffectAlgoModelPath(modelPath);

                    result.success(retValue);
                    break;
                }

                case "setVideoEffectNodes": {
                    List<String> effectNodes = arguments.getList("effectNodes");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEffectNodes(effectNodes);

                    result.success(retValue);
                    break;
                }

                case "updateVideoEffectNode": {
                    String effectNode = arguments.optString("effectNode");
                    String key = arguments.optString("key");
                    float value = arguments.optFloat("value");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updateVideoEffectNode(effectNode, key, value);

                    result.success(retValue);
                    break;
                }

                case "setVideoEffectColorFilter": {
                    String resFile = arguments.optString("resFile");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEffectColorFilter(resFile);

                    result.success(retValue);
                    break;
                }

                case "setVideoEffectColorFilterIntensity": {
                    float intensity = arguments.optFloat("intensity");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoEffectColorFilterIntensity(intensity);

                    result.success(retValue);
                    break;
                }

                case "setBackgroundSticker": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    String modelPath = arguments.optString("modelPath");
                    VirtualBackgroundSource source = RTCType.toVirtualBackgroundSource(arguments.optBox("source"));
                    int retValue = rtcVideo.setBackgroundSticker(modelPath, source);

                    result.success(retValue);
                    break;
                }

                case "registerFaceDetectionObserver": {
                    int interval = arguments.optInt("interval");
                    boolean observer = arguments.optBoolean("observer");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue;
                    if (observer) {
                        retValue = rtcVideo.registerFaceDetectionObserver(faceDetectionHandler, interval);
                    } else {
                        retValue = rtcVideo.registerFaceDetectionObserver(null, interval);
                    }

                    result.success(retValue);
                    break;
                }

                case "enableEffectBeauty": {
                    final boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableEffectBeauty(enabled);

                    result.success(retValue);
                    break;
                }

                case "setBeautyIntensity": {
                    EffectBeautyMode beautyMode = EffectBeautyMode.fromId(arguments.optInt("beautyMode"));
                    float intensity = arguments.optFloat("intensity");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setBeautyIntensity(beautyMode, intensity);

                    result.success(retValue);
                    break;
                }

                case "setCameraZoomRatio": {
                    float zoom = arguments.optFloat("zoom");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraZoomRatio(zoom);

                    result.success(retValue);
                    break;
                }

                case "getCameraZoomMaxRatio": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    float retValue = rtcVideo.getCameraZoomMaxRatio();

                    result.success(retValue);
                    break;
                }

                case "isCameraZoomSupported": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    boolean retValue = rtcVideo.isCameraZoomSupported();

                    result.success(retValue);
                    break;
                }

                case "isCameraTorchSupported": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    boolean supported = rtcVideo.isCameraTorchSupported();

                    result.success(supported);
                    break;
                }

                case "isCameraExposurePositionSupported": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    boolean supported = rtcVideo.isCameraExposurePositionSupported();

                    result.success(supported);
                    break;
                }

                case "setCameraTorch": {
                    TorchState torchState = RTCType.toTorchState(arguments.optInt("torchState"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraTorch(torchState);

                    result.success(retValue);
                    break;
                }

                case "isCameraFocusPositionSupported": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    boolean retValue = rtcVideo.isCameraFocusPositionSupported();

                    result.success(retValue);
                    break;
                }

                case "setCameraFocusPosition": {
                    float x = arguments.optFloat("x");
                    float y = arguments.optFloat("y");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraFocusPosition(x, y);

                    result.success(retValue);
                    break;
                }

                case "setCameraExposureCompensation": {
                    float val = arguments.optFloat("val");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraExposureCompensation(val);

                    result.success(retValue);
                    break;
                }

                case "setCameraExposurePosition": {
                    float x = arguments.optFloat("x");
                    float y = arguments.optFloat("y");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraExposurePosition(x, y);

                    result.success(retValue);
                    break;
                }

                case "enableCameraAutoExposureFaceMode": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableCameraAutoExposureFaceMode(arguments.optBoolean("enable"));
                    result.success(retValue);
                    break;
                }

                case "setCameraAdaptiveMinimumFrameRate": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCameraAdaptiveMinimumFrameRate(arguments.optInt("framerate"));
                    result.success(retValue);
                    break;
                }

                case "sendSEIMessage": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    byte[] msg = arguments.optBytes("message");
                    int repeatCount = arguments.optInt("repeatCount");
                    SEICountPerFrame mode = SEICountPerFrame.fromId(arguments.optInt("mode"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.sendSEIMessage(streamIndex, msg, repeatCount, mode);

                    result.success(retValue);
                    break;
                }

                case "setVideoDigitalZoomConfig": {
                    ZoomConfigType type = ZoomConfigType.fromId(arguments.optInt("type"));
                    float size = arguments.optFloat("size");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoDigitalZoomConfig(type, size);
                    result.success(retValue);
                    break;
                }

                case "setVideoDigitalZoomControl": {
                    ZoomDirectionType direction = ZoomDirectionType.fromId(arguments.optInt("direction"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoDigitalZoomControl(direction);
                    result.success(retValue);
                    break;
                }

                case "startVideoDigitalZoomControl": {
                    ZoomDirectionType direction = ZoomDirectionType.fromId(arguments.optInt("direction"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startVideoDigitalZoomControl(direction);
                    result.success(retValue);
                    break;
                }

                case "stopVideoDigitalZoomControl": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopVideoDigitalZoomControl();
                    result.success(retValue);
                    break;
                }

                case "setAudioRoute": {
                    AudioRoute audioRouteDevice = AudioRoute.fromId(arguments.optInt("audioRoute"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setAudioRoute(audioRouteDevice);

                    result.success(retValue);
                    break;
                }

                case "setDefaultAudioRoute": {
                    AudioRoute audioRouteDevice = AudioRoute.fromId(arguments.optInt("audioRoute"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setDefaultAudioRoute(audioRouteDevice);

                    result.success(retValue);
                    break;
                }

                case "getAudioRoute": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.getAudioRoute().value();

                    result.success(retValue);
                    break;
                }

                case "enableExternalSoundCard": {
                    final boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableExternalSoundCard(enabled);

                    result.success(retValue);
                    break;
                }

                case "startLiveTranscoding": {
                    String taskId = arguments.optString("taskId");
                    LiveTranscoding liveTranscoding = RTCType.toLiveTranscoding(arguments.optBox("transcoding"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startLiveTranscoding(taskId, liveTranscoding, liveTranscodingEventProxy);

                    result.success(retValue);
                    break;
                }

                case "stopLiveTranscoding": {
                    String taskId = arguments.optString("taskId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopLiveTranscoding(taskId);

                    result.success(retValue);
                    break;
                }

                case "updateLiveTranscoding": {
                    String taskId = arguments.optString("taskId");
                    LiveTranscoding liveTranscoding = RTCType.toLiveTranscoding(arguments.optBox("transcoding"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updateLiveTranscoding(taskId, liveTranscoding);

                    result.success(retValue);
                    break;
                }


                case "startPushPublicStream": {
                    String publicStreamId = arguments.optString("publicStreamId");
                    PublicStreaming publicStreamParam = RTCType.toPublicStreaming(arguments.optBox("publicStreamParam"));
                    publicStreamParam.setAction(PublicStreaming.ACTION_START);
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startPushPublicStream(publicStreamId, publicStreamParam);

                    result.success(retValue);
                    break;
                }

                case "stopPushPublicStream": {
                    String publicStreamId = arguments.optString("publicStreamId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopPushPublicStream(publicStreamId);

                    result.success(retValue);
                    break;
                }

                case "updatePublicStreamParam": {
                    String publicStreamId = arguments.optString("publicStreamId");
                    PublicStreaming publicStreamParam = RTCType.toPublicStreaming(arguments.optBox("publicStreamParam"));
                    publicStreamParam.setAction(PublicStreaming.ACTION_CHANGED);
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updatePublicStreamParam(publicStreamId, publicStreamParam);

                    result.success(retValue);
                    break;
                }

                case "startPlayPublicStream": {
                    String publicStreamId = arguments.optString("publicStreamId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startPlayPublicStream(publicStreamId);

                    result.success(retValue);
                    break;
                }

                case "stopPlayPublicStream": {
                    String publicStreamId = arguments.optString("publicStreamId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopPlayPublicStream(publicStreamId);

                    result.success(retValue);
                    break;
                }

                case "removePublicStreamVideo": { // Support Dart removePublicStreamVideo
                    String publicStreamId = arguments.optString("publicStreamId");
                    VideoCanvas videoCanvas = new VideoCanvas(); // Use a blank Canvas as Remove

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setPublicStreamVideoCanvas(publicStreamId, videoCanvas);

                    result.success(retValue);
                    break;
                }

                case "setPublicStreamAudioPlaybackVolume": {
                    String publicStreamId = arguments.optString("publicStreamId");
                    int volume = arguments.optInt("volume");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setPublicStreamAudioPlaybackVolume(publicStreamId, volume);

                    result.success(retValue);
                    break;
                }

                case "setBusinessId": {
                    String businessId = arguments.optString("businessId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setBusinessId(businessId);

                    result.success(retValue);
                    break;
                }

                case "feedback": {
                    List<ProblemFeedbackOption> types = RTCType.toFeedBackList(arguments.getList("types"));
                    ProblemFeedbackInfo info = RTCType.toFeedbackInfo(arguments.optBox("info"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.feedback(types, info);

                    result.success(retValue);
                    break;
                }

                case "setPublishFallbackOption": {
                    PublishFallbackOption option = RTCType.toPublishFallbackOption(arguments.optInt("option"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setPublishFallbackOption(option);

                    result.success(retValue);
                    break;
                }

                case "setSubscribeFallbackOption": {
                    SubscribeFallbackOptions options = RTCType.toSubscribeFallbackOptions(arguments.optInt("option"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setSubscribeFallbackOption(options);

                    result.success(retValue);
                    break;
                }

                case "setRemoteUserPriority": {
                    String roomId = arguments.optString("roomId");
                    String uid = arguments.optString("uid");
                    RemoteUserPriority priority = RTCType.toRemoteUserPriority(arguments.optInt("priority"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setRemoteUserPriority(roomId, uid, priority);

                    result.success(retValue);
                    break;
                }

                case "setEncryptInfo": {
                    int aesType = arguments.optInt("aesType");
                    String key = arguments.optString("key");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setEncryptInfo(aesType, key);

                    result.success(retValue);
                    break;
                }

                case "createRTCRoom": {
                    int insId = arguments.optInt("roomInsId");
                    String roomId = arguments.optString("roomId");
                    RTCRoom rtcRoom = RTCVideoManager.createRoom(insId, roomId);
                    if (rtcRoom == null) {
                        result.success(false);
                    } else {
                        RTCRoomPlugin plugin = new RTCRoomPlugin(insId, rtcRoom);
                        plugin.onAttachedToEngine(binding);
                        roomPlugins.put(insId, plugin);

                        result.success(true);
                    }
                    break;
                }

                case "destroyRTCRoom": {
                    int insId = arguments.optInt("insId");
                    RTCRoomPlugin plugin = roomPlugins.remove(insId);
                    if (plugin != null) {
                        plugin.onDetachedFromEngine(binding);
                    }
                    result.success(null);
                    break;
                }

                case "startScreenCapture": {
                    ScreenMediaType type = ScreenMediaType.fromId(arguments.optInt("type"));

                    Context applicationContext = binding.getApplicationContext();
                    boolean retValue = LaunchHelper.requestScreenCapture(applicationContext, type);

                    result.success(retValue);
                    break;
                }


                case "updateScreenCapture": {
                    ScreenMediaType type = ScreenMediaType.fromId(arguments.optInt("type"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updateScreenCapture(type);

                    result.success(retValue);
                    break;
                }

                case "stopScreenCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopScreenCapture();

                    result.success(retValue);
                    break;
                }

                case "setRuntimeParameters": {
                    JSONObject params = arguments.optJSONObject("params");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setRuntimeParameters(params);

                    result.success(retValue);
                    break;
                }

                case "startASR": {
                    RTCASRConfig asrConfig = RTCType.toRTCASRConfig(arguments.optBox("asrConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startASR(asrConfig, asrEventHandler);

                    result.success(retValue);
                    break;
                }

                case "stopASR": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopASR();

                    result.success(retValue);
                    break;
                }

                case "startFileRecording": {
                    StreamIndex type = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    RecordingConfig config = RTCType.toRecordingConfig(arguments.optBox("config"));

                    RecordingType recordingType = RecordingType.fromId(arguments.optInt("recordingType"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startFileRecording(type, config, recordingType);

                    result.success(retValue);
                    break;
                }

                case "stopFileRecording": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopFileRecording(streamIndex);

                    result.success(retValue);
                    break;
                }

                case "startAudioRecording": {
                    AudioRecordingConfig config = RTCType.toAudioRecordingConfig(arguments.optBox("config"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startAudioRecording(config);
                    result.success(retValue);
                    break;
                }

                case "stopAudioRecording": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopAudioRecording();
                    result.success(retValue);
                    break;
                }

                case "getAudioEffectPlayer": {
                    if (flutterPlugins.get("AudioEffectPlayer") != null) {
                        result.success(true);
                        break;
                    }
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    IAudioEffectPlayer player = rtcVideo.getAudioEffectPlayer();
                    boolean retValue = player != null;
                    if (retValue) {
                        AudioEffectPlayerPlugin plugin = new AudioEffectPlayerPlugin(player);
                        plugin.onAttachedToEngine(binding);
                        flutterPlugins.put("AudioEffectPlayer", plugin);
                    }
                    result.success(retValue);
                    break;
                }

                case "getMediaPlayer": {
                    int playerId = arguments.optInt("playerId");
                    String key = "MediaPlayer" + playerId;
                    if (flutterPlugins.get(key) != null) {
                        result.success(true);
                        break;
                    }
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    IMediaPlayer player = rtcVideo.getMediaPlayer(playerId);
                    boolean retValue = player != null;
                    if (retValue) {
                        MediaPlayerPlugin plugin = new MediaPlayerPlugin(player, playerId);
                        plugin.onAttachedToEngine(binding);
                        flutterPlugins.put(key, plugin);
                    }
                    result.success(retValue);
                    break;
                }

                case "login": {
                    String token = arguments.optString("token");
                    String uid = arguments.optString("uid");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    long retValue = rtcVideo.login(token, uid);

                    result.success(retValue);
                    break;
                }

                case "logout": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.logout();

                    result.success(retValue);
                    break;
                }


                case "updateLoginToken": {
                    String token = arguments.optString("token");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updateLoginToken(token);

                    result.success(retValue);
                    break;
                }

                case "setServerParams": {
                    String signature = arguments.optString("signature");
                    String url = arguments.optString("url");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setServerParams(signature, url);

                    result.success(retValue);
                    break;
                }

                case "getPeerOnlineStatus": {
                    String peerUserId = arguments.optString("peerUid");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.getPeerOnlineStatus(peerUserId);

                    result.success(retValue);
                    break;
                }

                case "sendUserMessageOutsideRoom": {
                    String uid = arguments.optString("uid");
                    String message = arguments.optString("message");
                    MessageConfig config = MessageConfig.fromId(arguments.optInt("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    long retValue = rtcVideo.sendUserMessageOutsideRoom(uid, message, config);

                    result.success(retValue);
                    break;
                }

                case "sendUserBinaryMessageOutsideRoom": {
                    String uid = arguments.optString("uid");
                    byte[] messages = arguments.optBytes("message");
                    MessageConfig config = MessageConfig.fromId(arguments.optInt("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    long retValue = rtcVideo.sendUserBinaryMessageOutsideRoom(uid, messages, config);

                    result.success(retValue);
                    break;
                }

                case "sendServerMessage": {
                    String message = arguments.optString("message");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    long retValue = rtcVideo.sendServerMessage(message);

                    result.success(retValue);
                    break;
                }

                case "sendServerBinaryMessage": {
                    byte[] messages = arguments.optBytes("message");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    long retValue = rtcVideo.sendServerBinaryMessage(messages);

                    result.success(retValue);
                    break;
                }

                case "startNetworkDetection": {
                    boolean isTestUplink = arguments.optBoolean("isTestUplink");
                    int expectedUplinkBitrate = arguments.optInt("expectedUplinkBitrate");
                    boolean isTestDownlink = arguments.optBoolean("isTestDownlink");
                    int expectedDownlinkBitrate = arguments.optInt("expectedDownlinkBitrate");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue =  rtcVideo.startNetworkDetection(isTestUplink, expectedUplinkBitrate, isTestDownlink, expectedDownlinkBitrate);

                    result.success(retValue);
                    break;
                }

                case "stopNetworkDetection": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopNetworkDetection();

                    result.success(retValue);
                    break;
                }

                case "setScreenAudioStreamIndex": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setScreenAudioStreamIndex(streamIndex);

                    result.success(retValue);
                    break;
                }

                case "sendStreamSyncInfo": {
                    byte[] data = arguments.optBytes("data");
                    StreamSycnInfoConfig config = RTCType.toStreamSyncInfoConfig(arguments.optBox("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.sendStreamSyncInfo(data, config);

                    result.success(retValue);
                    break;
                }


                case "muteAudioPlayback": {
                    MuteState muteState = MuteState.fromId(arguments.optInt("muteState"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.muteAudioPlayback(muteState);

                    result.success(retValue);
                    break;
                }

                case "setVideoWatermark": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    String imagePath = arguments.optString("imagePath");
                    RTCWatermarkConfig watermarkConfig = RTCType.toRTCWatermarkConfig(arguments.optBox("watermarkConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setVideoWatermark(streamIndex, imagePath, watermarkConfig);

                    result.success(retValue);
                    break;
                }

                case "clearVideoWatermark": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.clearVideoWatermark(streamIndex);

                    result.success(retValue);
                    break;
                }

                case "startCloudProxy": {
                    List<CloudProxyInfo> cloudProxiesInfo = RTCType.toCloudProxyInfoList(arguments.opt("cloudProxiesInfo", Collections.emptyList(), List.class));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startCloudProxy(cloudProxiesInfo);

                    result.success(retValue);
                    break;
                }

                case "stopCloudProxy": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopCloudProxy();

                    result.success(retValue);
                    break;
                }

                case "startEchoTest": {
                    EchoTestConfig config = RTCType.toEchoTestConfig(arguments.optBox("config"));
                    config.view = EchoTestViewHolder.getRenderView();
                    int delayTime = arguments.optInt("delayTime");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startEchoTest(config, delayTime);

                    result.success(retValue);
                    break;
                }

                case "stopEchoTest": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopEchoTest();

                    result.success(retValue);
                    break;
                }

                case "setVideoOrientation": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    VideoOrientation orientation = VideoOrientation.fromId(arguments.optInt("orientation"));
                    int retValue = rtcVideo.setVideoOrientation(orientation);

                    result.success(retValue);
                    break;
                }

                case "startPushMixedStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    MixedStreamConfig mixedConfig = RTCType.toMixedStreamConfig(arguments.optBox("mixedConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startPushMixedStreamToCDN(taskId, mixedConfig, mixedStreamProxy);

                    result.success(retValue);
                    break;
                }

                case "updatePushMixedStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    MixedStreamConfig mixedConfig = RTCType.toMixedStreamConfig(arguments.optBox("mixedConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.updatePushMixedStreamToCDN(taskId, mixedConfig);

                    result.success(retValue);
                    break;
                }

                case "startPushSingleStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    PushSingleStreamParam param = RTCType.toPushSingleStreamParam(arguments.optBox("param"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startPushSingleStreamToCDN(taskId, param, pushSingleStreamToCDNProxy);

                    result.success(retValue);
                    break;
                }

                case "stopPushStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();

                    int retValue = rtcVideo.stopPushStreamToCDN(taskId);

                    result.success(retValue);
                    break;
                }

                case "setDummyCaptureImagePath": {
                    String filePath = arguments.optString("filePath");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setDummyCaptureImagePath(filePath);

                    result.success(retValue);
                    break;
                }

                case "takeLocalSnapshot": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    String filePath = arguments.optString("filePath");
                    long taskId = rtcVideo.takeLocalSnapshot(streamIndex, snapshotResultCallbackProxy.createCallback(filePath));

                    result.success(taskId);
                    break;
                }

                case "takeRemoteSnapshot": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    RemoteStreamKey streamKey = RTCType.toRemoteStreamKey(arguments.optBox("streamKey"));
                    String filePath = arguments.optString("filePath");
                    long taskId = rtcVideo.takeRemoteSnapshot(streamKey, snapshotResultCallbackProxy.createCallback(filePath));

                    result.success(taskId);
                    break;
                }

                case "getSingScoringManager": {
                    if (flutterPlugins.get("SingScoring") != null) {
                        result.success(true);
                        break;
                    }
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    ISingScoringManager manager = rtcVideo.getSingScoringManager();
                    boolean retValue = manager != null;
                    if (retValue) {
                        SingScoringPlugin plugin = new SingScoringPlugin(manager);
                        plugin.onAttachedToEngine(binding);
                        flutterPlugins.put("SingScoring", plugin);
                    }
                    result.success(retValue);
                    break;
                }

                case "getNetworkTimeInfo": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    NetworkTimeInfo info = rtcVideo.getNetworkTimeInfo();
                    if (info == null) {
                        result.success(null);
                        break;
                    }
                    final HashMap<String, Object> map = new HashMap<>();
                    map.put("timestamp", info.timestamp);
                    result.success(map);
                    break;
                }

                case "setAudioAlignmentProperty": {
                    RemoteStreamKey streamKey = RTCType.toRemoteStreamKey(arguments.optBox("streamKey"));
                    AudioAlignmentMode mode = AudioAlignmentMode.fromId(arguments.optInt("mode"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setAudioAlignmentProperty(streamKey, mode);
                    result.success(retValue);
                    break;
                }

                case "invokeExperimentalAPI": {
                    String param = arguments.optString("param");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.invokeExperimentalAPI(param);
                    result.success(retValue);
                    break;
                }

                case "getKTVManager": {
                    if (flutterPlugins.get("KTVManager") != null) {
                        result.success(true);
                        break;
                    }
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    IKTVManager manager = rtcVideo.getKTVManager();
                    boolean retValue = manager != null;
                    if (retValue) {
                        KTVManagerPlugin plugin = new KTVManagerPlugin(manager);
                        plugin.onAttachedToEngine(binding);
                        flutterPlugins.put("KTVManager", plugin);
                    }
                    result.success(retValue);
                    break;
                }

                case "startHardwareEchoDetection": {
                    String testAudioFilePath = arguments.optString("testAudioFilePath");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.startHardwareEchoDetection(testAudioFilePath);
                    result.success(retValue);
                    break;
                }

                case "stopHardwareEchoDetection": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.stopHardwareEchoDetection();
                    result.success(retValue);
                    break;
                }

                case "setCellularEnhancement": {
                    MediaTypeEnhancementConfig config = RTCType.toMediaTypeEnhancementConfig(arguments.optBox("config"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setCellularEnhancement(config);
                    result.success(retValue);
                    break;
                }

                case "setLocalProxy": {
                    List<LocalProxyConfiguration> configurations = RTCType.toLocalProxyConfigurations(arguments.getList("configurations"));
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setLocalProxy(configurations);
                    result.success(retValue);
                    break;
                }
// endregion

                default:
                    result.notImplemented();
                    break;
            }
        }
    };
}
