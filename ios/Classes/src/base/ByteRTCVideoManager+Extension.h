/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCVideoManager.h"
#import <VolcEngineRTC/objc/ByteRTCVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCVideoManager ()

@property (nonatomic, strong, nullable) ByteRTCVideo *rtcVideo;
@property (nonatomic, copy, nullable) NSString *bundleId;
@property (nonatomic, copy, nullable) NSString *groupId;

@property (nonatomic, weak, nullable) ByteRTCView *echoTestView;

+ (instancetype)shared;

- (BOOL)createRTCVideo:(NSDictionary *)arguments delegate:(id<ByteRTCVideoDelegate> _Nullable)delegate;

- (void)destroyRTCVideo;

@end

NS_ASSUME_NONNULL_END
