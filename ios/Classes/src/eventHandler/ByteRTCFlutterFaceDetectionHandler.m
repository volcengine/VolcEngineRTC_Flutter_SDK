/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterFaceDetectionHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@implementation ByteRTCFlutterFaceDetectionHandler

#pragma mark - ByteRTCFaceDetectionObserver

- (void)onFaceDetectionResult:(ByteRTCFaceDetectionResult *)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"result"] = result.bf_toMap;
    [self emitEvent:dict methodName:@"onFaceDetectResult"];
}

- (void)onExpressionDetectResult:(ByteRTCExpressionDetectResult *)result {
    
}

@end
