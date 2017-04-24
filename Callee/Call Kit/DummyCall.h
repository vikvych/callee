//
//  DummyCall.h
//  Callee
//
//  Created by Ivan Tkachenko on 4/8/17.
//  Copyright © 2017 Youshido. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CallProtocol.h"

@interface DummyCall : NSObject <CallProtocol>

- (instancetype)initWithHandle:(NSString *)handle;

@end
