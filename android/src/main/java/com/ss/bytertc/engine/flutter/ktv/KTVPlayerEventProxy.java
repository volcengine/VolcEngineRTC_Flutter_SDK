/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.ktv;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.ktv.IKTVPlayerEventHandler;
import com.ss.bytertc.ktv.data.PlayState;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class KTVPlayerEventProxy extends IKTVPlayerEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_ktv_player_event");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onPlayProgress(@NonNull String musicId, long progress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("musicId", musicId);
        map.put("progress", progress);
        emitter.emit("onPlayProgress", map);
    }

    @Override
    public void onPlayStateChange(int errorCode, @NonNull String musicId, @NonNull PlayState playState) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("musicId", musicId);
        map.put("playState", playState.value());
        map.put("error", errorCode);
        emitter.emit("onPlayStateChange", map);
    }
}
