//
//  WPKeyGenTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WPKeyGen.h"
#import "WPConstants.h"
#import "WPErrorCodes.h"

extern NSString* const kWPErrorDomain;
extern NSString* const kWPErrorDetailsKey;

extern NSString* const kWPErrorRSAInvalidPublicKeyMessage;
extern NSString* const kWPErrorBufferAllocMessage;
extern NSString* const kWPKeyGenErrorMessage;
extern NSString* const kWPInvalidJsonErrorMessage;
extern NSString* const kWPJWEStringParseErrorMessage;

@interface WPKeyGenTests : XCTestCase

@end

@implementation WPKeyGenTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIVLength {
    XCTAssert([WPKeyGen IV_BIT_LENGTH] == 96, @"IV length should be 96");
}

- (void)testAuthTagLength {
    XCTAssert([WPKeyGen AUTH_TAG_BIT_LENGTH] == 128, @"Athentication tag length should be 128");
}

- (void)testAesKeyLength {
    XCTAssert([WPKeyGen KEY_BIT_LENGTH] == 256, @"AES key length should be 256");
}

- (void)testRandomGeneratorUnique {
    NSError *error = nil;
    
    NSData *testData = [WPKeyGen generateKey:6 error:&error];
    int count = 5;
    while (count <= 0) {
        XCTAssert(![[WPKeyGen generateKey:6 error:&error] isEqualToData:testData], @"Generated numbers shiuld not be equal");
    }
}

- (void)testRandomGeneratorFailure {
    NSError *error = nil;
    NSData *testData = [WPKeyGen generateKey:ULONG_MAX error:&error];
    XCTAssert(testData == nil, @"Data should be nil");
    XCTAssert(error != nil, @"Error should be nil");
    XCTAssert([error code] == WPErrorBufferAlloc, @"Error code should be WPErrorBufferAlloc");
    XCTAssert([error.userInfo[kWPErrorDetailsKey] isEqualToString:kWPErrorBufferAllocMessage], @"Error message should be kWPErrorBufferAllocMessage");
    
}

@end
