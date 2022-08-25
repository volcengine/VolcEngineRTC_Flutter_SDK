/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import android.util.Log;

import androidx.annotation.RestrictTo;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public final class Logger {
    private static final String TAG = "ByteRTCF";

    private Logger() {
    }

    public static void d(String tag, String message) {
        Log.d(TAG, "[" + tag + "] " + message);
    }

    public static void d(String tag, String message, Throwable tr) {
        Log.d(TAG, "[" + tag + "] " + message, tr);
    }

    public static void e(String tag, String message) {
        Log.e(TAG, "[" + tag + "] " + message);
    }
}
