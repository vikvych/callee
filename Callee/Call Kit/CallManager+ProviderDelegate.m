//
//  CallManager+ProviderDelegate.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import "CallManager+ProviderDelegate.h"

@interface CallManager()

@property (nonatomic, readonly) CXProvider *provider;

- (id<CallProtocol>)callWithUUID:(NSUUID *)UUID;
- (void)removeCall:(id<CallProtocol>)call;
- (void)resetCalls;

@end

@implementation CallManager (ProviderDelegate)

- (void)providerDidReset:(CXProvider *)provider
{
    [self.callProcessor reset];
    [self resetCalls];
}

- (void)provider:(CXProvider *)provider performStartCallAction:(CXStartCallAction *)action
{
    id<CallProtocol> call = [self callWithUUID:action.callUUID];
    
    if (nil != call)
    {        
        [self.callProcessor configureAudioSession];
        [self.callProcessor startCall:call completion:[self defaultHandlerWithAction:action]];
    }
    else
    {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action
{
    id<CallProtocol> call = [self callWithUUID:action.callUUID];
    
    if (nil != call)
    {
        [self.callProcessor configureAudioSession];
        [self.callProcessor answerCall:call completion:[self defaultHandlerWithAction:action]];
    }
    else
    {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action
{
    id<CallProtocol> call = [self callWithUUID:action.callUUID];
    
    if (nil != call)
    {
        [self removeCall:call];
        [self.callProcessor stopAudio];
        [self.callProcessor endCall:call];
        [action fulfill];
    }
    else
    {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performSetHeldCallAction:(CXSetHeldCallAction *)action
{
    id<CallProtocol> call = [self callWithUUID:action.callUUID];

    if (nil != call)
    {
        call.onHold = action.isOnHold;
        
        [action fulfill];
    }
    else
    {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action
{
    id<CallProtocol> call = [self callWithUUID:action.callUUID];

    if (nil != call)
    {
        call.muted = action.isMuted;
        
        [self.callProcessor setMuted:action.isMuted];
        
        [action fulfill];
    }
    else
    {
        [action fail];
    }
}

- (void)provider:(CXProvider *)provider performSetGroupCallAction:(CXSetGroupCallAction *)action
{
    // TODO: Implement when needed
}

- (void)provider:(CXProvider *)provider performPlayDTMFCallAction:(CXPlayDTMFCallAction *)action
{
    // TODO: Implement when needed
}

- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action
{
    NSLog(@"Action timeout: %@", action);
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession
{
    [self.callProcessor startAudio];
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession
{
    [self.callProcessor stopAudio];
}

- (CallHandler)defaultHandlerWithAction:(CXCallAction *)action
{
    return ^(NSError *error) {
        if (nil == error)
            [action fulfill];
        else
            [action fail];
    };
}

@end
