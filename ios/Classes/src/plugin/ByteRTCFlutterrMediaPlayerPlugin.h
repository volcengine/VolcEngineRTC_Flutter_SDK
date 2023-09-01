/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCMediaPlayer;
@interface ByteRTCFlutterrMediaPlayerPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCMediaPlayer:(ByteRTCMediaPlayer *)player playerId:(int)playerId;

@end

NS_ASSUME_NONNULL_END
