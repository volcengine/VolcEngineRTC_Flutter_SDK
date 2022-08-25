/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FlutterPluginRegistrar;

@protocol ByteRTCFlutterPlugin <NSObject>

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
