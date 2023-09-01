/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCSingScoringManager;
@interface ByteRTCFlutterSingScoringPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCSingScoringManager:(ByteRTCSingScoringManager *)manager;

@end

NS_ASSUME_NONNULL_END
