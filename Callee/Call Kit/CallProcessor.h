//
//  CallProcessor.h
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CallProtocol.h"

typedef void (^CallHandler)(NSError *error);

@protocol CallProcessorDelegate

- (void)call:(id<CallProtocol>)call failedWithError:(NSError *)error;
- (void)callTimeOut:(id<CallProtocol>)call;         // set call endDate before delegate method invokation
- (void)callRemoteEnded:(id<CallProtocol>)call;     // set call endDate before delegate method invokation
- (void)callConnecting:(id<CallProtocol>)call;      // set call connectingDate before delegate method invokation
- (void)callConnected:(id<CallProtocol>)call;       // set call connectedDate before delegate method invokation

@end

@protocol CallProcessor <NSObject>

@property (nonatomic, weak) id<CallProcessorDelegate> delegate;

- (void)reset;                      // Stop all connection and end all active calls

/**
 *  Audio methods
 */
- (void)configureAudioSession;      // Configure audio session for call
- (void)startAudio;                 // Turn audio on
- (void)stopAudio;                  // Turn audio off
- (void)setMuted:(BOOL)muted;       // Mute/unmute mic
- (void)setHeld:(BOOL)onHold;       // Pause/unpause call

/**
 *  Lifecycle methods
 */
- (void)startCall:(id<CallProtocol>)call            // start call, set call startDate
       completion:(CallHandler)handler;             // call opened connection handler

- (void)answerCall:(id<CallProtocol>)call           // answer call, set call startDate
        completion:(CallHandler)handler;            // call connected handler

- (void)endCall:(id<CallProtocol>)call;             // end call, set call endDate

@end
