/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LiveTranscodingDelegate;
@interface ByteRTCFlutterLiveTranscodingObserver : ByteRTCFlutterEventHandler <LiveTranscodingDelegate>

@end

NS_ASSUME_NONNULL_END
