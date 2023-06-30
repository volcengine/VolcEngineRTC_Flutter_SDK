/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCVideoSnapshotEventObserver.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCVideoSnapshotEventObserver ()
@property (nonatomic, strong) NSMutableDictionary *taskPaths;
@end

@implementation ByteRTCVideoSnapshotEventObserver

- (instancetype)init{
    self = [super init];
    if (self) {
        _taskPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addFilePath:(NSString*)filePath
              forId:(NSInteger)taskId{
    self.taskPaths[@(taskId)] = filePath;
}

- (void)onTakeLocalSnapshotResult:(NSInteger) taskId
                      streamIndex:(ByteRTCStreamIndex)streamIndex
                            image:(ByteRTCImage * _Nullable)image
                        errorCode:(NSInteger)errorCode {
    NSString *filePath = self.taskPaths[@(taskId)];
    if (filePath == nil) {
        return;
    }
    [self.taskPaths removeObjectForKey:@(taskId)];
    NSInteger error = [self writeImageToFile:image
                                    filePath:filePath
                                   errorCode:errorCode];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"taskId"] = @(taskId);
    dict[@"streamIndex"] = @(streamIndex);
    dict[@"filePath"] = filePath;
    dict[@"error"] = @(error);
    if (image != nil) {
        CGSize size = [image size];
        dict[@"width"] = @((NSInteger)size.width);
        dict[@"height"] = @((NSInteger)size.height);
    }
    [self emitEvent:dict methodName:@"onTakeLocalSnapshotResult"];
}

- (void)onTakeRemoteSnapshotResult:(NSInteger)taskId
                         streamKey:(ByteRTCRemoteStreamKey * _Nonnull)streamKey
                             image:(ByteRTCImage * _Nullable)image
                         errorCode:(NSInteger)errorCode {
    NSString *filePath = self.taskPaths[@(taskId)];
    if (filePath == nil) {
        return;
    }
    [self.taskPaths removeObjectForKey:@(taskId)];
    NSInteger error = [self writeImageToFile:image
                                    filePath:filePath
                                   errorCode:errorCode];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"taskId"] = @(taskId);
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"filePath"] = filePath;
    dict[@"error"] = @(error);
    if (image != nil) {
        CGSize size = [image size];
        dict[@"width"] = @((NSInteger)size.width);
        dict[@"height"] = @((NSInteger)size.height);
    }
    [self emitEvent:dict methodName:@"onTakeRemoteSnapshotResult"];
}

-(NSInteger)writeImageToFile:(ByteRTCImage * _Nullable)image
                    filePath:(NSString*)filePath
                   errorCode:(NSInteger)errorCode {
    if (image == nil){
        return errorCode;
    }

    NSData * data = UIImageJPEGRepresentation(image, 1);
    if (data == nil){
        return -103; // ERROR_IMAGE_FORMAT
    }
    NSError* err = nil;
    [data writeToFile:filePath options:NSDataWritingAtomic error:&err];
    if (err != nil) {
        return -102; // WRITE_FILE_FAILED
    }
    return errorCode;
}
@end
