/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCKTVManager;
@interface ByteRTCFlutterKTVManagerPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCKTVManager:(ByteRTCKTVManager *)ktvManager;

@end

NS_ASSUME_NONNULL_END
