/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlatformViews.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterVideoManager;
@interface ByteRTCFlutterSurfaceViewFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger
                    videoManager:(ByteRTCFlutterVideoManager *)videoManager;

@end

NS_ASSUME_NONNULL_END
