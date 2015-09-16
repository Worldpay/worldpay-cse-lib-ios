//
//  WPKeyGen.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This is a utility class for generating random keys of specific bit lengths.
 It also provides the bit lengths for AES Key, Authentication Tag and IV.
 */
@interface WPKeyGen : NSObject

/**
  The required AES IV length in bits

  @return 96
 */
+ (int)IV_BIT_LENGTH;

/**
  The required AES authentication tag size in bits.

  @return 128
 */
+ (int)AUTH_TAG_BIT_LENGTH;

/**
  The required AES key length in bits.

  @return 256
 */
+ (int)KEY_BIT_LENGTH;

/**
  Generates a random key of keySize bits length.

  @param keySize key length in bits
  @param error   erro on failure.

  @return random key of keySyze bits length.
 */
+ (NSData *)generateKey:(unsigned long)keySize
                  error:(NSError * __autoreleasing *)error;


@end
