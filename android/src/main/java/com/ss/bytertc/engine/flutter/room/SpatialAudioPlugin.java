/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.room;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.annotation.UiThread;

import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.audio.ISpatialAudio;
import com.ss.bytertc.engine.data.HumanOrientation;
import com.ss.bytertc.engine.data.Position;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class SpatialAudioPlugin extends RTCFlutterPlugin {

    private final Integer mIns;
    @NonNull
    private final RTCRoom mRTCRoom;

    public SpatialAudioPlugin(Integer roomInsId, @NonNull RTCRoom rtcRoom) {
        mIns = roomInsId;
        mRTCRoom = rtcRoom;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_spatial_audio" + mIns);
        channel.setMethodCallHandler(callHandler);
    }

    private final MethodChannel.MethodCallHandler callHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(getTAG(), "ISpatialAudio Call: " + call.method);
            }
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
            ISpatialAudio mSpatialAudio = mRTCRoom.getSpatialAudio();
            switch (call.method) {
                case "enableSpatialAudio": {
                    boolean enable = arguments.optBoolean("enable");
                    mSpatialAudio.enableSpatialAudio(enable);

                    result.success(null);
                    break;
                }

                case "updatePosition": {
                    Position position = RTCType.toBytePosition(arguments.optBox("pos"));
                    int retValue = mSpatialAudio.updatePosition(position);

                    result.success(retValue);
                    break;
                }

                case "updateSelfOrientation": {
                    HumanOrientation orientation = RTCType.toHumanOrientation(arguments.optBox("orientation"));
                    int retValue = mSpatialAudio.updateSelfOrientation(orientation);

                    result.success(retValue);
                    break;
                }

                case "disableRemoteOrientation": {
                    mSpatialAudio.disableRemoteOrientation();

                    result.success(null);
                    break;
                }

                case "updateListenerPosition": {
                    Position position = RTCType.toBytePosition(arguments.optBox("pos"));
                    int retValue = mSpatialAudio.updateListenerPosition(position);

                    result.success(retValue);
                    break;
                }

                case "updateListenerOrientation": {
                    HumanOrientation orientation = RTCType.toHumanOrientation(arguments.optBox("orientation"));
                    int retValue = mSpatialAudio.updateListenerOrientation(orientation);

                    result.success(retValue);
                    break;
                }

                default: {
                    result.notImplemented();
                    break;
                }
            }
        }
    };
}
