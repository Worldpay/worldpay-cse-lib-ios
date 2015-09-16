//
//  WPCryptoUtils.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 14/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

@import Security;

#import <openssl/err.h>

#import "WPCryptoUtils.h"
#import "NSError+WP.h"
#import "WPConstants.h"

extern NSString* const kWPOpenSSLErrorTitle;

@implementation WPCryptoUtils

+ (NSString *)getOpenSSLError {
    char buffer[120];
    unsigned long errorCode = 0;
    
    NSString *error = kWPOpenSSLErrorTitle;
    ERR_load_crypto_strings();
    while ((errorCode = ERR_get_error())) {
        ERR_error_string(errorCode, buffer);
        error = [error stringByAppendingFormat:@"%s. ", buffer];
    }
    
    return error;
}

+ (unsigned char*)allocBufferOfSize:(unsigned long)count
                              error:(NSError * __autoreleasing *)error {
    size_t allocSize = sizeof(unsigned char) * count;
    unsigned char *buffer = (unsigned char*) malloc(allocSize);
    
    if (buffer) {
        memset(buffer, '\0', allocSize);
    } else {
        buffer = NULL;
        if (error) {
            *error = [NSError bufferAllocError];
        }
    }
    
    return buffer;
}

@end
