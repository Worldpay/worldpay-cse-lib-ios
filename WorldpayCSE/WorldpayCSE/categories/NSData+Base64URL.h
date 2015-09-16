//
//  NSData+Base64URL.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This category is used to encode an `NSData` to a base64URL string.
 
 A base64URL string is a base64 string with:
 
   - '=' removed
 
   - '/' replaced with '_'
 
   - '+' replaced with '-'
 
 */
@interface NSData (Base64URL)

/**
  Encodes the NSData to a base64URL NSString.

  @return base64URL representation of the binary data
 */
- (NSString *)toBase64URLString;

@end
