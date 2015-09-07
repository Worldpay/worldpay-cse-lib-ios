//
//  NSDictionaryJSONTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSDictionary+JSON.h"

@interface NSDictionaryJSONTests : XCTestCase

@end

@implementation NSDictionaryJSONTests

- (void)testEmptyDictionaryToJSON {
    NSDictionary *demo = [NSDictionary new];
    XCTAssert([[demo jsonString] isEqualToString:@"{\n\n}"], @"Empty dictionary should match to empty json");
}

- (void)testEmptyDictionary {
    NSDictionary *dict = @{@"test1" : @"value1" , @"test2" : @"value2", @"test3" : @"value3"};
    NSData *data = [[dict jsonString] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    XCTAssert([json isEqualToDictionary:dict], @"Empty dictionary should match to empty json");
}

@end
