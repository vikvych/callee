//
//  CallManager.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <CallKit/CallKit.h>

#import "CallManager.h"
#import "CallManager+ProviderDelegate.h"
#import "CallManager+CallProcessorDelegate.h"

#define LOCALIZED_NAME NSLocalizedString(@"Callee", @"Application name")

@interface CallManager ()

@property (nonatomic, strong) NSArray<id<CallProtocol>> *calls;
@property (nonatomic, strong) CXCallController *callController;
@property (nonatomic, strong) CXProvider *provider;

@end

@implementation CallManager

@synthesize callProcessor = _callProcessor;

- (instancetype)initWithCallProcessor:(id<CallProcessor>)callProcessor
{
    self = [super init];
    
    if (self)
    {
        _calls = @[];
        _callProcessor = callProcessor;
        _callProcessor.delegate = self;
        _callController = [[CXCallController alloc] initWithQueue:dispatch_get_main_queue()];
        _provider = [[CXProvider alloc] initWithConfiguration:[self providerConfiguration]];
        
        [_provider setDelegate:self queue:nil];
    }
    
    return self;
}

- (void)reportIncommingCall:(id<CallProtocol>)call completion:(CallHandler)handler
{
    CXCallUpdate *update = [CXCallUpdate new];
    
    update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:call.handle];
    update.hasVideo = call.hasVideo;
    
    if ([call respondsToSelector:@selector(localizedCallerName)])
    {
        update.localizedCallerName = call.localizedCallerName;
    }
    
    [self.provider reportNewIncomingCallWithUUID:call.UUID update:update completion:^(NSError * _Nullable error) {
        if (nil == error) self.calls = [self.calls arrayByAddingObject:call];
        if (handler) handler(error);
    }];
}

- (void)startCall:(id<CallProtocol>)call completion:(CallHandler)handler
{
    self.calls = [self.calls arrayByAddingObject:call];
    
    CXHandle *handle = [[CXHandle alloc] initWithType:CXHandleTypePhoneNumber value:call.handle];
    CXStartCallAction *action = [[CXStartCallAction alloc] initWithCallUUID:call.UUID handle:handle];
    
    action.video = call.hasVideo;
    
    [self requestTransactionAction:action completion:handler];
}

- (void)endCall:(id<CallProtocol>)call completion:(CallHandler)handler
{
    CXEndCallAction *action = [[CXEndCallAction alloc] initWithCallUUID:call.UUID];
    
    [self requestTransactionAction:action completion:handler];
}

- (void)setCall:(id<CallProtocol>)call held:(BOOL)onHold completion:(CallHandler)handler
{
    CXSetHeldCallAction *action = [[CXSetHeldCallAction alloc] initWithCallUUID:call.UUID onHold:onHold];
    
    [self requestTransactionAction:action completion:handler];
}

- (void)setCall:(id<CallProtocol>)call muted:(BOOL)muted completion:(CallHandler)handler
{
    CXSetMutedCallAction *action = [[CXSetMutedCallAction alloc] initWithCallUUID:call.UUID muted:muted];
    
    [self requestTransactionAction:action completion:handler];
}

- (void)requestTransactionAction:(CXCallAction *)action completion:(CallHandler)handler
{
    CXTransaction *transaction = [[CXTransaction alloc] initWithAction:action];

    [self.callController requestTransaction:transaction completion:handler];
}

#pragma mark - Utils

- (id<CallProtocol>)callWithUUID:(NSUUID *)UUID
{
    for (id<CallProtocol> call in self.calls)
    {
        if ([call.UUID isEqual:UUID]) return call;
    }
    
    return nil;
}

- (void)removeCall:(id<CallProtocol>)call
{
    self.calls = [self.calls filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", call]];
}

- (void)resetCalls
{
    self.calls = @[];
}

- (CXProviderConfiguration *)providerConfiguration
{
    CXProviderConfiguration *configuration = [[CXProviderConfiguration alloc] initWithLocalizedName:LOCALIZED_NAME];
    
    configuration.supportsVideo = NO;
    configuration.maximumCallsPerCallGroup = 1;
    configuration.supportedHandleTypes = [NSSet setWithObject:@(CXHandleTypePhoneNumber)];
    configuration.ringtoneSound = @"incoming_call.wav";
    
    return configuration;
}

@end
