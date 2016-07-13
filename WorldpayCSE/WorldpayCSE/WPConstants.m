//
//  Constants.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

NSString* const kWPPublicKeyComponentsSeparator = @"#";

NSString* const kWPJWEHeaderLibraryVersionValue = @"1.0.3";
NSString* const kWPJWEHeaderApiVersionValue = @"1.0";
NSString* const kWPJWEHeaderChannelValue = @"ios";

NSString* const kWPJWEHeaderLibraryVersion = @"com.worldpay.libVersion";
NSString* const kWPJWEHeaderApiVersion = @"com.worldpay.apiVersion";
NSString* const kWPJWEHeaderChannelVersion = @"com.worldpay.channel";

NSString* const kWPJWEHeaderDefaultAlgValue = @"RSA1_5";
NSString* const kWPJWEHeaderDefaultEncValue = @"A256GCM";

NSString* const kWPJWEHeaderAlg = @"alg";
NSString* const kWPJWEHeaderEnc = @"enc";
NSString* const kWPJWEHeaderKid = @"kid";

NSString* const kWPOpenSSLErrorTitle = @"OpenSSL error: ";
NSString* const kWPErrorDomain = @"Worldpay";
NSString* const kWPErrorDetailsKey = @"Details";

NSString* const kWPErrorRSAInvalidPublicKeyMessage = @"Invalid RSA Pulic Key";
NSString* const kWPErrorBufferAllocMessage = @"Failed to alloc buffer";
NSString* const kWPKeyGenErrorMessage = @"Failed generate a random key";

NSString* const kWPCardDataNilMessage = @"Card data should not be nil!";

NSString* const kWPCardNumber = @"cardNumber";
NSString* const kWPCVC = @"cvc";
NSString* const kWPExpiryMonth = @"expiryMonth";
NSString* const kWPExpiryYear = @"expiryYear";
NSString* const kWPCardHolderName = @"cardHolderName";
