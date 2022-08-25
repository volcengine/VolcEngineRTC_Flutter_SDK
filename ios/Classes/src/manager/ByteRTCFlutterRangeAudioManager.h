/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCRangeAudioObserver;
@class ByteRTCFlutterRoomManager;

@interface ByteRTCFlutterRangeAudioManager : NSObject

@property (nonatomic, weak, nullable) id<ByteRTCRangeAudioObserver> observer;

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager;

@end

NS_ASSUME_NONNULL_END
