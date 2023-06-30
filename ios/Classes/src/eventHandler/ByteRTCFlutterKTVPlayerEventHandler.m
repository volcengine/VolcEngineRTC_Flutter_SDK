/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterKTVPlayerEventHandler.h"

@implementation ByteRTCFlutterKTVPlayerEventHandler

- (void)ktvPlayer:(ByteRTCKTVPlayer *)ktvPlayer onPlayProgress:(NSString *)musicId progress:(int64_t)progress {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"musicId"] = musicId;
    dict[@"progress"] = @(progress);
    [self emitEvent:dict methodName:@"onPlayProgress"];
}

- (void)ktvPlayer:(ByteRTCKTVPlayer *)ktvPlayer onPlayStateChange:(NSString *)musicId
            state:(ByteRTCKTVPlayState)state error:(ByteRTCKTVPlayerError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"musicId"] = musicId;
    dict[@"playState"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onPlayStateChange"];
}

@end
