/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.UiThread;

import com.ss.bytertc.engine.RTCRoom;
import com.ss.bytertc.engine.RTCVideo;
import com.ss.bytertc.engine.handler.IRTCVideoEventHandler;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public final class RTCVideoManager {
    @SuppressLint("StaticFieldLeak")
    private static Context mAppCxt;

    public static void setAppContext(Context cxt) {
        mAppCxt = cxt.getApplicationContext();
    }

    /**
     * 全局单例的 RTCVideo 对象
     */
    private static RTCVideo sRtcVideo;

    /**
     * 创建 RtcVideo
     *
     * @param appId      应用 ID
     * @param handler    方法回调响应
     * @param parameters 附加参数，用于覆盖默认值
     */
    public static void create(String appId, IRTCVideoEventHandler handler, JSONObject parameters) {
        try {
            sRtcVideo = RTCVideo.createRTCVideo(mAppCxt, appId, handler, null, parameters);
        } catch (Exception e) {
            throw new RuntimeException("create engine error!", e);
        }
    }

    @UiThread
    public static void destroy() {
        Iterator<Map.Entry<Integer, RTCRoom>> iterator = sRTCRoomMap.entrySet().iterator();
        while (iterator.hasNext()) {
            Map.Entry<Integer, RTCRoom> next = iterator.next();
            next.getValue().destroy();

            iterator.remove();
        }

        RTCVideo.destroyRTCVideo();
        sRtcVideo = null;
    }

    public static boolean hasRTCVideo() {
        return sRtcVideo != null;
    }

    @NonNull
    public static RTCVideo getRTCVideo() {
        if (sRtcVideo == null) {
            throw new IllegalStateException("RTCVideo not created YET.");
        }
        return sRtcVideo;
    }

    private static final HashMap<Integer, RTCRoom> sRTCRoomMap = new HashMap<>();

    private RTCVideoManager() {

    }

    /**
     * 创建 Room 并放到缓存中
     *
     * @param roomInsId Room 的对象 ID，缓存 KEY
     * @param roomId    Room ID
     * @return RTCRoom
     * @see #getRoom(Integer)
     */
    public static RTCRoom createRoom(@NonNull Integer roomInsId, @NonNull String roomId) {
        RTCVideo rtcVideo = getRTCVideo();
        RTCRoom room = rtcVideo.createRTCRoom(roomId);
        if (room != null) {
            sRTCRoomMap.put(roomInsId, room);
        }
        return room;
    }

    /**
     * 获取指定 [insId] 对应的 room
     *
     * @param insId Room 的对象 ID，缓存 KEY
     * @return 缓存的 IRTCRoom 对象
     * @see #createRoom(Integer, String)
     */
    public static RTCRoom getRoom(@NonNull Integer insId) {
        return sRTCRoomMap.get(insId);
    }

    /**
     * 销毁指定 [insId] 对应的 room，并从缓存中移除
     *
     * @param roomIns Room 的对象 ID，缓存 KEY
     */
    public static void destroyRoom(@NonNull Integer roomIns) {
        RTCRoom room = sRTCRoomMap.remove(roomIns);
        if (room != null) {
            room.destroy();
        }
    }
}