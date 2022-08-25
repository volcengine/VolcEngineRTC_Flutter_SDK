/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterChannels.h>

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterMethodHandler : NSObject

- (void)registerMethodChannelWithName:(NSString*)name
                         methodTarget:(id)methodTarget
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

- (void)destroy;

@end

@interface ByteRTCFlutterEventHandler : NSObject <FlutterStreamHandler>

- (void)registerEventChannelWithName:(NSString*)name
                     binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (void)emitEvent:(id _Nullable)event methodName:(NSString *)methodName;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
