//
//  WPJWEHeader.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPJWEHeader.h"
#import "WPConstants.h"
#import "WPErrorCodes.h"
#import "NSError+WP.h"
#import "NSString+Base64URL.h"
#import "NSDictionary+JSON.h"

extern NSString* const kWPJWEHeaderAlg;
extern NSString* const kWPJWEHeaderEnc;
extern NSString* const kWPJWEHeaderKid;


@implementation WPJWEHeader

- (id)init {
    self = [super init];
    
    self.alg = @"";
    self.enc = @"";
    self.kid = @"";
    self.additionalHeaders = nil;
    
    return self;
}

- (NSString *)jsonString {
    NSDictionary *defaultHeaders = @{
                                        kWPJWEHeaderAlg : self.alg,
                                        kWPJWEHeaderEnc : self.enc,
                                        kWPJWEHeaderKid : self.kid,
                                    };
    
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithDictionary:defaultHeaders];
    
    if (self.additionalHeaders) {
        [headers addEntriesFromDictionary:self.additionalHeaders];
    }
    

    return [headers jsonString];
}

- (NSString *)toBase64URLString {
    return [[self jsonString] toBase64URLString];
}


@end
