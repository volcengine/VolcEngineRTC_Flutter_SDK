/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlatformViews.h>

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterSurfaceViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END
