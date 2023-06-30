/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.flutter.BuildConfig;

import org.json.JSONObject;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCTypeBox {
    private static final String TAG = "RTCTypeBox";

    public final Object arguments;

    public final String logEx;

    public RTCTypeBox(Object arguments) {
        this(arguments, null);
    }

    public RTCTypeBox(Object arguments, String logEx) {
        this.arguments = arguments;
        this.logEx = logEx;
    }

    public <T> T opt(String key, T defaultValue, Class<T> clazz) {
        if (arguments == null) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "[" + logEx + "] " + "Error: Content is NULL: " + key);
            }
            return defaultValue;
        }

        final Object value = ((Map<?, ?>) arguments).get(key);
        if (value == null) {
            if (BuildConfig.DEBUG) {
                Logger.d(TAG, "[" + logEx + "] " + "Error: MISSING KEY: " + key);
            }
            return defaultValue;
        }

        if (clazz.isInstance(value)) {
            return clazz.cast(value);
        } else if (clazz == Float.class) { // Dart 中没有 Float 类型，使用 Double 适配
            if (value instanceof Double) {
                return clazz.cast(((Double) value).floatValue());
            }
        } else if (clazz == Long.class) { // int, if 32 bits not enough
            if (value instanceof Integer) {
                return clazz.cast(((Integer) value).longValue());
            }
        } else if (clazz == Integer.class) { // int, if 32 bits not enough
            if (value instanceof Long) {
                return clazz.cast(((Long) value).intValue());
            }
        }

        throw new ClassCastException("Argument (" + key + "): Cannot cast " + value.getClass() + " to " + clazz);
    }

    public int optInt(String key) {
        return optInt(key, 0);
    }

    public int optInt(String key, int defaultValue) {
        return opt(key, defaultValue, Integer.class);
    }

    public double optDouble(String key) {
        return opt(key, 0.0, Double.class);
    }

    public String optString(String key, String defaultValue) {
        return opt(key, defaultValue, String.class);
    }

    public String optString(String key) {
        return optString(key, "");
    }

    public boolean optBoolean(String key) {
        return opt(key, Boolean.FALSE, Boolean.class);
    }

    public boolean optBoolean(String key, boolean defValue) {
        return opt(key, defValue, Boolean.class);
    }

    public RTCTypeBox optBox(String key) {
        if (arguments == null) {
            return new RTCTypeBox(null, logEx);
        }
        return new RTCTypeBox(opt(key, null, Map.class), logEx);
    }

    @SuppressWarnings("unchecked")
    public <T> List<T> getList(String key) {
        return opt(key, Collections.emptyList(), List.class);
    }

    public JSONObject optJSONObject(String key) {
        return new JSONObject(opt(key, Collections.emptyMap(), Map.class));
    }

    @Nullable
    public JSONObject optNullJSONObject(String key) {
        Map<?, ?> opt = opt(key, null, Map.class);
        if (opt == null) {
            return null;
        }
        return new JSONObject(opt);
    }

    public byte[] optBytes(String key) {
        return opt(key, new byte[0], byte[].class);
    }

    public byte[] optBytes(String key, byte[] defaultValue) {
        return opt(key, defaultValue, byte[].class);
    }

    public long optLong(String key) {
        return opt(key, 0L, Long.class);
    }

    /**
     * 中没有 Float 类型，所以使用 Double 承接数据，转换为 Float
     */
    public float optFloat(String key) {
        return opt(key, 0F, Float.class);
    }
}
