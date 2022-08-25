/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.event;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.volc_engine_rtc.BuildConfig;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class EventEmitter {
    private static final String TAG = "EventEmitter";

    private static final String METHOD_NAME = "methodName";

    private final Handler mainThreadHandler = new Handler(Looper.getMainLooper());
    private EventChannel.EventSink eventSink;

    public void registerEvent(@NonNull BinaryMessenger binaryMessenger, @NonNull String channelName) {
        EventChannel eventChannel = new EventChannel(binaryMessenger, channelName);
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                eventSink = events;
            }

            @Override
            public void onCancel(Object arguments) {
                eventSink = null;
            }
        });
    }

    public void emit(@NonNull String methodName, @NonNull HashMap<String, Object> map) {
        if (BuildConfig.DEBUG) {
            Logger.d(TAG, "emit: " + methodName);
        }
        map.put(METHOD_NAME, methodName);
        mainThreadHandler.post(() -> {
            if (eventSink != null) eventSink.success(map);
        });
    }
}
