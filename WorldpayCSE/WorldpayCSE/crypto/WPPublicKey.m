//
//  WPPublicKey.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPPublicKey.h"
#import "WPConstants.h"
#import "NSError+WP.h"

//separator for the rsa public key components, default is #
extern NSString* const kWPPublicKeyComponentsSeparator;

@implementation WPPublicKey

- (BOOL)validateComponents {
    return (self.sequenceId.length > 0) &&
            (self.exponent.length > 0) &&
            (self.modulus.length > 0);
}

+ (id)parseKey:(NSString*)publicKey
         error:(NSError * __autoreleasing *)error {
    BOOL isValid = NO;
    WPPublicKey *key = [WPPublicKey new];
    
    NSArray *publicKeyComponents =
    [publicKey componentsSeparatedByString:kWPPublicKeyComponentsSeparator];
    
    if (publicKeyComponents.count == 3) {

        key.sequenceId = publicKeyComponents[0];
        key.exponent = publicKeyComponents[1];
        key.modulus = publicKeyComponents[2];
        
        isValid = [key validateComponents];
    } else {
        isValid = NO;
    }
    
    if (!isValid) {
        key = nil;
        if (error) {
            *error = [NSError rsaInvalidKey];
        }
    }
    
    return key;
}

@end
