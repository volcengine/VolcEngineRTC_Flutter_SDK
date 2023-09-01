/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.video;

import android.graphics.Bitmap;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.flutter.base.RTCMap;
import com.ss.bytertc.engine.flutter.event.EventEmitter;
import com.ss.bytertc.engine.video.ISnapshotResultCallback;
import io.flutter.plugin.common.BinaryMessenger;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;

public class SnapshotResultCallbackProxy {
    public static final int ERROR_WRITE_FILE_FAILED = -102;
    public static final int ERROR_IMAGE_FORMAT = -103;
    private final EventEmitter emitter = new EventEmitter();

    public void registerEvent(BinaryMessenger messenger) {
        this.emitter.registerEvent(messenger, "com.bytedance.ve_rtc_snapshot_result");
    }

    public void destroy() {
        emitter.destroy();
    }

    public ISnapshotResultCallback createCallback(String filePath) {
        return new ISnapshotResultCallback() {
            @Override
            public void onTakeLocalSnapshotResult(long taskId, StreamIndex streamIndex, Bitmap image, int errorCode) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("taskId", taskId);
                map.put("streamIndex", streamIndex.value());
                map.put("filePath", filePath);
                map.put("error", errorCode);
                if (image != null) {
                    map.put("width", image.getWidth());
                    map.put("height", image.getHeight());
                }

                storeImageToFile(image, filePath, map);

                emitter.emit("onTakeLocalSnapshotResult", map);
            }

            @Override
            public void onTakeRemoteSnapshotResult(long taskId, RemoteStreamKey streamKey, Bitmap image, int errorCode) {
                HashMap<String, Object> map = new HashMap<>();
                map.put("taskId", taskId);
                map.put("streamKey", RTCMap.from(streamKey));
                map.put("filePath", filePath);
                map.put("error", errorCode);
                if (image != null) {
                    map.put("width", image.getWidth());
                    map.put("height", image.getHeight());
                }

                storeImageToFile(image, filePath, map);

                emitter.emit("onTakeRemoteSnapshotResult", map);
            }
        };
    }

    void storeImageToFile(Bitmap image, String filePath, HashMap<String, Object> map) {
        if (image == null) {
            map.put("error", ERROR_IMAGE_FORMAT);
            return;
        }
        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            image.compress(Bitmap.CompressFormat.JPEG, 100, fos);
        } catch (IOException e) {
            map.put("error", ERROR_WRITE_FILE_FAILED);
        }
    }
}
