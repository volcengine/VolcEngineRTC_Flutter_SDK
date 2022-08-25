/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCVideoManager+Extension.h"

@implementation ByteRTCVideoManager

+ (instancetype)shared {
    static ByteRTCVideoManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (ByteRTCVideo *)getVideo {
    return [[self shared] rtcVideo];
}

+ (void)setExtensionConfig:(NSString *)groupId bundleId:(NSString *)bundleId {
    ByteRTCVideoManager *shared = [self shared];
    shared.groupId = groupId;
    shared.bundleId = bundleId;
    if (shared.rtcVideo != nil) {
        [shared.rtcVideo setExtensionConfig:groupId];
    }
}

@end
