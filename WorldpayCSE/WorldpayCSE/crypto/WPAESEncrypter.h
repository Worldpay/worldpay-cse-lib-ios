//
//  WPAESEncrypter.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This class implements AES256 GCM encryption.
 */
@interface WPAESEncrypter : NSObject

/**
  Initializez the encrypter with the secret key,
  initializationVect and the aad AES parts.
 
  @warning The key should be 256 bit.

  @param key                encryption key
  @param initializationVect initialization vectector
  @param aad                AES aad data

  @return a valid WPAESEncrypter, on failure nil
 */
- (id)initWithKey:(NSData *)key
           withIV:(NSData *)initializationVect
           andAad:(NSData *)aad;

/**
  Encrypts the given data with the provided secret key, initializationVect and aad.
 
  The authentication tag can be obtained by calling `getAuthenticationTag` after
  `encrypt:error`.
 
 Possible error codes:
 
 `WPErrorAESEncrypt` - could not encrypt the data
 
 `WPErrorAESCTXAlloc` - could not allocate AES context structure
 
 `WPErrorBufferAlloc` - could not allocate buffer for output
 
  @warning The key should be 256 bit.
  @param data  plain data
  @param error error on failure

  @return cipher data. nil on failure.
 */
- (NSData *)encrypt:(NSData *)data
              error:(NSError * __autoreleasing *)error;

/**
  The current encryption key
 */
- (id)getKey;

/**
   AES authentication tag.
   @warning The authentication tag is available only after
   method `encrypt:error` was called, othewise it is nil.
 
   @return AES authentication tag
 */
- (NSData *)getAuthenticationTag;

@end
