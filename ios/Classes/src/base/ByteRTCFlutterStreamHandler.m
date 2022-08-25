/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"
#import <objc/message.h>

static inline void dispatch_main_async_safe(dispatch_block_t block) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static NSString * const kMethodName = @"methodName";

@interface ByteRTCFlutterMethodHandler ()

@property (nonatomic, strong, nullable) FlutterMethodChannel *methodChannel;
@property (nonatomic, weak, nullable) id methodTarget;

@end

@implementation ByteRTCFlutterMethodHandler

- (void)registerMethodChannelWithName:(NSString*)name
                         methodTarget:(id)methodTarget
                      binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self.methodChannel != nil) {
        [self.methodChannel setMethodCallHandler:nil];
        self.methodChannel = nil;
    }
    self.methodTarget = methodTarget;
    self.methodChannel = [[FlutterMethodChannel alloc] initWithName:name
                                                    binaryMessenger:messenger
                                                              codec:[FlutterStandardMethodCodec sharedInstance]];
    __weak typeof(self) weak_self = self;
    [self.methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        typeof(weak_self) self = weak_self;
        [self handleMethodCall:call result:result];
    }];
}

- (void)destroy {
    [self.methodChannel setMethodCallHandler:nil];
    self.methodChannel = nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"[RTCFlutter] %@ MethodCall: %@", self.class, call.method);
    SEL selector = NSSelectorFromString([call.method stringByAppendingString:@":result:"]);
    if ([self.methodTarget respondsToSelector:selector]) {
        ((void(*)(id,SEL,id,FlutterResult))objc_msgSend)(self.methodTarget,selector,call.arguments,result);
        return;
    }
    NSLog(@"[RTCFlutter] %@ MethodNotImplemented: %@", self.class, call.method);
    result(FlutterMethodNotImplemented);
}

@end

@interface ByteRTCFlutterEventHandler ()

@property (nonatomic, strong, nullable) FlutterEventChannel *eventChannel;
@property (nonatomic, copy, nullable) FlutterEventSink eventSink;
@property (nonatomic, copy, nullable) NSString *eventChannelName;

@end

@implementation ByteRTCFlutterEventHandler

- (void)registerEventChannelWithName:(NSString*)name
                     binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self.eventChannel != nil) {
        [self.eventChannel setStreamHandler:nil];
        self.eventChannel = nil;
        self.eventSink = nil;
    }
    self.eventChannelName = name;
    self.eventChannel = [FlutterEventChannel eventChannelWithName:name
                                                  binaryMessenger:messenger];
    [self.eventChannel setStreamHandler:self];
}

- (void)emitEvent:(id _Nullable)event methodName:(nonnull NSString *)methodName {
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    message[kMethodName] = methodName;
    if ([event isKindOfClass:[NSDictionary class]]) {
        [message addEntriesFromDictionary:event];
    }
    dispatch_main_async_safe(^{
        if(self.eventSink) {
            self.eventSink(message);
            NSLog(@"[RTCFlutter] %@ Sink methodName: %@\n", self.class, methodName);
        } else {
            NSLog(@"[RTCFlutter] %@ Channel not listened: %@ methodName: %@", self.class, self.eventChannelName, methodName);
        }
    });
}

- (void)destroy {
    [self.eventChannel setStreamHandler:nil];
    self.eventChannel = nil;
    self.eventSink = nil;
}

#pragma mark - FlutterStreamHandler
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

@end
