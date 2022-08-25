/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.render;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCSurfaceViewFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    public RTCSurfaceViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        return new RTCSurfaceView(messenger, context, viewId, args);
    }
}
