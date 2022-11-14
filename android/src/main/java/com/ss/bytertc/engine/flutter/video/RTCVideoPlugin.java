/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.VideoCanvas;
import com.ss.bytertc.engine.VideoEncoderConfig;
import com.ss.bytertc.engine.audio.IAudioMixingManager;
import com.ss.bytertc.engine.data.AudioMixingConfig;
import com.ss.bytertc.engine.data.AudioMixingDualMonoMode;
import com.ss.bytertc.engine.data.AudioMixingType;
import com.ss.bytertc.engine.data.AudioPropertiesConfig;
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
import com.ss.bytertc.engine.data.ScreenMediaType;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.data.StreamSycnInfoConfig;
import com.ss.bytertc.engine.data.VideoOrientation;
import com.ss.bytertc.engine.data.VideoRotationMode;
import com.ss.bytertc.engine.data.VirtualBackgroundSource;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.render.EchoTestViewHolder;
import com.ss.bytertc.engine.flutter.room.RTCRoomPlugin;
import com.ss.bytertc.engine.flutter.screencapture.LaunchHelper;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.live.LiveTranscoding;
import com.ss.bytertc.engine.live.PushSingleStreamParam;
import com.ss.bytertc.engine.publicstream.PublicStreaming;
import com.ss.bytertc.engine.type.AudioProfileType;
import com.ss.bytertc.engine.type.AudioScenarioType;
import com.ss.bytertc.engine.type.MessageConfig;
import com.ss.bytertc.engine.type.NetworkDetectionStartReturn;
import com.ss.bytertc.engine.type.ProblemFeedback;
import com.ss.bytertc.engine.type.PublishFallbackOption;
import com.ss.bytertc.engine.type.RecordingType;
import com.ss.bytertc.engine.type.RemoteUserPriority;
import com.ss.bytertc.engine.type.SubscribeFallbackOptions;
import com.ss.bytertc.engine.type.TorchState;
import com.ss.bytertc.engine.type.VoiceChangerType;
import com.ss.bytertc.engine.type.VoiceReverbType;
import com.ss.bytertc.engine.utils.AudioFrame;
import com.ss.bytertc.engine.video.RTCWatermarkConfig;
import com.ss.bytertc.engine.video.VideoCaptureConfig;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCVideoPlugin implements FlutterPlugin {
    private static final String TAG = "RTCVideoPlugin";

    private FlutterPlugin.FlutterPluginBinding binding;

    private final VideoEventProxy videoEventHandler = new VideoEventProxy();
    private final FaceDetectionEventProxy faceDetectionHandler = new FaceDetectionEventProxy();
    private final LiveTranscodingEventProxy liveTranscodingEventProxy = new LiveTranscodingEventProxy();
    private final ASREngineEventProxy asrEventHandler = new ASREngineEventProxy();
    private final PushSingleStreamToCDNProxy pushSingleStreamToCDNProxy = new PushSingleStreamToCDNProxy();

    private final HashMap<Integer, RTCRoomPlugin> roomPlugins = new HashMap<>();


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        this.binding = binding;

        MethodChannel channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_video");
        channel.setMethodCallHandler(rtcVideoHandler);

        MethodChannel audioMixingManagerChannel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_audio_mixing_manager");
        audioMixingManagerChannel.setMethodCallHandler(audioMixingHandler);

        videoEventHandler.registerEvent(binding.getBinaryMessenger());
        faceDetectionHandler.registerEvent(binding.getBinaryMessenger());
        liveTranscodingEventProxy.registerEvent(binding.getBinaryMessenger());
        asrEventHandler.registerEvent(binding.getBinaryMessenger());
        pushSingleStreamToCDNProxy.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        for (RTCRoomPlugin value : roomPlugins.values()) {
            value.onDetachedFromEngine(binding);
        }

        roomPlugins.clear();
    }

    /**
     * 响应 IAudioMixingManager 接口
     */
    private final MethodChannel.MethodCallHandler audioMixingHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(TAG, "IAudioMixingManager Call: " + call.method);
        }
        RTCTypeBox arguments = new RTCTypeBox(call.arguments);
        RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
        IAudioMixingManager audioMixingManager = rtcVideo.getAudioMixingManager();
        switch (call.method) {
            case "startAudioMixing": {
                int mixId = arguments.optInt("mixId");
                String filePath = arguments.optString("filePath");
                AudioMixingConfig config = RTCType.toAudioMixingConfig(arguments.optBox("config"));

                audioMixingManager.startAudioMixing(mixId, filePath, config);

                result.success(null);
                break;
            }

            case "stopAudioMixing": {
                int mixId = arguments.optInt("mixId");

                audioMixingManager.stopAudioMixing(mixId);

                result.success(null);
                break;
            }

            case "pauseAudioMixing": {
                int mixId = arguments.optInt("mixId");

                audioMixingManager.pauseAudioMixing(mixId);

                result.success(null);
                break;
            }

            case "resumeAudioMixing": {
                int mixId = arguments.optInt("mixId");

                audioMixingManager.resumeAudioMixing(mixId);

                result.success(null);
                break;
            }

            case "preloadAudioMixing": {
                int mixId = arguments.optInt("mixId");
                String filePath = arguments.optString("filePath");

                audioMixingManager.preloadAudioMixing(mixId, filePath);

                result.success(null);
                break;
            }

            case "unloadAudioMixing": {
                int mixId = arguments.optInt("mixId");

                audioMixingManager.unloadAudioMixing(mixId);

                result.success(null);
                break;
            }

            case "setAudioMixingVolume": {
                int mixId = arguments.optInt("mixId");
                int volume = arguments.optInt("volume");
                AudioMixingType type = AudioMixingType.fromId(arguments.optInt("type"));

                audioMixingManager.setAudioMixingVolume(mixId, volume, type);

                result.success(null);
                break;
            }

            case "getAudioMixingDuration": {
                int mixId = arguments.optInt("mixId");

                int retValue = audioMixingManager.getAudioMixingDuration(mixId);

                result.success(retValue);
                break;
            }

            case "getAudioMixingCurrentPosition": {
                int mixId = arguments.optInt("mixId");

                int retValue = audioMixingManager.getAudioMixingCurrentPosition(mixId);

                result.success(retValue);
                break;
            }

            case "setAudioMixingPosition": {
                int mixId = arguments.optInt("mixId");
                int position = arguments.optInt("position");

                audioMixingManager.setAudioMixingPosition(mixId, position);

                result.success(null);
                break;
            }

            case "setAudioMixingDualMonoMode": {
                int mixId = arguments.optInt("mixId");
                AudioMixingDualMonoMode mode = AudioMixingDualMonoMode.fromId(arguments.optInt("mode"));

                audioMixingManager.setAudioMixingDualMonoMode(mixId, mode);

                result.success(null);
                break;
            }

            case "setAudioMixingPitch": {
                int mixId = arguments.optInt("mixId");
                int pitch = arguments.optInt("pitch");

                audioMixingManager.setAudioMixingPitch(mixId, pitch);

                result.success(null);
                break;
            }

            case "setAudioMixingPlaybackSpeed": {
                int mixId = arguments.optInt("mixId");
                int speed = arguments.optInt("speed");

                int retValue = audioMixingManager.setAudioMixingPlaybackSpeed(mixId, speed);

                result.success(retValue);
                break;
            }

            case "setAudioMixingLoudness": {
                int mixId = arguments.optInt("mixId");
                float loudness = arguments.optFloat("loudness");

                audioMixingManager.setAudioMixingLoudness(mixId, loudness);

                result.success(null);
                break;
            }

            case "setAudioMixingProgressInterval": {
                int mixId = arguments.optInt("mixId");
                long interval = arguments.optLong("interval");

                audioMixingManager.setAudioMixingProgressInterval(mixId, interval);

                result.success(null);
                break;
            }

            case "getAudioTrackCount": {
                int mixId = arguments.optInt("mixId");

                int retValue = audioMixingManager.getAudioTrackCount(mixId);

                result.success(retValue);
                break;
            }

            case "selectAudioTrack": {
                int mixId = arguments.optInt("mixId");
                int audioTrackIndex = arguments.optInt("audioTrackIndex");

                audioMixingManager.selectAudioTrack(mixId, audioTrackIndex);

                result.success(null);
                break;
            }

            case "enableAudioMixingFrame": { // Not Support by Dart
                int mixId = arguments.optInt("mixId");
                AudioMixingType type = AudioMixingType.fromId(arguments.optInt("type"));

                audioMixingManager.enableAudioMixingFrame(mixId, type);

                result.success(null);
                break;
            }

            case "disableAudioMixingFrame": { // Not Support by Dart
                int mixId = arguments.optInt("mixId");

                audioMixingManager.disableAudioMixingFrame(mixId);

                result.success(null);
                break;
            }

            case "pushAudioMixingFrame": { // Not Support by Dart
                int mixId = arguments.optInt("mixId");
                AudioFrame audioFrame = RTCType.toAudioFrame(arguments.optBox("audioFrame"));

                int retValue = audioMixingManager.pushAudioMixingFrame(mixId, audioFrame);

                result.success(retValue);
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    };

    /**
     * 响应 RTCVideo 接口
     */
    private final MethodChannel.MethodCallHandler rtcVideoHandler = new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "Video Call: " + call.method);
            }
            final RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);

            switch (call.method) {
// region Static Methods
                case "getSdkVersion": {
                    result.success(RTCVideo.getSdkVersion());
                    break;
                }

                case "getErrorDescription": {
                    int code = arguments.optInt("code");
                    result.success(RTCVideo.getErrorDescription(code));
                    break;
                }

                case "createRTCVideo": {
                    if (!RTCVideoManager.hasRTCVideo()) {
                        String appId = arguments.optString("appId");
                        JSONObject parameters = arguments.optJSONObject("parameters");
                        try {
                            parameters.put("rtc.platform", 6);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        RTCVideoManager.create(appId, videoEventHandler, parameters);
                    }
                    result.success(RTCVideoManager.hasRTCVideo());
                    break;
                }

                case "destroyRTCVideo": {
                    RTCVideoManager.destroy();

                    result.success(null);
                    break;
                }

// endregion
// region Object methods
                case "startAudioCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startAudioCapture();
                    result.success(null);
                    break;
                }

                case "stopAudioCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopAudioCapture();

                    result.success(null);
                    break;
                }

                case "setAudioScenario": {
                    AudioScenarioType scenario = AudioScenarioType.fromId(arguments.optInt("audioScenario"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setAudioScenario(scenario);

                    result.success(null);
                    break;
                }

                case "setAudioProfile": {
                    AudioProfileType profile = AudioProfileType.fromId(arguments.optInt("audioProfile"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setAudioProfile(profile);

                    result.success(null);
                    break;
                }

                case "setVoiceChangerType": {
                    VoiceChangerType changerType = VoiceChangerType.fromId(arguments.optInt("voiceChanger"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setVoiceChangerType(changerType);

                    result.success(null);
                    break;
                }

                case "setVoiceReverbType": {

                    VoiceReverbType reverbType = VoiceReverbType.fromId(arguments.optInt("voiceReverb"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setVoiceReverbType(reverbType);

                    result.success(null);
                    break;
                }

                case "setCaptureVolume": {
                    StreamIndex index = StreamIndex.fromId(arguments.optInt("index"));
                    int vol = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setCaptureVolume(index, vol);

                    result.success(null);
                    break;
                }

                case "setPlaybackVolume": {
                    int vol = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setPlaybackVolume(vol);

                    result.success(null);
                    break;
                }

                case "enableAudioPropertiesReport": {
                    AudioPropertiesConfig config = RTCType.toAudioPropertiesConfig(arguments.optBox("config"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.enableAudioPropertiesReport(config);

                    result.success(null);
                    break;
                }

                case "setRemoteAudioPlaybackVolume": {
                    String roomId = arguments.optString("roomId");
                    String uid = arguments.optString("uid");
                    int volume = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setRemoteAudioPlaybackVolume(roomId, uid, volume);

                    result.success(null);
                    break;
                }

                case "setEarMonitorMode": {
                    int mode = arguments.optInt("mode");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setEarMonitorMode(EarMonitorMode.fromId(mode));

                    result.success(null);
                    break;
                }

                case "setEarMonitorVolume": {
                    int volume = arguments.optInt("volume");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setEarMonitorVolume(volume);

                    result.success(null);
                    break;
                }

                case "setLocalVoicePitch": {
                    int pitch = arguments.optInt("pitch");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setLocalVoicePitch(pitch);

                    result.success(null);
                    break;
                }

                case "enableVocalInstrumentBalance": {
                    boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.enableVocalInstrumentBalance(enabled);

                    result.success(null);
                    break;
                }

                case "enablePlaybackDucking": {
                    boolean enabled = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.enablePlaybackDucking(enabled);

                    result.success(null);
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
                    VideoEncoderConfig solution = RTCType.toVideoEncoderConfig(arguments.optBox("screenSolution"));

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
                    int idx = arguments.optInt("streamType");
                    String uid = arguments.optString("uid");
                    StreamIndex streamIndex = StreamIndex.fromId(idx);
                    VideoCanvas canvas = new VideoCanvas(); // Use a blank Canvas as Remove
                    canvas.uid = uid; // Note: SDK Need the canvas & canvas has uid

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setRemoteVideoCanvas(uid, streamIndex, canvas);

                    result.success(retValue);
                    break;
                }

                case "startVideoCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startVideoCapture();

                    result.success(null);
                    break;
                }

                case "stopVideoCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopVideoCapture();

                    result.success(null);
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
                    rtcVideo.setVideoEffectAlgoModelPath(modelPath);

                    result.success(null);
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

                case "enableEffectBeauty": {
                    final boolean enable = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.enableEffectBeauty(enable);

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

                case "sendSEIMessage": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    byte[] msg = arguments.optBytes("message");
                    int repeatCount = arguments.optInt("repeatCount");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.sendSEIMessage(streamIndex, msg, repeatCount);

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
                    final boolean enable = arguments.optBoolean("enable");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.enableExternalSoundCard(enable);

                    result.success(null);
                    break;
                }

                case "startLiveTranscoding": {
                    String taskId = arguments.optString("taskId");
                    LiveTranscoding liveTranscoding = RTCType.toLiveTranscoding(arguments.optBox("transcoding"));
                    liveTranscoding.setAction(LiveTranscoding.ACTION_START);

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startLiveTranscoding(taskId, liveTranscoding, liveTranscodingEventProxy);

                    result.success(null);
                    break;
                }

                case "stopLiveTranscoding": {
                    String taskId = arguments.optString("taskId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopLiveTranscoding(taskId);

                    result.success(null);
                    break;
                }

                case "updateLiveTranscoding": {
                    String taskId = arguments.optString("taskId");
                    LiveTranscoding liveTranscoding = RTCType.toLiveTranscoding(arguments.optBox("transcoding"));
                    liveTranscoding.setAction(LiveTranscoding.ACTION_CHANGED);

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.updateLiveTranscoding(taskId, liveTranscoding);

                    result.success(null);
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

                case "setBusinessId": {
                    String businessId = arguments.optString("businessId");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setBusinessId(businessId);

                    result.success(retValue);
                    break;
                }

                case "feedback": {
                    List<ProblemFeedback> types = RTCType.toFeedBackList(arguments.getList("types"));
                    String problemDesc = arguments.optString("problemDesc");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.feedback(types, problemDesc);

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
                    rtcVideo.setEncryptInfo(aesType, key);

                    result.success(null);
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
                    rtcVideo.updateScreenCapture(type);

                    result.success(null);
                    break;
                }

                case "stopScreenCapture": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopScreenCapture();

                    result.success(null);
                    break;
                }

                case "setRuntimeParameters": {
                    JSONObject params = arguments.optJSONObject("params");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setRuntimeParameters(params);

                    result.success(null);
                    break;
                }

                case "startASR": {
                    RTCASRConfig asrConfig = RTCType.toRTCASRConfig(arguments.optBox("asrConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startASR(asrConfig, asrEventHandler);

                    result.success(null);
                    break;
                }

                case "stopASR": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopASR();

                    result.success(null);
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
                    rtcVideo.stopFileRecording(streamIndex);

                    result.success(null);
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
                    rtcVideo.logout();

                    result.success(null);
                    break;
                }


                case "updateLoginToken": {
                    String token = arguments.optString("token");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.updateLoginToken(token);

                    result.success(null);
                    break;
                }

                case "setServerParams": {
                    String signature = arguments.optString("signature");
                    String url = arguments.optString("url");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setServerParams(signature, url);

                    result.success(null);
                    break;
                }

                case "getPeerOnlineStatus": {
                    String peerUserId = arguments.optString("peerUid");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.getPeerOnlineStatus(peerUserId);

                    result.success(null);
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
                    long res = rtcVideo.sendServerBinaryMessage(messages);

                    result.success(res);
                    break;
                }

                case "startNetworkDetection": {
                    boolean isTestUplink = arguments.optBoolean("isTestUplink");
                    int expectedUplinkBitrate = arguments.optInt("expectedUplinkBitrate");
                    boolean isTestDownlink = arguments.optBoolean("isTestDownlink");
                    int expectedDownlinkBitrate = arguments.optInt("expectedDownlinkBitrate");

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    NetworkDetectionStartReturn networkDetectionStartReturn = rtcVideo.startNetworkDetection(isTestUplink, expectedUplinkBitrate, isTestDownlink, expectedDownlinkBitrate);

                    result.success(networkDetectionStartReturn.value());
                    break;
                }

                case "stopNetworkDetection": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopNetworkDetection();

                    result.success(null);
                    break;
                }

                case "setScreenAudioStreamIndex": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setScreenAudioStreamIndex(streamIndex);

                    result.success(null);
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
                    rtcVideo.muteAudioPlayback(muteState);

                    result.success(null);
                    break;
                }

                case "setVideoWatermark": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));
                    String imagePath = arguments.optString("imagePath");
                    RTCWatermarkConfig watermarkConfig = RTCType.toRTCWatermarkConfig(arguments.optBox("watermarkConfig"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.setVideoWatermark(streamIndex, imagePath, watermarkConfig);

                    result.success(null);
                    break;
                }

                case "clearVideoWatermark": {
                    StreamIndex streamIndex = StreamIndex.fromId(arguments.optInt("streamIndex"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.clearVideoWatermark(streamIndex);

                    result.success(null);
                    break;
                }

                case "startCloudProxy": {
                    List<CloudProxyInfo> cloudProxiesInfo = RTCType.toCloudProxyInfoList(arguments.opt("cloudProxiesInfo", Collections.emptyList(), List.class));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startCloudProxy(cloudProxiesInfo);

                    result.success(null);
                    break;
                }

                case "stopCloudProxy": {
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.stopCloudProxy();

                    result.success(null);
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
                    rtcVideo.setVideoOrientation(orientation);

                    result.success(null);
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

                case "startPushSingleStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    PushSingleStreamParam param = RTCType.toPushSingleStreamParam(arguments.optBox("param"));

                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    rtcVideo.startPushSingleStreamToCDN(taskId, param, pushSingleStreamToCDNProxy);

                    result.success(null);
                    break;
                }

                case "stopPushStreamToCDN": {
                    String taskId = arguments.optString("taskId");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();

                    rtcVideo.stopPushStreamToCDN(taskId);

                    result.success(null);
                    break;
                }

                case "setDummyCaptureImagePath": {
                    String filePath = arguments.optString("filePath");
                    RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
                    int retValue = rtcVideo.setDummyCaptureImagePath(filePath);

                    result.success(retValue);
                    break;
                }

                case "eventHandlerSwitches": { // for performance reason
                    videoEventHandler.setSwitches(arguments);
                    result.success(null);
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
