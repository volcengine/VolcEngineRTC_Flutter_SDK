/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterRangeAudioObserver.h"
#import "ByteRTCFlutterMapCategory.h"

@implementation ByteRTCFlutterRangeAudioObserver

#pragma mark - ByteRTCRangeAudioObserver

- (void)onRangeAudioInfo:(NSArray<ByteRTCRangeAudioInfo *> * _Nonnull)rangeAudioInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infoDics = [NSMutableArray array];
    for (ByteRTCRangeAudioInfo *info in rangeAudioInfo) {
        [infoDics addObject:info.bf_toMap];
    }
    dict[@"rangeAudioInfo"] = infoDics.copy;
    [self emitEvent:dict methodName:@"onRangeAudioInfo"];
}

@end
