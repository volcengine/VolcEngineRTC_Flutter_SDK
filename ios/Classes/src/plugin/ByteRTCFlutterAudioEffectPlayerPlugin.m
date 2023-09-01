/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCAudioEffectPlayer.h>
#import "ByteRTCFlutterAudioEffectPlayerPlugin.h"
#import "ByteRTCFlutterAudioEffectPlayerEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterAudioEffectPlayerPlugin ()

@property (nonatomic, strong) ByteRTCAudioEffectPlayer *player;
@property (nonatomic, strong) ByteRTCFlutterAudioEffectPlayerEventHandler *eventHandler;

@end

@implementation ByteRTCFlutterAudioEffectPlayerPlugin

- (instancetype)initWithRTCAudioEffectPlayer:(ByteRTCAudioEffectPlayer *)player {
    self = [super init];
    if (self) {
        self.player = player;
        self.eventHandler = [[ByteRTCFlutterAudioEffectPlayerEventHandler alloc] init];
        [player setEventHandler:self.eventHandler];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_audio_effect_player"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    [self.eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_audio_effect_player_event"
                                    binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.eventHandler destroy];
}

#pragma mark - method
- (void)start:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    NSString *filePath = arguments[@"filePath"];
    ByteRTCAudioEffectPlayerConfig *config = [ByteRTCAudioEffectPlayerConfig bf_fromMap:arguments[@"config"]];
    int res = [self.player start:effectId filePath:filePath config:config];
    result(@(res));
}

- (void)stop:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player stop:effectId];
    result(@(res));
}

- (void)stopAll:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player stopAll];
    result(@(res));
}

- (void)preload:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    NSString *filePath = arguments[@"filePath"];
    int res = [self.player preload:effectId filePath:filePath];
    result(@(res));
}

- (void)unload:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player unload:effectId];
    result(@(res));
}

- (void)unloadAll:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player unloadAll];
    result(@(res));
}

- (void)pause:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player pause:effectId];
    result(@(res));
}

- (void)pauseAll:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player pauseAll];
    result(@(res));
}

- (void)resume:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player resume:effectId];
    result(@(res));
}

- (void)resumeAll:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.player resumeAll];
    result(@(res));
}

- (void)setPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int position = [arguments[@"position"] intValue];
    int res = [self.player setPosition:effectId position:position];
    result(@(res));
}

- (void)getPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player getPosition:effectId];
    result(@(res));
}

- (void)setVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int volume = [arguments[@"volume"] intValue];
    int res = [self.player setVolume:effectId volume:volume];
    result(@(res));
}

- (void)setVolumeAll:(NSDictionary *)arguments result:(FlutterResult)result {
    int volume = [arguments[@"volume"] intValue];
    int res = [self.player setVolumeAll:volume];
    result(@(res));
}

- (void)getVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player getVolume:effectId];
    result(@(res));
}

- (void)getDuration:(NSDictionary *)arguments result:(FlutterResult)result {
    int effectId = [arguments[@"effectId"] intValue];
    int res = [self.player getDuration:effectId];
    result(@(res));
}
@end
