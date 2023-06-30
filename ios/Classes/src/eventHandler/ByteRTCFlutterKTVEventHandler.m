/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterKTVEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@implementation ByteRTCFlutterKTVEventHandler

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onMusicListResult:(ByteRTCKTVError)errorCode
         totalSize:(int)totalSize musics:(NSArray<ByteRTCKTVMusic *> * _Nullable)musics {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    dict[@"totalSize"] = @(totalSize);
    if (musics != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [musics enumerateObjectsUsingBlock:^(ByteRTCKTVMusic *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvMusicToMap:obj]];
        }];
        dict[@"musics"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onMusicListResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onSearchMusicResult:(ByteRTCKTVError)errorCode
         totalSize:(int)totalSize musics:(NSArray<ByteRTCKTVMusic *> * _Nullable)musics {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    dict[@"totalSize"] = @(totalSize);
    if (musics != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [musics enumerateObjectsUsingBlock:^(ByteRTCKTVMusic *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvMusicToMap:obj]];
        }];
        dict[@"musics"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onSearchMusicResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onHotMusicResult:(ByteRTCKTVError)errorCode
     hotMusicInfos:(NSArray<ByteRTCKTVHotMusicInfo *> * _Nullable)hotMusicInfos {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    if (hotMusicInfos != nil) {
        NSMutableArray *musicArray = [NSMutableArray array];
        [hotMusicInfos enumerateObjectsUsingBlock:^(ByteRTCKTVHotMusicInfo *obj, NSUInteger idx, BOOL *stop) {
            [musicArray addObject:[ByteRTCFlutterEventfactory ktvHotMusicInfoToMap:obj]];
        }];
        dict[@"hotMusics"] = musicArray;
    }
    [self emitEvent:dict methodName:@"onHotMusicResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onMusicDetailResult:(ByteRTCKTVError)errorCode music:(ByteRTCKTVMusic * _Nullable)music {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    if (music != nil) {
        dict[@"music"] = [ByteRTCFlutterEventfactory ktvMusicToMap:music];
    }
    [self emitEvent:dict methodName:@"onMusicDetailResult"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadSuccess:(int)downloadId downloadResult:(ByteRTCKTVDownloadResult *)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"result"] = [ByteRTCFlutterEventfactory ktvDownloadResultToMap:result];
    [self emitEvent:dict methodName:@"onDownloadSuccess"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadFail:(int)downloadId errorCode:(ByteRTCKTVError)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onDownloadFail"];
}

- (void)ktvManager:(ByteRTCKTVManager *)ktvManager onDownloadMusicProgress:(int)downloadId progress:(int)downloadPercentage {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"downloadId"] = @(downloadId);
    dict[@"downloadProgress"] = @(downloadPercentage);
    [self emitEvent:dict methodName:@"onDownloadMusicProgress"];
}

@end
