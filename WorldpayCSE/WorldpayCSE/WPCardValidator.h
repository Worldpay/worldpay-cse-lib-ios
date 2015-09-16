//
//  WPCardValidator.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file


#import <Foundation/Foundation.h>

/**
 
 Card data field validator
 The following is list of error codes `WPCardValidatorError` mapped to their meanings which would be provided back to the caller application.
 WPCardValidatorErrorEmptyCardNumber - Credit card number is mandatory.
 WPCardValidatorErrorInvalidCardNumber - Enter a valid credit card number, numbers only and should be between 12 and 20 digits.
 WPCardValidatorErrorInvalidCardNumberLuhn - Enter a valid credit card number, input doesn't verify Luhn check.
 WPCardValidatorErrorInvalidSecurityCode - Enter a valid security code, numbers only and should be between 3 and 4 digits.
 WPCardValidatorErrorEmptyExpiryMonth - Expiry month is mandatory.
 WPCardValidatorErrorInvalidExpiryMonthValue - Enter a valid expiry month; only numbers expected and in XX form (e.g. 09).
 WPCardValidatorErrorInvalidExpiryMonthRange - Enter a valid expiry month, should range from 01 to 12.
 WPCardValidatorErrorEmptyExpiryYear - Expiry year is mandatory.
 WPCardValidatorErrorInvalidExpiryYearValue - Enter a valid expiry year, only numbers expected.
 WPCardValidatorErrorExpiryYearFromPast - Expiry date should be in future.
 WPCardValidatorErrorEmpyCardholderName - Card holder's name is mandatory.
 WPCardValidatorErrorCardholderNameTooLong - Name should not exceed thirty characters.
 */
#import "WPCardData.h"

@interface WPCardValidator : NSObject

/**
 Validates the card data and 
 If the NSError instance code is `WPErrorInvalidCardData` then it will return
 a set of `WPCardValidatorError` error codes.
 If validation was successful, it will return an empty set.
 
 @return a set of `WPCardValidatorError` error codes.
 */
- (NSSet *)validate:(WPCardData *)data;

@end
