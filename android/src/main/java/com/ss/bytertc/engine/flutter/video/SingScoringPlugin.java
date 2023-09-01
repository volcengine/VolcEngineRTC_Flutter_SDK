/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.audio.ISingScoringManager;
import com.ss.bytertc.engine.data.SingScoringConfig;
import com.ss.bytertc.engine.data.StandardPitchInfo;
import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class SingScoringPlugin extends RTCFlutterPlugin {

    private ISingScoringManager mSingScoringManager;
    private final SingScoringEventProxy mSingScoringEventProxy = new SingScoringEventProxy();

    SingScoringPlugin(@NonNull ISingScoringManager manager) {
        mSingScoringManager = manager;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_sing_scoring_manager");
        channel.setMethodCallHandler(methodCallHandler);
        mSingScoringEventProxy.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);
        mSingScoringEventProxy.destroy();
    }

    private final MethodChannel.MethodCallHandler methodCallHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "ISingScoringManager Call: " + call.method);
        }
        RTCTypeBox arguments = new RTCTypeBox(call.arguments);

        switch (call.method) {
            case "initSingScoring": {
                String singScoringAppKey = arguments.optString("singScoringAppKey");
                String singScoringToken = arguments.optString("singScoringToken");
                boolean handler = arguments.optBoolean("handler");
                int retValue;
                if (handler) {
                    retValue = mSingScoringManager.initSingScoring(singScoringAppKey, singScoringToken, mSingScoringEventProxy);
                } else {
                    retValue = mSingScoringManager.initSingScoring(singScoringAppKey, singScoringToken, null);
                }
                result.success(retValue);
                break;
            }

            case "setSingScoringConfig": {
                SingScoringConfig config = RTCType.toSingScoringConfig(arguments.optBox("config"));
                int retValue = mSingScoringManager.setSingScoringConfig(config);
                result.success(retValue);
                break;
            }

            case "getStandardPitchInfo": {
                String midiFilepath = arguments.optString("midiFilepath");
                List<StandardPitchInfo> infoList = mSingScoringManager.getStandardPitchInfo(midiFilepath);
                if (infoList == null || infoList.isEmpty()) {
                    result.success(null);
                } else {
                    result.success(RTCMap.from(infoList));
                }
                break;
            }

            case "startSingScoring": {
                int position = arguments.optInt("position");
                int scoringInfoInterval = arguments.optInt("scoringInfoInterval");
                int retValue = mSingScoringManager.startSingScoring(position, scoringInfoInterval);
                result.success(retValue);
                break;
            }

            case "stopSingScoring": {
                int retValue = mSingScoringManager.stopSingScoring();
                result.success(retValue);
                break;
            }

            case "getLastSentenceScore": {
                int retValue = mSingScoringManager.getLastSentenceScore();
                result.success(retValue);
                break;
            }

            case "getTotalScore": {
                int retValue = mSingScoringManager.getTotalScore();
                result.success(retValue);
                break;
            }

            case "getAverageScore": {
                int retValue = mSingScoringManager.getAverageScore();
                result.success(retValue);
                break;
            }

            default:
                result.notImplemented();
                break;
        }
    };
}
