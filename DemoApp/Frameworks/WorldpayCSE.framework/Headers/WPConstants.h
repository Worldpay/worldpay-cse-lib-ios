//
//  Constants.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#ifndef WorldpayCSE_Constants_h
#define WorldpayCSE_Constants_h

//additional JWE headers

/**
 Library version (e.g. 1.0.0)
 */
extern NSString* const kWPJWEHeaderLibraryVersionValue;

/**
 Supported API version (e.g. 1.0)
 */
extern NSString* const kWPJWEHeaderApiVersionValue;

/**
  Channel value (e.g. ios, android, javascript)
 */
extern NSString* const kWPJWEHeaderChannelValue;

/**
   The CSE SDK  NSError error domain
 */
extern NSString* const kWPErrorDomain;

/**
  The CSE SDK  NSError userInfo key
 */
extern NSString* const kWPErrorDetailsKey;

#endif
