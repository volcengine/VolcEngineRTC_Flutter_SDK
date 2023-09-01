/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.IAudioEffectPlayerEventHandler;
import com.ss.bytertc.engine.data.PlayerError;
import com.ss.bytertc.engine.data.PlayerState;
import com.ss.bytertc.engine.flutter.event.EventEmitter;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class AudioEffectPlayerEventProxy implements IAudioEffectPlayerEventHandler {

    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_audio_effect_player_event");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onAudioEffectPlayerStateChanged(int effectId, PlayerState state, PlayerError error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("effectId", effectId);
        map.put("state", state.value());
        map.put("error", error.value());
        emitter.emit("onAudioEffectPlayerStateChanged", map);
    }
}
