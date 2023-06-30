/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.room;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;
import androidx.annotation.UiThread;

import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.audio.IRangeAudio;
import com.ss.bytertc.engine.data.Position;
import com.ss.bytertc.engine.data.ReceiveRange;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.engine.type.AttenuationType;

import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RangeAudioPlugin extends RTCFlutterPlugin {

    private final Integer mIns;
    @NonNull
    private final RTCRoom mRTCRoom;

    public RangeAudioPlugin(Integer roomInsId, @NonNull RTCRoom rtcRoom) {
        mIns = roomInsId;
        mRTCRoom = rtcRoom;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_range_audio" + mIns);
        channel.setMethodCallHandler(callHandler);
    }

    private final MethodChannel.MethodCallHandler callHandler = new MethodChannel.MethodCallHandler() {
        @UiThread
        @Override
        public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            if (BuildConfig.DEBUG) {
                Logger.d(getTAG(), "IRangeAudio Call: " + call.method);
            }
            RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
            IRangeAudio mRangeAudio = mRTCRoom.getRangeAudio();
            switch (call.method) {
                case "enableRangeAudio": {
                    boolean enable = arguments.optBoolean("enable");
                    mRangeAudio.enableRangeAudio(enable);

                    result.success(null);
                    break;
                }

                case "updateReceiveRange": {
                    ReceiveRange range = RTCType.toReceiveRange(arguments.optBox("range"));
                    int retValue = mRangeAudio.updateReceiveRange(range);

                    result.success(retValue);
                    break;
                }

                case "updatePosition": {
                    Position position = RTCType.toBytePosition(arguments.optBox("pos"));
                    int retValue = mRangeAudio.updatePosition(position);

                    result.success(retValue);
                    break;
                }

                case "setAttenuationModel": {
                    AttenuationType type = RTCType.toAttenuationType(arguments.optInt("type"));
                    float coefficient = arguments.optFloat("coefficient");
                    int retValue = mRangeAudio.setAttenuationModel(type, coefficient);
                    result.success(retValue);
                    break;
                }

                case "setNoAttenuationFlags": {
                    List<String> flags = arguments.getList("flags");
                    mRangeAudio.setNoAttenuationFlags(flags);
                    result.success(null);
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
