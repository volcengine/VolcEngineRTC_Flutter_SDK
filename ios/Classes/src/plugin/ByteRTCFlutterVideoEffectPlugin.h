/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"
#import "ByteRTCFlutterFaceDetectionHandler.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCVideo;
@interface ByteRTCFlutterVideoEffectPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo;

@end

NS_ASSUME_NONNULL_END
