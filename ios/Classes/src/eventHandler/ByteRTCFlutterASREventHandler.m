/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCAudioDefines.h>
#import "ByteRTCFlutterASREventHandler.h"

@implementation ByteRTCFlutterASREventHandler

#pragma mark - ByteRTCASREngineEventHandler

- (void)onSuccess {
    [self emitEvent:nil methodName:@"onSuccess"];
}

- (void)onMessage:(NSString *_Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"message"] = message;
    [self emitEvent:dict methodName:@"onMessage"];
}

- (void)onError:(NSInteger)errorCode withErrorMessage:(NSString *_Nonnull)errorMessage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"errorCode"] = @(errorCode);
    dict[@"errorMessage"] = errorMessage;
    [self emitEvent:dict methodName:@"onError"];
}

@end
