/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.ktv;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.ktv.IKTVEventHandler;
import com.ss.bytertc.ktv.data.DownloadResult;
import com.ss.bytertc.ktv.data.HotMusicInfo;
import com.ss.bytertc.ktv.data.Music;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class KTVEventProxy extends IKTVEventHandler {
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger binaryMessenger) {
        emitter.registerEvent(binaryMessenger, "com.bytedance.ve_rtc_ktv_manager_event");
    }

    public void destroy() {
        emitter.destroy();
    }

    @Override
    public void onMusicListResult(int errorCode, int totalSize, Music[] musics) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode);
        map.put("totalSize", totalSize);
        List<Map<String, ?>> musicList = RTCMap.from(musics);
        if (musicList != null) {
            map.put("musics", musicList);
        }
        emitter.emit("onMusicListResult", map);
    }

    @Override
    public void onSearchMusicResult(int errorCode, int totalSize, Music[] musics) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode);
        map.put("totalSize", totalSize);
        List<Map<String, ?>> musicList = RTCMap.from(musics);
        if (musicList != null) {
            map.put("musics", musicList);
        }
        emitter.emit("onSearchMusicResult", map);
    }

    @Override
    public void onHotMusicResult(int errorCode, HotMusicInfo[] hotMusics) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode);
        List<Map<String, ?>> hotMusicList = RTCMap.from(hotMusics);
        if (hotMusicList != null) {
            map.put("hotMusics", hotMusicList);
        }
        emitter.emit("onHotMusicResult", map);
    }

    @Override
    public void onMusicDetailResult(int errorCode, Music music) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("error", errorCode);
        if (music != null) {
            map.put("music", RTCMap.from(music));
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
    public void onDownloadFail(int downloadId, int errorCode) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("downloadId", downloadId);
        map.put("error", errorCode);
        emitter.emit("onDownloadFail", map);
    }

    @Override
    public void onDownloadMusicProgress(int downloadId, int downloadProgress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("downloadId", downloadId);
        map.put("downloadProgress", downloadProgress);
        emitter.emit("onDownloadMusicProgress", map);
    }
}
