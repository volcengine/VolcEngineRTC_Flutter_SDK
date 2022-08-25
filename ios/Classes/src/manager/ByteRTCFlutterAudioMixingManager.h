/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterVideoManager;
@interface ByteRTCFlutterAudioMixingManager : NSObject

- (instancetype)initWithVideoManager:(ByteRTCFlutterVideoManager *)videoManager;

@end

NS_ASSUME_NONNULL_END
