//
//  WPRSAEncrypter.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>
#import "WPPublicKey.h"

/**
 This class implements RSA 1.5 encryption.
 */
@interface WPRSAEncrypter : NSObject

/**
  Initializes a WPRSAEncrypter
 
  @param key RSA public key
  @return WPRSAEncrypter object
 */
- (id)initWithKey:(WPPublicKey *)key;

/**
  Encrypts the given data with the provided public key.

 Possible error codes:
 
 `WPErrorRSAEncrypt` - could not decrypt
 
 `WPErrorBufferAlloc` - could not allocate buffer for output
 

  @param data  plain data
  @param error error on failure
  @return cipher data. nil on failure.
 */
- (NSData *)encrypt:(NSData *)data
              error:(NSError * __autoreleasing *)error;

/**
  The current public key
 */
- (id)getKey;

@end
