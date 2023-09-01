/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCAudioEffectPlayer.h>
#import "ByteRTCFlutterAudioEffectPlayerEventHandler.h"

@implementation ByteRTCFlutterAudioEffectPlayerEventHandler

- (void)onAudioEffectPlayerStateChanged:(int)effectId state:(ByteRTCPlayerState)state error:(ByteRTCPlayerError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"effectId"] = @(effectId);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onAudioEffectPlayerStateChanged"];
}

@end
