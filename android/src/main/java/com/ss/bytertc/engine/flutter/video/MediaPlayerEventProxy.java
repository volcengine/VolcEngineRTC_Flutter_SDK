/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.IMediaPlayerEventHandler;
import com.ss.bytertc.engine.data.PlayerError;
import com.ss.bytertc.engine.data.PlayerState;
import com.ss.bytertc.engine.flutter.event.EventEmitter;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class MediaPlayerEventProxy implements IMediaPlayerEventHandler {

    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(@NonNull BinaryMessenger binaryMessenger, @NonNull String channelName) {
        emitter.registerEvent(binaryMessenger, channelName);
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onMediaPlayerStateChanged(int playerId, PlayerState state, PlayerError error) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("playerId", playerId);
        map.put("state", state.value());
        map.put("error", error.value());
        emitter.emit("onMediaPlayerStateChanged", map);
    }

    @Override
    public void onMediaPlayerPlayingProgress(int playerId, long progress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("playerId", playerId);
        map.put("progress", progress);
        emitter.emit("onMediaPlayerPlayingProgress", map);
    }
}
