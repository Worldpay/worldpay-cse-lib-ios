//
//  WorldpayCSETests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "WorldpayCSE.h"
#import "WPPublicKey.h"
#import "WPRSAEncrypter.h"
#import "WPJWEHeader.h"
#import "WPJWEObject.h"
#import "NSError+WP.h"
#import "WPConstants.h"

extern NSString* const kWPJWEHeaderDefaultAlgValue;
extern NSString* const kWPJWEHeaderDefaultEncValue;

extern NSString* const kWPJWEHeaderApiVersion;
extern NSString* const kWPJWEHeaderLibraryVersion;
extern NSString* const kWPJWEHeaderChannelVersion;


static NSString const *rsaPublicKeyIdModulusExponent =
@"1#10001#bf49edcaba456c6357e4ace484c3fba212543e78bf72a8c2238caaa1c7ed20262956caa61d74840598d9b0707bc82e66f18c8b369c77ae6be0429c93323bb7511fc73d9c7f698872a8384370cd77c7516caa25a195d48701e3e0462d61200983ba26cc4a20bb059d5beda09270ea6dcf15dd92084c4d5867b60986151717a8022e4054462ee74ab8533dda77cee227a49fdaf58eaeb95df90cb8c05ee81f58bec95339b6262633aef216f3ae503e8be0650350c48859eef406e63d4399994b147e45aaa14cf9936ac6fdd7d4ec5e66b527d041750ba63a8296b3e6e774a02ee6025c6ee66ef54c3688e4844be8951a8435e6b6e8d6763d9ee5f16521577e159d";

extern NSString* const kWPPublicKeyComponentsSeparator;

@interface WorldpayCSE (TestInterface)

@property (strong, nonatomic) WPPublicKey *rsaPublicKey;
@property (strong, nonatomic) WPJWEHeader *jweHeader;
@property (strong, nonatomic) WPJWEObject *jweObject;

@end


@interface WorldpayCSETests : XCTestCase
{
    WorldpayCSE *_wpCSE;
    id _publicKeyMock;
    
    WPCardData *_validCardData;
    WPCardData *_invalidCardData;
}
@end

@implementation WorldpayCSETests

- (void)setUp {
    [super setUp];
    
    _validCardData = [WPCardData new];
    _validCardData.cvc = @"123";
    _validCardData.expiryMonth = @"11";
    _validCardData.expiryYear = @"2090";
    _validCardData.cardHolderName = @"John Doe";
    _validCardData.cardNumber = @"4444333322221111";
    
    _invalidCardData = [WPCardData new];
    _invalidCardData.cvc = @"12";
    _invalidCardData.expiryMonth = @"1";
    _invalidCardData.expiryYear = @"090";
    _invalidCardData.cardHolderName = @"Ni34co7890   4567lae123ghi78901";
    _invalidCardData.cardNumber = @"444333322221111";
}

- (void)testSetPublicKey1 {
    NSError *error = nil;
    
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)rsaPublicKeyIdModulusExponent error:&error];
    
    WPPublicKey *previousPublicKey = _wpCSE.rsaPublicKey;
    BOOL result = [_wpCSE setPublicKey:(NSString *)rsaPublicKeyIdModulusExponent error:&error];
    XCTAssert(result, @"setPublicKey should return YES");
    XCTAssert([_wpCSE getPublicKey] != previousPublicKey, @"The new keys should not match");
}

- (void)testSetPublicKey1Failure {
    NSError *error = nil;
    
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)rsaPublicKeyIdModulusExponent error:&error];
    BOOL result = [_wpCSE setPublicKey:@"" error:&error];
    XCTAssert(!result, @"setPublicKey should return NO");
}


- (void)testSetPublicKey2 {
    NSError *error = nil;
    WPPublicKey *newPublicKey = [WPPublicKey parseKey:(NSString *)rsaPublicKeyIdModulusExponent
                                                error:&error];
    
    
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)rsaPublicKeyIdModulusExponent error:&error];
    
    WPPublicKey *previousPublicKey = _wpCSE.rsaPublicKey;
    [_wpCSE setPublicKey:newPublicKey];
    
    
    XCTAssert(_wpCSE, @"The WorldpayCSE should be initialized");
    XCTAssert(newPublicKey != previousPublicKey, @"The public keys should not match");
}

- (void)testEncrypt {
    
    NSError *error = nil;
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)rsaPublicKeyIdModulusExponent error:&error];
    NSString *result = [_wpCSE encrypt:_validCardData error:&error];
    
    NSArray *components = [result componentsSeparatedByString:@"."];
    XCTAssert(components.count == 5, @"The resulting JWE data should have 5 components");
}

- (void)testEncryptFailure {
    NSError *error = nil;
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)@"1#32423423432#34534534534543" error:&error];

    NSString *result = [_wpCSE encrypt:_validCardData error:&error];

    XCTAssert([_wpCSE.jweHeader.alg isEqualToString:kWPJWEHeaderDefaultAlgValue], @"Expected alg header should be present");
    XCTAssert([_wpCSE.jweHeader.enc isEqualToString:kWPJWEHeaderDefaultEncValue], @"Expected enc header should be present");
    XCTAssert([_wpCSE.jweHeader.kid isEqualToString:@"1"], @"Expected kid header should be present");
    XCTAssert([_wpCSE.jweHeader.additionalHeaders[kWPJWEHeaderApiVersion] isEqualToString:kWPJWEHeaderApiVersionValue],
              @"Expected kWPJWEHeaderApiVersion header should be present");
    XCTAssert([_wpCSE.jweHeader.additionalHeaders[kWPJWEHeaderLibraryVersion] isEqualToString:kWPJWEHeaderLibraryVersionValue],
              @"Expected kWPJWEHeaderLibraryVersion header should be present");

    XCTAssert([_wpCSE.jweHeader.additionalHeaders[kWPJWEHeaderChannelVersion] isEqualToString:kWPJWEHeaderChannelValue],
              @"Expected kWPJWEHeaderChannelVersion header should be present");


    NSArray *components = [result componentsSeparatedByString:@"."];
    XCTAssert(components.count != 5, @"The resulting JWE data should have 5 components");
}

- (void)testEncryptFailureInvalidCardData {
    NSError *error = nil;
    
    _wpCSE = [WorldpayCSE new];
    [_wpCSE setPublicKey:(NSString *)@"1#32423423432#34534534534543" error:&error];
    [_wpCSE encrypt:_invalidCardData error:&error];
    NSSet *expectedErrorSet = [NSSet setWithArray:@[@(WPCardValidatorErrorInvalidExpiryMonthValue),
                                                    @(WPCardValidatorErrorCardholderNameTooLong),
                                                    @(WPCardValidatorErrorInvalidSecurityCode),
                                                    @(WPCardValidatorErrorInvalidCardNumberLuhn),
                                                    @(WPCardValidatorErrorInvalidExpiryYearValue)]];
    NSSet *errorInfo = [NSSet setWithArray:error.userInfo[kWPErrorDetailsKey]];
    
    XCTAssert([error code] == WPErrorInvalidCardData, @"Error code should be as expected");
    XCTAssert([errorInfo isEqualToSet:expectedErrorSet], @"Resulting sets should be equal");
}

- (void)testValidateValidCardData {
    XCTAssert([WorldpayCSE validate:_validCardData].count == 0, @"There should be reported no erros for the valid card data");
}

- (void)testValidateIvalidCardData {
    XCTAssert([WorldpayCSE validate:_invalidCardData].count > 0, @"There should be reported erros for the invalid card data");
}


@end
