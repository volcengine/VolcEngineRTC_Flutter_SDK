/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterPlugin : NSObject

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) ByteRTCFlutterMethodHandler *methodHandler;

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
