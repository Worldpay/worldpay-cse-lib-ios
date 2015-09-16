//
//  WPPrivateKey.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPPrivateKey.h"

@implementation WPPrivateKey

- (id)initWithString:(NSString*)privateKey {
    self = [super init];
    self.data = [privateKey dataUsingEncoding:NSUTF8StringEncoding];
    
    return self;
}

@end
