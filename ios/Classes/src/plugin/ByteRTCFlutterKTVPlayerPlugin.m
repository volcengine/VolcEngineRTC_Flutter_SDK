/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCKTVPlayer.h>
#import "ByteRTCFlutterKTVPlayerPlugin.h"
#import "ByteRTCFlutterKTVPlayerEventHandler.h"

@interface ByteRTCFlutterKTVPlayerPlugin ()

@property (nonatomic, strong) ByteRTCKTVPlayer *ktvPlayer;
@property (nonatomic, strong) ByteRTCFlutterKTVPlayerEventHandler *eventHandler;

@end

@implementation ByteRTCFlutterKTVPlayerPlugin

- (instancetype)initWithRTCKTVPlayer:(ByteRTCKTVPlayer *)ktvPlayer {
    self = [super init];
    if (self) {
        self.ktvPlayer = ktvPlayer;
        self.eventHandler = [[ByteRTCFlutterKTVPlayerEventHandler alloc] init];
        ktvPlayer.delegate = self.eventHandler;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_ktv_player"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    [self.eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_ktv_player_event"
                                    binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.eventHandler destroy];
}

#pragma mark - method
- (void)playMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    ByteRTCKTVAudioTrackType trackType = [arguments[@"trackType"] integerValue];
    ByteRTCKTVAudioPlayType playType = [arguments[@"playType"] integerValue];
    [self.ktvPlayer playMusic:musicId audioTrackType:trackType audioPlayType:playType];
    result(nil);
}

- (void)pauseMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    [self.ktvPlayer pauseMusic:musicId];
    result(nil);
}

- (void)resumeMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    [self.ktvPlayer resumeMusic:musicId];
    result(nil);
}

- (void)stopMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    [self.ktvPlayer stopMusic:musicId];
    result(nil);
}

- (void)seekMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    int position = [arguments[@"position"] intValue];
    [self.ktvPlayer seekMusic:musicId position:position];
    result(nil);
}

- (void)setMusicVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    int volume = [arguments[@"volume"] intValue];
    [self.ktvPlayer setMusicVolume:musicId volume:volume];
    result(nil);
}

- (void)switchAudioTrackType:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    [self.ktvPlayer switchAudioTrackType:musicId];
    result(nil);
}

- (void)setMusicPitch:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    int pitch = [arguments[@"pitch"] intValue];
    [self.ktvPlayer setMusicPitch:musicId pitch:pitch];
    result(nil);
}

@end
