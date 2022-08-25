/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPushSingleStreamToCDNObserver.h"

@implementation ByteRTCFlutterPushSingleStreamToCDNObserver

#pragma mark - ByteRTCPushSingleStreamToCDNObserver

- (void)onStreamPushEvent:(ByteRTCSingleStreamPushEvent)event taskId:(NSString * _Nonnull)taskId error:(NSInteger)Code {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"eventType"] = @(event);
    dict[@"taskId"] = taskId;
    dict[@"error"] = @(Code);
    [self emitEvent:dict methodName:@"onStreamPushEvent"];
}

@end
