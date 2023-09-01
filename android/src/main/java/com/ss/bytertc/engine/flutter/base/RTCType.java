/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCRoomConfig;
import com.ss.bytertc.engine.ScreenVideoEncoderConfig;
import com.ss.bytertc.engine.UserInfo;
import com.ss.bytertc.engine.VideoEncoderConfig;
import com.ss.bytertc.engine.data.AudioChannel;
import com.ss.bytertc.engine.data.AudioEffectPlayerConfig;
import com.ss.bytertc.engine.data.AudioFrameSource;
import com.ss.bytertc.engine.data.AudioMixingConfig;
import com.ss.bytertc.engine.data.AudioMixingType;
import com.ss.bytertc.engine.data.AudioPropertiesConfig;
import com.ss.bytertc.engine.data.AudioPropertiesMode;
import com.ss.bytertc.engine.data.AudioQuality;
import com.ss.bytertc.engine.data.AudioRecordingConfig;
import com.ss.bytertc.engine.data.AudioReportMode;
import com.ss.bytertc.engine.data.AudioSampleRate;
import com.ss.bytertc.engine.data.CloudProxyInfo;
import com.ss.bytertc.engine.data.EchoTestConfig;
import com.ss.bytertc.engine.data.ForwardStreamInfo;
import com.ss.bytertc.engine.data.HumanOrientation;
import com.ss.bytertc.engine.data.LocalLogLevel;
import com.ss.bytertc.engine.data.MediaPlayerConfig;
import com.ss.bytertc.engine.data.MulDimSingScoringMode;
import com.ss.bytertc.engine.data.Orientation;
import com.ss.bytertc.engine.data.Position;
import com.ss.bytertc.engine.data.PositionInfo;
import com.ss.bytertc.engine.data.RTCASRConfig;
import com.ss.bytertc.engine.data.RTCLogConfig;
import com.ss.bytertc.engine.data.ReceiveRange;
import com.ss.bytertc.engine.data.RecordingConfig;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.RemoteVideoConfig;
import com.ss.bytertc.engine.data.SingScoringConfig;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.data.StreamSycnInfoConfig;
import com.ss.bytertc.engine.data.VirtualBackgroundSource;
import com.ss.bytertc.engine.data.VirtualBackgroundSourceType;
import com.ss.bytertc.engine.live.ByteRTCStreamMixingType;
import com.ss.bytertc.engine.live.LiveTranscoding;
import com.ss.bytertc.engine.live.MixedStreamConfig;
import com.ss.bytertc.engine.live.PushSingleStreamParam;
import com.ss.bytertc.engine.publicstream.PublicStreaming;
import com.ss.bytertc.engine.type.AttenuationType;
import com.ss.bytertc.engine.type.AudioSelectionPriority;
import com.ss.bytertc.engine.type.ChannelProfile;
import com.ss.bytertc.engine.type.LocalProxyConfiguration;
import com.ss.bytertc.engine.type.LocalProxyType;
import com.ss.bytertc.engine.type.MediaStreamType;
import com.ss.bytertc.engine.type.MediaTypeEnhancementConfig;
import com.ss.bytertc.engine.type.PauseResumeControlMediaType;
import com.ss.bytertc.engine.type.ProblemFeedbackInfo;
import com.ss.bytertc.engine.type.ProblemFeedbackOption;
import com.ss.bytertc.engine.type.ProblemFeedbackRoomInfo;
import com.ss.bytertc.engine.type.PublishFallbackOption;
import com.ss.bytertc.engine.type.RecordingFileType;
import com.ss.bytertc.engine.type.RemoteUserPriority;
import com.ss.bytertc.engine.type.SubscribeFallbackOptions;
import com.ss.bytertc.engine.type.SubtitleConfig;
import com.ss.bytertc.engine.type.SubtitleMode;
import com.ss.bytertc.engine.type.TorchState;
import com.ss.bytertc.engine.type.VoiceEqualizationBandFrequency;
import com.ss.bytertc.engine.type.VoiceEqualizationConfig;
import com.ss.bytertc.engine.type.VoiceReverbConfig;
import com.ss.bytertc.engine.utils.AudioFrame;
import com.ss.bytertc.engine.video.ByteWatermark;
import com.ss.bytertc.engine.video.RTCWatermarkConfig;
import com.ss.bytertc.engine.video.VideoCaptureConfig;
import com.ss.bytertc.ktv.data.MusicFilterType;
import com.ss.bytertc.ktv.data.MusicHotType;

import java.util.ArrayList;
import java.util.List;

/**
 * 从 Flutter 层的 Map 信息中恢复 RTC 类型
 */
@RestrictTo(RestrictTo.Scope.LIBRARY)
public class RTCType {

    public static UserInfo toUserInfo(RTCTypeBox box) {
        return new UserInfo(
                box.optString("uid"),
                box.optString("metaData"));
    }

    public static RemoteVideoConfig toRemoteVideoConfig(RTCTypeBox value) {
        return new RemoteVideoConfig(
                value.optInt("width"),
                value.optInt("height"),
                value.optInt("frameRate")
        );
    }

    @NonNull
    public static MediaStreamType toMediaStreamType(int value) {
        MediaStreamType type = MediaStreamType.valueOf(value);
        if (type != null) {
            return type;
        }

        throw new IllegalArgumentException("Unknown MediaStreamType value: " + value);
    }

