/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

package com.ss.bytertc.engine.flutter.base;

import androidx.annotation.NonNull;
import androidx.annotation.RestrictTo;

import com.ss.bytertc.engine.RTCRoomConfig;
import com.ss.bytertc.engine.UserInfo;
import com.ss.bytertc.engine.VideoEncoderConfig;
import com.ss.bytertc.engine.data.AudioChannel;
import com.ss.bytertc.engine.data.AudioFormat;
import com.ss.bytertc.engine.data.AudioMixingConfig;
import com.ss.bytertc.engine.data.AudioMixingType;
import com.ss.bytertc.engine.data.AudioPropertiesConfig;
import com.ss.bytertc.engine.data.AudioSampleRate;
import com.ss.bytertc.engine.data.CloudProxyInfo;
import com.ss.bytertc.engine.data.EchoTestConfig;
import com.ss.bytertc.engine.data.ForwardStreamInfo;
import com.ss.bytertc.engine.data.HumanOrientation;
import com.ss.bytertc.engine.data.Orientation;
import com.ss.bytertc.engine.data.Position;
import com.ss.bytertc.engine.data.RTCASRConfig;
import com.ss.bytertc.engine.data.ReceiveRange;
import com.ss.bytertc.engine.data.RecordingConfig;
import com.ss.bytertc.engine.data.RemoteStreamKey;
import com.ss.bytertc.engine.data.RemoteVideoConfig;
import com.ss.bytertc.engine.data.StreamIndex;
import com.ss.bytertc.engine.data.StreamSycnInfoConfig;
import com.ss.bytertc.engine.data.VideoCodecType;
import com.ss.bytertc.engine.data.VideoPictureType;
import com.ss.bytertc.engine.data.VideoRotation;
import com.ss.bytertc.engine.data.VirtualBackgroundSource;
import com.ss.bytertc.engine.data.VirtualBackgroundSourceType;
import com.ss.bytertc.engine.live.ByteRTCStreamMixingType;
import com.ss.bytertc.engine.live.LiveTranscoding;
import com.ss.bytertc.engine.live.PushSingleStreamParam;
import com.ss.bytertc.engine.mediaio.RTCEncodedVideoFrame;
import com.ss.bytertc.engine.publicstream.PublicStreaming;
import com.ss.bytertc.engine.type.AttenuationType;
import com.ss.bytertc.engine.type.BackgroundMode;
import com.ss.bytertc.engine.type.ChannelProfile;
import com.ss.bytertc.engine.type.DivideModel;
import com.ss.bytertc.engine.type.MediaStreamType;
import com.ss.bytertc.engine.type.PauseResumeControlMediaType;
import com.ss.bytertc.engine.type.ProblemFeedback;
import com.ss.bytertc.engine.type.PublishFallbackOption;
import com.ss.bytertc.engine.type.RangeAudioMode;
import com.ss.bytertc.engine.type.RecordingFileType;
import com.ss.bytertc.engine.type.RemoteUserPriority;
import com.ss.bytertc.engine.type.RtcMode;
import com.ss.bytertc.engine.type.SubscribeFallbackOptions;
import com.ss.bytertc.engine.type.TorchState;
import com.ss.bytertc.engine.utils.AudioFrame;
import com.ss.bytertc.engine.video.ByteWatermark;
import com.ss.bytertc.engine.video.RTCWatermarkConfig;
import com.ss.bytertc.engine.video.VideoCaptureConfig;
import com.ss.bytertc.engine.video.VideoEffectExpressionConfig;

