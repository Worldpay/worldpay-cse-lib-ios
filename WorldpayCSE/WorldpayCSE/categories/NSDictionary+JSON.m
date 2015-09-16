//
//  NSDictionary+JSON.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 15/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSString *)jsonString {
    NSError *error = nil;
    NSString *jsonString = @"";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData
                                           encoding:NSUTF8StringEncoding];
    }

    return jsonString;
}

@end
