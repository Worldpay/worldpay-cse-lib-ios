//
//  NSDictionary+JSON.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This category is used to serialize an `NSDictionary` to a JSON string.
 */
@interface NSDictionary (JSON)

/**
  Converts the NSDictionary to a JSON NSString.
 
  @return A JSON string. If it fails to convert the data to JSON, it returns an empty NSString.
 */
- (NSString *)jsonString;

@end
