//
//  NSDataBase64URLTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSData+Base64URL.h"

@interface NSDataBase64URLTests : XCTestCase

@end

@implementation NSDataBase64URLTests

- (void)testDataIsConverted1 {
    const unsigned char bytes[] = {0xee, 0xbc, 0x1f, 0x57, 0x48, 0x7f, 0x51, 0x92, 0x1c, 0x04, 0x65, 0x66};
    NSData *bytesData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    NSString *createdBase64URL = [bytesData toBase64URLString];
    NSString *expectedBase64URL = @"7rwfV0h_UZIcBGVm";
    XCTAssert([createdBase64URL isEqualToString:expectedBase64URL], @"decoded base64url string should match");
}

- (void)testDataIsConverted2 {
    const unsigned char bytes[] = {0xee};
    NSData *bytesData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    NSString *createdBase64URL = [bytesData toBase64URLString];
    NSString *expectedBase64URL = @"7g";
    XCTAssert([createdBase64URL isEqualToString:expectedBase64URL], @"decoded base64url string should match");
}

- (void)testDataIsConvertedEmptyData {
    const unsigned char bytes[] = {};
    NSData *bytesData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    
    NSString *createdBase64URL = [bytesData toBase64URLString];
    NSString *expectedBase64URL = @"";
    XCTAssert([createdBase64URL isEqualToString:expectedBase64URL], @"decoded base64url string should match");
}

@end
