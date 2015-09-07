//
//  WPJWEObjectTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "WPJWEObject.h"
#import "WPJWEHeader.h"
#import "WPPublicKey.h"
#import "NSData+Base64URL.h"


static NSString const *kPublicKeyIdModulusExponent =
@"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054c07fa73cf86cd78d141f923cff2fb70afb40be36ec78c7a334ef23451c34cc8df03c2f496cd7f4fcccfd35aba72417c859d7e5e960a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89d065fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a0dd0dc4f2be8a669b48eb247a1df5d94d921435af66588568999e6a984152c53af211aab64edcd94a0ce1aceb66c50c0d3c074bac30d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b715555dc08ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc6e777a558d802381488c24a74cff4fcce3104e727ede3";

@interface WPJWEObject (TestInterface)

@property (strong, nonatomic) NSData *payload;
@property (strong, nonatomic) WPJWEHeader *header;
@property (strong, nonatomic) WPPublicKey *key;
@property (strong, nonatomic) NSData *secretKey;
@property (strong, nonatomic) NSData *encryptedKey;
@property (strong, nonatomic) NSData *initializationVector;
@property (strong, nonatomic) NSData *cipherText;
@property (strong, nonatomic) NSData *authTag;
@property (strong, nonatomic) NSData *aad;

@end

@interface WPJWEObjectTests : XCTestCase
{
    WPJWEObject *_jweObject;
    WPJWEHeader *_jweHeader;
    NSData *_payload;
    
    NSData *_encryptedKey;
    NSData *_initializationVector;
    NSData *_cipherText;
    NSData *_authTag;
}
@end

@implementation WPJWEObjectTests

- (void)setUp {
    [super setUp];
    _payload = [@"DataPayload" dataUsingEncoding:NSUTF8StringEncoding];
    _jweHeader = [[WPJWEHeader alloc] init];
    
    _encryptedKey = [@"1234" dataUsingEncoding:NSUTF8StringEncoding];
    _initializationVector = [@"234234" dataUsingEncoding:NSUTF8StringEncoding];
    _cipherText = [@"45435435" dataUsingEncoding:NSUTF8StringEncoding];
    _authTag = [@"6456456" dataUsingEncoding:NSUTF8StringEncoding];
    
    _jweObject = [[WPJWEObject alloc] initWithHeader:_jweHeader
                                         withPayload:_payload];
    
    _jweObject.encryptedKey = _encryptedKey;
    _jweObject.initializationVector = _initializationVector;
    _jweObject.cipherText = _cipherText;
    _jweObject.authTag = _authTag;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializer {
    XCTAssert([_jweObject header] == _jweHeader, @"Header should be the original one");
    XCTAssert([_jweObject payload] == _payload, @"Header should be the original one");
}

- (void)testSerialize {
    NSString *result = [NSString stringWithFormat:@"%@.%@.%@.%@.%@",
                                   [_jweHeader toBase64URLString],
                                   [_encryptedKey toBase64URLString],
                                   [_initializationVector toBase64URLString],
                                   [_cipherText toBase64URLString],
                                   [_authTag toBase64URLString]];
    
    XCTAssert([[_jweObject serialize] isEqualToString:result], @"Data should match");

}

- (void)testSerializeFiveComponents {
    
    XCTAssert([[_jweObject serialize] componentsSeparatedByString:@"."].count == 5, @"Should be five components");
    
}

- (void)testEncryptionFiveComponents {
    NSError *localError;
    WPPublicKey *publicKey = [WPPublicKey parseKey:(NSString *)kPublicKeyIdModulusExponent
                                             error:&localError];
    [_jweObject setPublicKey:publicKey];
    
    BOOL result = [_jweObject encrypt:&localError];
    XCTAssert(result, @"The encryption result should be YES");
    XCTAssert([[_jweObject serialize] componentsSeparatedByString:@"."].count == 5, @"Should be five components");
}

@end
