//
//  CallManager.h
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CallProcessor.h"

#define CALL_KIT_AVAILABLE  UIDevice.currentDevice.systemVersion.floatValue > 10.0

@protocol CallManagerDelegate;

@interface CallManager : NSObject

@property (nonatomic, readonly) id<CallProcessor> callProcessor;
@property (nonatomic, weak) id<CallManagerDelegate> delegate;

- (instancetype)initWithCallProcessor:(id<CallProcessor>)callProcessor;

- (void)reportIncommingCall:(id<CallProtocol>)call completion:(CallHandler)handler;
- (void)startCall:(id<CallProtocol>)call completion:(CallHandler)handler;
- (void)endCall:(id<CallProtocol>)call completion:(CallHandler)handler;
- (void)setCall:(id<CallProtocol>)call held:(BOOL)onHold completion:(CallHandler)handler;
- (void)setCall:(id<CallProtocol>)call muted:(BOOL)muted completion:(CallHandler)handler;

@end

@protocol CallManagerDelegate <NSObject>

- (void)callManager:(CallManager *)callManager сall:(id<CallProtocol>)call failedWithError:(NSError *)error;
- (void)callManager:(CallManager *)callManager callRemoteEnded:(id<CallProtocol>)call;
- (void)callManager:(CallManager *)callManager callTimeOut:(id<CallProtocol>)call;
- (void)callManager:(CallManager *)callManager connectingCall:(id<CallProtocol>)call;
- (void)callManager:(CallManager *)callManager connectedCall:(id<CallProtocol>)call;

// Called if iOS < 10.0 delegate should show incomming call view
- (void)callManager:(CallManager *)callManager reportIncommingCall:(id<CallProtocol>)call withAnswerHandler:(void (^)(BOOL answer))handler;


@end
