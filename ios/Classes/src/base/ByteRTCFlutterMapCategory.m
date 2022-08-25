/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterCodecs.h>
#import "ByteRTCFlutterMapCategory.h"

@implementation ByteRTCFlutterEventfactory

+ (NSDictionary *)localAudioStatsToMap:(ByteRTCLocalAudioStats *)stats {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"audioLossRate"] = @(stats.audioLossRate);
    dict[@"sentKBitrate"] = @(stats.sentKBitrate);
    dict[@"recordSampleRate"] = @(stats.recordSampleRate);
    dict[@"statsInterval"] = @(stats.statsInterval);
    dict[@"rtt"] = @(stats.rtt);
    dict[@"numChannels"] = @(stats.numChannels);
    dict[@"sentSampleRate"] = @(stats.sentSampleRate);
    dict[@"jitter"] = @(stats.jitter);
    return dict.copy;
}

+ (NSDictionary *)localVideoStatsToMap:(ByteRTCLocalVideoStats *)stats {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"sentKBitrate"] = @(stats.sentKBitrate);
    dict[@"inputFrameRate"] = @(stats.inputFrameRate);
    dict[@"sentFrameRate"] = @(stats.sentFrameRate);
    dict[@"encoderOutputFrameRate"] = @(stats.encoderOutputFrameRate);
    dict[@"renderOutputFrameRate"] = @(stats.rendererOutputFrameRate);
    dict[@"statsInterval"] = @(stats.statsInterval);
    dict[@"videoLossRate"] = @(stats.videoLossRate);
    dict[@"rtt"] = @(stats.rtt);
    dict[@"encodedBitrate"] = @(stats.encodedBitrate);
    dict[@"encodedFrameWidth"] = @(stats.encodedFrameWidth);
    dict[@"encodedFrameHeight"] = @(stats.encodedFrameHeight);
    dict[@"encodedFrameCount"] = @(stats.encodedFrameCount);
    dict[@"codecType"] = @(stats.codecType);
    dict[@"isScreen"] = @(stats.isScreen);
    dict[@"jitter"] = @(stats.jitter);
    return dict.copy;
}

+ (NSDictionary *)networkQualityStatsToMap:(ByteRTCNetworkQualityStats *)stats {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = stats.uid ?: @"";
    dict[@"fractionLost"] = @(stats.lossRatio);
    dict[@"rtt"] = @(stats.rtt);
    dict[@"totalBandwidth"] = @(stats.totalBandwidth);
    dict[@"txQuality"] = @(stats.txQuality);
    dict[@"rxQuality"] = @(stats.rxQuality);
    return dict.copy;
}

@end

@implementation ByteRTCUser (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.userId;
    dict[@"metaData"] = self.metaData;
    return dict.copy;
}

@end

@implementation ByteRTCLocalStreamStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"audioStats"] = [ByteRTCFlutterEventfactory localAudioStatsToMap:self.audio_stats];
    dict[@"videoStats"] = [ByteRTCFlutterEventfactory localVideoStatsToMap:self.self.video_stats];
    dict[@"isScreen"] = @(self.is_screen);
    return dict.copy;
}

@end

@implementation ByteRTCRemoteStreamStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.uid;
    dict[@"audioStats"] = self.audio_stats.bf_toMap;
    dict[@"videoStats"] = self.video_stats.bf_toMap;
    dict[@"isScreen"] = @(self.is_screen);
    return dict.copy;
}

@end


@implementation ByteRTCRemoteAudioStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"audioLossRate"] = @(self.audioLossRate);
    dict[@"receivedKBitrate"] = @(self.receivedKBitrate);
    dict[@"stallCount"] = @(self.stallCount);
    dict[@"stallDuration"] = @(self.stallDuration);
    dict[@"playoutSampleRate"] = @(self.playoutSampleRate);
    dict[@"e2eDelay"] = @(self.e2eDelay);
    dict[@"statsInterval"] = @(self.statsInterval);
    dict[@"rtt"] = @(self.rtt);
    dict[@"totalRtt"] = @(self.total_rtt);
    dict[@"quality"] = @(self.quality);
    dict[@"jitterBufferDelay"] = @(self.jitterBufferDelay);
    dict[@"numChannels"] = @(self.numChannels);
    dict[@"receivedSampleRate"] = @(self.receivedSampleRate);
    dict[@"frozenRate"] = @(self.frozenRate);
    dict[@"concealedSamples"] = @(self.concealedSamples);
    dict[@"concealmentEvent"] = @(self.concealmentEvent);
    dict[@"decSampleRate"] = @(self.decSampleRate);
    dict[@"decDuration"] = @(self.decDuration);
    dict[@"jitter"] = @(self.jitter);
    return dict.copy;
}

@end

@implementation ByteRTCRemoteVideoStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    dict[@"videoLossRate"] = @(self.videoLossRate);
    dict[@"receivedKBitrate"] = @(self.receivedKBitrate);
    dict[@"receivedFrameRate"] = @(self.receivedFrameRate);
    dict[@"decoderOutputFrameRate"] = @(self.decoderOutputFrameRate);
    dict[@"renderOutputFrameRate"] = @(self.renderOutputFrameRate);
    dict[@"stallCount"] = @(self.stallCount);
    dict[@"stallDuration"] = @(self.stallDuration);
    dict[@"e2eDelay"] = @(self.e2eDelay);
    dict[@"isScreen"] = @(self.isScreen);
    dict[@"statsInterval"] = @(self.statsInterval);
    dict[@"rtt"] = @(self.rtt);
    dict[@"frozenRate"] = @(self.frozenRate);
    dict[@"codecType"] = @(self.codecType);
    dict[@"videoIndex"] = @(self.videoIndex);
    dict[@"jitter"] = @(self.jitter);
    return dict.copy;
}

@end

@implementation ByteRTCSysStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"cpuCores"] = @(self.cpu_cores);
    dict[@"cpuAppUsage"] = @(self.cpu_app_usage);
    dict[@"cpuTotalUsage"] = @(self.cpu_total_usage);
    dict[@"memoryUsage"] = @(self.memory_usage);
    dict[@"fullMemory"] = @(self.full_memory);
    dict[@"totalMemoryUsage"] = @(self.total_memory_usage);
    dict[@"freeMemory"] = @(self.free_memory);
    dict[@"memoryRatio"] = @(self.memory_ratio);
    dict[@"totalMemoryRatio"] = @(self.total_memory_ratio);
    return dict.copy;
}

@end

@implementation ByteRTCSourceWantedData (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    dict[@"frameRate"] = @(self.frameRate);
    return dict.copy;
}

@end

@implementation ByteRTCRemoteStreamSwitchEvent (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.uid;
    dict[@"isScreen"] = @(self.isScreen);
    dict[@"beforeVideoIndex"] = @(self.beforeVideoIndex);
    dict[@"afterVideoIndex"] = @(self.afterVideoIndex);
    dict[@"beforeEnable"] = @(self.beforeVideoEnabled);
    dict[@"afterEnable"] = @(self.afterVideoEnabled);
    dict[@"reason"] = @(self.reason);
    return dict.copy;
}

@end

@implementation ByteRTCRemoteStreamKey (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = self.roomId;
    dict[@"uid"] = self.userId;
    dict[@"streamIndex"] = @(self.streamIndex);
    return dict.copy;
}

@end

@implementation ByteRTCVideoFrameInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    dict[@"rotation"] = @(self.rotation);
    return dict.copy;
}

@end

@implementation ByteRTCTranscoderLayoutRegionDataParam (ByteRTCFlutterMapCategory)

