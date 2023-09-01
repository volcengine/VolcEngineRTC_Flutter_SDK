/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.data.VirtualBackgroundSource;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.engine.video.IVideoEffect;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class VideoEffectPlugin extends RTCFlutterPlugin {

    private final FaceDetectionEventProxy faceDetectionHandler = new FaceDetectionEventProxy();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_video_effect");
        channel.setMethodCallHandler(callHandler);
        faceDetectionHandler.registerEvent(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_video_effect_face_detection");
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);

        faceDetectionHandler.destroy();
    }

    private final MethodChannel.MethodCallHandler callHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "IVideoEffect Call: " + call.method);
        }
        RTCTypeBox arguments = new RTCTypeBox(call.arguments);
        RTCVideo rtcVideo = RTCVideoManager.getRTCVideo();
        IVideoEffect videoEffect = rtcVideo.getVideoEffectInterface();

        switch (call.method) {
            case "initCVResource": {
                String licenseFile = arguments.optString("licenseFile");
                String modelPath = arguments.optString("modelPath");
                int retValue = videoEffect.initCVResource(licenseFile, modelPath);
                result.success(retValue);
                break;
            }

            case "enableVideoEffect": {
                int retValue = videoEffect.enableVideoEffect();
                result.success(retValue);
                break;
            }

            case "disableVideoEffect": {
                int retValue = videoEffect.disableVideoEffect();
                result.success(retValue);
                break;
            }

            case "setEffectNodes": {
                List<String> effectNodes = arguments.getList("effectNodes");
                int retValue = videoEffect.setEffectNodes(effectNodes);
                result.success(retValue);
                break;
            }

            case "updateEffectNode": {
                String effectNode = arguments.optString("effectNode");
                String key = arguments.optString("key");
                float value = arguments.optFloat("value");
                int retValue = videoEffect.updateEffectNode(effectNode, key, value);
                result.success(retValue);
                break;
            }

            case "setColorFilter": {
                String resFile = arguments.optString("resFile");
                int retValue = videoEffect.setColorFilter(resFile);
                result.success(retValue);
                break;
            }

            case "setColorFilterIntensity": {
                float intensity = arguments.optFloat("intensity");
                int retValue = videoEffect.setColorFilterIntensity(intensity);
                result.success(retValue);
                break;
            }

            case "enableVirtualBackground": {
                String modelPath = arguments.optString("modelPath");
                VirtualBackgroundSource source = RTCType.toVirtualBackgroundSource(arguments.optBox("source"));
                int retValue = videoEffect.enableVirtualBackground(modelPath, source);
                result.success(retValue);
                break;
            }

            case "disableVirtualBackground": {
                int retValue = videoEffect.disableVirtualBackground();
                result.success(retValue);
                break;
            }

            case "enableFaceDetection": {
                int interval = arguments.optInt("interval");
                String modelPath = arguments.optString("modelPath");
                int retValue = videoEffect.enableFaceDetection(faceDetectionHandler, interval, modelPath);
                result.success(retValue);
                break;
            }

            case "disableFaceDetection": {
                final int retValue = videoEffect.disableFaceDetection();
                result.success(retValue);
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    };
}
