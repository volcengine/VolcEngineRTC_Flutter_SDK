/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.audio.IAudioEffectPlayer;
import com.ss.bytertc.engine.data.AudioEffectPlayerConfig;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class AudioEffectPlayerPlugin extends RTCFlutterPlugin {

    private IAudioEffectPlayer mPlayer;
    private final AudioEffectPlayerEventProxy mPlayerEventProxy = new AudioEffectPlayerEventProxy();

    AudioEffectPlayerPlugin(@NonNull IAudioEffectPlayer player) {
        mPlayer = player;
        mPlayer.setEventHandler(mPlayerEventProxy);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_audio_effect_player");
        channel.setMethodCallHandler(callHandler);
        mPlayerEventProxy.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);
        mPlayerEventProxy.destroy();
    }

    private final MethodChannel.MethodCallHandler callHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "IAudioEffectPlayer Call: " + call.method);
        }

        RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
        switch (call.method) {
            case "start": {
                int effectId = arguments.optInt("effectId");
                String filePath = arguments.optString("filePath");
                AudioEffectPlayerConfig config = RTCType.toAudioEffectPlayerConfig(arguments.optBox("config"));
                int retValue = mPlayer.start(effectId, filePath, config);
                result.success(retValue);
                break;
            }

            case "stop": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.stop(effectId);
                result.success(retValue);
                break;
            }

            case "stopAll": {
                int retValue = mPlayer.stopAll();
                result.success(retValue);
                break;
            }

            case "preload": {
                int effectId = arguments.optInt("effectId");
                String filePath = arguments.optString("filePath");
                int retValue = mPlayer.preload(effectId, filePath);
                result.success(retValue);
                break;
            }

            case "unload": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.unload(effectId);
                result.success(retValue);
                break;
            }

            case "unloadAll": {
                int retValue = mPlayer.unloadAll();
                result.success(retValue);
                break;
            }

            case "pause": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.pause(effectId);
                result.success(retValue);
                break;
            }

            case "pauseAll": {
                int retValue = mPlayer.pauseAll();
                result.success(retValue);
                break;
            }

            case "resume": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.resume(effectId);
                result.success(retValue);
                break;
            }

            case "resumeAll": {
                int retValue = mPlayer.resumeAll();
                result.success(retValue);
                break;
            }

            case "setPosition": {
                int effectId = arguments.optInt("effectId");
                int position = arguments.optInt("position");
                int retValue = mPlayer.setPosition(effectId, position);
                result.success(retValue);
                break;
            }

            case "getPosition": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.getPosition(effectId);
                result.success(retValue);
                break;
            }

            case "setVolume": {
                int effectId = arguments.optInt("effectId");
                int volume = arguments.optInt("volume");
                int retValue = mPlayer.setVolume(effectId, volume);
                result.success(retValue);
                break;
            }

            case "setVolumeAll": {
                int volume = arguments.optInt("volume");
                int retValue = mPlayer.setVolumeAll(volume);
                result.success(retValue);
                break;
            }

            case "getVolume": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.getVolume(effectId);
                result.success(retValue);
                break;
            }

            case "getDuration": {
                int effectId = arguments.optInt("effectId");
                int retValue = mPlayer.getDuration(effectId);
                result.success(retValue);
                break;
            }

            default: {
                result.notImplemented();
                break;
            }
        }
    };
}
