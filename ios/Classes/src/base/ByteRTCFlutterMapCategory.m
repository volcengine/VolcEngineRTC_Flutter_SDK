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

+ (NSDictionary *)ktvMusicToMap:(ByteRTCMusicInfo *)music {
    return @{
        @"musicId": music.musicId ?: @"",
        @"musicName": music.musicName ?: @"",
        @"singer": music.singer ?: @"",
        @"vendorId": music.vendorId ?: @"",
        @"vendorName": music.vendorName ?: @"",
        @"updateTimestamp": @(music.updateTimestamp),
        @"posterUrl": music.posterUrl ?: @"",
        @"lyricStatus": @(music.lyricStatus),
        @"duration": @(music.duration),
        @"enableScore": @(music.enableScore),
        @"climaxStartTime": @(music.climaxStartTime),
        @"climaxEndTime": @(music.climaxEndTime),
    };
}

+ (NSDictionary *)ktvHotMusicInfoToMap:(ByteRTCHotMusicInfo *)hotMusicInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"hotType"] = @(hotMusicInfo.hotType);
    if (hotMusicInfo.hotName != nil) {
        dict[@"hotName"] = hotMusicInfo.hotName;
    }
    if (hotMusicInfo.musics != nil && hotMusicInfo.musics.count != 0) {
        NSMutableArray *musics = [NSMutableArray array];
        [hotMusicInfo.musics enumerateObjectsUsingBlock:^(ByteRTCMusicInfo *obj, NSUInteger idx, BOOL *stop) {
            [musics addObject:[self ktvMusicToMap:obj]];
        }];
        dict[@"musicInfos"] = musics;
    }
    return dict.copy;
}


+ (NSDictionary *)ktvDownloadResultToMap:(ByteRTCDownloadResult *)downloadResult {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"musicId"] = downloadResult.musicId ?: @"";
    dict[@"fileType"] = @(downloadResult.fileType);
    if (downloadResult.filePath != nil) {
        dict[@"filePath"] = downloadResult.filePath;
    }
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

+ (ByteRTCRemoteStreamKey *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCRemoteStreamKey * param = [[ByteRTCRemoteStreamKey alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return param;
    }
    param.roomId = dict[@"roomId"];
    param.userId = dict[@"uid"];
    param.streamIndex = [dict[@"streamIndex"] integerValue];
    return param;
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
    region.cornerRadius = [dict[@"cornerRadius"] doubleValue];
    region.spatialPosition = [Position bf_fromMap:dict[@"spatialPosition"]];
    region.applySpatialAudio = [dict[@"applySpatialAudio"] boolValue];
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

@implementation ByteRTCTranscodingSpatialConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCTranscodingSpatialConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCTranscodingSpatialConfig *config = [ByteRTCTranscodingSpatialConfig new];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.audienceSpatialOrientation = [HumanOrientation bf_fromMap:dict[@"orientation"]];
    config.audienceSpatialPosition = [Position bf_fromMap:dict[@"position"]];
    config.enableSpatialRender = [dict[@"enableSpatialRender"] boolValue];
    return config;
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
        NSString *codec = audioDict[@"codec"];
        if ([codec isEqualToString:@"AAC"]) {
            audio.codec = ByteRTCTranscodingAudioCodecAAC;
        }
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
        NSString *codec = audioDict[@"codec"];
        if ([codec isEqualToString:@"H264"]) {
            video.codec = ByteRTCTranscodingVideoCodecH264;
        } else if ([codec isEqualToString:@"ByteVC1"]) {
            video.codec = ByteRTCTranscodingVideoCodecH265;
        }
        video.height = [videoDict[@"height"]integerValue];
        video.width = [videoDict[@"width"]integerValue];
        video.fps = [videoDict[@"fps"] integerValue];
        video.gop = [videoDict[@"gop"] integerValue];
        video.kBitRate = [videoDict[@"kBitrate"] integerValue];
        video.bFrame = [videoDict[@"bFrame"] boolValue];
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
    [obj setExpectedMixingType:[dict[@"mixType"] integerValue]];
    [obj setSpatialConfig:[ByteRTCTranscodingSpatialConfig bf_fromMap:dict[@"spatialConfig"]]];
    return obj;
}

@end

@implementation ByteRTCMixedStreamLayoutRegionImageWaterMarkConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMixedStreamLayoutRegionImageWaterMarkConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMixedStreamLayoutRegionImageWaterMarkConfig * param = [[ByteRTCMixedStreamLayoutRegionImageWaterMarkConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return param;
    }
    param.imageWidth = [dict[@"imageWidth"] integerValue];
    param.imageHeight = [dict[@"imageHeight"] integerValue];
    return param;
}

@end

@implementation ByteRTCMixedStreamLayoutRegionConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMixedStreamLayoutRegionConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMixedStreamLayoutRegionConfig * region = [[ByteRTCMixedStreamLayoutRegionConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return region;
    }
    region.userID = dict[@"uid"];
    region.roomID = dict[@"roomId"];
    region.locationX = [dict[@"locationX"] doubleValue];
    region.locationY = [dict[@"locationY"] doubleValue];
    region.widthProportion = [dict[@"widthProportion"] doubleValue];
    region.heightProportion = [dict[@"heightProportion"] doubleValue];
    region.zOrder = [dict[@"zOrder"] integerValue];
    region.isLocalUser = [dict[@"isLocalUser"] boolValue];
    region.streamType = [dict[@"streamType"] integerValue];
    region.alpha = [dict[@"alpha"] doubleValue];
    region.cornerRadius = [dict[@"cornerRadius"] doubleValue];
    region.mediaType = [dict[@"mediaType"] integerValue];
    region.renderMode = [dict[@"renderMode"] unsignedIntegerValue];
    region.regionContentType = [dict[@"regionContentType"] integerValue];
    region.spatialPosition = [Position bf_fromMap:dict[@"spatialPosition"]];
    region.applySpatialAudio = [dict[@"applySpatialAudio"] boolValue];
    FlutterStandardTypedData *imageWaterMark = dict[@"imageWaterMark"];
    if (imageWaterMark != nil) {
        region.imageWaterMark = imageWaterMark.data;
    }
    NSDictionary *imageWaterMarkConfig = dict[@"imageWaterMarkConfig"];
    if (imageWaterMarkConfig != nil) {
        region.imageWaterMarkConfig = [ByteRTCMixedStreamLayoutRegionImageWaterMarkConfig bf_fromMap:imageWaterMarkConfig];
    }
    return region;
}

@end

@implementation ByteRTCMixedStreamSpatialAudioConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMixedStreamSpatialAudioConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMixedStreamSpatialAudioConfig *config = [ByteRTCMixedStreamSpatialAudioConfig new];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.audienceSpatialOrientation = [HumanOrientation bf_fromMap:dict[@"orientation"]];
    config.audienceSpatialPosition = [Position bf_fromMap:dict[@"position"]];
    config.enableSpatialRender = [dict[@"enableSpatialRender"] boolValue];
    return config;
}

