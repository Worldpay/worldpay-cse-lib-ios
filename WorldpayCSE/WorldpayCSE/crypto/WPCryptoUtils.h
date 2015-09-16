//
//  WPCryptoUtils.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 14/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
 This is a utility class for getting OpenSSL errors and allocating s
 ecurely buffers.
 */
@interface WPCryptoUtils : NSObject

/**
 *  Returns OpenSSL errors created by a failed openssl operation.
 */
+ (NSString *)getOpenSSLError;

/**
 *  Allocates an array of count size, and it initializes with '\0'.
 *
 *  @param count count number of bytes to allocate
 *  @param error debug information on failure
 *
 *  @return a valid array if successful,
 *          nil if it fails to allocate memory
 */
+ (unsigned char*)allocBufferOfSize:(unsigned long)count
                              error:(NSError * __autoreleasing *)error;

@end
