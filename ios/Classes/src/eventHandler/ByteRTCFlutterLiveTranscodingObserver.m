/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCVideoDefines.h>
#import "ByteRTCFlutterLiveTranscodingObserver.h"

@implementation ByteRTCFlutterLiveTranscodingObserver

#pragma mark - LiveTranscodingDelegate

- (BOOL)isSupportClientPushStream {
    return NO;
}

- (void)onStreamMixingEvent:(ByteRTCStreamMixingEvent)event
                     taskId:(NSString *)taskId
                      error:(ByteRtcTranscoderErrorCode)errorCode
                    mixType:(ByteRTCStreamMixingType)mixType {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"eventType"] = @(event);
    dict[@"taskId"] = taskId;
    dict[@"error"] = @(errorCode);
    dict[@"mixType"] = @(mixType);
    [self emitEvent:dict methodName:@"onStreamMixingEvent"];
}

@end
