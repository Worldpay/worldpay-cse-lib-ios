//
//  WPPayload.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPCardData.h"
#import "WPConstants.h"
#import "WPErrorCodes.h"
#import "NSError+WP.h"
#import "NSDictionary+JSON.h"

extern NSString* const kWPCardNumber;
extern NSString* const kWPCVC;
extern NSString* const kWPExpiryMonth;
extern NSString* const kWPExpiryYear;
extern NSString* const kWPCardHolderName;

@implementation WPCardData


- (id)init {
    self = [super init];
    
    self.cardNumber = @"";
    self.cvc = @"";
    self.expiryMonth = @"";
    self.expiryYear = @"";
    self.cardHolderName = @"";
    
    return self;
}

- (NSString *)jsonString {
    NSDictionary *dict = @{kWPCardNumber : self.cardNumber,
                           kWPCVC : self.cvc,
                           kWPExpiryMonth : self.expiryMonth,
                           kWPExpiryYear : self.expiryYear,
                           kWPCardHolderName : self.cardHolderName};
    
    return [dict jsonString];
}

@end
