/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCKTVPlayer;
@interface ByteRTCFlutterKTVPlayerPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCKTVPlayer:(ByteRTCKTVPlayer *)ktvPlayer;

@end

NS_ASSUME_NONNULL_END
