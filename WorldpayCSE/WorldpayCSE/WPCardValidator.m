//
//  WPCardValidator.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file


#import "WPCardValidator.h"
#import "WPErrorCodes.h"
#import "NSString+WP.h"

NSString* const kMonthValidLenRegexPart = @"2";
NSString* const kYearValidLenRegexPart = @"4";
NSString* const kCardNumberValidLenRegexPart = @"12,20";

@implementation WPCardValidator

- (void)addError:(WPCardValidatorError)error
           toSet:(NSMutableSet *)errorsSet {
    
    if (error != WPCardValidatorErrorNone) {
        [errorsSet addObject:@(error)];
    }
}

- (NSSet *)validate:(WPCardData *)data {
    NSMutableSet *errorsSet = [[NSMutableSet alloc] init];
    
    WPCardValidatorError monthValidationError = [self validateMonth:data.expiryMonth];
    WPCardValidatorError yearValidationError = [self validateYear:data.expiryYear];

    [self addError:[self validateCvc:data.cvc]
             toSet:errorsSet];
    
    [self addError:[self validateCardNumber:data.cardNumber]
             toSet:errorsSet];

    [self addError:[self validateCardHolderName:data.cardHolderName]
             toSet:errorsSet];
    
    [self addError:monthValidationError
             toSet:errorsSet];

    [self addError:yearValidationError
             toSet:errorsSet];

    //validate date only if both month and year are valid
    if (monthValidationError == WPCardValidatorErrorNone &&
         yearValidationError == WPCardValidatorErrorNone) {
        [self addError:[self validateFutureDateMonth:data.expiryMonth
                                             andYear:data.expiryYear]
                 toSet:errorsSet];
    }
    
    return errorsSet;
}

- (BOOL)matchValue:(NSString *)value withRegexPattern:(NSString *)pattern {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
      regularExpressionWithPattern:pattern
                           options:NSRegularExpressionCaseInsensitive
                             error:&error];
    
    return (0 < [regex numberOfMatchesInString:value
                                      options:0
                                        range:NSMakeRange(0, [value length])]);
}

- (int)validateNumber:(NSString *)value withExpectedLength:(NSString *)length {
    if ([value isEmpty]) {
        return 1;
    }
    
    NSString *regex = [NSString stringWithFormat:@"^[0-9]{%@}$", length];
    if (![self matchValue:value withRegexPattern:regex]) {
        return 2;
    };
    
    return 0;
}

- (WPCardValidatorError)validateMonth:(NSString *)expiryMonth {
    //validate expiry Month
    int validNumber = [self validateNumber:expiryMonth
                        withExpectedLength:kMonthValidLenRegexPart];
    
    if (validNumber > 0) {
        return validNumber == 1 ? WPCardValidatorErrorEmptyExpiryMonth :
        WPCardValidatorErrorInvalidExpiryMonthValue;
    }
    
    int exMonth = [expiryMonth intValue];
    if (exMonth <= 0 || exMonth > 12) {
        return WPCardValidatorErrorInvalidExpiryMonthRange;
    }
    
    return WPCardValidatorErrorNone;
}

- (WPCardValidatorError)validateYear:(NSString *)expiryYear {
    //validate Expiry Year
    int validNumber = [self validateNumber:expiryYear
                                withExpectedLength:kYearValidLenRegexPart];
    
    if (validNumber > 0) {
        return validNumber == 1 ? WPCardValidatorErrorEmptyExpiryYear :
        WPCardValidatorErrorInvalidExpiryYearValue;
    }
    
    return WPCardValidatorErrorNone;
}


- (WPCardValidatorError)validateFutureDateMonth:(NSString *)expiryMonth
                                        andYear:(NSString *)expiryYear {
    int exMonth = [expiryMonth intValue];
    int exYear = [expiryYear intValue];
    
    if ([self isFutureDateMonth:exMonth
                        andYear:exYear]) {
        return WPCardValidatorErrorNone;
    }

    return WPCardValidatorErrorExpiryYearFromPast;
}

- (BOOL)isFutureDateMonth:(int)expiryMonth
                  andYear:(int)expiryYear {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    components.year = expiryYear;
    components.month = expiryMonth + 1;
    
    NSDate *expiryDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *nowDate = [NSDate date];
    
    //Expire just before midnight on the last day of the month
    NSTimeInterval expiryTime = [expiryDate timeIntervalSince1970] - 1;
    NSTimeInterval currentTime = [nowDate timeIntervalSince1970];

    return (expiryTime - currentTime) >= 0;
}

- (WPCardValidatorError)validateCardHolderName:(NSString *)cardHolderName {
    if (![cardHolderName isEmpty]) {
        if ([self matchValue:cardHolderName
            withRegexPattern:@"^.{1,30}$"]) {
            return WPCardValidatorErrorNone;
        }
        
        return WPCardValidatorErrorCardholderNameTooLong;
    }
    
    return WPCardValidatorErrorEmpyCardholderName;
}

- (WPCardValidatorError)validateCvc:(NSString *)cvc {
    if ([cvc isEmpty] ||
        [self matchValue:cvc
        withRegexPattern:@"^[0-9]{3,4}$"]) {
        return WPCardValidatorErrorNone;
    }
    
    return WPCardValidatorErrorInvalidSecurityCode;
}

- (WPCardValidatorError)validateCardNumber:(NSString *)cardNumber {
    int validationCode = [self validateNumber:cardNumber
                           withExpectedLength:kCardNumberValidLenRegexPart];
    
    if (validationCode == 0) {
        if ([self passesLuhnCheck:cardNumber]) {
            return WPCardValidatorErrorNone;
        }
        return WPCardValidatorErrorInvalidCardNumberLuhn;
    } else if (validationCode == 1) {
        return WPCardValidatorErrorEmptyCardNumber;
    }
    
    return WPCardValidatorErrorInvalidCardNumber;
}

- (BOOL)passesLuhnCheck:(NSString *)value {
    if ([value isEmpty]) {
        return NO;
    }
    
    NSData *number = [[value trimmed] dataUsingEncoding:NSUTF8StringEncoding];
    const char * array = number.bytes;
    
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    for (NSInteger i = [number length] - 1; i >= 0; i--) {
        
        if (!isdigit(array[i])) {
            return NO;
        }
        
        char buffer[2] = {array[i], '\0'};
        int digit = atoi(buffer);
        
        if (isOdd)
            oddSum += digit;
        else
            evenSum += digit/5 + (2*digit) % 10;
        
        isOdd = !isOdd;				 
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

@end