+ (ByteRTCTranscoderLayoutRegionDataParam *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCTranscoderLayoutRegionDataParam * param = [[ByteRTCTranscoderLayoutRegionDataParam alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return param;
    }
    param.imageWidth = [dict[@"imageWidth"] integerValue];
    param.imageHeight = [dict[@"imageHeight"] integerValue];
    return param;
}

@end
    
@implementation ByteRTCVideoCompositingRegion (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoCompositingRegion *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVideoCompositingRegion * region = [[ByteRTCVideoCompositingRegion alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return region;
    }
    region.uid = dict[@"uid"];
    region.roomId = dict[@"roomId"];
    region.x = [dict[@"x"] doubleValue];
    region.y = [dict[@"y"] doubleValue];
    region.width = [dict[@"w"] doubleValue];
    region.height = [dict[@"h"] doubleValue];
    region.zOrder = [dict[@"zorder"] integerValue];
    region.localUser = [dict[@"localUser"] boolValue];
    region.screenStream = [dict[@"isScreen"] boolValue];
    region.alpha = [dict[@"alpha"] doubleValue];
    region.contentControl = [dict[@"contentControl"] integerValue];
    region.renderMode = [dict[@"renderMode"] unsignedIntegerValue];
    region.type = [dict[@"type"] integerValue];
    FlutterStandardTypedData *data = dict[@"data"];
    if (data != nil) {
        region.data = data.data;
    }
    NSDictionary *dataParam = dict[@"dataParam"];
    if (dataParam != nil) {
        region.dataParam = [ByteRTCTranscoderLayoutRegionDataParam bf_fromMap:dataParam];
    }
    return region;
}

@end

@implementation ByteRTCLiveTranscoding (ByteRTCFlutterMapCategory)

+ (ByteRTCLiveTranscoding *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCLiveTranscoding *obj = [ByteRTCLiveTranscoding defaultTranscoding];
    obj.expectedMixingType = ByteRTCStreamMixingTypeByServer;
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    
    ByteRTCTranscodingAudioConfig * audio = [obj audio];
    NSDictionary* audioDict = dict[@"audio"];
    if ([audioDict isKindOfClass:[NSDictionary class]]) {
        audio.codec = audioDict[@"codec"];
        audio.sampleRate =  [audioDict[@"sampleRate"] integerValue];
        audio.channels = [audioDict[@"channels"] integerValue];
        audio.kBitRate = [audioDict[@"kBitrate"] integerValue];
        NSString *aacProfile = audioDict[@"aacProfile"];
        if ([aacProfile isEqualToString:@"LC"]) {
            audio.profile = ByteRTCAACProfileLC;
        } else if ([aacProfile isEqualToString:@"HEV1"]){
            audio.profile = ByteRTCAACProfileHEv1;
        } else if ([aacProfile isEqualToString:@"HEV2"]){
            audio.profile = ByteRTCAACProfileHEv2;
        }
    }
    
    ByteRTCTranscodingVideoConfig* video = [obj video];
    NSDictionary *videoDict = dict[@"video"];
    if ([videoDict isKindOfClass:[NSDictionary class]]) {
        video.codec = videoDict[@"codec"];
        video.height = [videoDict[@"height"]integerValue];
        video.width = [videoDict[@"width"]integerValue];
        video.fps = [videoDict[@"fps"] integerValue];
        video.gop = [videoDict[@"gop"] integerValue];
        video.kBitRate = [videoDict[@"kBitrate"] integerValue];
        video.lowLatency = [videoDict[@"lowLatency"] boolValue];
    }
    
    ByteRTCVideoCompositingLayout * layout = [obj layout];
    NSDictionary *layoutDict = dict[@"layout"];
    if ([layoutDict isKindOfClass:[NSDictionary class]]) {
        layout.appData = layoutDict[@"appData"];
        layout.backgroundColor = layoutDict[@"backgroundColor"];
        NSArray *regionList = layoutDict[@"regions"];
        if ([regionList isKindOfClass:[NSArray class]]) {
            NSMutableArray * regions = [[NSMutableArray alloc] init];
            for (int i = 0; i< [regionList count]; i++) {
                NSDictionary* regionDict = regionList[i];
                ByteRTCVideoCompositingRegion * region = [ByteRTCVideoCompositingRegion bf_fromMap:regionDict];
                [regions addObject:region];
            }
            [layout setRegions:regions];
        }
    }
    
    [obj setAudio:audio];
    [obj setVideo:video];
    [obj setLayout:layout];
    [obj setUrl:dict[@"url"]];
    [obj setRoomId:dict[@"roomId"]];
    [obj setUserId:dict[@"uid"]];
    [obj setAuthInfo:dict[@"authInfo"]];
    [obj setExpectedMixingType:[dict[@"mixType"] integerValue]];
    return obj;
}

@end

@implementation ByteRTCRoomStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"duration"] = @(self.duration);
    dict[@"txBytes"] = @(self.txBytes);
    dict[@"rxBytes"] = @(self.rxBytes);
    dict[@"txKBitrate"] = @(self.txKbitrate);
    dict[@"rxKBitrate"] = @(self.rxKbitrate);
    dict[@"rxAudioKBitrate"] = @(self.rxAudioKBitrate);
    dict[@"txAudioKBitrate"] = @(self.txAudioKBitrate);
    dict[@"rxVideoKBitrate"] = @(self.rxVideoKBitrate);
    dict[@"txVideoKBitrate"] = @(self.txVideoKBitrate);
    dict[@"txScreenKBitrate"] = @(self.txScreenKBitrate);
    dict[@"rxScreenKBitrate"] = @(self.rxScreenKBitrate);
    dict[@"userCount"] = @(self.userCount);
    dict[@"txLostrate"] = @(self.txLostrate);
    dict[@"rxLostrate"] = @(self.rxLostrate);
    dict[@"rtt"] = @(self.rtt);
    dict[@"txJitter"] = @(self.txJitter);
    dict[@"rxJitter"] = @(self.rxJitter);
    dict[@"txCellularKBitrate"] = @(self.tx_cellular_kbitrate);
    dict[@"rxCellularKBitrate"] = @(self.rx_cellular_kbitrate);
    return dict.copy;
}

