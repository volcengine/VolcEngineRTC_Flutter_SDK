/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCMediaPlayerEventHandler;
@interface ByteRTCFlutterMediaPlayerEventHandler : ByteRTCFlutterEventHandler <ByteRTCMediaPlayerEventHandler>

@end

NS_ASSUME_NONNULL_END
