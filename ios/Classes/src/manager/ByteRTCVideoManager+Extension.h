/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCVideoManager.h"
#import <VolcEngineRTC/objc/ByteRTCVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCVideoManager ()

@property (nonatomic, weak, nullable) ByteRTCVideo *rtcVideo;
@property (nonatomic, copy, nullable) NSString *bundleId;
@property (nonatomic, copy, nullable) NSString *groupId;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
