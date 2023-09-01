/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCMediaPlayer.h>
#import "ByteRTCFlutterMediaPlayerEventHandler.h"

@implementation ByteRTCFlutterMediaPlayerEventHandler

- (void)onMediaPlayerPlayingProgress:(int)playerId progress:(int64_t)progress {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"playerId"] = @(playerId);
    dict[@"progress"] = @(progress);
    [self emitEvent:dict methodName:@"onMediaPlayerPlayingProgress"];
}

- (void)onMediaPlayerStateChanged:(int)playerId state:(ByteRTCPlayerState)state error:(ByteRTCPlayerError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"playerId"] = @(playerId);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onMediaPlayerStateChanged"];
}

@end
