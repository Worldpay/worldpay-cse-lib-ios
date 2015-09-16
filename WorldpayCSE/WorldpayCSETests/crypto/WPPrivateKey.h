//
//  WPPrivateKey.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

@interface WPPrivateKey : NSObject

@property (strong, nonatomic) NSData *data;

- (id)initWithString:(NSString*)privateKey;

@end
