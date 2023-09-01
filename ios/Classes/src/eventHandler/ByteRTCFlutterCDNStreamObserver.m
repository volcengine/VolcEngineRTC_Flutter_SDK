/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterCDNStreamObserver.h"

@implementation ByteRTCFlutterPushSingleStreamToCDNObserver

#pragma mark - ByteRTCPushSingleStreamToCDNObserver

- (void)onStreamPushEvent:(ByteRTCSingleStreamPushEvent)event
                   taskId:(NSString *)taskId
                    error:(NSInteger)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"eventType"] = @(event);
    dict[@"taskId"] = taskId;
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onStreamPushEvent"];
}

@end

@implementation ByteRTCFlutterMixedStreamObserver

#pragma mark - LiveTranscodingDelegate

- (BOOL)isSupportClientPushStream {
    return NO;
}

- (void)onMixingEvent:(ByteRTCStreamMixingEvent)event
               taskId:(NSString *)taskId
                error:(ByteRTCStreamMixingErrorCode)errorCode
              mixType:(ByteRTCMixedStreamType)mixType {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"eventType"] = @(event);
    dict[@"taskId"] = taskId;
    dict[@"error"] = @(errorCode);
    dict[@"mixType"] = @(mixType);
    [self emitEvent:dict methodName:@"onMixingEvent"];
}

@end
