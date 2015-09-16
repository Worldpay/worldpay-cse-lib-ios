//
//  WPKeyGen.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPKeyGen.h"
#import "WPCryptoUtils.h"
#import "WPErrorCodes.h"
#import "WPConstants.h"
#import "NSError+WP.h"

static int kSuccess = 0;

@implementation WPKeyGen

+ (int)IV_BIT_LENGTH {
    return 96;
}

+ (int)AUTH_TAG_BIT_LENGTH {
    return 128;
}

+ (int)KEY_BIT_LENGTH {
    return 256;
}

+ (NSData *)generateKey:(unsigned long)keySize
                  error:(NSError * __autoreleasing *)error {

    NSError *localError = nil;
    NSData *randomData = nil;
    unsigned long count = keySize / 8;
    unsigned char *buffer = [WPCryptoUtils allocBufferOfSize:count
                                                       error:&localError];
    
    if (!buffer) {
        if (error) {
            *error = localError;
        }
        return nil;
    }
    
    if (kSuccess == SecRandomCopyBytes(kSecRandomDefault, count, buffer)) {
        randomData = [NSData dataWithBytes:buffer length:count];
    } else {
        randomData = nil;
        
        if (error) {
            *error = [NSError randomKeyGenError];
        }
    }
    free(buffer);
    
    return randomData;
}


@end