    public static ForwardStreamInfo toForwardStreamInfo(RTCTypeBox value) {
        return new ForwardStreamInfo(
                value.optString("roomId"),
                value.optString("token")
        );
    }

    public static List<ForwardStreamInfo> toForwardStreamInfoList(List<?> values) {
        List<ForwardStreamInfo> retValue = new ArrayList<>(values.size());
        for (Object value : values) {
            retValue.add(toForwardStreamInfo(new RTCTypeBox(value)));
        }
        return retValue;
    }

    public static PublicStreaming toPublicStreaming(RTCTypeBox value) {
        PublicStreaming streaming = new PublicStreaming();
        streaming.setRoomId(value.optString("roomId"));
        streaming.setVideo(toStreamingVideoConfig(value.optBox("video")));
        streaming.setAudio(toStreamingAudioConfig(value.optBox("audio")));
        streaming.setLayout(toLayout(value.optBox("layout")));
        return streaming;
    }

    public static PublicStreaming.Layout toLayout(RTCTypeBox value) {
        PublicStreaming.Layout layout = new PublicStreaming.Layout();
        layout.setInterpolationMode(value.optInt("interpolationMode"));
        layout.setLayoutMode(value.optInt("layoutMode"));
        layout.setBackgroundColor(value.optString("backgroundImage"));
        layout.setBackgroundImage(value.optString("backgroundColor"));
        layout.setRegions(toRegionsArray(value.getList("regions")));
        return layout;
    }

    public static PublicStreaming.Layout.Region[] toRegionsArray(List<?> values) {
        if (values == null) return null;
        PublicStreaming.Layout.Region[] retValue = new PublicStreaming.Layout.Region[values.size()];
        for (int i = 0; i < values.size(); i++) {
            retValue[i] = toRegion(new RTCTypeBox(values.get(i)));
        }
        return retValue;
    }

    public static PublicStreaming.Layout.Region toRegion(RTCTypeBox box) {
        PublicStreaming.Layout.Region region = new PublicStreaming.Layout.Region();
        region.userId(box.optString("uid"));
        region.roomId(box.optString("roomId"));
//        region.alternateImage = box.optString("alternateImage");
        region.size(box.optDouble("w"), box.optDouble("h"));
        region.position(box.optDouble("x"), box.optDouble("y"));
        region.zorder(box.optInt("zorder"));
        region.alpha(box.optDouble("alpha"));
        region.streamType(box.optInt("streamType"));
        region.mediaType(box.optInt("mediaType"));
        region.renderMode(box.optInt("renderMode"));

        RTCTypeBox sourceCrop = box.optBox("sourceCrop");
        region.sourceCropPosition(sourceCrop.optDouble("locationX"), sourceCrop.optDouble("locationY"));
        region.sourceCropSize(sourceCrop.optDouble("widthProportion"), sourceCrop.optDouble("heightProportion"));

        return region;
    }


    public static PublicStreaming.AudioConfig toStreamingAudioConfig(RTCTypeBox value) {
        PublicStreaming.AudioConfig audio = new PublicStreaming.AudioConfig();
        audio.setKBitRate(value.optInt("kBitrate"));
        audio.setSampleRate(value.optInt("sampleRate"));
        audio.setChannels(value.optInt("channels"));
        return audio;
    }

    public static PublicStreaming.VideoConfig toStreamingVideoConfig(RTCTypeBox value) {
        PublicStreaming.VideoConfig video = new PublicStreaming.VideoConfig();
        video.setWidth(value.optInt("width"));
        video.setHeight(value.optInt("height"));
        video.setFps(value.optInt("fps"));
        video.setKBitRate(value.optInt("kBitrate"));
        return video;
    }

    public static VideoEncoderConfig[] toVideoEncoderConfigArray(List<?> values) {
        if (values == null) {
            return new VideoEncoderConfig[0];
        }
        VideoEncoderConfig[] retValue = new VideoEncoderConfig[values.size()];

        for (int i = 0; i < values.size(); i++) {
            retValue[i] = toVideoEncoderConfig(new RTCTypeBox(values.get(i)));
        }

        return retValue;
    }

    public static ScreenVideoEncoderConfig toScreenVideoEncoderConfig(RTCTypeBox value) {
        ScreenVideoEncoderConfig config = new ScreenVideoEncoderConfig(
                value.optInt("width"),
                value.optInt("height"),
                value.optInt("frameRate"),
                value.optInt("maxBitrate"),
                value.optInt("minBitrate"));
        config.encodePreference = toScreenVideoEncoderPreference(value.optInt("encoderPreference"));
        return config;
    }

    public static VideoEncoderConfig toVideoEncoderConfig(RTCTypeBox value) {
        VideoEncoderConfig config = new VideoEncoderConfig(
                value.optInt("width"),
                value.optInt("height"),
                value.optInt("frameRate"),
                value.optInt("maxBitrate"),
                value.optInt("minBitrate"));
        config.encodePreference = toEncoderPreference(value.optInt("encoderPreference"));
        return config;
    }

    @NonNull
    public static VideoEncoderConfig.EncoderPreference toEncoderPreference(int value) {
        for (VideoEncoderConfig.EncoderPreference preference : VideoEncoderConfig.EncoderPreference.values()) {
            if (preference.getValue() == value) {
                return preference;
            }
        }

        throw new IllegalArgumentException("Unknown VideoEncoderConfig.EncoderPreference value: " + value);
    }

