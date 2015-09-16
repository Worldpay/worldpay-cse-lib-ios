//
//  NSString+WP.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 24/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This category is used to trim an `NSString` and to check whether the string is empty.
 */

@interface NSString (WP)

/**
 Returns the trimmed string
 
 @return Returns the trimmed string
 */
- (NSString *)trimmed;

/**
 Returns `YES` if the string is empty, and `NO` otherwise
 
 @return  Returns `YES` if the string is empty, and `NO` otherwise.
 */
- (BOOL)isEmpty;
@end
