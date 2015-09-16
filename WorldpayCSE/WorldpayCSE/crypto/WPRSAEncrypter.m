//
//  WPRSAEncrypter.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPRSAEncrypter.h"
#import "RSA1_5.h"


@interface WPRSAEncrypter()
/// RSA public key
@property (strong, nonatomic) WPPublicKey *key;
@end


@implementation WPRSAEncrypter


- (id)initWithKey:(WPPublicKey *)key {
    self = [super init];
    self.key = key;
    
    return self;
}

- (NSData *)encrypt:(NSData *)data
              error:(NSError * __autoreleasing *)error {
    NSError *localError = nil;
    NSData *result = [RSA1_5 encrypt:data withPublicKey:self.key
                               error:&localError];
    
    if (localError && error) {
        *error = localError;
    }
    
    return result;
}

- (id)getKey {
    return self.key;
}

@end
