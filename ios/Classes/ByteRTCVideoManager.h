/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCVideo;
@interface ByteRTCVideoManager : NSObject

/**
 * @type api
 * @region 引擎管理
 * @brief 获取ByteRTCVideo实例。
 * @notes  内部管理生命周期，请不要手动调用 destroyRTCVideo。
 */
+ (nullable ByteRTCVideo *)getVideo;

/**
 * @type api
 * @region 屏幕共享
 * @brief 设置 Extension 配置项。
 * @param groupId 你的应用和 Extension 应该归属于同一个 App Group，此处需要传入 Group Id。
 * @param bundleId 绑定 Extension 的 Bundle ID，绑定后应用中共享屏幕的选择列表中只展示你的 Extension 可供选择。
 * @notes 如果需要使用屏幕共享，请在创建引擎之前调用此方法。在引擎实例的生命周期中，此方法只需要调用一次。
 */
+ (void)setExtensionConfig:(NSString * _Nullable)groupId bundleId:(NSString * _Nullable)bundleId;

@end

NS_ASSUME_NONNULL_END
