//
//  NSString+Base64URL.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 14/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This category is used to encode an `NSString` to a base64URL string.
 
 Also for converting a base64 string to base64URL.
 
 A base64URL string is a base64 string with:
 
 - '=' removed
 
 - '/' replaced with '_'
 
 - '+' replaced with '-'
 */
@interface NSString (Base64URL)

/**
 *  Encodes the string to base64URL representation. rfc4648.
 *
 *  @return base64URL string
 */
- (NSString *)toBase64URLString;

/**
 *  Encodes a base64 string to base64URL string representation. rfc4648.
 *  @warning the string should be already encoded to base64.
 *  @return base64URL string
 */
- (NSString *)base64StringToBase64URLString;

@end
