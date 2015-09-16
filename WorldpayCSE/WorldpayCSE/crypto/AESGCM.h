//
//  AESGCM.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This class implements AES256 GCM encryption.
 @warning It is hardcoded to accept only 256 bit encryption keys. 
 
 The implementation uses the [OpenSSL](http://openssl.org) library.

 */
@interface AESGCM : NSObject

/**
  Encrypt plain data with AES256GCM.

  @param data                 Plain data
  @param key                  Encryption key
  @param initializationVector Initialization vector (IV)
  @param aad                  AAD data
  @param authenticationTag    Authentication tag
  @param error                Error on nil return
 
  Possible error codes:
 
   `WPErrorAESEncrypt` - could not encrypt the data
 
   `WPErrorAESCTXAlloc` - could not allocate AES context structure
 
   `WPErrorBufferAlloc` - could not allocate buffer for output

  @return Encrypted data with AES256 GCM. On failure nil.
 */
+ (NSData *)encrypt:(NSData *)data
      withSecretKey:(NSData *)key
             withIV:(NSData *)initializationVector
       withAuthData:(NSData *)aad
         andAuthTag:(NSData **)authenticationTag
              error:(NSError * __autoreleasing *)error;

@end
