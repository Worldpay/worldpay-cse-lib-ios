//
//  WPJWEObject.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

#import "WPJWEHeader.h"
#import "WPPublicKey.h"

/**
  JSON Web Encryption Object (JWE). 
  This class implements JWE encryption only.
 
  It uses RSA 1.5 to encrypt the AES key, and AES25 GCM to encrypt the payload.
 */
@interface WPJWEObject : NSObject


/// RSA public key.
@property (strong, nonatomic) WPPublicKey *publicKey;

/**
  Initializes a JWE Object with the JWE Header and payload

 @param header  JWE header
  @param payload payload data
  @return JWE Object. nil on failure.
 */
- (id)initWithHeader:(WPJWEHeader *)header withPayload:(NSData *)payload;

/**
  Encrypts the payload.
 
  It uses RSA 1.5 to encrypt the AES key, and AES25 GCM to encrypt the payload.
 
  Possible error codes:

  `WPErrorRSAEncrypt` - could not decrypt

  `WPErrorBufferAlloc` - could not allocate buffer for output

  `WPErrorAESEncrypt` - could not encrypt the data

  `WPErrorAESCTXAlloc` - could not allocate AES context structure

  `WPErrorBufferAlloc` - could not allocate buffer for output

  @param error     Error on failure
  @return YES if successful, NO on failure
 */
- (BOOL)encrypt:(NSError * __autoreleasing *)error;


/**
  Serialize the encrypted data to JWE compact string.
  JWE compact string example:
  `ewogICJlbmMiIDogIkEyNTZHQ00iLAogICJraWQiIDogIjEiLAogICJjb20ud29ybGRwYXkubGliVmVyc2lvbiIgOiAiMS4wLjAiLAogICJjb20ud29ybGRwYXkuYXBpVmVyc2lvbiIgOiAiMS4wIiwKICAiY29tLndvcmxkcGF5LmNoYW5uZWwiIDogImlvcyIsCiAgImFsZyIgOiAiUlNBMV81Igp9.H9EgXsIrwJTVqDjzrlb-iC3NOze26eENHE7k7TAuUMO-In7noswlXcBWqGKc5BZv4A_NtgOIdI4Vik9n0vCCVGnyMAOQUZZerFjrfp4P6D-Jji1f9mvqcrmaerqC-CR1pmM95enlggRT9qWQayv5YDmgNSM35XwEdJtvij1ncNIRfTLLgSabSvIgZhN8fQPIzc_SMatdWCXGZY5nODXANPIHLcy4fTMCQinmBrcxKUpW2Fst7kdbBeKoqxw9_BMqdNjuBgE-7YTyVjpontKd5h_NYJh-0n15gOu8GxdJdaE9jxX1ObVzU8KK06ZTnrdUxqjJb5iNLBv8n4oDbWP3Xw.ouWEaXmofNKXothi.td7Lz2ry7e5TuVbY4u8sIo4Fzj1HmVjl-gxKEq_SKykVPcV8FsAYksZcKap7KN5JpF0sCWTS1jC8Qk-btH9_ojD_w2WzF_7joxh48wBHdnZuDqbXFhAqf7ynIehxGsjCoJaZzAqcVL8Kqu-FmHomLvkOEPvvcIUMztkq57WDenObtTTXcgfp_uf-nDykpxGf991hE6c.doGZ0C-oeWvCWbUILDkB5A`

 @return JWE compact string. nil on error.
 */
- (NSString *)serialize;

@end
