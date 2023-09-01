/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCAudioEffectPlayer;
@interface ByteRTCFlutterAudioEffectPlayerPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCAudioEffectPlayer:(ByteRTCAudioEffectPlayer *)player;

@end

NS_ASSUME_NONNULL_END
