/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.audio.IMediaPlayer;
import com.ss.bytertc.engine.data.AudioMixingDualMonoMode;
import com.ss.bytertc.engine.data.AudioMixingType;
import com.ss.bytertc.engine.data.MediaPlayerConfig;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class MediaPlayerPlugin extends RTCFlutterPlugin {

    private IMediaPlayer mPlayer;
    private final int mPlayerId;
    private final MediaPlayerEventProxy mPlayerEventProxy = new MediaPlayerEventProxy();

    MediaPlayerPlugin(@NonNull IMediaPlayer player, int playerId) {
        mPlayer = player;
        mPlayerId = playerId;
        mPlayer.setEventHandler(mPlayerEventProxy);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_media_player_" + mPlayerId);
        channel.setMethodCallHandler(callHandler);
        mPlayerEventProxy.registerEvent(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_media_player_event_" + mPlayerId);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);
        mPlayerEventProxy.destroy();
    }

    private final MethodChannel.MethodCallHandler callHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "IMediaPlayer Call: " + call.method);
        }

        RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
        switch (call.method) {
            case "open": {
                String filePath = arguments.optString("filePath");
                MediaPlayerConfig config = RTCType.toMediaPlayerConfig(arguments.optBox("config"));
                int retValue = mPlayer.open(filePath, config);
                result.success(retValue);
                break;
            }

            case "start": {
                int retValue = mPlayer.start();
                result.success(retValue);
                break;
            }

            case "stop": {
                int retValue = mPlayer.stop();
                result.success(retValue);
                break;
            }

            case "pause": {
                int retValue = mPlayer.pause();
                result.success(retValue);
                break;
            }

            case "resume": {
                int retValue = mPlayer.resume();
                result.success(retValue);
                break;
            }

            case "setVolume": {
                int volume = arguments.optInt("volume");
                AudioMixingType type = AudioMixingType.fromId(arguments.optInt("type"));
                int retValue = mPlayer.setVolume(volume, type);
                result.success(retValue);
                break;
            }

            case "getVolume": {
                AudioMixingType type = AudioMixingType.fromId(arguments.optInt("type"));
                int retValue = mPlayer.getVolume(type);
                result.success(retValue);
                break;
            }

            case "getTotalDuration": {
                int retValue = mPlayer.getTotalDuration();
                result.success(retValue);
                break;
            }

            case "getPlaybackDuration": {
                int retValue = mPlayer.getPlaybackDuration();
                result.success(retValue);
                break;
            }

            case "getPosition": {
                int retValue = mPlayer.getPosition();
                result.success(retValue);
                break;
            }

            case "setAudioPitch": {
                int pitch = arguments.optInt("pitch");
                int retValue = mPlayer.setAudioPitch(pitch);
                result.success(retValue);
                break;
            }

            case "setPosition": {
                int position = arguments.optInt("position");
                int retValue = mPlayer.setPosition(position);
                result.success(retValue);
                break;
            }

            case "setAudioDualMonoMode": {
                AudioMixingDualMonoMode mode = AudioMixingDualMonoMode.fromId(arguments.optInt("mode"));
                int retValue = mPlayer.setAudioDualMonoMode(mode);
                result.success(retValue);
                break;
            }

            case "getAudioTrackCount": {
                int retValue = mPlayer.getAudioTrackCount();
                result.success(retValue);
                break;
            }

            case "selectAudioTrack": {
                int index = arguments.optInt("index");
                int retValue = mPlayer.selectAudioTrack(index);
                result.success(retValue);
                break;
            }

            case "setPlaybackSpeed": {
                int speed = arguments.optInt("speed");
                int retValue = mPlayer.setPlaybackSpeed(speed);
                result.success(retValue);
                break;
            }

            case "setProgressInterval": {
                long interval = arguments.optLong("interval");
                int retValue = mPlayer.setProgressInterval(interval);
                result.success(retValue);
                break;
            }

            case "setLoudness": {
                float loudness = arguments.optFloat("loudness");
                int retValue = mPlayer.setLoudness(loudness);
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
