//
//  AESGCM.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <openssl/rsa.h>
#import <openssl/err.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import <openssl/evp.h>
#import <openssl/aes.h>

#import "AESGCM.h"
#import "WPCryptoUtils.h"
#import "NSError+WP.h"

@implementation AESGCM

+ (NSData *)encrypt:(NSData *)data
      withSecretKey:(NSData *)key
             withIV:(NSData *)initializationVector
       withAuthData:(NSData *)aad
         andAuthTag:(NSData **)authenticationTag
              error:(NSError * __autoreleasing *)error {
    
    NSError *localError = nil;

    int outlen = 0;
    unsigned char *outbuf = [WPCryptoUtils
                             allocBufferOfSize:(data.length + 16)
                             error:&localError];
    NSData *encryptedData = nil;

    if (!outbuf) {
        if (error) {
            *error = localError;
        }
        return nil;
    }

    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    
    if (!ctx) {
        if (error) {
            *error = [NSError aesContextAllocError];
        }
        free(outbuf);
        return nil;
    }
    
    /* Set cipher type and mode */
    EVP_EncryptInit_ex(ctx, EVP_aes_256_gcm(), NULL, NULL, NULL);
    /* Set IV length if default 96 bits is not appropriate */
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN,
                        (int)initializationVector.length, NULL);
    /* Initialise key and IV */
    EVP_EncryptInit_ex(ctx, NULL, NULL, [key bytes],
                       [initializationVector bytes]);
    /* Zero or more calls to specify any AAD */
    EVP_EncryptUpdate(ctx, NULL, &outlen,
                      [aad bytes],
                      (int)aad.length);
    /* Encrypt plaintext */
    EVP_EncryptUpdate(ctx, outbuf, &outlen,
                      [data bytes],
                      (int)data.length);

    /* Encrypted block */
    encryptedData = [NSData dataWithBytes:outbuf
                                   length:outlen];
    
    if (!encryptedData && error) {
        *error = [NSError aesEncryptError];
    }

    /* Finalise: note get no output for GCM */
    EVP_EncryptFinal_ex(ctx, outbuf, &outlen);

    /* Get tag */
    EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, 16, outbuf);
    *authenticationTag = [NSData dataWithBytes:outbuf
                                        length:16];

    EVP_CIPHER_CTX_free(ctx);
    free(outbuf);
    
    return encryptedData;
}


@end