@end

@implementation ByteRTCAudioMixingConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioMixingConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCAudioMixingConfig *config = [[ByteRTCAudioMixingConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.type = [dict[@"type"] integerValue];
    config.playCount = [dict[@"playCount"] integerValue];
    config.position = [dict[@"position"] integerValue];
    config.callbackOnProgressInterval = [dict[@"callbackOnProgressInterval"] integerValue];
    return config;
}

@end

@implementation ReceiveRange (ByteRTCFlutterMapCategory)

+ (ReceiveRange *)bf_fromMap:(NSDictionary *)dict {
    ReceiveRange *range = [[ReceiveRange alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return range;
    }
    range.min = [dict[@"min"] intValue];
    range.max = [dict[@"max"] intValue];
    return range;
}

@end

@implementation Position (ByteRTCFlutterMapCategory)

+ (Position *)bf_fromMap:(NSDictionary *)dict {
    Position *pos = [[Position alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return pos;
    }
    pos.x = [dict[@"x"] intValue];
    pos.y = [dict[@"y"] intValue];
    pos.z = [dict[@"z"] intValue];
    return pos;
}

@end

@implementation Orientation (ByteRTCFlutterMapCategory)

+ (Orientation *)bf_fromMap:(NSDictionary *)dict {
    Orientation *ori = [[Orientation alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return ori;
    }
    ori.x = [dict[@"x"] floatValue];
    ori.y = [dict[@"y"] floatValue];
    ori.z = [dict[@"z"] floatValue];
    return ori;
}

@end

@implementation HumanOrientation (ByteRTCFlutterMapCategory)

+ (HumanOrientation *)bf_fromMap:(NSDictionary *)dict {
    HumanOrientation *ori = [[HumanOrientation alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return ori;
    }
    ori.forward = [Orientation bf_fromMap:dict[@"forward"]];
    ori.right = [Orientation bf_fromMap:dict[@"right"]];
    ori.up = [Orientation bf_fromMap:dict[@"up"]];
    return ori;
}

@end

@implementation ByteRTCRangeAudioInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.userId;
    dict[@"factor"] = @(self.factor);
    return dict.copy;
}

@end

@implementation ByteRTCVideoCaptureConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoCaptureConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVideoCaptureConfig *config = [[ByteRTCVideoCaptureConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.preference = [dict[@"capturePreference"] integerValue];
    config.videoSize = CGSizeMake([dict[@"width"] floatValue], [dict[@"height"] floatValue]);
    config.frameRate = [dict[@"frameRate"] integerValue];
    return config;
}

@end

@implementation ByteRTCRecordingConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCRecordingConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCRecordingConfig *config = [[ByteRTCRecordingConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.dirPath = dict[@"dirPath"];
    config.recordingFileType = [dict[@"recordingFileType"] integerValue];
    return config;
}

@end

@implementation ByteRTCASRConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCASRConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCASRConfig *config = [[ByteRTCASRConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.appId = dict[@"appId"];
    config.userId = dict[@"uid"];
    config.accessToken = dict[@"accessToken"];
    config.secretKey = dict[@"secretKey"];
    config.cluster = dict[@"cluster"];
    config.authorizationType = [dict[@"authorizationType"] integerValue];
    return config;
}

@end

@implementation ByteRTCAudioPropertiesConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioPropertiesConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCAudioPropertiesConfig *config = [[ByteRTCAudioPropertiesConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.interval = [dict[@"interval"] integerValue];
    config.enable_spectrum = [dict[@"enableSpectrum"] boolValue];
    config.enable_vad = [dict[@"enableVad"] boolValue];
    return config;
}

@end

@implementation ByteRTCStreamSycnInfoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCStreamSycnInfoConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCStreamSycnInfoConfig *config = [[ByteRTCStreamSycnInfoConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.streamIndex = [dict[@"streamIndex"] integerValue];
    config.repeatCount = [dict[@"repeatCount"] intValue];
    config.streamType = [dict[@"streamType"] integerValue];
    return config;
}

@end

@implementation ByteRTCRecordingInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"filePath"] = self.filePath;
    dict[@"videoCodecType"] = @(self.codecType);
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    return dict.copy;
}

@end

@implementation ByteRTCRecordingProgress (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"duration"] = @(self.duration);
    dict[@"fileSize"] = @(self.fileSize);
    return dict.copy;
}

@end

@implementation ByteRTCAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"linearVolume"] = @(self.linearVolume);
    dict[@"nonlinearVolume"] = @(self.nonlinearVolume);
    dict[@"vad"] = @(self.vad);
    dict[@"spectrum"] = self.spectrum;
    return dict.copy;
}

@end

@implementation ByteRTCLocalAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(self.streamIndex);
    dict[@"audioPropertiesInfo"] = self.audioPropertiesInfo.bf_toMap;
    return dict.copy;
}

@end

@implementation ByteRTCRemoteAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = self.streamKey.bf_toMap;
    dict[@"audioPropertiesInfo"] = self.audioPropertiesInfo.bf_toMap;
    return dict.copy;
}

@end

@implementation ByteRTCRemoteVideoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCRemoteVideoConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCRemoteVideoConfig *config = [[ByteRTCRemoteVideoConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.framerate = [dict[@"frameRate"] intValue];
    config.width = [dict[@"width"] intValue];
    config.height = [dict[@"height"] intValue];
    return config;
}

@end

@implementation ByteRTCVideoEncoderConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoEncoderConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVideoEncoderConfig *config = [[ByteRTCVideoEncoderConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.width = [dict[@"width"] integerValue];
    config.height = [dict[@"height"] integerValue];
    config.frameRate = [dict[@"frameRate"] integerValue];
    config.maxBitrate = [dict[@"maxBitrate"] integerValue];
    config.encoderPreference = [dict[@"encoderPreference"] integerValue];
    return config;
}

@end

@implementation ByteRTCVirtualBackgroundSource (ByteRTCFlutterMapCategory)

+ (ByteRTCVirtualBackgroundSource *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVirtualBackgroundSource *source = [[ByteRTCVirtualBackgroundSource alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return source;
    }
    source.sourceType = [dict[@"sourceType"] integerValue];
    source.sourceColor = [dict[@"sourceColor"] intValue];
    source.sourcePath = dict[@"sourcePath"];
    return source;
}

@end

@implementation ByteRTCSourceCropInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCSourceCropInfo *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCSourceCropInfo *info = [[ByteRTCSourceCropInfo alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return info;
    }
    info.LocationX = [dict[@"locationX"] doubleValue];
    info.LocationY = [dict[@"locationY"] doubleValue];
    info.WidthProportion = [dict[@"widthProportion"] doubleValue];
    info.HeightProportion = [dict[@"heightProportion"] doubleValue];
    return info;
}

@end

@implementation ByteRTCPublicStreamRegion (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamRegion *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPublicStreamRegion *region = [[ByteRTCPublicStreamRegion alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return region;
    }
    region.userId = dict[@"uid"];
    region.roomId = dict[@"roomId"];
    region.alternateImage = dict[@"alternateImage"];
    region.x = [dict[@"x"] doubleValue];
    region.y = [dict[@"y"] doubleValue];
    region.width = [dict[@"w"] doubleValue];
    region.height = [dict[@"h"] doubleValue];
    region.zOrder = [dict[@"zorder"] integerValue];
    region.alpha = [dict[@"alpha"] doubleValue];
    region.mediaType = [dict[@"mediaType"] integerValue];
    region.streamType = [dict[@"streamType"] integerValue];
    region.renderMode = [dict[@"renderMode"] unsignedIntegerValue];
    region.sourceCrop = [ByteRTCSourceCropInfo bf_fromMap:dict[@"sourceCrop"]];
    return region;
}

@end

@implementation ByteRTCPublicStreamLayout (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamLayout *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPublicStreamLayout *layout = [[ByteRTCPublicStreamLayout alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return layout;
    }
    layout.layoutMode = [dict[@"layoutMode"] integerValue];
    layout.interpolationMode = [dict[@"interpolationMode"] integerValue];
    layout.backgroundColor = dict[@"backgroundColor"];
    layout.backgroundImage = dict[@"backgroundImage"];
    NSMutableArray<ByteRTCPublicStreamRegion *> *regions = [NSMutableArray array];
    for (NSDictionary *reDic in dict[@"regions"]) {
        ByteRTCPublicStreamRegion *region = [ByteRTCPublicStreamRegion bf_fromMap:reDic];
        [regions addObject:region];
    }
    layout.regions = [regions copy];
    return layout;
}

@end

@implementation ByteRTCPublicStreamVideoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamVideoConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPublicStreamVideoConfig *config = [[ByteRTCPublicStreamVideoConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.width = [dict[@"width"] integerValue];
    config.height = [dict[@"height"] integerValue];
    config.fps = [dict[@"fps"] integerValue];
    config.bitrate = [dict[@"kBitrate"] integerValue];
    return config;
}

@end

@implementation ByteRTCPublicStreamAudioConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamAudioConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPublicStreamAudioConfig *config = [[ByteRTCPublicStreamAudioConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.sampleRate = [dict[@"sampleRate"] integerValue];
    config.channels = [dict[@"channels"] integerValue];
    config.bitrate = [dict[@"kBitrate"] integerValue];
    return config;
}

@end

@implementation ByteRTCPublicStreaming (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreaming *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPublicStreaming *streaming = [ByteRTCPublicStreaming defaultPublicStreaming];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return streaming;
    }
    streaming.layout = [ByteRTCPublicStreamLayout bf_fromMap:dict[@"layout"]];
    streaming.video = [ByteRTCPublicStreamVideoConfig bf_fromMap:dict[@"video"]];
    streaming.audio = [ByteRTCPublicStreamAudioConfig bf_fromMap:dict[@"audio"]];
    streaming.roomId = dict[@"roomId"];
    return streaming;
}

@end

@implementation ForwardStreamConfiguration (ByteRTCFlutterMapCategory)

+ (ForwardStreamConfiguration *)bf_fromMap:(NSDictionary *)dict {
    ForwardStreamConfiguration *config = [[ForwardStreamConfiguration alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.roomId = dict[@"roomId"];
    config.token = dict[@"token"];
    return config;
}

@end

@implementation ForwardStreamStateInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = self.roomId ?: @"";
    dict[@"state"] = @(self.state);
    dict[@"error"] = @(self.error);
    return dict.copy;
}

@end

@implementation ForwardStreamEventInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = self.roomId ?: @"";
    dict[@"event"] = @(self.event);
    return dict.copy;
}

@end

@implementation ByteRTCVideoByteWatermark (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoByteWatermark *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVideoByteWatermark *config = [[ByteRTCVideoByteWatermark alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.x = [dict[@"x"] floatValue];
    config.y = [dict[@"y"] floatValue];
    config.width = [dict[@"width"] floatValue];
    config.height = [dict[@"height"] floatValue];
    return config;
}

@end

@implementation ByteRTCVideoWatermarkConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoWatermarkConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVideoWatermarkConfig *config = [[ByteRTCVideoWatermarkConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.visibleInPreview = [dict[@"visibleInPreview"] boolValue];
    config.positionInLandscapeMode = [ByteRTCVideoByteWatermark bf_fromMap:dict[@"positionInLandscapeMode"]];
    config.positionInPortraitMode = [ByteRTCVideoByteWatermark bf_fromMap:dict[@"positionInPortraitMode"]];
    return config;
}

@end

@implementation ByteRTCSubscribeConfig (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"isScreen"] = @(self.isScreen);
    dict[@"subVideo"] = @(self.subscribeVideo);
    dict[@"subAudio"] = @(self.subscribeAudio);
    dict[@"videoIndex"] = @(self.videoIndex);
    dict[@"svcLayer"] = @(self.svcLayer);
    dict[@"subWidth"] = @(self.width);
    dict[@"subHeight"] = @(self.height);
    dict[@"subVideoIndex"] = @(self.subVideoIndex);
    dict[@"frameRate"] = @(self.framerate);
    return dict.copy;
}

@end

@implementation ByteRTCRectangle (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"x"] = @(self.x);
    dict[@"y"] = @(self.y);
    dict[@"width"] = @(self.width);
    dict[@"height"] = @(self.height);
    return dict.copy;
}

@end

@implementation ByteRTCFaceDetectionResult (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"detectResult"] = @(self.detectResult);
    dict[@"imageWidth"] = @(self.imageWidth);
    dict[@"imageHeight"] = @(self.imageHeight);
    NSMutableArray *faceDics = [NSMutableArray array];
    for (ByteRTCRectangle *face in self.faces) {
        [faceDics addObject:face.bf_toMap];
    }
    dict[@"faces"] = faceDics.copy;
    return dict.copy;
}

@end

@implementation ByteRTCCloudProxyInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCCloudProxyInfo *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCCloudProxyInfo *info = [[ByteRTCCloudProxyInfo alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return info;
    }
    info.cloudProxyIp = dict[@"cloudProxyIp"];
    info.cloudProxyPort = [dict[@"cloudProxyPort"] intValue];
    return info;
}

@end

@implementation ByteRTCEchoTestConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCEchoTestConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCEchoTestConfig *config = [[ByteRTCEchoTestConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.roomId = dict[@"roomId"];
    config.userId = dict[@"uid"];
    config.token = dict[@"token"];
    config.enableAudio = [dict[@"enableAudio"] boolValue];
    config.enableVideo = [dict[@"enableVideo"] boolValue];
    config.audioReportInterval = [dict[@"audioReportInterval"] integerValue];
    return config;
}

@end

@implementation ByteRTCPushSingleStreamParam (ByteRTCFlutterMapCategory)

+ (ByteRTCPushSingleStreamParam *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPushSingleStreamParam *param = [[ByteRTCPushSingleStreamParam alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return param;
    }
    param.roomId = dict[@"roomId"];
    param.userId = dict[@"uid"];
    param.url = dict[@"url"];
    param.isScreen = [dict[@"isScreen"] boolValue];
    return param;
}

@end
