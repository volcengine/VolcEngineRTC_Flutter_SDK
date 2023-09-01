/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.ktv;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.ktv.IKTVManagerEventHandler;
import com.ss.bytertc.ktv.data.DownloadResult;
import com.ss.bytertc.ktv.data.HotMusicInfo;
import com.ss.bytertc.ktv.data.KTVErrorCode;
import com.ss.bytertc.ktv.data.MusicInfo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class KTVManagerEventProxy extends IKTVManagerEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_ktv_manager_event");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onMusicListResult(MusicInfo[] musicInfos, int totalSize, KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode.value());
        map.put("totalSize", totalSize);
        List<Map<String, ?>> musicList = RTCMap.from(musicInfos);
        if (musicList != null) {
            map.put("musicInfos", musicList);
        }
        emitter.emit("onMusicListResult", map);
    }

    @Override
    public void onSearchMusicResult(MusicInfo[] musicInfos, int totalSize, KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode.value());
        map.put("totalSize", totalSize);
        List<Map<String, ?>> musicList = RTCMap.from(musicInfos);
        if (musicList != null) {
            map.put("musicInfos", musicList);
        }
        emitter.emit("onSearchMusicResult", map);
    }

    @Override
    public void onHotMusicResult(HotMusicInfo[] hotMusics, KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode.value());
        List<Map<String, ?>> hotMusicList = RTCMap.from(hotMusics);
        if (hotMusicList != null) {
            map.put("hotMusics", hotMusicList);
        }
        emitter.emit("onHotMusicResult", map);
    }

    @Override
    public void onMusicDetailResult(MusicInfo musicInfo, KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode.value());
        if (musicInfo != null) {
            map.put("musicInfo", RTCMap.from(musicInfo));
        }
        emitter.emit("onMusicDetailResult", map);
    }

    @Override
    public void onDownloadSuccess(int downloadId, DownloadResult result) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("downloadId", downloadId);
        map.put("result", RTCMap.from(result));
        emitter.emit("onDownloadSuccess", map);
    }

    @Override
    public void onDownloadFailed(int downloadId, KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("downloadId", downloadId);
        map.put("error", errorCode.value());
        emitter.emit("onDownloadFailed", map);
    }

    @Override
    public void onDownloadMusicProgress(int downloadId, int downloadProgress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("downloadId", downloadId);
        map.put("downloadProgress", downloadProgress);
        emitter.emit("onDownloadMusicProgress", map);
    }

    @Override
    public void onClearCacheResult(KTVErrorCode errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode.value());
        emitter.emit("onClearCacheResult", map);
    }
}
