//
//  WPJWEHeaderTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WPJWEHeader.h"
#import "WPConstants.h"

extern NSString* const kWPJWEHeaderDefaultAlgValue;
extern NSString* const kWPJWEHeaderDefaultEncValue;

extern NSString* const kWPJWEHeaderAlg;
extern NSString* const kWPJWEHeaderEnc;
extern NSString* const kWPJWEHeaderKid;

extern NSString* const kWPJWEHeaderApiVersion;
extern NSString* const kWPJWEHeaderLibraryVersion;
extern NSString* const kWPJWEHeaderChannelVersion;

static NSString* const kJsonFormat = @"{  \"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\"}";

@interface WPJWEHeaderTests : XCTestCase
{
    NSString *_validJSON;
    NSString *_invalidJSON;
}
@end

@implementation WPJWEHeaderTests

- (void)setUp {
    [super setUp];
    
    _validJSON = [NSString stringWithFormat:kJsonFormat,
                  kWPJWEHeaderAlg, kWPJWEHeaderDefaultAlgValue,
                  kWPJWEHeaderEnc, kWPJWEHeaderDefaultEncValue,
                  kWPJWEHeaderKid, @"1",
                  kWPJWEHeaderApiVersion, kWPJWEHeaderApiVersionValue,
                  kWPJWEHeaderLibraryVersion, kWPJWEHeaderLibraryVersionValue,
                  kWPJWEHeaderChannelVersion, kWPJWEHeaderChannelValue];
    
    _invalidJSON = [NSString stringWithFormat:kJsonFormat,
                    @"\'\"", kWPJWEHeaderDefaultAlgValue,
                    kWPJWEHeaderEnc, kWPJWEHeaderDefaultEncValue,
                    kWPJWEHeaderKid, @"1",
                    kWPJWEHeaderApiVersion, kWPJWEHeaderApiVersionValue,
                    kWPJWEHeaderLibraryVersion, kWPJWEHeaderLibraryVersionValue,
                    kWPJWEHeaderChannelVersion, kWPJWEHeaderChannelValue];
}

- (void)testInitializer {
    WPJWEHeader *jweHeader = [WPJWEHeader new];
    
    XCTAssert([jweHeader.alg isEqualToString:@""], @"alg should be blank");
    XCTAssert([jweHeader.enc isEqualToString:@""], @"enc should be blank");
    XCTAssert([jweHeader.kid isEqualToString:@""], @"kid should be blank");
    XCTAssert(jweHeader.additionalHeaders == nil, @"expiryYear should be blank");
}


- (void)testToJsonString {
    WPJWEHeader *jweHeader = [WPJWEHeader new];
    
    jweHeader.alg = kWPJWEHeaderDefaultAlgValue;
    jweHeader.enc = kWPJWEHeaderDefaultEncValue;
    jweHeader.kid = @"1";
    jweHeader.additionalHeaders = @{kWPJWEHeaderApiVersion : kWPJWEHeaderApiVersionValue,
                                    kWPJWEHeaderLibraryVersion : kWPJWEHeaderLibraryVersionValue,
                                    kWPJWEHeaderChannelVersion : kWPJWEHeaderChannelValue};
    
    NSError *jsonError = nil;
    NSString *jweHeaderJson = [jweHeader jsonString];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jweHeaderJson dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    XCTAssert(json[kWPJWEHeaderAlg], @"kWPJWEHeaderAlg key should exist");
    XCTAssert(json[kWPJWEHeaderEnc], @"kWPJWEHeaderEnc key should exist");
    XCTAssert(json[kWPJWEHeaderAlg], @"kWPJWEHeaderAlg key should exist");
    XCTAssert(json[kWPJWEHeaderKid], @"kWPJWEHeaderKid key should exist");
    XCTAssert(json[kWPJWEHeaderApiVersion], @"kWPJWEHeaderApiVersion key should exist");
    XCTAssert(json[kWPJWEHeaderLibraryVersion], @"kWPJWEHeaderLibraryVersion key should exist");
    XCTAssert(json[kWPJWEHeaderChannelVersion], @"kWPJWEHeaderChannelVersion key should exist");
    
    XCTAssert([json[kWPJWEHeaderAlg] isEqualToString:kWPJWEHeaderDefaultAlgValue], @"kWPJWEHeaderAlg key should have the expected value");
    XCTAssert([json[kWPJWEHeaderEnc] isEqualToString:kWPJWEHeaderDefaultEncValue], @"kWPJWEHeaderEnc key should have the expected value");
    XCTAssert([json[kWPJWEHeaderKid] isEqualToString:@"1"], @"kWPJWEHeaderKid key should have the expected value");
    XCTAssert([json[kWPJWEHeaderApiVersion] isEqualToString:kWPJWEHeaderApiVersionValue], @"kWPJWEHeaderApiVersion key should have the expected value");
    XCTAssert([json[kWPJWEHeaderLibraryVersion] isEqualToString:kWPJWEHeaderLibraryVersionValue], @"kWPJWEHeaderLibraryVersion key should have the expected value");
    XCTAssert([json[kWPJWEHeaderChannelVersion] isEqualToString:kWPJWEHeaderChannelValue], @"kWPJWEHeaderChannelVersion key should have the expected value");
}

- (void)testToBase64URLString {
    WPJWEHeader *jweHeader = [[WPJWEHeader alloc] init];
    NSString *base64URLString = [jweHeader toBase64URLString];
    
    NSString *expectedBase64URLString = @"ewogICJhbGciIDogIiIsCiAgImVuYyIgOiAiIiwKICAia2lkIiA6ICIiCn0";

    XCTAssert([base64URLString isEqualToString:expectedBase64URLString], @"Expected base64RUL value should match the generated one");
}

@end
