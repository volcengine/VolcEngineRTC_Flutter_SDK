/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCRoomDelegate;
@class ByteRTCRoom;
@interface ByteRTCFlutterRoomManager : NSObject

+ (instancetype)createWithRTCRoom:(ByteRTCRoom *)rtcRoom
                     roomDelegate:(id<ByteRTCRoomDelegate>)delegate;

- (ByteRTCRoom *)getRTCRoom;

- (void)destroyEngine;

@end

NS_ASSUME_NONNULL_END
