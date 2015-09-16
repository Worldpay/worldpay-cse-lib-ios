//
//  NSData+Base64URL.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "NSData+Base64URL.h"
#import "NSString+Base64URL.h"

@implementation NSData (Base64URL)

- (NSString *)toBase64URLString {
    NSString *base64String = [self base64EncodedStringWithOptions:0];
    NSString *base64URLString = [base64String base64StringToBase64URLString];
    return base64URLString;
}

@end