@end

@implementation ByteRTCMixedStreamConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMixedStreamConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMixedStreamConfig *obj = [ByteRTCMixedStreamConfig defaultMixedStreamConfig];
    obj.expectedMixingType = ByteRTCMixedStreamByServer;
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    
    ByteRTCMixedStreamAudioConfig * audio = obj.audioConfig;
    NSDictionary* audioDict = dict[@"audioConfig"];
    if ([audioDict isKindOfClass:[NSDictionary class]]) {
        audio.audioCodec = [audioDict[@"audioCodec"] integerValue];
        audio.sampleRate =  [audioDict[@"sampleRate"] integerValue];
        audio.channels = [audioDict[@"channels"] integerValue];
        audio.bitrate = [audioDict[@"bitrate"] integerValue];
        audio.audioProfile = [audioDict[@"audioProfile"] integerValue];
    }
    
    ByteRTCMixedStreamVideoConfig* video = obj.videoConfig;
    NSDictionary *videoDict = dict[@"videoConfig"];
    if ([videoDict isKindOfClass:[NSDictionary class]]) {
        video.videoCodec = [videoDict[@"videoCodec"]integerValue];
        video.height = [videoDict[@"height"]integerValue];
        video.width = [videoDict[@"width"]integerValue];
        video.fps = [videoDict[@"fps"] integerValue];
        video.gop = [videoDict[@"gop"] integerValue];
        video.bitrate = [videoDict[@"bitrate"] integerValue];
        video.enableBFrame = [videoDict[@"enableBFrame"] boolValue];
    }
    
    ByteRTCMixedStreamLayoutConfig * layout = obj.layoutConfig;
    NSDictionary *layoutDict = dict[@"layout"];
    if ([layoutDict isKindOfClass:[NSDictionary class]]) {
        layout.backgroundColor = layoutDict[@"backgroundColor"];
        layout.userConfigExtraInfo = layoutDict[@"userConfigExtraInfo"];
        NSArray *regionList = layoutDict[@"regions"];
        if ([regionList isKindOfClass:[NSArray class]]) {
            NSMutableArray * regions = [[NSMutableArray alloc] init];
            [regionList enumerateObjectsUsingBlock:^(NSDictionary *regionDict, NSUInteger idx, BOOL * _Nonnull stop) {
                ByteRTCMixedStreamLayoutRegionConfig * region = [ByteRTCMixedStreamLayoutRegionConfig bf_fromMap:regionDict];
                [regions addObject:region];
            }];
            [layout setRegions:regions];
        }
    }
    
    obj.pushURL = dict[@"pushURL"];
    obj.roomID = dict[@"roomId"];
    obj.userID = dict[@"uid"];
    obj.expectedMixingType = [dict[@"expectedMixingType"] integerValue];
    obj.spatialAudioConfig = [ByteRTCMixedStreamSpatialAudioConfig bf_fromMap:dict[@"spatialConfig"]];
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
    dict[@"txCellularKBitrate"] = @(self.txCellularKBitrate);
    dict[@"rxCellularKBitrate"] = @(self.rxCellularKBitrate);
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
    config.syncProgressToRecordFrame = [dict[@"syncProgressToRecordFrame"] boolValue];
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
    pos.x = [dict[@"x"] floatValue];
    pos.y = [dict[@"y"] floatValue];
    pos.z = [dict[@"z"] floatValue];
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

