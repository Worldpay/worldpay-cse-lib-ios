//
//  NSStringWP.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 29/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSString+WP.h"

@interface NSStringWP : XCTestCase

@end

@implementation NSStringWP


- (void)testEmptyStringPositive {
    XCTAssert([@"" isEmpty], @"The string should be empty");
}

- (void)testEmptyStringNegative {
    XCTAssert(![@"s" isEmpty], @"The string should be empty");
}

- (void)testTrimmedString1 {
    XCTAssert([[@" s s   " trimmed] isEqualToString:@"s s"], @"The trimmed string should match the expected one");
}

- (void)testTrimmedString2 {
    XCTAssert([[@" ss   " trimmed] isEqualToString:@"ss"], @"The trimmed string should match the expected one");
}

- (void)testTrimmedString3 {
    XCTAssert([@"" isEqualToString:@""], @"The trimmed string should match the expected one");
}

@end
