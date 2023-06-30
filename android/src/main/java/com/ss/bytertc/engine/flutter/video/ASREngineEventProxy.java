/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.handler.IRTCASREngineEventHandler;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class ASREngineEventProxy implements IRTCASREngineEventHandler {

    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_asr");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onSuccess() {
        final HashMap<String, Object> map = new HashMap<>();
        emitter.emit("onSuccess", map);
    }

    @Override
    public void onMessage(String message) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("message", message);
        emitter.emit("onMessage", map);
    }

    @Override
    public void onError(int errorCode, String errorMessage) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("errorCode", errorCode);
        map.put("errorMessage", errorMessage);
        emitter.emit("onError", map);
    }
}
