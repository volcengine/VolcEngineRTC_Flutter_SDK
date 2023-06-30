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

- (BOOL)createRTCVideo:(NSDictionary *)arguments delegate:(id<ByteRTCVideoDelegate> _Nullable)delegate {
    NSString *appId = arguments[@"appId"];
    NSDictionary *origParameters = arguments[@"parameters"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (origParameters.count != 0) {
        [parameters addEntriesFromDictionary:origParameters];
    }
    parameters[@"rtc.platform"] = @6;
    
    self.rtcVideo = [ByteRTCVideo createRTCVideo:appId
                                        delegate:delegate
                                      parameters:parameters];
    [self.rtcVideo setExtensionConfig:[ByteRTCVideoManager shared].groupId];
    return self.rtcVideo != nil;
}

- (void)destroyRTCVideo {
    [ByteRTCVideo destroyRTCVideo];
    self.rtcVideo = nil;
}

@end
