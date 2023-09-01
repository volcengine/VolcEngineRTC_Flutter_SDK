/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.live.ByteRTCStreamSinglePushEvent;
import com.ss.bytertc.engine.live.IPushSingleStreamToCDNObserver;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class PushSingleStreamToCDNProxy implements IPushSingleStreamToCDNObserver {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_push_single_stream_to_cdn");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onStreamPushEvent(ByteRTCStreamSinglePushEvent eventType, String taskId, int error) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("eventType", eventType.value());
        map.put("taskId", taskId);
        map.put("error", error);

        emitter.emit("onStreamPushEvent", map);
    }
}
