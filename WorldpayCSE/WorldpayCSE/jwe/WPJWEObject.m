//
//  WPJWEObject.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPJWEObject.h"
#import "NSString+Base64URL.h"
#import "NSData+Base64URL.h"
#import "NSError+WP.h"
#import "WPConstants.h"
#import "WPRSAEncrypter.h"
#import "WPAESEncrypter.h"

#import "WPKeyGen.h"

@interface WPJWEObject()

/// The payload to encrypt
@property (strong, nonatomic) NSData *payload;

/// JWE header
@property (strong, nonatomic) WPJWEHeader *header;

/// AES secret key
@property (strong, nonatomic) NSData *secretKey;

/// RSA encrypted AES secret key
@property (strong, nonatomic) NSData *encryptedKey;

/// AES IV data
@property (strong, nonatomic) NSData *initializationVector;

/// AES encrypted data
@property (strong, nonatomic) NSData *cipherText;

/// AES authentication tag
@property (strong, nonatomic) NSData *authTag;

/// AES aad data
@property (strong, nonatomic) NSData *aad;

@end

@implementation WPJWEObject

- (id)initWithHeader:(WPJWEHeader *)header withPayload:(NSData *)payload {
    self = [super init];
    self.header = header;
    self.payload = payload;
    return self;
}

/**
 Generates a random AES 256 bit key.
 
 It sets `self.secretKey` with the new generated data.
 
 @return nil on success. NSError on failure.
 */

- (NSError *)generateKey {
    NSError *localError = nil;
    self.secretKey = [WPKeyGen generateKey:[WPKeyGen KEY_BIT_LENGTH]
                                     error:&localError];
    
    return localError;
}

/**
 Encrypts the key.
 
 It calls `generateKey`, then encrypts the key.
 
 It sets `self.encryptedKey` with the encrypted data.
 
 @return nil on success. NSError on failure.
 */
- (NSError *)encryptKey {
    NSError *localError = nil;
    
    localError = [self generateKey];
    if (localError) {
        return localError;
    }

    WPRSAEncrypter *rsaEncrypter = [[WPRSAEncrypter alloc] initWithKey:self.publicKey];
    
    self.encryptedKey = [rsaEncrypter encrypt:self.secretKey
                                        error:&localError];
    
    return localError;
}

/**
  Generates an AES IV vector.
 
  It sets `self.initializationVector` with the generated data.

  @return nil on success. NSError on failure.
 */
- (NSError *)generateIV {
    NSError *localError = nil;
    self.initializationVector = [WPKeyGen generateKey:[WPKeyGen IV_BIT_LENGTH]
                                               error:&localError];
    
    return localError;
}

/**
 Encrypts the content.
 
 It calls `generateIV`, then encrypts the content.
 
 It sets `self.cipherText` with the encrypted data.

 It sets `self.authTag` with the AES authentication tag.
 
 @return nil on success. NSError on failure.
 */
- (NSError *)encryptContent {
    NSError *localError = nil;
    
    localError = [self generateIV];
    if (localError) {
        return localError;
    }

    self.aad = [[self.header toBase64URLString] dataUsingEncoding:NSUTF8StringEncoding];
    
    WPAESEncrypter *aesEncrypter = [[WPAESEncrypter alloc] initWithKey:self.secretKey
                                                                withIV:self.initializationVector
                                                                andAad:self.aad];
    
    self.cipherText = [aesEncrypter encrypt:self.payload error:&localError];
    self.authTag = [aesEncrypter getAuthenticationTag];
    
    return localError;
}

/**
 Encrypts the content.
 
 It calls `encryptKey`, then encrypts the content.
 
 It calls `encryptContent`, then encrypts the content.
 */
- (BOOL)encrypt:(NSError * __autoreleasing *)error {
    NSError *localError = nil;
    
    localError = [self encryptKey];
    if (localError) {
        *error = localError;
        return NO;
    }
    
    localError = [self encryptContent];
    if (localError) {
        *error = localError;
        return NO;
    }

    return YES;
}

/**
 
 Serializes all the encrypted and encoded data to JWE format.
 @return encrypted data in JWE format.
 */
- (NSString *)serialize {
    return [NSString stringWithFormat:@"%@.%@.%@.%@.%@",
            [self.header toBase64URLString],
            [self.encryptedKey toBase64URLString],
            [self.initializationVector toBase64URLString],
            [self.cipherText toBase64URLString],
            [self.authTag toBase64URLString]];
}


@end
