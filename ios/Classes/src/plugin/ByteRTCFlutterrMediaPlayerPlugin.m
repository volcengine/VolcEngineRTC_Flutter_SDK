/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCMediaPlayer.h>
#import "ByteRTCFlutterrMediaPlayerPlugin.h"
#import "ByteRTCFlutterMediaPlayerEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterrMediaPlayerPlugin ()

@property (nonatomic, strong) ByteRTCMediaPlayer *player;
@property (nonatomic, strong) ByteRTCFlutterMediaPlayerEventHandler *eventHandler;
@property (nonatomic, assign) int playerId;

@end

@implementation ByteRTCFlutterrMediaPlayerPlugin

- (instancetype)initWithRTCMediaPlayer:(ByteRTCMediaPlayer *)player playerId:(int)playerId {
    self = [super init];
    if (self) {
        self.player = player;
        self.playerId = playerId;
        self.eventHandler = [[ByteRTCFlutterMediaPlayerEventHandler alloc] init];
        [player setEventHandler:self.eventHandler];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:[NSString stringWithFormat:@"com.bytedance.ve_rtc_media_player_%d", self.playerId]
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    [self.eventHandler registerEventChannelWithName:[NSString stringWithFormat:@"com.bytedance.ve_rtc_media_player_event_%d", self.playerId]
                                    binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.eventHandler destroy];
}

#pragma mark - method
- (void)open:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *filePath = arguments[@"filePath"];
    ByteRTCMediaPlayerConfig *config = [ByteRTCMediaPlayerConfig bf_fromMap:arguments[@"config"]];
    int res = [self.player open:filePath config:config];
    result(@(res));
}

- (void)start:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player start];
    result(@(res));
}

- (void)stop:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player stop];
    result(@(res));
}

- (void)pause:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player pause];
    result(@(res));
}

- (void)resume:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player resume];
    result(@(res));
}

- (void)setVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    int volume = [arguments[@"volume"] intValue];
    ByteRTCAudioMixingType type = [arguments[@"type"] integerValue];
    int res = [self.player setVolume:volume type:type];
    result(@(res));
}

- (void)getVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioMixingType type = [arguments[@"type"] integerValue];
    int res = [self.player getVolume:type];
    result(@(res));
}

- (void)getTotalDuration:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player getTotalDuration];
    result(@(res));
}

- (void)getPlaybackDuration:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player getPlaybackDuration];
    result(@(res));
}

- (void)getPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player getPosition];
    result(@(res));
}

- (void)setAudioPitch:(NSDictionary *)arguments result:(FlutterResult)result {
    int pitch = [arguments[@"pitch"] intValue];
    int res = [self.player setAudioPitch:pitch];
    result(@(res));
}

- (void)setPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int position = [arguments[@"position"] intValue];
    int res = [self.player setPosition:position];
    result(@(res));
}

- (void)setAudioDualMonoMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioMixingDualMonoMode mode = [arguments[@"mode"] integerValue];
    int res = [self.player setAudioDualMonoMode:mode];
    result(@(res));
}

- (void)getAudioTrackCount:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player getAudioTrackCount];
    result(@(res));
}

- (void)selectAudioTrack:(NSDictionary *)arguments result:(FlutterResult)result {
    int index = [arguments[@"index"] intValue];
    int res = [self.player selectAudioTrack:index];
    result(@(res));
}

- (void)setPlaybackSpeed:(NSDictionary *)arguments result:(FlutterResult)result {
    int speed = [arguments[@"speed"] intValue];
    int res = [self.player setPlaybackSpeed:speed];
    result(@(res));
}

- (void)setProgressInterval:(NSDictionary *)arguments result:(FlutterResult)result {
    int64_t interval = [arguments[@"interval"] longLongValue];
    int res = [self.player setProgressInterval:interval];
    result(@(res));
}

- (void)setLoudness:(NSDictionary *)arguments result:(FlutterResult)result {
    float loudness = [arguments[@"loudness"] floatValue];
    int res = [self.player setLoudness:loudness];
    result(@(res));
}

@end
