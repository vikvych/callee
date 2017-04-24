//
//  DummyCall.m
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import "DummyCall.h"

@implementation DummyCall

@synthesize UUID = _UUID;
@synthesize handle = _handle;

@synthesize hasVideo = _hasVideo;
@synthesize onHold = _onHold;
@synthesize muted = _muted;

@synthesize startDate = _startDate;
@synthesize connectingDate = _connectingDate;
@synthesize connectedDate = _connectedDate;
@synthesize endDate = _endDate;

- (instancetype)initWithHandle:(NSString *)handle
{
    self = [super init];
    
    if (self)
    {
        _UUID = [NSUUID UUID];
        _handle = handle;
    }
    
    return self;
}

@end
