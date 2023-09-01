/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterKTVManagerEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@implementation ByteRTCFlutterKTVManagerEventHandler

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onMusicListResult:(NSArray<ByteRTCMusicInfo *> *)musics totalSize:(int)totalSize errorCode:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    dict[@"totalSize"] = @(totalSize);
    if (musics != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [musics enumerateObjectsUsingBlock:^(ByteRTCMusicInfo *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvMusicToMap:obj]];
        }];
        dict[@"musicInfos"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onMusicListResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onSearchMusicResult:(NSArray<ByteRTCMusicInfo *> *)musics totalSize:(int)totalSize errorCode:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    dict[@"totalSize"] = @(totalSize);
    if (musics != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [musics enumerateObjectsUsingBlock:^(ByteRTCMusicInfo *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvMusicToMap:obj]];
        }];
        dict[@"musicInfos"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onSearchMusicResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onHotMusicResult:(NSArray<ByteRTCHotMusicInfo *> *)hotMusicInfos errorCode:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    if (hotMusicInfos != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [hotMusicInfos enumerateObjectsUsingBlock:^(ByteRTCHotMusicInfo *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvHotMusicInfoToMap:obj]];
        }];
        dict[@"hotMusics"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onHotMusicResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onMusicDetailResult:(ByteRTCMusicInfo *)music errorCode:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    if (music != nil) {
        dict[@"musicInfo"] = [ByteRTCFlutterEventfactory ktvMusicToMap:music];
    }
    [self emitEvent:dict methodName:@"onMusicDetailResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadSuccess:(int)downloadId downloadResult:(ByteRTCDownloadResult *)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"result"] = [ByteRTCFlutterEventfactory ktvDownloadResultToMap:result];
    [self emitEvent:dict methodName:@"onDownloadSuccess"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadFailed:(int)downloadId errorCode:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onDownloadFailed"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadMusicProgress:(int)downloadId progress:(int)downloadPercentage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"downloadProgress"] = @(downloadPercentage);
    [self emitEvent:dict methodName:@"onDownloadMusicProgress"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onClearCacheResult:(ByteRTCKTVErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onClearCacheResult"];
}

@end
