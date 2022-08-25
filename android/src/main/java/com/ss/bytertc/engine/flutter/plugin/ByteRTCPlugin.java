/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.plugin;

import android.content.Context;

import androidx.annotation.NonNull;

import com.ss.bytertc.engine.flutter.base.RTCVideoManager;
import com.ss.bytertc.engine.flutter.render.RTCSurfaceViewFactory;
import com.ss.bytertc.engine.flutter.video.RTCVideoPlugin;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.platform.PlatformViewRegistry;

/**
 * ByteRTCPlugin 总入口管理类
 *
 * @see RTCVideoPlugin RTCVideo 交互管理类
 */
public class ByteRTCPlugin implements FlutterPlugin {
    private final RTCVideoPlugin mVideoPlugin = new RTCVideoPlugin();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        // Hold an application context
        Context applicationContext = binding.getApplicationContext();
        RTCVideoManager.setAppContext(applicationContext);

        // Register platform view
        PlatformViewRegistry platformViewRegistry = binding.getPlatformViewRegistry();
        platformViewRegistry.registerViewFactory("ByteRTCSurfaceView",
                new RTCSurfaceViewFactory(binding.getBinaryMessenger()));

        // Forward to video plugin
        mVideoPlugin.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mVideoPlugin.onDetachedFromEngine(binding);
    }
}
