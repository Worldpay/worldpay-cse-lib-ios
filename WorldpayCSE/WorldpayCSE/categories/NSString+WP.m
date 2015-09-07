//
//  NSString+WP.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 24/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import "NSString+WP.h"

@implementation NSString (WP)

- (NSString *)trimmed {
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)isEmpty {
    return ([self trimmed].length == 0);
}
@end
