/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.ktv;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.BuildConfig;
import com.ss.bytertc.engine.flutter.base.Logger;
import com.ss.bytertc.engine.flutter.base.RTCType;
import com.ss.bytertc.engine.flutter.base.RTCTypeBox;
import com.ss.bytertc.engine.flutter.plugin.RTCFlutterPlugin;
import com.ss.bytertc.ktv.KTVManager;
import com.ss.bytertc.ktv.KTVPlayer;
import com.ss.bytertc.ktv.data.DownloadLyricType;
import com.ss.bytertc.ktv.data.MusicFilterType;
import com.ss.bytertc.ktv.data.MusicHotType;

import io.flutter.plugin.common.MethodChannel;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class KTVManagerPlugin extends RTCFlutterPlugin {

    private KTVManager mKTVManager;
    private final KTVEventProxy mEventProxy = new KTVEventProxy();

    private KTVPlayerPlugin mKTVPlayer;

    public KTVManagerPlugin(@NonNull KTVManager ktvManager) {
        mKTVManager = ktvManager;
        ktvManager.setKTVEventHandler(mEventProxy);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        super.onAttachedToEngine(binding);

        channel = new MethodChannel(binding.getBinaryMessenger(), "com.bytedance.ve_rtc_ktv_manager");
        channel.setMethodCallHandler(callHandler);
        mEventProxy.registerEvent(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        super.onDetachedFromEngine(binding);

        mEventProxy.destroy();
        if (mKTVPlayer != null) {
            mKTVPlayer.onDetachedFromEngine(binding);
        }
    }

    private final MethodChannel.MethodCallHandler callHandler = (call, result) -> {
        if (BuildConfig.DEBUG) {
            Logger.d(getTAG(), "KTVManager Call: " + call.method);
        }
        RTCTypeBox arguments = new RTCTypeBox(call.arguments, call.method);
        switch (call.method) {

            case "getMusicList": {
                int pageNum = arguments.optInt("pageNum");
                int pageSize = arguments.optInt("pageSize");
                MusicFilterType[] filters = RTCType.toMusicFilterTypes(arguments.getList("filters"));
                mKTVManager.getMusicList(pageNum, pageSize, filters);
                result.success(null);
                break;
            }

            case "searchMusic": {
                String keyWord = arguments.optString("keyWord");
                int pageNum = arguments.optInt("pageNum");
                int pageSize = arguments.optInt("pageSize");
                MusicFilterType[] filters = RTCType.toMusicFilterTypes(arguments.getList("filters"));
                mKTVManager.searchMusic(keyWord, pageNum, pageSize, filters);
                result.success(null);
                break;
            }

            case "getHotMusic": {
                MusicHotType[] hotTypes = RTCType.toMusicHotTypes(arguments.getList("hotTypes"));
                MusicFilterType[] filters = RTCType.toMusicFilterTypes(arguments.getList("filters"));
                mKTVManager.getHotMusic(hotTypes, filters);
                result.success(null);
                break;
            }

            case "getMusicDetail": {
                String musicId = arguments.optString("musicId");
                mKTVManager.getMusicDetail(musicId);
                result.success(null);
                break;
            }

            case "downloadMusic": {
                String musicId = arguments.optString("musicId");
                int downloadId = mKTVManager.downloadMusic(musicId);
                result.success(downloadId);
                break;
            }

            case "downloadLyric": {
                String musicId = arguments.optString("musicId");
                DownloadLyricType lyricType = DownloadLyricType.fromId(arguments.optInt("lyricType"));
                int downloadId = mKTVManager.downloadLyric(musicId, lyricType);
                result.success(downloadId);
                break;
            }

            case "downloadMidi": {
                String musicId = arguments.optString("musicId");
                int downloadId = mKTVManager.downloadMidi(musicId);
                result.success(downloadId);
                break;
            }

            case "cancelDownload": {
                int downloadId = arguments.optInt("downloadId");
                mKTVManager.cancelDownload(downloadId);
                result.success(null);
                break;
            }

            case "clearCache": {
                mKTVManager.clearCache();
                result.success(null);
                break;
            }

            case "setMaxCacheSize": {
                int maxCacheSizeMB = arguments.optInt("maxCacheSizeMB");
                mKTVManager.setMaxCacheSize(maxCacheSizeMB);
                result.success(null);
                break;
            }

            case "getKTVPlayer": {
                if (mKTVPlayer != null) {
                    result.success(true);
                    break;
                }
                KTVPlayer player = mKTVManager.getKTVPlayer();
                boolean res = player != null;
                if (res) {
                    mKTVPlayer = new KTVPlayerPlugin(player);
                    mKTVPlayer.onAttachedToEngine(binding);
                }
                result.success(res);
                break;
            }

            default: {
                result.notImplemented();
                break;
            }
        }
    };
}
