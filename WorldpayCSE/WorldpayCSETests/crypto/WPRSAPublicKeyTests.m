//
//  WPRSAPublicKeyTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WPPublicKey.h"
#import "WPErrorCodes.h"
#import "WPConstants.h"

extern NSString* const kWPErrorDomain;
extern NSString* const kWPErrorDetailsKey;

extern NSString* const kWPErrorRSAInvalidPublicKeyMessage;

@interface WPRSAPublicKeyTests : XCTestCase

@end

@implementation WPRSAPublicKeyTests

- (void)testPublicKeyWithCorrectFormat {
    NSError *error = nil;
    WPPublicKey *publicKey = [WPPublicKey parseKey:@"1#23#45" error:&error];
    
    XCTAssert(error == nil, @"Error should  be nil");
    XCTAssert(publicKey != nil, @"Key should not be nil");
    XCTAssert([publicKey.sequenceId isEqualToString:@"1"], @"Key sequence id should be 1");
    XCTAssert([publicKey.modulus isEqualToString:@"45"], @"Key modulus should be 45");
    XCTAssert([publicKey.exponent isEqualToString:@"23"], @"Key exponent should be 23");
}

- (void)verifyPublicKeyWithInvalidFormat:(NSString *)format {
    NSError *error = nil;
    WPPublicKey *publicKey = [WPPublicKey parseKey:format error:&error];
    
    XCTAssert(error != nil, @"Error should not be nil");
    XCTAssert(publicKey == nil, @"Key should be nil");
    XCTAssert([error code] == WPErrorRSAInvalidPublicKey, @"Error code should be WPErrorRSAInvalidPublicKey");
    XCTAssert([error.userInfo[kWPErrorDetailsKey] isEqualToString:kWPErrorRSAInvalidPublicKeyMessage], @"Error message should be kWPErrorRSAInvalidPublicKeyMessage");
}

- (void)testPublicKeyWithInvalidFormat1 {
    [self verifyPublicKeyWithInvalidFormat:@"23#234"];
}

- (void)testPublicKeyWithInvalidFormat2 {
    [self verifyPublicKeyWithInvalidFormat:@"#23#234"];
}

- (void)testPublicKeyWithInvalidFormat3 {
    [self verifyPublicKeyWithInvalidFormat:@"##"];
}

- (void)testPublicKeyWithInvalidFormat4 {
    [self verifyPublicKeyWithInvalidFormat:@"1##23423423434"];
}

- (void)testPublicKeyWithInvalidFormat5 {
    [self verifyPublicKeyWithInvalidFormat:@"1##"];
}

@end
