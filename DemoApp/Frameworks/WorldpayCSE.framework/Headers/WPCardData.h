//
//  WPPayload.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
  Payment card object that holds sensitive information.
 */
@interface WPCardData : NSObject

/**
  Payment card number (e.g. PAN)
 */
@property (strong, nonatomic) NSString *cardNumber;

/**
  Payment card CVC code
 */
@property (strong, nonatomic) NSString *cvc;

/**
  Payment card expiry month (e.g. 01, 02, .., 10, 11, 12)
 */
@property (strong, nonatomic) NSString *expiryMonth;

/**
  Payment card expiry year (e.g. 2018)
 */
@property (strong, nonatomic) NSString *expiryYear;

/**
  Cardholder name (e.g. John Doe)
 */
@property (strong, nonatomic) NSString *cardHolderName;

/**
  JSON string of the CardData object.
 *
  @return JSON string of the CardData object.
 */
- (NSString *)jsonString;

/**
 *  The default init method. It initializes all values to blank.
 *
 *  @return a valid instance of WPCardData
 */
- (id)init;
@end
