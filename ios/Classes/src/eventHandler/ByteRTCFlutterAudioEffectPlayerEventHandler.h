/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCAudioEffectPlayerEventHandler;
@interface ByteRTCFlutterAudioEffectPlayerEventHandler : ByteRTCFlutterEventHandler <ByteRTCAudioEffectPlayerEventHandler>

@end

NS_ASSUME_NONNULL_END
