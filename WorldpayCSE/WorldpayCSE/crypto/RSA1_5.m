//
//  RSA1_5.m
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

#import "RSA1_5.h"
#import "WPCryptoUtils.h"
#import "NSError+WP.h"

@implementation RSA1_5

/**
   An utility method to simplify the code.

  @param exponentHex RSA exponent in hex form string
  @param modulusHex  RSA modulus in hex form string

  @return An initialized RSA object.
 */
+ (RSA *)rsaWithExpHex:(NSString *)exponentHex
         andWithModHex:(NSString *)modulusHex {
    
    BIGNUM *exponentBN = NULL;
    BIGNUM *modulusBN = NULL;
    
    BN_hex2bn(&exponentBN, [exponentHex cStringUsingEncoding:NSUTF8StringEncoding]);
    BN_hex2bn(&modulusBN, [modulusHex cStringUsingEncoding:NSUTF8StringEncoding]);
    
    RSA *rsa = RSA_new();
    rsa->e = exponentBN;
    rsa->n = modulusBN;
    rsa->iqmp = NULL;
    rsa->d = NULL;
    rsa->p = NULL;
    rsa->q = NULL;
    
    return rsa;
}

+ (NSData *)encrypt:(NSData *)clearText
      withPublicKey:(WPPublicKey *)publicKey
              error:(NSError * __autoreleasing *)error {
    
    NSError *localError = nil;
    NSData *encryptedData = nil;
    const char *rawData = clearText.bytes;
    int rawDataLen = (int)clearText.length;

    RSA *rsa = [RSA1_5 rsaWithExpHex:publicKey.exponent
                       andWithModHex:publicKey.modulus];
    
    //alloc according to the RSA key size
    unsigned char *encrypted = [WPCryptoUtils allocBufferOfSize:RSA_size(rsa)
                                                          error:&localError];
    
    
    if (!encrypted) {
        if (error) {
            *error = localError;
        }
        RSA_free(rsa);
        return nil;
    }
    
    int encryptedSize = RSA_public_encrypt(rawDataLen,
                                           (const unsigned char *)rawData,
                                           encrypted,
                                           rsa,
                                           RSA_PKCS1_PADDING);
    
    if (encryptedSize >= 0) {
        encryptedData = [NSData dataWithBytes:encrypted length:encryptedSize];
    } else if (error) {
        *error = [NSError rsaEncryptError];
    }
    
    free(encrypted);
    RSA_free(rsa);
    
    return encryptedData;
}


@end
