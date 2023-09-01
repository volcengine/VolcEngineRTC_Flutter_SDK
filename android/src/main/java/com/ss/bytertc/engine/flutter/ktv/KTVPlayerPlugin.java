/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.ktv;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.ktv.IKTVPlayer;
import com.ss.bytertc.ktv.data.AudioPlayType;
import com.ss.bytertc.ktv.data.AudioTrackType;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class KTVPlayerPlugin extends RTCFlutterPlugin {

    private IKTVPlayer mKTVPlayer;
    private final KTVPlayerEventProxy mPlayerEventProxy = new KTVPlayerEventProxy();

    KTVPlayerPlugin(@NonNull IKTVPlayer ktvPlayer) {
        mKTVPlayer = ktvPlayer;
        ktvPlayer.setPlayerEventHandler(mPlayerEventProxy);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_ktv_player");
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
            Logger.d(getTAG(), "KTVPlayer Call: " + call.method);
        }
        RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
        switch (call.method) {
            case "playMusic": {
                String musicId = arguments.optString("musicId");
                AudioTrackType trackType = AudioTrackType.fromId(arguments.optInt("trackType"));
                AudioPlayType playType = AudioPlayType.fromId(arguments.optInt("playType"));
                mKTVPlayer.playMusic(musicId, trackType, playType);
                result.success(null);
                break;
            }

            case "pauseMusic": {
                String musicId = arguments.optString("musicId");
                mKTVPlayer.pauseMusic(musicId);
                result.success(null);
                break;
            }

            case "resumeMusic": {
                String musicId = arguments.optString("musicId");
                mKTVPlayer.resumeMusic(musicId);
                result.success(null);
                break;
            }

            case "stopMusic": {
                String musicId = arguments.optString("musicId");
                mKTVPlayer.stopMusic(musicId);
                result.success(null);
                break;
            }

            case "seekMusic": {
                String musicId = arguments.optString("musicId");
                int position = arguments.optInt("position");
                mKTVPlayer.seekMusic(musicId, position);
                result.success(null);
                break;
            }

            case "setMusicVolume": {
                String musicId = arguments.optString("musicId");
                int volume = arguments.optInt("volume");
                mKTVPlayer.setMusicVolume(musicId, volume);
                result.success(null);
                break;
            }

            case "switchAudioTrackType": {
                String musicId = arguments.optString("musicId");
                mKTVPlayer.switchAudioTrackType(musicId);
                result.success(null);
                break;
            }

            case "setMusicPitch": {
                String musicId = arguments.optString("musicId");
                int pitch = arguments.optInt("pitch");
                mKTVPlayer.setMusicPitch(musicId, pitch);
                result.success(null);
                break;
            }

            default: {
                result.notImplemented();
                break;
            }
        }
    };
}
