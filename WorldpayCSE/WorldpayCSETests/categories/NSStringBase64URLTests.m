//
//  NSStringBase64Tests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+Base64URL.h"

@interface NSStringBase64URLTests : XCTestCase

@end

@implementation NSStringBase64URLTests

- (void)testStringToBase64URL {
    NSString *string = @"All programs on a Unix system are a child";
    NSString *expectedBase64URLString = @"QWxsIHByb2dyYW1zIG9uIGEgVW5peCBzeXN0ZW0gYXJlIGEgY2hpbGQ";
    XCTAssert([[string toBase64URLString] isEqualToString:expectedBase64URLString], @"the base64 representation should match");
}

- (void)testEmptyStringToBase64URL {
    NSString *string = @"";
    NSString *expectedBase64URLString = @"";
    XCTAssert([[string toBase64URLString] isEqualToString:expectedBase64URLString], @"the empy string should yield an empty base64URL string");
}

- (void)testBase64StringToBase64URL {
    NSString *base64String = @"QWxsIHByb2dyYW1zIG9++uIGE/gVW5peCBzeXN0ZW0gYXJlIGEgY2hpbGQ=";
    NSString *expectedBase64URLString = @"QWxsIHByb2dyYW1zIG9--uIGE_gVW5peCBzeXN0ZW0gYXJlIGEgY2hpbGQ";
    XCTAssert([[base64String base64StringToBase64URLString] isEqualToString:expectedBase64URLString], @"the resulting base64URL string should match");
}

@end
