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

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_face_detection");
    }

    @Override
    public void onFaceDetectResult(FaceDetectionResult result) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("detectResult", result.detectResult);
        map.put("imageWidth", result.imageWidth);
        map.put("imageHeight", result.imageHeight);
        map.put("faces", RTCMap.from(result.faces));

        HashMap<String, Object> ret = new HashMap<>();
        ret.put("result", map);
        emitter.emit("onFaceDetectResult", ret);
    }

    @Override
    public void onExpressionDetectResult(ExpressionDetectResult result) {
//        final HashMap<String, Object> map = new HashMap<>();
//        map.put("detectResult", result.detectResult);
//        map.put("faceCount", result.faceCount);
//        map.put("detectInfo", RTCMap.from(result.detectInfo));
//
//        HashMap<String, Object> ret = new HashMap<>();
//        ret.put("ret", map);
//        emitter.emit("onExpressionDetectResult", ret);
    }
}
