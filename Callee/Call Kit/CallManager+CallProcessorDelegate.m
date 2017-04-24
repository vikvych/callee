//
//  CallManager+CallProcessorDelegate.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/13/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <CallKit/CallKit.h>

#import "CallManager+CallProcessorDelegate.h"

@interface CallManager()

@property (nonatomic, readonly) CXProvider *provider;

@end

@implementation CallManager (CallProcessorDelegate)

- (void)call:(id<CallProtocol>)call failedWithError:(NSError *)error
{
    if (CALL_KIT_AVAILABLE)
    {
        [self.provider reportCallWithUUID:call.UUID endedAtDate:call.endDate reason:CXCallEndedReasonFailed];
    }
    
    [self.delegate callManager:self сall:call failedWithError:error];
}

- (void)callTimeOut:(id<CallProtocol>)call
{
    if (CALL_KIT_AVAILABLE)
    {
        [self.provider reportCallWithUUID:call.UUID endedAtDate:call.endDate reason:CXCallEndedReasonUnanswered];
    }
    
    [self.delegate callManager:self callTimeOut:call];
}

- (void)callRemoteEnded:(id<CallProtocol>)call
{
    if (CALL_KIT_AVAILABLE)
    {
        [self.provider reportCallWithUUID:call.UUID endedAtDate:call.endDate reason:CXCallEndedReasonRemoteEnded];
    }
    
    [self.delegate callManager:self callRemoteEnded:call];
}

- (void)callConnecting:(id<CallProtocol>)call
{
    if (CALL_KIT_AVAILABLE)
    {
        [self.provider reportOutgoingCallWithUUID:call.UUID startedConnectingAtDate:call.connectingDate];
    }
    
    [self.delegate callManager:self connectingCall:call];
}

- (void)callConnected:(id<CallProtocol>)call
{
    if (CALL_KIT_AVAILABLE)
    {
        [self.provider reportOutgoingCallWithUUID:call.UUID connectedAtDate:call.connectedDate];
    }
    
    [self.delegate callManager:self connectedCall:call];
}

@end
