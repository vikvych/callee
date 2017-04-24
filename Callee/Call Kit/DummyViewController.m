//
//  DummyViewController.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import "DummyViewController.h"
#import "CallManager.h"
#import "DummyCallProcessor.h"
#import "DummyCall.h"

@interface DummyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onHoldSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mutedSwitch;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;

- (IBAction)reportIncomingCall:(id)sender;
- (IBAction)startOutgoingCall:(id)sender;
- (IBAction)endCall:(id)sender;
- (IBAction)onHoldSwitchValueChanged:(id)sender;
- (IBAction)mutedSwitchValueChanged:(id)sender;

@property (nonatomic, strong) CallManager *callManager;
@property (nonatomic, strong) id<CallProtocol> call;

@end

@implementation DummyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.callManager = [[CallManager alloc] initWithCallProcessor:[DummyCallProcessor new]];
    self.onHoldSwitch.on = NO;
    self.mutedSwitch.on = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.callManager endCall:self.call completion:^(NSError *error) {
        
    }];
}

#pragma mark - Actions

- (IBAction)reportIncomingCall:(id)sender
{
    self.call = [[DummyCall alloc] initWithHandle:@"+19001001010"];
    
    __weak DummyViewController *weakSelf = self;

    [self.callManager reportIncommingCall:self.call completion:^(NSError *error) {
        weakSelf.statusLabel.text = nil == error ? @"Incoming call" : @"Incoming call failed";
    }];
}

- (IBAction)startOutgoingCall:(id)sender
{
    self.call = [[DummyCall alloc] initWithHandle:@"+19001001010"];

    __weak DummyViewController *weakSelf = self;

    [self.callManager startCall:self.call completion:^(NSError *error) {
        weakSelf.statusLabel.text = nil == error ? @"Outgoing call" : @"Outgoing call failed";
    }];
}

- (IBAction)endCall:(id)sender
{
    __weak DummyViewController *weakSelf = self;

    [self.callManager endCall:self.call completion:^(NSError *error) {
        weakSelf.statusLabel.text = nil == error ? @"Call ended" : @"Failed to end call";
    }];
}

- (IBAction)onHoldSwitchValueChanged:(id)sender
{
    __weak DummyViewController *weakSelf = self;
    
    [self.callManager setCall:self.call held:[sender isOn] completion:^(NSError *error) {
        NSString *onHold = [sender isOn] ? @"Call on hold" : @"Call resumed";
        
        weakSelf.statusLabel.text = nil == error ? onHold : @"Failed to set call hold";
    }];
}

- (IBAction)mutedSwitchValueChanged:(id)sender
{
    __weak DummyViewController *weakSelf = self;

    [self.callManager setCall:self.call muted:[sender isOn] completion:^(NSError *error) {
        NSString *muted = [sender isOn] ? @"Call muted" : @"Call unmuted";
        
        weakSelf.statusLabel.text = nil == error ? muted : @"Failed to set call hold";
    }];
}

@end
