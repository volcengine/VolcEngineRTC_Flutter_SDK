/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.SubscribeConfig;
import com.ss.bytertc.engine.SysStats;
import com.ss.bytertc.engine.UserInfo;
import com.ss.bytertc.engine.data.AudioPropertiesInfo;
import com.ss.bytertc.engine.data.ForwardStreamEventInfo;
import com.ss.bytertc.engine.data.ForwardStreamStateInfo;
import com.ss.bytertc.engine.data.RecordingInfo;
import com.ss.bytertc.engine.data.RecordingProgress;
import com.ss.bytertc.engine.data.RemoteAudioPropertiesInfo;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.SingScoringRealtimeInfo;
import com.ss.bytertc.engine.data.StandardPitchInfo;
import com.ss.bytertc.engine.data.VideoFrameInfo;
import com.ss.bytertc.engine.type.LocalAudioStats;
import com.ss.bytertc.engine.type.LocalStreamStats;
import com.ss.bytertc.engine.type.LocalVideoStats;
import com.ss.bytertc.engine.type.NetworkQualityStats;
import com.ss.bytertc.engine.type.RTCRoomStats;
import com.ss.bytertc.engine.type.RemoteAudioStats;
import com.ss.bytertc.engine.type.RemoteStreamStats;
import com.ss.bytertc.engine.type.RemoteStreamSwitch;
import com.ss.bytertc.engine.type.RemoteVideoStats;
import com.ss.bytertc.engine.type.RtcUser;
import com.ss.bytertc.engine.type.SourceWantedData;
import com.ss.bytertc.engine.type.SubtitleMessage;
import com.ss.bytertc.engine.video.Rectangle;
import com.ss.bytertc.ktv.data.DownloadResult;
import com.ss.bytertc.ktv.data.HotMusicInfo;
import com.ss.bytertc.ktv.data.MusicInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 转换 RTC 的类型到 Map 中，以传输到 Flutter 层
 */
