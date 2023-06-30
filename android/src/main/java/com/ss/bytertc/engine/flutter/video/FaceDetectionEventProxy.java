/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.video.ExpressionDetectResult;
import com.ss.bytertc.engine.video.FaceDetectionResult;
import com.ss.bytertc.engine.video.IFaceDetectionObserver;

import java.util.HashMap;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class FaceDetectionEventProxy implements IFaceDetectionObserver {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger, String channelName) {
        emitter.registerEvent(binaryMessenger, channelName);
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onFaceDetectResult(FaceDetectionResult result) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("detectResult", result.detectResult);
        map.put("imageWidth", result.imageWidth);
        map.put("imageHeight", result.imageHeight);
        map.put("faces", RTCMap.from(result.faces));
        map.put("frameTimestampUs", result.frameTimestampUs);

        HashMap<String, Object> ret = new HashMap<>();
        ret.put("result", map);
        emitter.emit("onFaceDetectResult", ret);
    }

    @Override
    public void onExpressionDetectResult(ExpressionDetectResult result) {
    }
}
