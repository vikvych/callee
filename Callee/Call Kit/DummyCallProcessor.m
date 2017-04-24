//
//  DummyCallProcessor.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import "DummyCallProcessor.h"

@implementation DummyCallProcessor

@synthesize delegate = _delegate;

- (void)reset
{
    NSLog(@"Dummy %@", NSStringFromSelector(_cmd));
}

- (void)configureAudioSession
{
    NSLog(@"Dummy %@", NSStringFromSelector(_cmd));
}

- (void)startAudio
{
    NSLog(@"Dummy %@", NSStringFromSelector(_cmd));
}

- (void)stopAudio
{
    NSLog(@"Dummy %@", NSStringFromSelector(_cmd));
}

- (void)setMuted:(BOOL)muted
{
    NSLog(@"Dummy %@ %@", NSStringFromSelector(_cmd), muted ? @"YES" : @"NO");
}

- (void)setHeld:(BOOL)onHold
{
    NSLog(@"Dummy %@ %@", NSStringFromSelector(_cmd), onHold ? @"YES" : @"NO");
}

- (void)startCall:(id<CallProtocol>)call completion:(CallHandler)handler
{
    NSLog(@"Dummy %@ %@", NSStringFromSelector(_cmd), call);

    call.startDate = [NSDate date];
    
    if (handler) handler(nil);
    
    __weak DummyCallProcessor *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        call.connectingDate = [NSDate date];
        
        [weakSelf.delegate callConnecting:call];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            call.connectedDate = [NSDate date];
            
//            [weakSelf.delegate callConnected:call];
            [weakSelf.delegate callRemoteEnded:call];
        });
    });
}

- (void)answerCall:(id<CallProtocol>)call completion:(CallHandler)handler
{
    NSLog(@"Dummy %@ %@", NSStringFromSelector(_cmd), call);
    
    call.startDate = [NSDate date];
    
    if (handler) handler(nil);
}

- (void)endCall:(id<CallProtocol>)call
{
    call.endDate = [NSDate date];
    
    NSLog(@"Dummy %@ %@", NSStringFromSelector(_cmd), call);
}

@end
