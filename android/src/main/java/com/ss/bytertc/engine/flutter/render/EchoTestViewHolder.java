/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.render;

import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.VideoCanvas;

import java.lang.ref.WeakReference;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class EchoTestViewHolder {
    @NonNull
    private static WeakReference<VideoCanvas> ref = new WeakReference<>(null);

    public static void setView(@Nullable VideoCanvas view) {
        ref = new WeakReference<>(view);
    }

    @Nullable
    public static VideoCanvas getView() {
        return ref.get();
    }

    @Nullable
    public static View getRenderView() {
        VideoCanvas view = getView();
        return view == null ? null : view.renderView;
    }
}
