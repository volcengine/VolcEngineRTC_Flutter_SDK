/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterAudioMixingPlugin.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterAudioMixingPlugin ()

@property (nonatomic, strong) ByteRTCVideo *rtcVideo;

@end

@implementation ByteRTCFlutterAudioMixingPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo {
    self = [super init];
    if (self) {
        self.rtcVideo = rtcVideo;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_audio_mixing_manager"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
}

- (nullable ByteRTCAudioMixingManager *)audioMixingManager {
    return self.rtcVideo.getAudioMixingManager;
}

#pragma mark audio mix related

- (void)startAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    NSString *filePath = arguments[@"filePath"];
    ByteRTCAudioMixingConfig *config = [ByteRTCAudioMixingConfig bf_fromMap:arguments[@"config"]];
    [self.audioMixingManager startAudioMixing:mixId
                                     filePath:filePath
                                       config:config];
    result(nil);
}

- (void)stopAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    [self.audioMixingManager stopAudioMixing:mixId];
    result(nil);
}

- (void)pauseAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    [self.audioMixingManager pauseAudioMixing:mixId];
    result(nil);
}

- (void)resumeAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    [self.audioMixingManager resumeAudioMixing:mixId];
    result(nil);
}

- (void)preloadAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    NSString *filePath = arguments[@"filePath"];
    [self.audioMixingManager preloadAudioMixing:mixId
                                       filePath:filePath];
    result(nil);
}

- (void)unloadAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    [self.audioMixingManager unloadAudioMixing:mixId];
    result(nil);
}

- (void)setAudioMixingVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int volume = [arguments[@"volume"] intValue];
    ByteRTCAudioMixingType type = [arguments[@"type"] integerValue];
    [self.audioMixingManager setAudioMixingVolume:mixId
                                           volume:volume
                                             type:type];
    result(nil);
}

- (void)getAudioMixingDuration:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int duration = [self.audioMixingManager getAudioMixingDuration:mixId];
    result(@(duration));
}

- (void)getAudioMixingPlaybackDuration:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int duration = [self.audioMixingManager getAudioMixingPlaybackDuration:mixId];
    result(@(duration));
}

- (void)getAudioMixingCurrentPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int position = [self.audioMixingManager getAudioMixingCurrentPosition:mixId];
    result(@(position));
}

- (void)setAudioMixingPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int position = [arguments[@"position"] intValue];
    [self.audioMixingManager setAudioMixingPosition:mixId
                                           position:position];
    result(nil);
}

- (void)setAudioMixingDualMonoMode:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    ByteRTCAudioMixingDualMonoMode mode = [arguments[@"mode"] integerValue];
    [self.audioMixingManager setAudioMixingDualMonoMode:mixId
                                                   mode:mode];
    result(nil);
}

- (void)setAudioMixingPitch:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int pitch = [arguments[@"pitch"] intValue];
    [self.audioMixingManager setAudioMixingPitch:mixId
                                           pitch:pitch];
    result(nil);
}

- (void)setAudioMixingPlaybackSpeed:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int speed = [arguments[@"speed"] intValue];
    int res = [self.audioMixingManager setAudioMixingPlaybackSpeed:mixId
                                                             speed:speed];
    result(@(res));
}

- (void)setAudioMixingLoudness:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    float loudness = [arguments[@"loudness"] floatValue];
    [self.audioMixingManager setAudioMixingLoudness:mixId
                                           loudness:loudness];
    result(nil);
}

- (void)setAudioMixingProgressInterval:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int64_t interval = [arguments[@"interval"] longLongValue];
    [self.audioMixingManager setAudioMixingProgressInterval:mixId
                                                   interval:interval];
    result(nil);
}

- (void)getAudioTrackCount:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int res = [self.audioMixingManager getAudioTrackCount:mixId];
    result(@(res));
}

- (void)selectAudioTrack:(NSDictionary *)arguments result:(FlutterResult)result {
    int mixId = [arguments[@"mixId"] intValue];
    int audioTrackIndex = [arguments[@"audioTrackIndex"] intValue];
    [self.audioMixingManager selectAudioTrack:mixId
                              audioTrackIndex:audioTrackIndex];
    result(nil);
}

- (void)setAllAudioMixingVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    int volume = [arguments[@"volume"] intValue];
    ByteRTCAudioMixingType type = [arguments[@"type"] integerValue];
    [self.audioMixingManager setAllAudioMixingVolume:volume type:type];
    result(nil);
}

- (void)pauseAllAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.audioMixingManager pauseAllAudioMixing];
    result(nil);
}

- (void)resumeAllAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.audioMixingManager resumeAllAudioMixing];
    result(nil);
}

- (void)stopAllAudioMixing:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.audioMixingManager stopAllAudioMixing];
    result(nil);
}

@end
