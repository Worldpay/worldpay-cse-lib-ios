//
//  WPJWEHeader.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
    JWE header class. It is a stripped down representation of the JWE header.
    It handles directly the alg, enc and kid headers. Other headers can be added
    through the additionalHeaders property.
 */
@interface WPJWEHeader : NSObject

/**
  Selected algorithm for key encryption.
 */
@property (strong, nonatomic) NSString *alg;

/**
  Selected algorithm for content encryption.
 */
@property (strong, nonatomic) NSString *enc;

/**
  Private key id.
  By default it is blank.
 */
@property (strong, nonatomic) NSString *kid;

/**
  Additional headers.
 */
@property (strong, nonatomic) NSDictionary *additionalHeaders;

/**
  Initializes a JWE header with blank values.
    alg = ""
    enc = ""
    kid = ""

 @return JWE header object
 */
- (id)init;

/**
  JSON string of the JWE header object.

 @return JSON string of the JWE header object with additional data.
 */
- (NSString *)jsonString;

/**
  Base64URL string of the JSON representaiton of th JWE header.

  @return Base64URL string of the JSON representaiton of th JWE header.
 */
- (NSString *)toBase64URLString;

@end
