/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCKTVManager.h>
#import "ByteRTCFlutterKTVManagerPlugin.h"
#import "ByteRTCFlutterKTVPlayerPlugin.h"
#import "ByteRTCFlutterKTVEventHandler.h"

@interface ByteRTCFlutterKTVManagerPlugin ()

@property (nonatomic, strong) ByteRTCKTVManager *ktvManager;
@property (nonatomic, strong) ByteRTCFlutterKTVEventHandler *eventHandler;
@property (nonatomic, strong, nullable) ByteRTCFlutterKTVPlayerPlugin *ktvPlayer;

@end

@implementation ByteRTCFlutterKTVManagerPlugin

- (instancetype)initWithRTCKTVManager:(ByteRTCKTVManager *)ktvManager {
    self = [super init];
    if (self) {
        self.ktvManager = ktvManager;
        self.eventHandler = [[ByteRTCFlutterKTVEventHandler alloc] init];
        ktvManager.delegate = self.eventHandler;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_ktv_manager"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    [self.eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_ktv_manager_event"
                                    binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.eventHandler destroy];
    [self.ktvPlayer destroy];
}

#pragma mark - method
- (void)getMusicList:(NSDictionary *)arguments result:(FlutterResult)result {
    int pageNum = [arguments[@"pageNum"] intValue];
    int pageSize = [arguments[@"pageSize"] intValue];
    NSArray<NSNumber *> *filterList = arguments[@"filters"];
    __block ByteRTCKTVMusicFilterType filters = ByteRTCKTVMusicFilterTypeNone;
    [filterList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        filters = filters | [obj unsignedIntegerValue];
    }];
    [self.ktvManager getMusicList:pageNum pageSize:pageSize filterType:filters];
    result(nil);
}

- (void)searchMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *keyWord = arguments[@"keyWord"];
    int pageNum = [arguments[@"pageNum"] intValue];
    int pageSize = [arguments[@"pageSize"] intValue];
    NSArray<NSNumber *> *filterList = arguments[@"filters"];
    __block ByteRTCKTVMusicFilterType filters = ByteRTCKTVMusicFilterTypeNone;
    [filterList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        filters = filters | [obj unsignedIntegerValue];
    }];
    [self.ktvManager searchMusic:keyWord pageNumber:pageNum pageSize:pageSize filterType:filters];
    result(nil);
}

- (void)getHotMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray<NSNumber *> *hotTypeList = arguments[@"hotTypes"];
    __block ByteRTCKTVMusicHotType hotTypes = 0;
    [hotTypeList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        hotTypes = hotTypes | [obj unsignedIntegerValue];
    }];
    NSArray<NSNumber *> *filterList = arguments[@"filters"];
    __block ByteRTCKTVMusicFilterType filters = ByteRTCKTVMusicFilterTypeNone;
    [filterList enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        filters = filters | [obj unsignedIntegerValue];
    }];
    [self.ktvManager getHotMusic:hotTypes filterType:filters];
    result(nil);
}

- (void)getMusicDetail:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    [self.ktvManager getMusicDetail:musicId];
    result(nil);
}

- (void)downloadMusic:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    int downloadId = [self.ktvManager downloadMusic:musicId];
    result(@(downloadId));
}

- (void)downloadLyric:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    ByteRTCKTVDownloadLyricType lyricType = [arguments[@"lyricType"] integerValue];
    int downloadId = [self.ktvManager downloadLyric:musicId lyricType:lyricType];
    result(@(downloadId));
}

- (void)downloadMidi:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *musicId = arguments[@"musicId"];
    int downloadId = [self.ktvManager downloadMidi:musicId];
    result(@(downloadId));
}

- (void)cancelDownload:(NSDictionary *)arguments result:(FlutterResult)result {
    int downloadId = [arguments[@"downloadId"] intValue];
    [self.ktvManager cancelDownload:downloadId];
    result(nil);
}

- (void)clearCache:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.ktvManager clearCache];
    result(nil);
}

- (void)setMaxCacheSize:(NSDictionary *)arguments result:(FlutterResult)result {
    int maxCacheSizeMB = [arguments[@"maxCacheSizeMB"] intValue];
    [self.ktvManager setMaxCacheSize:maxCacheSizeMB];
    result(nil);
}

- (void)getKTVPlayer:(NSDictionary *)arguments result:(FlutterResult)result {
    if (self.ktvPlayer != nil) {
        result(@(YES));
        return;
    }
    ByteRTCKTVPlayer *ktvPlayer = [self.ktvManager getKTVPlayer];
    BOOL res = !!ktvPlayer;
    if (res) {
        self.ktvPlayer = [[ByteRTCFlutterKTVPlayerPlugin alloc] initWithRTCKTVPlayer:ktvPlayer];
        [self.ktvPlayer registerWithRegistrar:self.registrar];
    }
    result(@(res));
}

@end
