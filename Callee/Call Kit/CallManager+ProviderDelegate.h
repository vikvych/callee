//
//  CallManager+ProviderDelegate.h
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <CallKit/CallKit.h>

#import "CallManager.h"

@interface CallManager (ProviderDelegate) <CXProviderDelegate>

@end
