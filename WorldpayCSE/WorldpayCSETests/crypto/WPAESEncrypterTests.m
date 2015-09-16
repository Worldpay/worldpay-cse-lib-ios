//
//  WPAESEncrypterTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 23/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AESGCM.h"
#import "WPAESEncrypter.h"
#import "WPCryptoUtils.h"

@interface WPAESEncrypter (TestingInterface)

@property (strong, nonatomic) NSData *authenticationTag;
@property (strong, nonatomic) NSData *initializationVect;
@property (strong, nonatomic) NSData *aad;

@end


@interface WPAESEncrypterTests : XCTestCase
{
    NSData *_clearText;
    NSData *_secretKey;
    NSData *_iv;
    NSData *_aad;
    NSData *_authTag;

    WPAESEncrypter *_encrypter;
    NSData *_encryptedData;
    id _aesMock;
}

@end

@implementation WPAESEncrypterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _clearText = [@"clearText" dataUsingEncoding:NSUTF8StringEncoding];
    _secretKey = [@"secretKey" dataUsingEncoding:NSUTF8StringEncoding];
    _iv = [@"iv" dataUsingEncoding:NSUTF8StringEncoding];
    _aad = [@"aad" dataUsingEncoding:NSUTF8StringEncoding];
    _authTag = [@"authTag" dataUsingEncoding:NSUTF8StringEncoding];

    _encryptedData = [NSData new];
    _encrypter = [[WPAESEncrypter alloc] initWithKey:_secretKey withIV:_iv andAad:_aad];
    _aesMock  = [OCMockObject niceMockForClass:[AESGCM class]];

}

- (void)tearDown {
    [_aesMock stopMocking];

    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializerThatSetsKey {
    XCTAssert([_encrypter getKey] == _secretKey, @"Secret key should be the same");
}

- (void)testInitializerThatSetsAad {
    XCTAssert(_encrypter.aad == _aad, @"AAD should be the same");
}

- (void)testInitializerThatSetsIV {
    XCTAssert(_encrypter.initializationVect == _iv, @"IV should be the same");
}



- (void)testEncryptSuccess {
    NSError *error;
    
    XCTAssert(nil != [_encrypter encrypt:_secretKey error:&error], @"Returned encrypted data should match the expected one");
    XCTAssert(nil != [_encrypter authenticationTag], @"Authtag should be initialized");

}

- (void)testEncryptFailNoKey {
    _encrypter = [[WPAESEncrypter alloc] initWithKey:nil withIV:nil andAad:nil];

    XCTAssert(nil != [_encrypter encrypt:_secretKey error:nil], @"The result should be nil");
}



@end
