//
//  NSError+WP.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "NSError+WP.h"
#import "WPConstants.h"
#import "WPCryptoUtils.h"

extern NSString* const kWPErrorRSAInvalidPublicKeyMessage;
extern NSString* const kWPErrorBufferAllocMessage;
extern NSString* const kWPKeyGenErrorMessage;
extern NSString* const kWPInvalidJsonErrorMessage;
extern NSString* const kWPJWEStringParseErrorMessage;

@implementation NSError (WP)

+ (NSError *)createWPErrorWithInfo:(id)info
                      andErrorCode:(WPErrorCode)errorCode {
    id infoData = info;
    
    if (!info) {
        infoData = @"";
    }
    
    return [NSError errorWithDomain:kWPErrorDomain
                               code:errorCode
                           userInfo:@{kWPErrorDetailsKey : infoData}];
}

+ (NSError *)rsaEncryptError {
    return [NSError createWPErrorWithInfo:[WPCryptoUtils getOpenSSLError]
                             andErrorCode:WPErrorRSAEncrypt];
}

+ (NSError *)rsaInvalidKey {
    return [NSError createWPErrorWithInfo:kWPErrorRSAInvalidPublicKeyMessage
                             andErrorCode:WPErrorRSAInvalidPublicKey];
}

+ (NSError *)aesEncryptError {
    return [NSError createWPErrorWithInfo:[WPCryptoUtils getOpenSSLError]
                             andErrorCode:WPErrorAESEncrypt];
}

+ (NSError *)aesContextAllocError {
    return [NSError createWPErrorWithInfo:[WPCryptoUtils getOpenSSLError]
                             andErrorCode:WPErrorAESCTXAlloc];
}

+ (NSError *)bufferAllocError {
    return [NSError createWPErrorWithInfo:kWPErrorBufferAllocMessage
                             andErrorCode:WPErrorBufferAlloc];
}

+ (NSError *)randomKeyGenError {
    return [NSError createWPErrorWithInfo:kWPKeyGenErrorMessage
                             andErrorCode:WPErrorRandKeyGenError];
}

+ (NSError *)invalidCardDataErrorWithSet:(NSSet *)errors {
    return [NSError createWPErrorWithInfo:[errors allObjects]
                             andErrorCode:WPErrorInvalidCardData];
}
@end
