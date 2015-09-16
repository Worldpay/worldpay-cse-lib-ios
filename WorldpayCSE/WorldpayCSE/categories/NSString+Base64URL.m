//
//  NSString+Base64URL.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 14/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "NSString+Base64URL.h"

@implementation NSString (Base64URL)

- (NSString *)base64StringToBase64URLString {
    NSString *base64StringURL = [self
                                 stringByReplacingOccurrencesOfString:@"/"
                                 withString:@"_"];
    base64StringURL = [base64StringURL
                       stringByReplacingOccurrencesOfString:@"+"
                       withString:@"-"];
    base64StringURL = [base64StringURL
                       stringByReplacingOccurrencesOfString:@"="
                       withString:@""];

    return base64StringURL;
}

- (NSString *)toBase64URLString {
    NSData *nsdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [nsdata base64EncodedStringWithOptions:0];

    return [base64String base64StringToBase64URLString];
}

@end
