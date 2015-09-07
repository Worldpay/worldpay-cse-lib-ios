//
//  AESGSMTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <openssl/rsa.h>
#import <openssl/err.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import <openssl/evp.h>
#import <openssl/aes.h>

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "AESGCM.h"
#import "WPKeyGen.h"
#import "WPCryptoUtils.h"
#import "NSError+WP.h"


static const unsigned char gcm_key[] = {
    0xee, 0xbc, 0x1f, 0x57, 0x48, 0x7f, 0x51, 0x92, 0x1c, 0x04, 0x65, 0x66,
    0x5f, 0x8a, 0xe6, 0xd1, 0x65, 0x8b, 0xb2, 0x6d, 0xe6, 0xf8, 0xa0, 0x69,
    0xa3, 0x52, 0x02, 0x93, 0xa5, 0x72, 0x07, 0x8f
};

static const unsigned char gcm_iv[] = {
    0x99, 0xaa, 0x3e, 0x68, 0xed, 0x81, 0x73, 0xa0, 0xee, 0xd0, 0x66, 0x84
};

static const unsigned char gcm_pt[] = {
    0xf5, 0x6e, 0x87, 0x05, 0x5b, 0xc3, 0x2d, 0x0e, 0xeb, 0x31, 0xb2, 0xea,
    0xcc, 0x2b, 0xf2, 0xa5
};

static const unsigned char gcm_aad[] = {
    0x4d, 0x23, 0xc3, 0xce, 0xc3, 0x34, 0xb4, 0x9b, 0xdb, 0x37, 0x0c, 0x43,
    0x7f, 0xec, 0x78, 0xde
};

static const unsigned char gcm_ct[] = {
    0xf7, 0x26, 0x44, 0x13, 0xa8, 0x4c, 0x0e, 0x7c, 0xd5, 0x36, 0x86, 0x7e,
    0xb9, 0xf2, 0x17, 0x36
};

static const unsigned char gcm_tag[] = {
    0x67, 0xba, 0x05, 0x10, 0x26, 0x2a, 0xe4, 0x87, 0xd7, 0x37, 0xee, 0x62,
    0x98, 0xf7, 0x7e, 0x0c
};

@interface AESGCM (TestingInterface)

/**
 *  Decrypt plain data with AES256GCM.
 *
 *  @param data                 Plain data
 *  @param key                  Encryption key
 *  @param initializationVector Initialization vector (IV)
 *  @param aad                  AAD data
 *  @param authenticationTag    Authentication tag
 *  @param error                Error on nil return
 *  Possible error codes:
 *   WPAESDecryptError - could not decrypt the data
 *   WPAESAuthError - could not validat authentication tag
 *   WPErrorAESCTXAlloc - could not allocate AES context structure
 *   WPErrorBufferAlloc - could not allocate buffer for output
 *
 *  @return Encrypted data with AES256GCM. On failure nil.
 */
+ (NSData *)decrypt:(NSData *)data
      withSecretKey:(NSData *)key
             withIV:(NSData *)initializationVector
       withAuthData:(NSData *)aad
         andAuthTag:(NSData *)authenticationTag
              error:(NSError * __autoreleasing *)error;

@end

@implementation AESGCM (TestingInterface)

