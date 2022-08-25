/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCASREngineEventHandler;
@interface ByteRTCFlutterASREventHandler : ByteRTCFlutterEventHandler <ByteRTCASREngineEventHandler>

@end

NS_ASSUME_NONNULL_END
