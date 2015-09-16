//
//  WPRSAEncrypterTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "RSA1_5.h"
#import "WPRSAEncrypter.h"

@interface WPRSAEncrypterTests : XCTestCase
{
    NSData *_clearText;
    NSData *_secretKey;
    WPPublicKey *_publicKey;
    WPRSAEncrypter *_encrypter;
    NSData *_encryptedKey;
    id _rsa1_5Mock;
}

@end

@implementation WPRSAEncrypterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _clearText = [@"clearText" dataUsingEncoding:NSUTF8StringEncoding];
    _secretKey = [@"secretKey" dataUsingEncoding:NSUTF8StringEncoding];
    
    _encryptedKey = [NSData new];
    _publicKey = [[WPPublicKey alloc] init];
    _encrypter = [[WPRSAEncrypter alloc] initWithKey:_publicKey];
    _rsa1_5Mock  = [OCMockObject niceMockForClass:[RSA1_5 class]];
}

- (void)tearDown {
    
    [_rsa1_5Mock stopMocking];
    [super tearDown];
}

- (void)testInitializerThatSetsKey {
    XCTAssert([_encrypter getKey] == _publicKey, @"Public keys should be the same");
}

- (void)testEncryptSuccess {
    NSError *error;
    
    [[[_rsa1_5Mock expect] andReturn:_encryptedKey] encrypt:_secretKey
                                              withPublicKey:_publicKey
                                                      error:[OCMArg anyObjectRef]];
    
    XCTAssert(_encryptedKey == [_encrypter encrypt:_secretKey error:&error], @"Returned encrypted key should match the expected one");
    
    [_rsa1_5Mock verify];
}

- (void)testEncryptFailNoKey {
    NSError *error = nil;
    [[[_rsa1_5Mock expect] andReturn:nil] encrypt:_secretKey
                                    withPublicKey:_publicKey
                                            error:[OCMArg anyObjectRef]];
    XCTAssert(nil == [_encrypter encrypt:_secretKey error:&error], @"The result should be nil");
    [_rsa1_5Mock verify];

}


- (void)testEncryptFailNoKeyAndNilError {
    [[[_rsa1_5Mock expect] andReturn:nil] encrypt:_secretKey
                                    withPublicKey:_publicKey
                                            error:[OCMArg anyObjectRef]];
    XCTAssert(nil == [_encrypter encrypt:_secretKey error:nil], @"The result should be nil");
    [_rsa1_5Mock verify];
}




@end