    public static ScreenVideoEncoderConfig.EncoderPreference toScreenVideoEncoderPreference(int value) {
        for (ScreenVideoEncoderConfig.EncoderPreference preference : ScreenVideoEncoderConfig.EncoderPreference.values()) {
            if (preference.getValue() == value) {
                return preference;
            }
        }

        throw new IllegalArgumentException("Unknown ScreenVideoEncoderConfig.EncoderPreference value: " + value);
    }

    public static AudioFrame toAudioFrame(RTCTypeBox value) {
        return new AudioFrame(
                value.optBytes("buffer"),
                value.optInt("samples"),
                AudioSampleRate.fromId(value.optInt("sampleRate")),
                AudioChannel.fromId(value.optInt("channel"))
        );
    }

    @NonNull
    public static PublishFallbackOption toPublishFallbackOption(int value) {
        for (PublishFallbackOption option : PublishFallbackOption.values()) {
            if (option.value() == value) {
                return option;
            }
        }

        throw new IllegalArgumentException("Unknown PublishFallbackOption value: " + value);
    }

    @NonNull
    public static SubscribeFallbackOptions toSubscribeFallbackOptions(int value) {
        for (SubscribeFallbackOptions options : SubscribeFallbackOptions.values()) {
            if (options.value() == value) {
                return options;
            }
        }

        throw new IllegalArgumentException("Unknown SubscribeFallbackOptions value: " + value);
    }

    @NonNull
    public static RemoteUserPriority toRemoteUserPriority(int value) {
        for (RemoteUserPriority priority : RemoteUserPriority.values()) {
            if (priority.value() == value) {
                return priority;
            }
        }

        throw new IllegalArgumentException("Unknown RemoteUserPriority value: " + value);
    }

    public static VirtualBackgroundSource toVirtualBackgroundSource(RTCTypeBox value) {
        VirtualBackgroundSource source = new VirtualBackgroundSource();
        source.sourceType = toVirtualBackgroundSourceType(value.optInt("sourceType"));
        source.sourceColor = value.optInt("sourceColor");
        source.sourcePath = value.optString("sourcePath");
        return source;
    }

    private static VirtualBackgroundSourceType toVirtualBackgroundSourceType(int value) {
        return VirtualBackgroundSourceType.values()[value];
    }

    public static RemoteStreamKey toRemoteStreamKey(RTCTypeBox value) {
        return new RemoteStreamKey(
                value.optString("roomId"),
                value.optString("uid"),
                StreamIndex.fromId(value.optInt("streamIndex"))
        );
    }

    public static TorchState toTorchState(int value) {
        for (TorchState state : TorchState.values()) {
            if (value == state.ordinal()) {
                return state;
            }
        }

        throw new IllegalArgumentException("Unknown TorchState value: " + value);
    }

    public static RTCWatermarkConfig toRTCWatermarkConfig(RTCTypeBox value) {
        return new RTCWatermarkConfig(
                value.optBoolean("visibleInPreview"),
                toByteWatermark(value.optBox("positionInLandscapeMode")),
                toByteWatermark(value.optBox("positionInPortraitMode"))

        );
    }

    private static ByteWatermark toByteWatermark(RTCTypeBox value) {
        return new ByteWatermark(
                value.optFloat("x"),
                value.optFloat("y"),
                value.optFloat("width"),
                value.optFloat("height")
        );
    }

    @NonNull
    public static PauseResumeControlMediaType toPauseResumeControlMediaType(int value) {
        return PauseResumeControlMediaType.values()[value];
    }

    public static LiveTranscoding toLiveTranscoding(RTCTypeBox obj) {
        LiveTranscoding liveTranscoding = LiveTranscoding.getDefualtLiveTranscode();
        liveTranscoding.setUrl(obj.optString("url"));
        liveTranscoding.setRoomId(obj.optString("roomId"));
        liveTranscoding.setUserId(obj.optString("uid"));
        liveTranscoding.setMixType(ByteRTCStreamMixingType.fromId(obj.optInt("mixType")));
        liveTranscoding.setVideo(toLiveVideoConfig(obj.optBox("video")));
        liveTranscoding.setLayout(toLiveLayout(obj.optBox("layout")));
        liveTranscoding.setAudio(toLiveAudioConfig(obj.optBox("audio")));
        liveTranscoding.setSpatialConfig(toLiveSpatialConfig(obj.optBox("spatialConfig")));
        return liveTranscoding;
    }

    public static LiveTranscoding.SpatialConfig toLiveSpatialConfig(RTCTypeBox obj) {
        LiveTranscoding.SpatialConfig spatialConfig = new LiveTranscoding.SpatialConfig();
        spatialConfig.setAudienceSpatialOrientation(toHumanOrientation(obj.optBox("orientation")));
        spatialConfig.setAudienceSpatialPosition(toBytePosition(obj.optBox("position")));
        spatialConfig.setEnableSpatialRender(obj.optBoolean("enableSpatialRender"));
        return spatialConfig;
    }

