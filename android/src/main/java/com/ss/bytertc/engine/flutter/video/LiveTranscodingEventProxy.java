/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.live.ByteRTCStreamMixingEvent;
import com.ss.bytertc.engine.live.ByteRTCStreamMixingType;
import com.ss.bytertc.engine.live.ByteRTCTranscoderErrorCode;
import com.ss.bytertc.engine.live.ILiveTranscodingObserver;

import org.webrtc.VideoFrame;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class LiveTranscodingEventProxy implements ILiveTranscodingObserver {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_live_transcoding");
    }

    @Override
    public boolean isSupportClientPushStream() {
        return false;
    }

    @Override
    public void onStreamMixingEvent(ByteRTCStreamMixingEvent eventType, String taskId, ByteRTCTranscoderErrorCode error, ByteRTCStreamMixingType mixType) {
        HashMap<String, Object> map = new HashMap<>();
        map.put("eventType", eventType.value());
        map.put("taskId", taskId);
        map.put("error", error.value());
        map.put("mixType", mixType.value());

        emitter.emit("onStreamMixingEvent", map);
    }

    @Override
    public void onMixingAudioFrame(String taskId, byte[] audioFrame, int frameNum) {

    }

    @Override
    public void onMixingVideoFrame(String taskId, VideoFrame VideoFrame) {

    }

    @Override
    public void onDataFrame(String taskId, byte[] dataFrame, long time) {

    }
}