+ (NSData *)decrypt:(NSData *)data
      withSecretKey:(NSData *)key
             withIV:(NSData *)initializationVector
       withAuthData:(NSData *)aad
         andAuthTag:(NSData *)authenticationTag
              error:(NSError * __autoreleasing *)error {
    
    NSError *localError = nil;
    int outlen = 0, rvResult = 0;
    unsigned char *outbuf = [WPCryptoUtils
                             allocBufferOfSize:(data.length + 16)
                             error:&localError];
    NSData *decryptedData = nil;
    
    if (!outbuf) {
        if (error) {
            *error = localError;
        }
        return nil;
    }
    
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    
    if (!ctx) {
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
        free(outbuf);
        return nil;
    }
    
    /* Set cipher type and mode */
    EVP_DecryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL);
    /* Set IV length if default 96 bits is not appropriate */
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN,
                        (int)initializationVector.length, NULL);
    /* Initialise key and IV */
    EVP_DecryptInit_ex(ctx, NULL, NULL,
                       [key bytes],
                       [initializationVector bytes]);
    /* Zero or more calls to specify any AAD */
    EVP_DecryptUpdate(ctx, NULL, &outlen,
                      [aad bytes],
                      (int)aad.length);
    /* Decrypt plaintext */
    EVP_DecryptUpdate(ctx, outbuf, &outlen,
                      [data bytes],
                      (int)data.length);
    
    /* Decrypted block */
    decryptedData = [NSData dataWithBytes:outbuf length:outlen];
    
    if (!decryptedData) {
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
        EVP_CIPHER_CTX_free(ctx);
        free(outbuf);
        return nil;
    }
    
    /* Set expected tag value */
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG,
                        (int)authenticationTag.length,
                        (void *)[authenticationTag bytes]);
    
    /* Finalise: note get no output for GCM */
    rvResult = EVP_DecryptFinal_ex(ctx, outbuf, &outlen);
    
    if (rvResult < 0) {
        //failed authentication
        decryptedData = nil;
        
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
    }
    
    EVP_CIPHER_CTX_free(ctx);
    free(outbuf);
    
    return decryptedData;
}
@end

@interface AESGSMTests : XCTestCase
{
    NSData *_gcmKey;
    NSData *_gcmPlainText;
    NSData *_gcmIV;
    NSData *_gcmAAD;
    NSData *_gcmAuthTag;
    NSData *_gcmAuthCipherText;
    NSData *_dataIV;

}
@end

@implementation AESGSMTests

- (void)setUp {
    [super setUp];
    
    _gcmKey = [[NSData alloc] initWithBytes:gcm_key length:sizeof(gcm_key)];
    _gcmPlainText = [[NSData alloc] initWithBytes:gcm_pt length:sizeof(gcm_pt)];
    _gcmIV = [[NSData alloc] initWithBytes:gcm_iv length:sizeof(gcm_iv)];
    _gcmAAD = [[NSData alloc] initWithBytes:gcm_aad length:sizeof(gcm_aad)];
    _gcmAuthTag = [[NSData alloc] initWithBytes:gcm_tag length:sizeof(gcm_tag)];
    _gcmAuthCipherText = [[NSData alloc] initWithBytes:gcm_ct length:sizeof(gcm_ct)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateIV {
    NSError *error;
    
    
    NSData *dataIV = [WPKeyGen generateKey:[WPKeyGen IV_BIT_LENGTH] error:&error];

    XCTAssert(dataIV.length == 12, @"IV vector should be 96 bit");
}

- (void)testAESEncryptSuccess {
    NSError *error = nil;
    NSData *gcmAuthTag = [NSData new];
    NSData *crypted = nil;

    crypted = [AESGCM encrypt:_gcmPlainText
                withSecretKey:_gcmKey
             withIV:_gcmIV
       withAuthData:_gcmAAD
         andAuthTag:&gcmAuthTag
              error:&error];
    
    XCTAssert([crypted isEqualToData:_gcmAuthCipherText], @"Crypted cyphers should match");
    XCTAssert([gcmAuthTag isEqualToData:_gcmAuthTag], @"Auth tags should match");
}

- (void)testAESDecryptSuccess {
    NSError *error = nil;
    NSData *decrypted = nil;

    decrypted = [AESGCM decrypt:_gcmAuthCipherText
                  withSecretKey:_gcmKey
                         withIV:_gcmIV
                   withAuthData:_gcmAAD
                     andAuthTag:_gcmAuthTag
                          error:&error];
    
    XCTAssert([decrypted isEqualToData:_gcmPlainText], @"Plain text should match");
}

- (void)testAESDecryptFailure {
    NSError *error = nil;
    NSData *decrypted = nil;
    
    decrypted = [AESGCM decrypt:_gcmAuthCipherText
                  withSecretKey:_gcmAAD
                         withIV:_gcmIV
                   withAuthData:_gcmAAD
                     andAuthTag:_gcmKey
                          error:&error];
    
    XCTAssert(![decrypted isEqualToData:_gcmPlainText], @"Plain text should not match");
}




@end