@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCMap {

    /**
     * @see RTCType#toRemoteStreamKey(RTCTypeBox)
     */
    public static Map<String, ?> from(RemoteStreamKey key) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("roomId", key.getRoomId());
        map.put("uid", key.getUserId());
        map.put("streamIndex", key.getStreamIndex().value());
        return map;
    }

    public static Map<String, ?> from(VideoFrameInfo info) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("width", info.getWidth());
        map.put("height", info.getHeight());
        map.put("rotation", info.rotation.value());
        return map;
    }

    public static Map<String, ?> from(LocalAudioStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("audioLossRate", stats.audioLossRate);
        map.put("sentKBitrate", stats.sendKBitrate);
        map.put("recordSampleRate", stats.recordSampleRate);
        map.put("statsInterval", stats.statsInterval);
        map.put("rtt", stats.rtt);
        map.put("numChannels", stats.numChannels);
        map.put("sentSampleRate", stats.sentSampleRate);
        map.put("jitter", stats.jitter);
        return map;
    }

    public static Map<String, ?> from(LocalVideoStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("sentKBitrate", stats.sentKBitrate);
        map.put("inputFrameRate", stats.inputFrameRate);
        map.put("sentFrameRate", stats.sentFrameRate);
        map.put("encoderOutputFrameRate", stats.encoderOutputFrameRate);
        map.put("renderOutputFrameRate", stats.rendererOutputFrameRate);
        map.put("statsInterval", stats.statsInterval);
        map.put("videoLossRate", stats.videoLossRate);
        map.put("rtt", stats.rtt);
        map.put("encodedBitrate", stats.encodedBitrate);
        map.put("encodedFrameWidth", stats.encodedFrameWidth);
        map.put("encodedFrameHeight", stats.encodedFrameHeight);
        map.put("encodedFrameCount", stats.encodedFrameCount);
        map.put("codecType", stats.codecType);
        map.put("isScreen", stats.isScreen);
        map.put("jitter", stats.jitter);
        return map;
    }


    public static Map<String, ?> from(LocalStreamStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("audioStats", from(stats.audioStats));
        map.put("videoStats", from(stats.videoStats));
        map.put("isScreen", stats.isScreen);
        return map;
    }

    public static Map<String, ?> from(RemoteAudioStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("audioLossRate", stats.audioLossRate);
        map.put("receivedKBitrate", stats.receivedKBitrate);
        map.put("stallCount", stats.stallCount);
        map.put("stallDuration", stats.stallDuration);
        map.put("e2eDelay", stats.e2eDelay);
        map.put("playoutSampleRate", stats.playoutSampleRate);
        map.put("statsInterval", stats.statsInterval);
        map.put("rtt", stats.rtt);
        map.put("totalRtt", stats.totalRtt);
        map.put("quality", stats.quality);
        map.put("jitterBufferDelay", stats.jitterBufferDelay);
        map.put("numChannels", stats.numChannels);
        map.put("receivedSampleRate", stats.receivedSampleRate);
        map.put("frozenRate", stats.frozenRate);
        map.put("concealedSamples", stats.concealedSamples);
        map.put("concealmentEvent", stats.concealmentEvent);
        map.put("decSampleRate", stats.decSampleRate);
        map.put("decDuration", stats.decDuration);
        map.put("jitter", stats.jitter);
        return map;
    }


    public static Map<String, ?> from(RemoteVideoStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("width", stats.width);
        map.put("height", stats.height);
        map.put("videoLossRate", stats.videoLossRate);
        map.put("receivedKBitrate", stats.receivedKBitrate);
        map.put("decoderOutputFrameRate", stats.decoderOutputFrameRate);
        map.put("renderOutputFrameRate", stats.rendererOutputFrameRate);
        map.put("stallCount", stats.stallCount);
        map.put("stallDuration", stats.stallDuration);
        map.put("e2eDelay", stats.e2eDelay);
        map.put("isScreen", stats.isScreen);
        map.put("statsInterval", stats.statsInterval);
        map.put("rtt", stats.rtt);
        map.put("frozenRate", stats.frozenRate);
        map.put("videoIndex", stats.videoIndex);
        map.put("codecType", stats.codecType);
        return map;
    }

    public static Map<String, ?> from(RemoteStreamStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("audioStats", from(stats.audioStats));
        map.put("videoStats", from(stats.videoStats));
        map.put("uid", stats.uid);
        map.put("isScreen", stats.isScreen);
        return map;
    }

    public static Map<String, ?> from(SourceWantedData data) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("width", data.width);
        map.put("height", data.height);
        map.put("frameRate", data.frameRate);
        return map;
    }

    public static Map<String, ?> from(RecordingInfo info) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("width", info.width);
        map.put("height", info.height);
        map.put("filePath", info.filePath);
        map.put("videoCodecType", info.videoCodecType.value());
        return map;
    }

    public static Map<String, ?> from(RecordingProgress progress) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("duration", progress.duration);
        map.put("fileSize", progress.fileSize);
        return map;
    }

    public static Map<String, ?> from(SysStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("cpuAppUsage", stats.cpuAppUsage);
        map.put("cpuCores", stats.cpuCores);
        map.put("cpuTotalUsage", stats.cpuTotalUsage);
        map.put("freeMemory", stats.freeMemory);
        map.put("fullMemory", stats.fullMemory);
        map.put("memoryRatio", stats.memoryRatio);
        map.put("memoryUsage", stats.memoryUsage);
        map.put("totalMemoryUsage", stats.totalMemoryUsage);
        map.put("totalMemoryRatio", stats.totalMemoryRatio);
        return map;
    }

    public static Map<String, ?> from(RTCRoomStats stats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("duration", stats.totalDuration);
        map.put("txBytes", stats.txBytes);
        map.put("rxBytes", stats.rxBytes);
        map.put("txKBitrate", stats.txKBitRate);
        map.put("rxKBitrate", stats.rxKBitRate);
        map.put("txAudioKBitrate", stats.txAudioKBitRate);
        map.put("rxAudioKBitrate", stats.rxAudioKBitRate);
        map.put("txVideoKBitrate", stats.txVideoKBitRate);
        map.put("rxVideoKBitrate", stats.rxVideoKBitRate);
        map.put("txScreenKBitrate", stats.txScreenKBitRate);
        map.put("rxScreenKBitrate", stats.rxScreenKBitRate);
        map.put("userCount", stats.users);
        map.put("cpuAppUsage", stats.cpuAppUsage);
        map.put("cpuTotalUsage", stats.cpuTotalUsage);
        map.put("txLostrate", stats.txLostrate);
        map.put("rxLostrate", stats.rxLostrate);
        map.put("rtt", stats.rtt);
        map.put("txJitter", stats.txJitter);
        map.put("rxJitter", stats.rxJitter);
        map.put("txCellularKBitrate", stats.txCellularKBitrate);
        map.put("rxCellularKBitrate", stats.rxCellularKBitrate);
        return map;
    }

    public static Map<String, ?> from(RemoteStreamSwitch event) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", event.uid);
        map.put("isScreen", event.isScreen);
        map.put("beforeVideoIndex", event.beforeVideoIndex);
        map.put("afterVideoIndex", event.afterVideoIndex);
        map.put("beforeEnable", event.beforeEnable);
        map.put("afterEnable", event.afterEnable);
        map.put("reason", event.reason.value());
        return map;
    }

    public static Map<String, ?> from(AudioPropertiesInfo info) {
        final HashMap<String, Object> result = new HashMap<>();
        result.put("linearVolume", info.linearVolume);
        result.put("nonlinearVolume", info.nonlinearVolume);
        result.put("vad", info.vad);
        final int spectrumCount = info.spectrum == null ? 0 : info.spectrum.length;
        // Flutter 2.0.0 not support float[]
        double[] spectrum = new double[spectrumCount];
        for (int i = 0; i < spectrumCount; i++) {
            spectrum[i] = info.spectrum[i];
        }
        result.put("spectrum", spectrum);
        result.put("voicePitch", info.voicePitch);
        return result;
    }

    public static Map<String, ?> from(SubscribeConfig info) {
        final HashMap<String, Object> result = new HashMap<>();
        result.put("isScreen", info.isScreen);
        result.put("subVideo", info.subVideo);
        result.put("subAudio", info.subAudio);
        result.put("videoIndex", info.videoIndex);
        result.put("subWidth", info.subWidth);
        result.put("subHeight", info.subHeight);
        result.put("subVideoIndex", info.subVideoIndex);
        result.put("svcLayer", info.svcLayer.getValue());
        result.put("frameRate", info.framerate);
        return result;
    }

    public static Map<?, ?> from(NetworkQualityStats qualityStats) {
        final HashMap<String, Object> map = new HashMap<>();
        map.put("uid", qualityStats.uid);
        map.put("fractionLost", qualityStats.fractionLost);
        map.put("rtt", qualityStats.rtt);
        map.put("totalBandwidth", qualityStats.totalBandwidth);
        map.put("txQuality", qualityStats.txQuality);
        map.put("rxQuality", qualityStats.rxQuality);
        return map;
    }

    public static List<Map<?, ?>> from(NetworkQualityStats[] qualityStats) {
        ArrayList<Map<?, ?>> list = new ArrayList<>(qualityStats.length);
        for (NetworkQualityStats qualityStat : qualityStats) {
            list.add(from(qualityStat));
        }
        return list;
    }


    public static Map<?, ?> from(ForwardStreamEventInfo eventInfo) {
        Map<String, Object> map = new HashMap<>();
        map.put("roomId", eventInfo.roomId);
        map.put("event", eventInfo.event.value());
        return map;
    }

    public static List<Map<?, ?>> from(ForwardStreamEventInfo[] eventInfos) {
        ArrayList<Map<?, ?>> list = new ArrayList<>(eventInfos.length);
        for (ForwardStreamEventInfo eventInfo : eventInfos) {
            list.add(from(eventInfo));
        }
        return list;

    }

    public static Map<?, ?> from(ForwardStreamStateInfo stateInfo) {
        Map<String, Object> map = new HashMap<>();
        map.put("roomId", stateInfo.roomId);
        map.put("state", stateInfo.state.value());
        map.put("error", stateInfo.error.value());
        return map;
    }

    public static List<Map<?, ?>> from(ForwardStreamStateInfo[] stateInfos) {
        ArrayList<Map<?, ?>> list = new ArrayList<>(stateInfos.length);
        for (ForwardStreamStateInfo stateInfo : stateInfos) {
            list.add(from(stateInfo));
        }
        return list;
    }

    public static Map<?, ?> from(RtcUser user) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("uid", user.userId);
        userInfoMap.put("metaData", user.metaData);
        return userInfoMap;
    }

    public static Map<?, ?> from(UserInfo user) {
        HashMap<String, Object> userInfoMap = new HashMap<>();
        userInfoMap.put("uid", user.getUid());
        userInfoMap.put("metaData", user.getExtraInfo());
        return userInfoMap;
    }

    public static Map<?, ?> from(RemoteAudioPropertiesInfo info) {
        HashMap<String, Object> retValue = new HashMap<>();
        retValue.put("streamKey", RTCMap.from(info.streamKey));
        retValue.put("audioPropertiesInfo", RTCMap.from(info.audioPropertiesInfo));
        return retValue;
    }

    public static List<Map<?, ?>> from(RemoteAudioPropertiesInfo[] infos) {
        ArrayList<Map<?, ?>> retValue = new ArrayList<>();
        for (RemoteAudioPropertiesInfo info : infos) {
            retValue.add(RTCMap.from(info));
        }

        return retValue;
    }

    public static List<Map<String, Object>> from(Rectangle[] faces) {
        if (faces == null) return Collections.emptyList();
        List<Map<String, Object>> result = new ArrayList<>(faces.length);
        for (Rectangle face : faces) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("x", face.x);
            map.put("y", face.y);
            map.put("width", face.width);
            map.put("height", face.height);
            result.add(map);
        }
        return result;
    }

    public static Map<String, ?> from(MusicInfo music) {
        HashMap<String, Object> retValue = new HashMap<>();
        retValue.put("musicId", music.musicId);
        retValue.put("musicName", music.musicName);
        retValue.put("singer", music.singer);
        retValue.put("vendorId", music.vendorId);
        retValue.put("vendorName", music.vendorName);
        retValue.put("updateTimestamp", music.updateTimestamp);
        retValue.put("posterUrl", music.posterUrl);
        retValue.put("lyricStatus", music.lyricStatus.value());
        retValue.put("duration", music.duration);
        retValue.put("enableScore", music.enableScore);
        retValue.put("climaxStartTime", music.climaxStartTime);
        retValue.put("climaxEndTime", music.climaxEndTime);
        return retValue;
    }

    public static List<Map<String, ?>> from(MusicInfo[] musics) {
        if (musics == null) return null;
        List<Map<String, ?>> result = new ArrayList<>(musics.length);
        for (MusicInfo music : musics) {
            result.add(from(music));
        }
        return result;
    }

    public static List<Map<String, ?>> from(HotMusicInfo[] hotMusics) {
        if (hotMusics == null) return null;
        List<Map<String, ?>> result = new ArrayList<>(hotMusics.length);
        for (HotMusicInfo hotMusic : hotMusics) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("hotType", hotMusic.hotType.value());
            if (hotMusic.hotName != null) {
                map.put("hotName", hotMusic.hotName);
            }
            List<Map<String, ?>> musics = from(hotMusic.musicInfos);
            if (musics != null) {
                map.put("musicInfos", musics);
            }
            result.add(map);
        }
        return result;
    }

    public static Map<String, ?> from(DownloadResult result) {
        HashMap<String, Object> retValue = new HashMap<>();
        retValue.put("musicId", result.musicId);
        retValue.put("fileType", result.fileType.value());
        if (result.filePath != null) {
            retValue.put("filePath", result.filePath);
        }
        return retValue;
    }

    public static List<Map<String, Object>> from(List<StandardPitchInfo> infos) {
        List<Map<String, Object>> retValue = new ArrayList<>(infos.size());
        for (StandardPitchInfo info : infos) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("startTime", info.startTime);
            map.put("duration", info.duration);
            map.put("pitch", info.pitch);
            retValue.add(map);
        }
        return retValue;
    }

    public static Map<?, ?> from(SingScoringRealtimeInfo info) {
        HashMap<String, Object> retValue = new HashMap<>();
        retValue.put("currentPosition", info.currentPosition);
        retValue.put("userPitch", info.userPitch);
        retValue.put("standardPitch", info.standardPitch);
        retValue.put("sentenceIndex", info.sentenceIndex);
        retValue.put("sentenceScore", info.sentenceScore);
        retValue.put("totalScore", info.totalScore);
        retValue.put("averageScore", info.averageScore);
        return retValue;
    }

    public static List<Map<String, Object>> from(SubtitleMessage[] subtitles) {
        List<Map<String, Object>> retValue = new ArrayList<>(subtitles.length);
        for (SubtitleMessage subtitle : subtitles) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("uid", subtitle.userId);
            map.put("text", subtitle.text);
            map.put("sequence", subtitle.sequence);
            map.put("definite", subtitle.definite);
            map.put("language", subtitle.language);
            map.put("mode", subtitle.mode.value());
            retValue.add(map);
        }
        return retValue;
    }
}
