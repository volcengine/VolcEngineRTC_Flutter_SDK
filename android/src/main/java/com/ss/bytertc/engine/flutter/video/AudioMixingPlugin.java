/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.audio.IAudioMixingManager;
import com.ss.bytertc.engine.data.AudioMixingConfig;
import com.ss.bytertc.engine.data.AudioMixingDualMonoMode;
import com.ss.bytertc.engine.data.AudioMixingType;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.engine.utils.AudioFrame;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class AudioMixingPlugin extends RTCFlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_audio_mixing_manager");
        channel.setMethodCallHandler(callHandler);
    }

    /**
     * 响应 IAudioMixingManager 接口
     */
    private final MethodChannel.MethodCallHandler callHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "IAudioMixingManager Call: " + call.method);
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

            case "getAudioMixingPlaybackDuration": {
                int mixId = arguments.optInt("mixId");

                int retValue = audioMixingManager.getAudioMixingPlaybackDuration(mixId);

                result.success(retValue);
                break;
            }

            case "setAllAudioMixingVolume": {
                int volume = arguments.optInt("volume");
                AudioMixingType type = AudioMixingType.fromId(arguments.optInt("type"));
                audioMixingManager.setAllAudioMixingVolume(volume, type);
                result.success(null);
                break;
            }

            case "pauseAllAudioMixing": {
                audioMixingManager.pauseAllAudioMixing();
                result.success(null);
                break;
            }

            case "resumeAllAudioMixing": {
                audioMixingManager.resumeAllAudioMixing();
                result.success(null);
                break;
            }

            case "stopAllAudioMixing": {
                audioMixingManager.stopAllAudioMixing();
                result.success(null);
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    };
}