@implementation ByteRTCPositionInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCPositionInfo *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCPositionInfo *info = [[ByteRTCPositionInfo alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return info;
    }
    info.position = [Position bf_fromMap:dict[@"position"]];
    info.orientation = [HumanOrientation bf_fromMap:dict[@"orientation"]];
    return info;
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
    config.local_main_report_mode = [dict[@"localMainReportMode"] integerValue];
    config.audio_report_mode = [dict[@"audioReportMode"] integerValue];
    config.smooth = [dict[@"smooth"] floatValue];
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
    config.minBitrate = [dict[@"minBitrate"] integerValue];
    config.encoderPreference = [dict[@"encoderPreference"] integerValue];
    return config;
}

@end

@implementation ByteRTCScreenVideoEncoderConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCScreenVideoEncoderConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCScreenVideoEncoderConfig *config = [[ByteRTCScreenVideoEncoderConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.width = [dict[@"width"] integerValue];
    config.height = [dict[@"height"] integerValue];
    config.frameRate = [dict[@"frameRate"] integerValue];
    config.maxBitrate = [dict[@"maxBitrate"] integerValue];
    config.minBitrate = [dict[@"minBitrate"] integerValue];
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
    NSInteger frameTimestampUs = (NSInteger)(CMTimeGetSeconds(self.frameTimestamp) * 1000);
    dict[@"frameTimestampUs"] = @(frameTimestampUs);
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


@implementation ByteRTCAudioRecordingConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioRecordingConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCAudioRecordingConfig *config = [ByteRTCAudioRecordingConfig new];
    config.absoluteFileName = dict[@"absoluteFileName"];
    config.sampleRate = [dict[@"sampleRate"] integerValue];
    config.channel = [dict[@"channel"] integerValue];
    config.frameSource = [dict[@"frameSource"] integerValue];
    config.quality = [dict[@"quality"] integerValue];
    return config;
}

@end

@implementation ByteRTCVoiceEqualizationConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVoiceEqualizationConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVoiceEqualizationConfig *config = [ByteRTCVoiceEqualizationConfig new];
    config.frequency = [dict[@"frequency"] integerValue];
    config.gain = [dict[@"gain"] intValue];
    return config;
}

@end

@implementation ByteRTCVoiceReverbConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVoiceReverbConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCVoiceReverbConfig *config = [ByteRTCVoiceReverbConfig new];
    config.roomSize = [dict[@"roomSize"] floatValue];
    config.decayTime = [dict[@"decayTime"] floatValue];
    config.damping = [dict[@"damping"] floatValue];
    config.wetGain = [dict[@"wetGain"] floatValue];
    config.dryGain = [dict[@"dryGain"] floatValue];
    config.preDelay = [dict[@"preDelay"] floatValue];
    return config;
}

@end

@implementation ByteRTCSingScoringConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCSingScoringConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCSingScoringConfig *config = [[ByteRTCSingScoringConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.sampleRate = [dict[@"sampleRate"] integerValue];
    config.mode = ByteRTCMulDimSingScoringModeNote;
    config.lyricsFilepath = dict[@"lyricsFilepath"];
    config.midiFilepath = dict[@"midiFilepath"];
    return config;
}

@end

@implementation ByteRTCStandardPitchInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"startTime"] = @(self.startTime);
    dict[@"duration"] = @(self.duration);
    dict[@"pitch"] = @(self.pitch);
    return dict.copy;
}

@end

@implementation ByteRTCSingScoringRealtimeInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"currentPosition"] = @(self.currentPosition);
    dict[@"userPitch"] = @(self.userPitch);
    dict[@"standardPitch"] = @(self.standardPitch);
    dict[@"sentenceIndex"] = @(self.sentenceIndex);
    dict[@"sentenceScore"] = @(self.sentenceScore);
    dict[@"totalScore"] = @(self.totalScore);
    dict[@"averageScore"] = @(self.averageScore);
    return dict.copy;
}

@end

@implementation ByteRTCProblemFeedbackInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCProblemFeedbackInfo *)bf_fromMap:(NSDictionary *)dict {
    if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    ByteRTCProblemFeedbackInfo *info = [[ByteRTCProblemFeedbackInfo alloc] init];
    info.problemDesc = dict[@"problemDesc"];
    NSArray *roomDic = dict[@"roomInfo"];
    if (roomDic != nil && roomDic.count != 0) {
        NSMutableArray<ByteRTCProblemFeedbackRoomInfo *> *roomInfos = [NSMutableArray array];
        [roomDic enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ByteRTCProblemFeedbackRoomInfo *roomInfo = [[ByteRTCProblemFeedbackRoomInfo alloc] init];
            roomInfo.roomId = obj[@"roomId"];
            roomInfo.userId = obj[@"uid"];
            [roomInfos addObject:roomInfo];
        }];
        info.roomInfo = roomInfos.copy;
    }
    return info;
}

@end

@implementation ByteRTCMediaTypeEnhancementConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMediaTypeEnhancementConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMediaTypeEnhancementConfig *config = [[ByteRTCMediaTypeEnhancementConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.enhanceSignaling = [dict[@"enhanceSignaling"] boolValue];
    config.enhanceAudio = [dict[@"enhanceAudio"]  boolValue];
    config.enhanceVideo = [dict[@"enhanceVideo"] boolValue];
    config.enhanceScreenAudio = [dict[@"enhanceScreenAudio"] boolValue];
    config.enhanceScreenVideo = [dict[@"enhanceScreenVideo"] boolValue];
    return config;
}

@end

@implementation ByteRTCLocalProxyInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCLocalProxyInfo *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCLocalProxyInfo *info = [[ByteRTCLocalProxyInfo alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return info;
    }
    info.localProxyType = [dict[@"localProxyType"] unsignedIntegerValue];
    info.localProxyIp = dict[@"localProxyIp"];
    info.localProxyPort = [dict[@"localProxyPort"] intValue];
    info.localProxyUsername = dict[@"localProxyUsername"];
    info.localProxyPassword = dict[@"localProxyPassword"];
    return info;
}

@end

@implementation ByteRTCSubtitleConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCSubtitleConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCSubtitleConfig *config = [[ByteRTCSubtitleConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.mode = [dict[@"mode"] integerValue];
    config.targetLanguage = dict[@"targetLanguage"];
    return config;
}

@end

@implementation ByteRTCSubtitleMessage (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = self.userId;
    dict[@"text"] = self.text;
    dict[@"sequence"] = @(self.sequence);
    dict[@"definite"] = @(self.definite);
    return dict.copy;
}

@end

@implementation ByteRTCLogConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCLogConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCLogConfig *config = [[ByteRTCLogConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.logPath = dict[@"logPath"];
    config.logLevel = [dict[@"logLevel"] unsignedIntegerValue];
    config.logFileSize = [dict[@"logFileSize"] intValue];
    return config;
}

@end

@implementation ByteRTCAudioEffectPlayerConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioEffectPlayerConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCAudioEffectPlayerConfig *config = [[ByteRTCAudioEffectPlayerConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.type = [dict[@"type"] integerValue];
    config.pitch = [dict[@"pitch"] integerValue];
    config.playCount = [dict[@"playCount"] integerValue];
    config.startPos = [dict[@"startPos"] integerValue];
    return config;
}

@end

@implementation ByteRTCMediaPlayerConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCMediaPlayerConfig *)bf_fromMap:(NSDictionary *)dict {
    ByteRTCMediaPlayerConfig *config = [[ByteRTCMediaPlayerConfig alloc] init];
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return config;
    }
    config.type = [dict[@"type"] integerValue];
    config.playCount = [dict[@"playCount"] integerValue];
    config.startPos = [dict[@"startPos"] integerValue];
    config.callbackOnProgressInterval = [dict[@"callbackOnProgressInterval"] integerValue];
    config.syncProgressToRecordFrame = [dict[@"syncProgressToRecordFrame"] boolValue];
    config.autoPlay = [dict[@"autoPlay"] boolValue];
    return config;
}

@end
