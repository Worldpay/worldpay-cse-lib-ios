//
//  RSA1_5.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

#import "WPPublicKey.h"

/**
 This class implements RSA encryption for RSA 1.5.
 
 The implementation uses the [OpenSSL](http://openssl.org) library.
 
 */
@interface RSA1_5 : NSObject

/**
  Encrypts the provided text with RSA 1.5 public key.

  @param clearText Plain data
  @param publicKey Public key to encrypt with
  @param error     Error on nil return
 
   Possible error codes:
 
   `WPErrorRSAEncrypt` - could not decrypt
 
   `WPErrorBufferAlloc` - could not allocate buffer for output

  @return Encrypted data with RSA 1.5 public key. On failure nil.
 */
+ (NSData *)encrypt:(NSData *)clearText
      withPublicKey:(WPPublicKey *)publicKey
              error:(NSError * __autoreleasing *)error;


@end
