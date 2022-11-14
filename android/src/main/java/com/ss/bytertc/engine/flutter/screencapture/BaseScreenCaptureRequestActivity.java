/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.screencapture;

import static com.ss.bytertc.engine.flutter.screencapture.LaunchHelper.EXTRA_STREAM_TYPE;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.data.ScreenMediaType;
import com.ss.bytertc.engine.flutter.base.RTCVideoManager;

import org.webrtc.RXScreenCaptureService;

public abstract class BaseScreenCaptureRequestActivity extends Activity {
    private static final int REQUEST_CODE_SCREEN_CAPTURE = 9679;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        MediaProjectionManager mediaProjectionManager = (MediaProjectionManager) getSystemService(Context.MEDIA_PROJECTION_SERVICE);
        Intent screenCaptureIntent = mediaProjectionManager.createScreenCaptureIntent();

        startActivityForResult(screenCaptureIntent, REQUEST_CODE_SCREEN_CAPTURE);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_CODE_SCREEN_CAPTURE) {
            if (resultCode == Activity.RESULT_OK) {
                Intent intent = getIntent();
                ScreenMediaType type = (ScreenMediaType) intent.getSerializableExtra(EXTRA_STREAM_TYPE);

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    startRXScreenCaptureService(data);
                }

                RTCVideo engine = RTCVideoManager.getRTCVideo();
                engine.startScreenCapture(type, data);
            } else {
                // TODO User rejected
            }
            finish();
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void startRXScreenCaptureService(Intent data) {
        final Intent intent = new Intent();
        intent.putExtra(RXScreenCaptureService.KEY_LARGE_ICON, getLargeIcon());
        intent.putExtra(RXScreenCaptureService.KEY_SMALL_ICON, getSmallIcon());
        intent.putExtra(RXScreenCaptureService.KEY_LAUNCH_ACTIVITY, getLaunchActivity().getCanonicalName());
        intent.putExtra(RXScreenCaptureService.KEY_CONTENT_TEXT, getContextText());
        intent.putExtra(RXScreenCaptureService.KEY_RESULT_DATA, data);
        startForegroundService(RXScreenCaptureService.getServiceIntent(this, RXScreenCaptureService.COMMAND_LAUNCH, intent));
    }

    /**
     * Android 10 及以上录屏通知使用
     *
     * @return
     * @see RXScreenCaptureService#KEY_LARGE_ICON
     */
    public abstract int getLargeIcon();

    /**
     * Android 10 及以上录屏通知使用
     *
     * @return
     * @see RXScreenCaptureService#KEY_LARGE_ICON
     */
    public abstract int getSmallIcon();

    /**
     * Android 10 及以上录屏通知使用
     *
     * @return
     * @see RXScreenCaptureService#KEY_LARGE_ICON
     */
    public abstract Class<? extends Activity> getLaunchActivity();

    /**
     * Android 10 及以上录屏通知使用
     *
     * @return
     * @see RXScreenCaptureService#KEY_LARGE_ICON
     */
    public abstract String getContextText();
}
