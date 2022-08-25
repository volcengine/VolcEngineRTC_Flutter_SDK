/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.room;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.IRangeAudioObserver;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.type.RangeAudioInfo;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RangeAudioEventProxy implements IRangeAudioObserver {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger, int instanceId) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_range_audio_observer" + instanceId);
    }

    private boolean mEnabled = false;

    public void setEnable(boolean enable) {
        mEnabled = enable;
    }

    @Override
    public void onRangeAudioInfo(RangeAudioInfo[] rangeAudioInfos) {
        if (!mEnabled) {
            return;
        }
        HashMap<String, Object> map = new HashMap<>();
        map.put("rangeAudioInfo", RTCMap.from(rangeAudioInfos));
        emitter.emit("onRangeAudioInfo", map);
    }
}
