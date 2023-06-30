/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import com.ss.bytertc.engine.ISingScoringEventHandler;
import com.ss.bytertc.engine.data.SingScoringRealtimeInfo;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

public class SingScoringEventProxy implements ISingScoringEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_sing_scoring_event_handler");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onCurrentScoringInfo(SingScoringRealtimeInfo info) {
        final HashMap<String, Object> map = new HashMap<>();
        if (info != null) {
            map.put("info", RTCMap.from(info));
        }
        emitter.emit("onCurrentScoringInfo", map);
    }
}
