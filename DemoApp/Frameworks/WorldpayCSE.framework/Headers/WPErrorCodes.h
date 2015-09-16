//
//  WPErrorCodes.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 16/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#ifndef WorldpayCSE_WPErrorCodes_h
#define WorldpayCSE_WPErrorCodes_h

/**
 Various error codes used during encryption.
 */
typedef NS_ENUM(NSUInteger, WPErrorCode){
    /// Could not allocate buffer for crypto operations
    WPErrorBufferAlloc = 9000,
    
    /// Error during AES encryption
    WPErrorAESEncrypt,
    
    //// Could not allocate AES context
    WPErrorAESCTXAlloc,
    
    /// Invalid RSA Public key
    WPErrorRSAInvalidPublicKey,
    
    /// Error during RSA encryption
    WPErrorRSAEncrypt,
    
    /// Could not generate a random key
    WPErrorRandKeyGenError,
    
    /// Could not validate card data
    WPErrorInvalidCardData
};

/**
 Various error codes related to `WPCardData` validation.
 */
typedef NS_ENUM(NSUInteger, WPCardValidatorError){
    ///  No error
    WPCardValidatorErrorNone = 0,
    
    /// Credit card number is mandatory
    WPCardValidatorErrorEmptyCardNumber = 101,

    /// Enter a valid credit card number, numbers only and should be between 12 and 20 digits.
    WPCardValidatorErrorInvalidCardNumber = 102,

    /// Enter a valid credit card number, input doesn't verify Luhn check
    WPCardValidatorErrorInvalidCardNumberLuhn = 103,

    /// Enter a valid security code, numbers only and should be between 3 and 4 digits
    WPCardValidatorErrorInvalidSecurityCode = 201,

    /// Expiry month is mandatory
    WPCardValidatorErrorEmptyExpiryMonth = 301,

    /// Enter a valid expiry month, only numbers expected.
    WPCardValidatorErrorInvalidExpiryMonthValue = 302,

    /// Enter a valid expiry month, should range from 01 to 12
    WPCardValidatorErrorInvalidExpiryMonthRange = 303,

    /// Expiry year is mandatory
    WPCardValidatorErrorEmptyExpiryYear = 304,

    /// Enter a valid expiry year, only numbers expected
    WPCardValidatorErrorInvalidExpiryYearValue = 305,

    /// Expiry date should be in future
    WPCardValidatorErrorExpiryYearFromPast = 306,

    /// Card holder's name is mandatory
    WPCardValidatorErrorEmpyCardholderName = 401,

    /// Name should not exceed thirty characters
    WPCardValidatorErrorCardholderNameTooLong = 402
};


#endif
