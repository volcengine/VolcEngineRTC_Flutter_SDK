/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.screencapture;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.data.ScreenMediaType;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class LaunchHelper {
    private static final String TAG = "LaunchHelper";
    static final String EXTRA_STREAM_TYPE = "type";

    public static boolean requestScreenCapture(Context context, ScreenMediaType type) {
        try {
            Intent intent = new Intent(context.getPackageName() + ".action.REQUEST_SCREEN_CAPTURE");
            intent.setPackage(context.getPackageName());
            intent.putExtra(EXTRA_STREAM_TYPE, type);

            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
            return true;
        } catch (ActivityNotFoundException anfe) {
            Log.d(TAG, "requestScreenCapture", anfe);
            return false;
        }
    }
}
