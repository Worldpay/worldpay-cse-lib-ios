//
//  NSError+WP.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

#import "WPErrorCodes.h"

/** 
   This category is used to create a specific `NSError` instance.
   Each created error instance has the `kWPErrorDomain` error domain.
 
   To get the error message, call the `userInfo[kWPErrorDetailsKey]` method.
   Expected error codes are defined in `WPCrypoErrorCode`.
 */

@interface NSError (WP)

/**
  Create an NSError with the `kWPErrorDomain` domain
  and the related OpenSSL error.

  @param info      error info
  @param errorCode error code
 
  @return returns an initialized NSError
 */
+ (NSError *)createWPErrorWithInfo:(id)info andErrorCode:(WPErrorCode)errorCode;

/**
  Creates an `NSError` instance with code `WPErrorRSAEncrypt`
  and the related OpenSSL error.

  @return An `NSError` instance with code `WPErrorRSAEncrypt`
 */
+ (NSError *)rsaEncryptError;

/**
  Creates an `NSError` instance with code `WPErrorRSAInvalidPublicKey`
  and the related OpenSSL error.

  @return `NSError` instance with code `WPErrorRSAInvalidPublicKey`
 */
+ (NSError *)rsaInvalidKey;

/**
  Creates an `NSError` instance with code `WPErrorAESEncrypt`
  and the related OpenSSL error.

  @return `NSError` instance with code `WPErrorAESEncrypt`
 */
+ (NSError *)aesEncryptError;

/**
  Creates an `NSError` instance with code `WPErrorAESCTXAlloc`
  and the related OpenSSL error.

  @return `NSError` instance with code `WPErrorAESCTXAlloc`
 */
+ (NSError *)aesContextAllocError;

/**
  Creates an `NSError` instance with code `WPErrorBufferAlloc`
  and the related OpenSSL error.

  @return `NSError` instance with code `WPErrorBufferAlloc`
 */
+ (NSError *)bufferAllocError;

/**
  Creates an `NSError` instance with code `WPErrorRandKeyGenError`
  and the related OpenSSL error.

  @return `NSError` instance with code `WPErrorRandKeyGenError`
 */
+ (NSError *)randomKeyGenError;

/**
 Creates an `NSError` instance with code `WPErrorInvalidCardData`.
 All card data validation errors can be accessed from NSError userInfo[kWPErrorDetailsKey].
 The stored object is an NSArray with `WPCardValidatorError` codes.
 
 @return `NSError` instance with code `WPErrorInvalidCardData`
 */
+ (NSError *)invalidCardDataErrorWithSet:(NSSet *)errors;
@end