import java.nio.ByteBuffer;
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

    /**
     * @param value
     * @return
     */
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

    @NonNull
    public static RtcMode toRtcMode(int value) {
        for (RtcMode mode : RtcMode.values()) {
            if (mode.value() == value) {
                return mode;
            }
        }

        throw new IllegalArgumentException("Unknown RtcMode value: " + value);
    }

    @NonNull
    public static RangeAudioMode toRangeAudioMode(int value) {
        for (RangeAudioMode mode : RangeAudioMode.values()) {
            if (mode.value() == value) {
                return mode;
            }
        }

        throw new IllegalArgumentException("Unknown RangeAudioMode value: " + value);
    }

    public static RTCRoomConfig toRoomConfig(RTCTypeBox value) {
        ChannelProfile channelProfile = ChannelProfile.fromId(value.optInt("profile"));
        return new RTCRoomConfig(channelProfile,
                value.optBoolean("isAutoPublish"),
                value.optBoolean("isAutoSubscribeAudio"),
                value.optBoolean("isAutoSubscribeVideo"),
                toRemoteVideoConfig(value.optBox("roomConfig")));
    }

    @NonNull
    public static BackgroundMode toBackgroundMode(int value) {
        for (BackgroundMode mode : BackgroundMode.values()) {
            if (mode.value() == value) {
                return mode;
            }
        }

        throw new IllegalArgumentException("Unknown BackgroundMode value: " + value);
    }

    @NonNull
    public static DivideModel toDivideModel(int value) {
        for (DivideModel model : DivideModel.values()) {
            if (model.value() == value) {
                return model;
            }
        }
        throw new IllegalArgumentException("Unknown DivideModel value: " + value);
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

    public static VideoEncoderConfig toVideoEncoderConfig(RTCTypeBox value) {
        return new VideoEncoderConfig(
                value.optInt("width"),
                value.optInt("height"),
                value.optInt("frameRate"),
                value.optInt("maxBitrate"),
                0,
                0,
                value.optInt("encoderPreference")
        );
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

    public static VideoEffectExpressionConfig toVideoEffectExpressionConfig(RTCTypeBox value) {
        VideoEffectExpressionConfig videoEffectExpressionConfig = new VideoEffectExpressionConfig();
        videoEffectExpressionConfig.enableAgeDetect = value.optBoolean("enableAgeDetect");
        videoEffectExpressionConfig.enableGenderDetect = value.optBoolean("enableGenderDetect");
        videoEffectExpressionConfig.enableEmotionDetect = value.optBoolean("enableEmotionDetect");
        videoEffectExpressionConfig.enableAttractivenessDetect = value.optBoolean("enableAttractivenessDetect");
        videoEffectExpressionConfig.enableHappinessDetect = value.optBoolean("enableHappinessDetect");
        return videoEffectExpressionConfig;
    }

    public static RTCEncodedVideoFrame toRTCEncodedVideoFrame(RTCTypeBox value) {
        return new RTCEncodedVideoFrame(
                ByteBuffer.wrap(value.optBytes("buffer")),
                value.optLong("timestampUs"),
                value.optLong("timestampDtsUs"),
                value.optInt("width"),
                value.optInt("height"),
                VideoCodecType.fromId(value.optInt("videoCodecType")),
                VideoPictureType.fromId(value.optInt("videoPictureType")),
                VideoRotation.fromId(value.optInt("videoRotation"))
        );
    }

    /**
     * @param value
     * @return
     * @see RTCMap#from(RemoteStreamKey)
     */
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
        LiveTranscoding liveTranscoding = new LiveTranscoding();
        liveTranscoding.setUrl(obj.optString("url"));
        liveTranscoding.setRoomId(obj.optString("roomId"));
        liveTranscoding.setUserId(obj.optString("uid"));
        liveTranscoding.setMixType(ByteRTCStreamMixingType.fromId(obj.optInt("mixType")));
        liveTranscoding.setVideo(toLiveVideoConfig(obj.optBox("video")));
        liveTranscoding.setAuthInfo(obj.optJSONObject("authInfo"));
        liveTranscoding.setLayout(toLiveLayout(obj.optBox("layout")));
        liveTranscoding.setAudio(toLiveAudioConfig(obj.optBox("audio")));
        return liveTranscoding;
    }


    public static LiveTranscoding.AudioConfig toLiveAudioConfig(RTCTypeBox obj) {
        LiveTranscoding.AudioConfig audioConfig = new LiveTranscoding.AudioConfig();

        audioConfig.setAacProfile(toAACProfile(obj.optString("aacProfile")));
        audioConfig.setChannels(obj.optInt("channels"));
        audioConfig.setSampleRate(obj.optInt("sampleRate"));
        audioConfig.setCodec(obj.optString("codec"));
        audioConfig.setKBitRate(obj.optInt("kBitrate"));

        return audioConfig;
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
        videoConfig.setCodec(obj.optString("codec"));
        videoConfig.setFps(obj.optInt("fps"));
        videoConfig.setGop(obj.optInt("gop"));
        videoConfig.setLowLatency(obj.optBoolean("lowLatency"));
        videoConfig.setKBitRate(obj.optInt("kBitrate"));
        videoConfig.setWidth(obj.optInt("width"));
        videoConfig.setHeight(obj.optInt("height"));
        return videoConfig;
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

        region.type(toTranscoderLayoutRegionType(obj.optInt("type")));
        region.data(obj.optBytes("data", null));
        RTCTypeBox dataParam = obj.optBox("dataParam");
        if (dataParam != null) {
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

    public static List<ProblemFeedback> toFeedBackList(List<Integer> obj) {
        List<ProblemFeedback> lists = new ArrayList<>();
        for (Integer feedback : obj) {
            lists.add(ProblemFeedback.fromId(feedback));
        }
        return lists;
    }


    public static AudioPropertiesConfig toAudioPropertiesConfig(RTCTypeBox obj) {
        return new AudioPropertiesConfig(
                obj.optInt("interval"),
                obj.optBoolean("enableSpectrum"),
                obj.optBoolean("enableVad")
        );
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

    public static AudioFormat toAudioFormat(RTCTypeBox box) {
        return new AudioFormat(
                AudioSampleRate.fromId(box.optInt("audioSampleRate")),
                AudioChannel.fromId(box.optInt("channel"))
        );
    }

    public static AudioMixingConfig toAudioMixingConfig(RTCTypeBox value) {
        return new AudioMixingConfig(
                AudioMixingType.fromId(value.optInt("type")),
                value.optInt("playCount"),
                value.optInt("position"),
                value.optInt("callbackOnProgressInterval")
        );
    }

    public static Position toBytePosition(RTCTypeBox value) {
        return new Position(
                value.optInt("x"),
                value.optInt("y"),
                value.optInt("z")
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
        List<CloudProxyInfo> retValue = new ArrayList<>();
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
}
