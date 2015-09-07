//
//  NSErrorWPTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSError+WP.h"
#import "WPConstants.h"

@interface NSErrorWPTests : XCTestCase

@end

@implementation NSErrorWPTests

- (void)testWPNSErrorCreated {
    NSString *info = @"Hello world";
    NSError *error = [NSError createWPErrorWithInfo:info andErrorCode:WPErrorRSAEncrypt];
    NSString *errorInfo = error.userInfo[kWPErrorDetailsKey];
    
    XCTAssert([error code] == WPErrorRSAEncrypt, @"Error code should be WPErrorRSAEncrypt");
    XCTAssert([errorInfo isEqualToString:info], @"Error userInfo should be as set");
    XCTAssert([[error domain] isEqualToString:kWPErrorDomain], @"Error domain should be the same");
}

- (void)testWPNSErrorCreatedNoInfo {
    NSString *info = @"";
    NSError *error = [NSError createWPErrorWithInfo:info andErrorCode:WPErrorRSAEncrypt];
    NSString *errorInfo = error.userInfo[kWPErrorDetailsKey];
    
    XCTAssert([error code] == WPErrorRSAEncrypt, @"Error code should be WPErrorRSAEncrypt");
    XCTAssert([errorInfo isEqualToString:info], @"Error userInfo should be as set");
    XCTAssert([[error domain] isEqualToString:kWPErrorDomain], @"Error domain should be the same");
}

- (void)testWPNSErrorCreatedNilInfo {
    NSError *error = [NSError createWPErrorWithInfo:nil andErrorCode:WPErrorRSAEncrypt];
    NSString *errorInfo = error.userInfo[kWPErrorDetailsKey];
    
    XCTAssert([error code] == WPErrorRSAEncrypt, @"Error code should be WPErrorRSAEncrypt");
    XCTAssert([errorInfo isEqualToString:@""], @"Error userInfo should be as set");
    XCTAssert([[error domain] isEqualToString:kWPErrorDomain], @"Error domain should be the same");
}


- (void)testRSAEncryptError {
    NSError *error = [NSError rsaEncryptError];
    XCTAssert([error code] == WPErrorRSAEncrypt, @"Error code should be as expected");
}

- (void)testRSAInvalidPublicKey {
    NSError *error = [NSError rsaInvalidKey];
    XCTAssert([error code] == WPErrorRSAInvalidPublicKey, @"Error code should be as expected");
}

- (void)testAESEncryptError {
    NSError *error = [NSError aesEncryptError];
    XCTAssert([error code] == WPErrorAESEncrypt, @"Error code should be as expected");
}

- (void)testAESCTXAllocError {
    NSError *error = [NSError aesContextAllocError];
    XCTAssert([error code] == WPErrorAESCTXAlloc, @"Error code should be as expected");
}

- (void)testBufferAllocError {
    NSError *error = [NSError bufferAllocError];
    XCTAssert([error code] == WPErrorBufferAlloc, @"Error code should be as expected");
}

- (void)testRandKeyGenError {
    NSError *error = [NSError randomKeyGenError];
    XCTAssert([error code] == WPErrorRandKeyGenError, @"Error code should be as expected");
}

- (void)testInvalidCardData {
    NSSet *errorSet = [NSSet setWithArray:@[@12, @13]];
    NSError *error = [NSError invalidCardDataErrorWithSet:errorSet];
    NSSet *errorInfo = [NSSet setWithArray:error.userInfo[kWPErrorDetailsKey]];

    XCTAssert([error code] == WPErrorInvalidCardData, @"Error code should be as expected");
    XCTAssert([errorInfo isEqualToSet:errorSet], @"Resulting sets should be equal");
}



@end