    public static LiveTranscoding.AudioConfig toLiveAudioConfig(RTCTypeBox obj) {
        LiveTranscoding.AudioConfig audioConfig = new LiveTranscoding.AudioConfig();

        audioConfig.setAacProfile(toAACProfile(obj.optString("aacProfile")));
        audioConfig.setChannels(obj.optInt("channels"));
        audioConfig.setSampleRate(obj.optInt("sampleRate"));
        audioConfig.setCodec(toAudioCodecType(obj.optString("codec")));
        audioConfig.setKBitRate(obj.optInt("kBitrate"));

        return audioConfig;
    }

    @NonNull
    public static LiveTranscoding.AudioConfig.AudioCodecType toAudioCodecType(String value) {
        for (LiveTranscoding.AudioConfig.AudioCodecType type : LiveTranscoding.AudioConfig.AudioCodecType.values()) {
            if (type.getValue().equals(value)) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown LiveTranscoding.AudioConfig.AudioCodecType value: " + value);
    }

    @NonNull
    public static LiveTranscoding.AACProfile toAACProfile(String value) {
        for (LiveTranscoding.AACProfile profile : LiveTranscoding.AACProfile.values()) {
            if (profile.getValue().equals(value)) {
                return profile;
            }
        }

        throw new IllegalArgumentException("Unknown LiveTranscoding.AACProfile value: " + value);
    }

    public static LiveTranscoding.VideoConfig toLiveVideoConfig(RTCTypeBox obj) {
        LiveTranscoding.VideoConfig videoConfig = new LiveTranscoding.VideoConfig();
        videoConfig.setCodec(toVideoCodecType(obj.optString("codec")));
        videoConfig.setFps(obj.optInt("fps"));
        videoConfig.setGop(obj.optInt("gop"));
        videoConfig.setBFrame(obj.optBoolean("bFrame"));
        videoConfig.setKBitRate(obj.optInt("kBitrate"));
        videoConfig.setWidth(obj.optInt("width"));
        videoConfig.setHeight(obj.optInt("height"));
        return videoConfig;
    }

    @NonNull
    public static LiveTranscoding.VideoConfig.VideoCodecType toVideoCodecType(String value) {
        for (LiveTranscoding.VideoConfig.VideoCodecType type : LiveTranscoding.VideoConfig.VideoCodecType.values()) {
            if (type.getValue().equals(value)) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown LiveTranscoding.VideoConfig.VideoCodecType value: " + value);
    }

    public static LiveTranscoding.Layout toLiveLayout(RTCTypeBox obj) {
        LiveTranscoding.Layout layout = new LiveTranscoding.Layout();
        layout.setAppData(obj.optString("appData"));
        layout.setBackgroundColor(obj.optString("backgroundColor"));
        List<?> regionList = obj.getList("regions");
        LiveTranscoding.Region[] regions = new LiveTranscoding.Region[regionList.size()];
        for (int i = 0; i < regionList.size(); i++) {
            RTCTypeBox regionBox = new RTCTypeBox(regionList.get(i));
            regions[i] = toLiveLayoutRegion(regionBox);
        }
        layout.setRegions(regions);
        return layout;
    }

    public static LiveTranscoding.Region toLiveLayoutRegion(RTCTypeBox obj) {
        LiveTranscoding.Region region = new LiveTranscoding.Region();
        region.uid(obj.optString("uid"));
        region.roomId(obj.optString("roomId"));
        region.position(obj.optDouble("x"), obj.optDouble("y"));
        region.size(obj.optDouble("w"), obj.optDouble("h"));
        region.zorder(obj.optInt("zorder"));
        region.alpha(obj.optDouble("alpha"));
        region.contentControl(toTranscoderContentControlType(obj.optInt("contentControl")));
        region.renderMode(toTranscoderRenderMode(obj.optInt("renderMode")));
        region.setLocalUser(obj.optBoolean("localUser"));
        region.setScreenStream(obj.optBoolean("isScreen"));
        region.setCornerRadius(obj.optDouble("cornerRadius"));
        Position position = toBytePosition(obj.optBox("spatialPosition"));
        region.spatialPosition(position.x, position.y, position.z);
        region.applySpatialAudio(obj.optBoolean("applySpatialAudio"));
        region.type(toTranscoderLayoutRegionType(obj.optInt("type")));
        region.data(obj.optBytes("data", null));
        RTCTypeBox dataParam = obj.optBox("dataParam");
        if (dataParam.arguments != null) {
            region.dataParam(toDataParam(dataParam));
        }
        return region;
    }

    public static LiveTranscoding.TranscoderLayoutRegionType toTranscoderLayoutRegionType(int value) {
        for (LiveTranscoding.TranscoderLayoutRegionType type : LiveTranscoding.TranscoderLayoutRegionType.values()) {
            if (type.getValue() == value) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown TranscoderLayoutRegionType value: " + value);
    }

    public static LiveTranscoding.Region.DataParam toDataParam(RTCTypeBox obj) {
        LiveTranscoding.Region.DataParam retValue = new LiveTranscoding.Region.DataParam();
        retValue.setImageWidth(obj.optInt("imageWidth"));
        retValue.setImageHeight(obj.optInt("imageHeight"));
        return retValue;
    }

    @NonNull
    public static LiveTranscoding.TranscoderContentControlType toTranscoderContentControlType(int value) {
        for (LiveTranscoding.TranscoderContentControlType type : LiveTranscoding.TranscoderContentControlType.values()) {
            if (type.getValue() == value) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown TranscoderContentControlType value: " + value);
    }

    @NonNull
    public static LiveTranscoding.TranscoderRenderMode toTranscoderRenderMode(int value) {
        for (LiveTranscoding.TranscoderRenderMode mode : LiveTranscoding.TranscoderRenderMode.values()) {
            if (mode.getValue() == value) {
                return mode;
            }
        }

        throw new IllegalArgumentException("Unknown TranscoderRenderMode value: " + value);
    }

    public static RecordingConfig toRecordingConfig(RTCTypeBox obj) {
        String dirPath = obj.optString("dirPath");
        RecordingFileType type = RecordingFileType.fromId(obj.optInt("recordingFileType"));
        return new RecordingConfig(dirPath, type);
    }


    public static RTCASRConfig toRTCASRConfig(RTCTypeBox obj) {
        String userId = obj.optString("uid");
        String accessToken = obj.optString("accessToken");
        String secretKey = obj.optString("secretKey");
        RTCASRConfig.ASRAuthorizationType type = toASRAuthorizationType(obj.optInt("authorizationType"));
        String cluster = obj.optString("cluster");
        String appId = obj.optString("appId");
        return new RTCASRConfig(userId, accessToken, secretKey, type, cluster, appId);
    }

    @NonNull
    public static RTCASRConfig.ASRAuthorizationType toASRAuthorizationType(int value) {
        for (RTCASRConfig.ASRAuthorizationType type : RTCASRConfig.ASRAuthorizationType.values()) {
            if (type.value() == value) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown RTCASRConfig.ASRAuthorizationType value: " + value);
    }

    public static List<ProblemFeedbackOption> toFeedBackList(List<Integer> obj) {
        List<ProblemFeedbackOption> lists = new ArrayList<>(obj.size());
        for (Integer feedback : obj) {
            lists.add(ProblemFeedbackOption.fromId(feedback));
        }
        return lists;
    }

    public static ProblemFeedbackRoomInfo toFeedbackRoomInfo(RTCTypeBox value) {
        return new ProblemFeedbackRoomInfo(
                value.optString("roomId"),
                value.optString("uid")
        );
    }

    public static ProblemFeedbackInfo toFeedbackInfo(RTCTypeBox value) {
        if (value == null || value.arguments == null) {
            return null;
        }

        ProblemFeedbackInfo info = new ProblemFeedbackInfo();
        info.problemDesc = value.optString("problemDesc");
        List<?> infos = value.getList("roomInfo");
        if (!infos.isEmpty()) {
            List<ProblemFeedbackRoomInfo> lists = new ArrayList<>(infos.size());
            for (Object obj : infos) {
                lists.add(toFeedbackRoomInfo(new RTCTypeBox(obj)));
            }
            info.roomInfo = lists;
        }
        return info;
    }

    public static AudioPropertiesConfig toAudioPropertiesConfig(RTCTypeBox obj) {
        return new AudioPropertiesConfig(
                obj.optInt("interval"),
                obj.optBoolean("enableSpectrum"),
                obj.optBoolean("enableVad"),
                AudioReportMode.fromId(obj.optInt("localMainReportMode")),
                obj.optFloat("smooth"),
                toAudioPropertiesMode(obj.optInt("audioReportMode"))
        );
    }

    public static AudioPropertiesMode toAudioPropertiesMode(int value) {
        for (AudioPropertiesMode type : AudioPropertiesMode.values()) {
            if (value == type.value()) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown AudioPropertiesMode value: " + value);
    }

    public static StreamSycnInfoConfig toStreamSyncInfoConfig(RTCTypeBox obj) {
        StreamIndex streamIndex = StreamIndex.fromId(obj.optInt("streamIndex"));
        int repeatCount = obj.optInt("repeatCount");
        return new StreamSycnInfoConfig(streamIndex, repeatCount, StreamSycnInfoConfig.SyncInfoStreamType.SYNC_INFO_STREAM_TYPE_AUDIO);
    }


    public static VideoCaptureConfig toVideoCaptureConfig(RTCTypeBox obj) {
        VideoCaptureConfig frameRate = new VideoCaptureConfig(
                obj.optInt("width"),
                obj.optInt("height"),
                obj.optInt("frameRate")
        );
        frameRate.capturePreference = VideoCaptureConfig.CapturePreference
                .convertFromInt(obj.optInt("capturePreference"));
        return frameRate;
    }

    public static AudioMixingConfig toAudioMixingConfig(RTCTypeBox value) {
        AudioMixingConfig config = new AudioMixingConfig(
                AudioMixingType.fromId(value.optInt("type")),
                value.optInt("playCount"),
                value.optInt("position"),
                value.optInt("callbackOnProgressInterval")
        );
        config.syncProgressToRecordFrame = value.optBoolean("syncProgressToRecordFrame");
        return config;
    }

    public static Position toBytePosition(RTCTypeBox value) {
        return new Position(
                value.optFloat("x"),
                value.optFloat("y"),
                value.optFloat("z")
        );
    }

    public static HumanOrientation toHumanOrientation(RTCTypeBox value) {
        return new HumanOrientation(
                toByteOrientation(value.optBox("forward")),
                toByteOrientation(value.optBox("right")),
                toByteOrientation(value.optBox("up"))
        );
    }

    public static Orientation toByteOrientation(RTCTypeBox value) {
        return new Orientation(
                value.optFloat("x"),
                value.optFloat("y"),
                value.optFloat("z")
        );
    }

    public static PositionInfo toPositionInfo(RTCTypeBox value) {
        return new PositionInfo(
                toBytePosition(value.optBox("position")),
                toHumanOrientation(value.optBox("orientation"))
        );
    }

    public static ReceiveRange toReceiveRange(RTCTypeBox range) {
        return new ReceiveRange(
                range.optInt("min"),
                range.optInt("max")
        );
    }

    public static AttenuationType toAttenuationType(int value) {
        for (AttenuationType type : AttenuationType.values()) {
            if (value == type.value()) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown AttenuationType value: " + value);
    }

    public static EchoTestConfig toEchoTestConfig(RTCTypeBox config) {
        return new EchoTestConfig(
                null,
                config.optString("uid"),
                config.optString("roomId"),
                config.optString("token"),
                config.optBoolean("enableAudio"),
                config.optBoolean("enableVideo"),
                config.optInt("audioReportInterval")
        );
    }

    public static CloudProxyInfo toCloudProxy(RTCTypeBox value) {
        return new CloudProxyInfo(
                value.optString("cloudProxyIp"),
                value.optInt("cloudProxyPort")
        );
    }

    public static List<CloudProxyInfo> toCloudProxyInfoList(List<?> values) {
        List<CloudProxyInfo> retValue = new ArrayList<>(values.size());
        for (Object value : values) {
            retValue.add(toCloudProxy(new RTCTypeBox(value)));
        }
        return retValue;
    }

    public static RTCRoomConfig toRTCRoomConfig(RTCTypeBox values) {
        return new RTCRoomConfig(
                ChannelProfile.fromId(values.optInt("profile")),
                values.optBoolean("isAutoPublish"),
                values.optBoolean("isAutoSubscribeAudio"),
                values.optBoolean("isAutoSubscribeVideo"),
                toRemoteVideoConfig(values.optBox("remoteVideoConfig"))
        );
    }

    public static PushSingleStreamParam toPushSingleStreamParam(RTCTypeBox values) {
        return new PushSingleStreamParam(
                values.optString("roomId"),
                values.optString("uid"),
                values.optString("url"),
                values.optBoolean("isScreen")
        );
    }

    public static AudioRecordingConfig toAudioRecordingConfig(RTCTypeBox values) {
        return new AudioRecordingConfig(
                values.optString("absoluteFileName"),
                AudioSampleRate.fromId(values.optInt("sampleRate")),
                AudioChannel.fromId(values.optInt("channel")),
                AudioFrameSource.fromId(values.optInt("frameSource")),
                AudioQuality.fromId(values.optInt("quality"))
        );
    }

    public static VoiceEqualizationConfig toVoiceEqualizationConfig(RTCTypeBox values) {
        return new VoiceEqualizationConfig(
                VoiceEqualizationBandFrequency.fromId(values.optInt("frequency")),
                values.optInt("gain")
        );
    }

    public static VoiceReverbConfig toVoiceReverbConfig(RTCTypeBox values) {
        return new VoiceReverbConfig(
                values.optFloat("roomSize"),
                values.optFloat("decayTime"),
                values.optFloat("damping"),
                values.optFloat("wetGain"),
                values.optFloat("dryGain"),
                values.optFloat("preDelay")
        );
    }

    public static MusicFilterType[] toMusicFilterTypes(List<Integer> values) {
        MusicFilterType[] filters = new MusicFilterType[values.size()];
        for (int i = 0; i < values.size(); i++) {
            filters[i] = MusicFilterType.fromId(values.get(i));
        }
        return filters;
    }

    public static MusicHotType[] toMusicHotTypes(List<Integer> values) {
        MusicHotType[] hotTypes = new MusicHotType[values.size()];
        for (int i = 0; i < values.size(); i++) {
            hotTypes[i] = MusicHotType.fromId(values.get(i));
        }
        return hotTypes;
    }

    public static SingScoringConfig toSingScoringConfig(RTCTypeBox values) {
        return new SingScoringConfig(
                AudioSampleRate.fromId(values.optInt("sampleRate")),
                MulDimSingScoringMode.MUL_DIM_SING_SCORING_MODE_NOTE,
                values.optString("lyricsFilepath"),
                values.optString("midiFilepath")
        );
    }

    public static MixedStreamConfig toMixedStreamConfig(RTCTypeBox obj) {
        MixedStreamConfig mixedConfig = MixedStreamConfig.defaultMixedStreamConfig();
        mixedConfig.setPushURL(obj.optString("pushURL"));
        mixedConfig.setRoomID(obj.optString("roomId"));
        mixedConfig.setUserID(obj.optString("uid"));
        mixedConfig.setExpectedMixingType(ByteRTCStreamMixingType.fromId(obj.optInt("expectedMixingType")));
        mixedConfig.setAudioConfig(toMixedStreamAudioConfig(obj.optBox("audioConfig")));
        mixedConfig.setVideoConfig(toMixedStreamVideoConfig(obj.optBox("videoConfig")));
        mixedConfig.setLayout(toMixedStreamLayoutConfig(obj.optBox("layout")));
        mixedConfig.setSpatialConfig(toMixedStreamSpatialConfig(obj.optBox("spatialConfig")));
        return mixedConfig;
    }

    public static MixedStreamConfig.MixedStreamVideoConfig toMixedStreamVideoConfig(RTCTypeBox obj) {
        MixedStreamConfig.MixedStreamVideoConfig videoConfig = new MixedStreamConfig.MixedStreamVideoConfig();
        videoConfig.setVideoCodec(toMixedStreamVideoCodecType(obj.optInt("videoCodec")));
        videoConfig.setFps(obj.optInt("fps"));
        videoConfig.setGop(obj.optInt("gop"));
        videoConfig.setBitrate(obj.optInt("bitrate"));
        videoConfig.setWidth(obj.optInt("width"));
        videoConfig.setHeight(obj.optInt("height"));
        videoConfig.setEnableBframe(obj.optBoolean("enableBFrame"));
        return videoConfig;
    }

    public static MixedStreamConfig.MixedStreamVideoConfig.MixedStreamVideoCodecType toMixedStreamVideoCodecType(int value) {
        if (value == 1) {
            return MixedStreamConfig.MixedStreamVideoConfig.MixedStreamVideoCodecType.MIXED_STREAM_VIDEO_CODEC_TYPE_BYTEVC1;
        }
        return MixedStreamConfig.MixedStreamVideoConfig.MixedStreamVideoCodecType.MIXED_STREAM_VIDEO_CODEC_TYPE_H264;
    }

    public static MixedStreamConfig.MixedStreamAudioConfig toMixedStreamAudioConfig(RTCTypeBox obj) {
        MixedStreamConfig.MixedStreamAudioConfig audioConfig = new MixedStreamConfig.MixedStreamAudioConfig();
        audioConfig.setChannels(obj.optInt("channels"));
        audioConfig.setSampleRate(obj.optInt("sampleRate"));
        audioConfig.setBitrate(obj.optInt("bitrate"));
        audioConfig.setAudioProfile(toMixedStreamAudioProfile(obj.optInt("audioProfile")));
        return audioConfig;
    }

    public static MixedStreamConfig.MixedStreamAudioProfile toMixedStreamAudioProfile(int value) {
        switch (value) {
            case 1:
                return MixedStreamConfig.MixedStreamAudioProfile.MIXED_STREAM_AUDIO_PROFILE_HEV1;
            case 2:
                return MixedStreamConfig.MixedStreamAudioProfile.MIXED_STREAM_AUDIO_PROFILE_HEV2;
            default:
                return MixedStreamConfig.MixedStreamAudioProfile.MIXED_STREAM_AUDIO_PROFILE_LC;
        }
    }

    public static MixedStreamConfig.MixedStreamSpatialConfig toMixedStreamSpatialConfig(RTCTypeBox obj) {
        MixedStreamConfig.MixedStreamSpatialConfig spatialConfig = new MixedStreamConfig.MixedStreamSpatialConfig();
        spatialConfig.setAudienceSpatialOrientation(toHumanOrientation(obj.optBox("orientation")));
        spatialConfig.setAudienceSpatialPosition(toBytePosition(obj.optBox("position")));
        spatialConfig.setEnableSpatialRender(obj.optBoolean("enableSpatialRender"));
        return spatialConfig;
    }

    public static MixedStreamConfig.MixedStreamLayoutConfig toMixedStreamLayoutConfig(RTCTypeBox obj) {
        MixedStreamConfig.MixedStreamLayoutConfig layout = new MixedStreamConfig.MixedStreamLayoutConfig();
        layout.setBackgroundColor(obj.optString("backgroundColor"));
        layout.setUserConfigExtraInfo(obj.optString("userConfigExtraInfo"));
        List<?> regionList = obj.getList("regions");
        MixedStreamConfig.MixedStreamLayoutRegionConfig[] regions = new MixedStreamConfig.MixedStreamLayoutRegionConfig[regionList.size()];
        for (int i = 0; i < regionList.size(); i++) {
            RTCTypeBox regionBox = new RTCTypeBox(regionList.get(i));
            regions[i] = toMixedStreamLayoutRegionConfig(regionBox);
        }
        layout.setRegions(regions);
        return layout;
    }

    public static MixedStreamConfig.MixedStreamLayoutRegionConfig toMixedStreamLayoutRegionConfig(RTCTypeBox obj) {
        MixedStreamConfig.MixedStreamLayoutRegionConfig region = new MixedStreamConfig.MixedStreamLayoutRegionConfig();
        region.setUserID(obj.optString("uid"));
        region.setRoomID(obj.optString("roomId"));
        region.setLocationX(obj.optDouble("locationX"));
        region.setLocationY(obj.optDouble("locationY"));
        region.setWidthProportion(obj.optDouble("widthProportion"));
        region.setHeightProportion(obj.optDouble("heightProportion"));
        region.setZOrder(obj.optInt("zOrder"));
        region.setAlpha(obj.optDouble("alpha"));
        region.setCornerRadius(obj.optDouble("cornerRadius"));
        region.setMediaType(toMixedStreamMediaType(obj.optInt("mediaType")));
        region.setRenderMode(toMixedStreamRenderMode(obj.optInt("renderMode")));
        region.setIsLocalUser(obj.optBoolean("isLocalUser"));
        region.setStreamType(toMixedStreamVideoType(obj.optInt("streamType")));
        region.setRegionContentType(toMixedStreamLayoutRegionType(obj.optInt("regionContentType")));
        region.setSpatialPosition(toBytePosition(obj.optBox("spatialPosition")));
        region.setApplySpatialAudio(obj.optBoolean("applySpatialAudio"));
        region.setImageWaterMark(obj.optBytes("imageWaterMark", null));
        RTCTypeBox dataParam = obj.optBox("imageWaterMarkConfig");
        if (dataParam.arguments != null) {
            region.setImageWaterMarkConfig(toMixedStreamLayoutRegionImageWaterMarkConfig(dataParam));
        }
        return region;
    }

    @NonNull
    public static MixedStreamConfig.MixedStreamMediaType toMixedStreamMediaType(int value) {
        for (MixedStreamConfig.MixedStreamMediaType type : MixedStreamConfig.MixedStreamMediaType.values()) {
            if (type.getValue() == value) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown MixedStreamMediaType value: " + value);
    }

    @NonNull
    public static MixedStreamConfig.MixedStreamRenderMode toMixedStreamRenderMode(int value) {
        for (MixedStreamConfig.MixedStreamRenderMode mode : MixedStreamConfig.MixedStreamRenderMode.values()) {
            if (mode.getValue() == value) {
                return mode;
            }
        }

        throw new IllegalArgumentException("Unknown MixedStreamRenderMode value: " + value);
    }

    @NonNull
    public static MixedStreamConfig.MixedStreamLayoutRegionConfig.MixedStreamVideoType toMixedStreamVideoType(int value) {
        for (MixedStreamConfig.MixedStreamLayoutRegionConfig.MixedStreamVideoType type : MixedStreamConfig.MixedStreamLayoutRegionConfig.MixedStreamVideoType.values()) {
            if (type.getValue() == value) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown MixedStreamVideoType value: " + value);
    }

    @NonNull
    public static MixedStreamConfig.MixedStreamLayoutRegionType toMixedStreamLayoutRegionType(int value) {
        for (MixedStreamConfig.MixedStreamLayoutRegionType type : MixedStreamConfig.MixedStreamLayoutRegionType.values()) {
            if (type.getValue() == value) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown MixedStreamLayoutRegionType value: " + value);
    }

    public static MixedStreamConfig.MixedStreamLayoutRegionConfig.MixedStreamLayoutRegionImageWaterMarkConfig toMixedStreamLayoutRegionImageWaterMarkConfig(RTCTypeBox values) {
        return new MixedStreamConfig.MixedStreamLayoutRegionConfig.MixedStreamLayoutRegionImageWaterMarkConfig(
                values.optInt("imageWidth"),
                values.optInt("imageHeight")
        );
    }

    public static MediaTypeEnhancementConfig toMediaTypeEnhancementConfig(RTCTypeBox values) {
        return new MediaTypeEnhancementConfig(
                values.optBoolean("enhanceSignaling"),
                values.optBoolean("enhanceAudio"),
                values.optBoolean("enhanceVideo"),
                values.optBoolean("enhanceScreenAudio"),
                values.optBoolean("enhanceScreenVideo")
        );
    }

    public static List<LocalProxyConfiguration> toLocalProxyConfigurations(List<?> value) {
        List<LocalProxyConfiguration> list = new ArrayList<>(value.size());
        for (Object obj : value) {
            RTCTypeBox arguments = new RTCTypeBox(obj);
            list.add(new LocalProxyConfiguration(
                    LocalProxyType.fromId(arguments.optInt("localProxyType")),
                    arguments.optString("localProxyIp"),
                    arguments.optInt("localProxyPort"),
                    arguments.optString("localProxyUsername"),
                    arguments.optString("localProxyPassword")
            ));
        }
        return list;
    }

    public static AudioSelectionPriority toAudioSelectionPriority(int value) {
        for (AudioSelectionPriority type : AudioSelectionPriority.values()) {
            if (value == type.value()) {
                return type;
            }
        }

        throw new IllegalArgumentException("Unknown AudioSelectionPriority value: " + value);
    }

    public static SubtitleConfig toSubtitleConfig(RTCTypeBox values) {
        return new SubtitleConfig(
                SubtitleMode.fromId(values.optInt("mode")),
                values.optString("targetLanguage")
        );
    }

    public static RTCLogConfig toLogConfig(RTCTypeBox values) {
        return new RTCLogConfig(
                LocalLogLevel.fromId(values.optInt("logLevel")),
                values.optString("logPath"),
                values.optInt("logFileSize")
        );
    }

    public static AudioEffectPlayerConfig toAudioEffectPlayerConfig(RTCTypeBox values) {
        return new AudioEffectPlayerConfig(
                AudioMixingType.fromId(values.optInt("type")),
                values.optInt("playCount"),
                values.optInt("startPos"),
                values.optInt("pitch")
        );
    }

    public static MediaPlayerConfig toMediaPlayerConfig(RTCTypeBox values) {
        return new MediaPlayerConfig(
                AudioMixingType.fromId(values.optInt("type")),
                values.optInt("playCount"),
                values.optInt("startPos"),
                values.optBoolean("autoPlay"),
                values.optLong("callbackOnProgressInterval"),
                values.optBoolean("syncProgressToRecordFrame")
        );
    }
}
