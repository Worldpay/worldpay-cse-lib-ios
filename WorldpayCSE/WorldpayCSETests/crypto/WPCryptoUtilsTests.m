//
//  CryptoTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <openssl/rsa.h>
#import <openssl/err.h>
#import <openssl/pem.h>
#import <openssl/bio.h>

#import "WPCryptoUtils.h"
#import "WPConstants.h"
#import "WPErrorCodes.h"

extern NSString* const kWPOpenSSLErrorTitle;
extern NSString* const kWPErrorBufferAllocMessage;

@interface WPCryptoUtilsTests : XCTestCase

@end

@implementation WPCryptoUtilsTests

- (void)testGetOpenSSLErrorWhenNoErros {
    XCTAssert([[WPCryptoUtils getOpenSSLError] isEqualToString:kWPOpenSSLErrorTitle], @"The default OpenSSL error title should match");
}

- (void)testGetOpenSSLErrorWhenAreErros {
    PEM_read_bio_RSAPrivateKey(NULL, NULL, 0, NULL);
    XCTAssert(![[WPCryptoUtils getOpenSSLError] isEqualToString:kWPOpenSSLErrorTitle], @"The default OpenSSL error title should not match");
}

- (void)testBufferAllocSuccess {
    int bufferSize = 34;
    NSError *error = nil;
    unsigned char* buffer = [WPCryptoUtils allocBufferOfSize:bufferSize error:&error];
    
    for (int index = 0; index < bufferSize; index++) {
        XCTAssert(buffer[index] == '\0', @"All data should be zero");
    }

    XCTAssert(buffer != NULL, @"Buffer should not be nil");
    XCTAssert(error == nil, @"Error should be nil");
}

- (void)testBufferAllocFailure {
    unsigned long bufferSize = ULONG_MAX;
    NSError *error = nil;
    unsigned char* buffer = [WPCryptoUtils allocBufferOfSize:bufferSize error:&error];
        
    XCTAssert(buffer == NULL, @"Buffer should be NULL");
    XCTAssert(error != nil, @"Error should be nil");
    XCTAssert([error code] == WPErrorBufferAlloc, @"Error code should be WPErrorBufferAlloc");
    XCTAssert([error.userInfo[kWPErrorDetailsKey] isEqualToString:kWPErrorBufferAllocMessage], @"Error message should be kWPErrorBufferAllocMessage");
}



@end
