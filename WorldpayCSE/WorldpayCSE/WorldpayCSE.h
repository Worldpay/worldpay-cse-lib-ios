//
//  WorldpayCSE.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

#import "WPPublicKey.h"
#import "WPCardData.h"
#import "WPErrorCodes.h"
#import "WPConstants.h"

/**
   Worldpay Client Side Encryption class.
   Is the main entry point of the Worldpay CSE SDK.
 
   This class is used to encrypt the provided `WPCardData` payload.
    
   Objective C example usage:
 
 @code
 
     NSError *error = nil;
     
     WorldpayCSE *wpCSE = [WorldpayCSE new];
     
     // set public key
    [wpCSE setPublicKey:@"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054"
                         "c07fa73cf86cd78d141f923cff2fb70afb40be36ec78c7a334ef2"
                         "3451c34cc8df03c2f496cd7f4fcccfd35aba72417c859d7e5e960"
                         "a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89d0"
                         "65fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a"
                         "0dd0dc4f2be8a669b48eb247a1df5d94d921435af66588568999e"
                         "6a984152c53af211aab64edcd94a0ce1aceb66c50c0d3c074bac3"
                         "0d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b715555dc0"
                         "8ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc"
                         "6e777a558d802381488c24a74cff4fcce3104e727ede3"
              error:&error];

     if (error != nil) {
        //handle error
     }
     
     // set card data
     WPCardData *cardData = [WPCardData new];
     cardData.cardNumber = @"4444333322221111";
     cardData.cvc = @"123";
     cardData.expiryMonth = @"11";
     cardData.expiryYear = @"2020";
     cardData.cardHolderName = @"John Doe";

     // encrypt card data and validate
     NSString *encryptedData = [wpCSE encrypt:cardData error:&error];
     
     // handle error
     if (error) {
        if (error.code == WPErrorInvalidCardData) {
            NSArray *cardValidationErrors = error.userInfo[kWPErrorDetailsKey];
            // process errors
        }
     }
 
 @endcode
 
 Swift 2.0 example usage:
 
 @code
 
     // set card data
     let cardData : WPCardData = WPCardData()
     cardData.cardNumber = "4444333322221111"
     cardData.cvc = "123"
     cardData.expiryMonth = "11"
     cardData.expiryYear = "2020"
     cardData.cardHolderName = "John Doe"
     
     let wpCSE : WorldpayCSE = WorldpayCSE()
     
     do {
         // set public key
         try wpCSE.setPublicKey(
             "1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054c07fa73cf86cd78d1" +
             "41f923cff2fb70afb40be36ec78c7a334ef23451c34cc8df03c2f496cd7f4fcccfd35a" +
             "ba72417c859d7e5e960a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89" +
             "d065fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a0dd0dc4f2be8a66" +
             "9b48eb247a1df5d94d921435af66588568999e6a984152c53af211aab64edcd94a0ce1" +
             "aceb66c50c0d3c074bac30d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b71555" +
             "5dc08ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc6e777a558d802" +
             "381488c24a74cff4fcce3104e727ede3", error: ())
     
          // encrypt card data and validate
          let encryptedData = try wpCSE.encrypt(cardData)
 
     } catch let error as NSError {
         // handle error
         let errorCode = WPErrorCode(rawValue: (UInt)(error.code))
         if errorCode == WPErrorCode.InvalidCardData {
             let cardValidationErrors = error.userInfo[kWPErrorDetailsKey];
             // handle card validation errors
         }
     }
 
 @endcode

 
*/
@interface WorldpayCSE : NSObject

/**
 
 Sets the RSA public key.
 
 The RSA public key must be provided in the Worldpay format:
 sequenceId#exponent#modulus.
 
 sequenceId - keySequenceId used by Worldpay to match their private key
 
 exponent - RSA key public exponent
 
 modulus - RSA key modulus
 
 An example of a public key:
 
 @code
 
     NSString *publicKeyString = @"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054"
     "c07fa73cf86cd78d141f923cff2fb70afb40be36ec78c7a334ef2"
     "3451c34cc8df03c2f496cd7f4fcccfd35aba72417c859d7e5e960"
     "a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89d0"
     "65fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a"
     "0dd0dc4f2be8a669b48eb247a1df5d94d921435af66588568999e"
     "6a984152c53af211aab64edcd94a0ce1aceb66c50c0d3c074bac3"
     "0d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b715555dc0"
     "8ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc"
     "6e777a558d802381488c24a74cff4fcce3104e727ede3";

  @param publicKey    RSA public key
  @param error        Error on failure
  @return YES if successful, NO on failure
 */
- (BOOL)setPublicKey:(NSString *)publicKey
               error:(NSError * __autoreleasing *)error;

/**
  Sets the RSA public key

  @param publicKey rsaPublicKey
 */
- (void)setPublicKey:(WPPublicKey *)publicKey;

/**
  Current RSA public key.

  @return Current RSA public key.
 */
- (WPPublicKey *)getPublicKey;

/**
 
 Validates and encrypts the supplied card data.

 Encrypted data example:
 `ewogICJlbmMiIDogIkEyNTZHQ00iLAogICJraWQiIDogIjEiLAogICJjb20ud29ybGRwYXkubGliVmVyc2lvbiIgOiAiMS4wLjAiLAogICJjb20ud29ybGRwYXkuYXBpVmVyc2lvbiIgOiAiMS4wIiwKICAiY29tLndvcmxkcGF5LmNoYW5uZWwiIDogImlvcyIsCiAgImFsZyIgOiAiUlNBMV81Igp9.H9EgXsIrwJTVqDjzrlb-iC3NOze26eENHE7k7TAuUMO-In7noswlXcBWqGKc5BZv4A_NtgOIdI4Vik9n0vCCVGnyMAOQUZZerFjrfp4P6D-Jji1f9mvqcrmaerqC-CR1pmM95enlggRT9qWQayv5YDmgNSM35XwEdJtvij1ncNIRfTLLgSabSvIgZhN8fQPIzc_SMatdWCXGZY5nODXANPIHLcy4fTMCQinmBrcxKUpW2Fst7kdbBeKoqxw9_BMqdNjuBgE-7YTyVjpontKd5h_NYJh-0n15gOu8GxdJdaE9jxX1ObVzU8KK06ZTnrdUxqjJb5iNLBv8n4oDbWP3Xw.ouWEaXmofNKXothi.td7Lz2ry7e5TuVbY4u8sIo4Fzj1HmVjl-gxKEq_SKykVPcV8FsAYksZcKap7KN5JpF0sCWTS1jC8Qk-btH9_ojD_w2WzF_7joxh48wBHdnZuDqbXFhAqf7ynIehxGsjCoJaZzAqcVL8Kqu-FmHomLvkOEPvvcIUMztkq57WDenObtTTXcgfp_uf-nDykpxGf991hE6c.doGZ0C-oeWvCWbUILDkB5A`
 
  @param cardData CardData object to encrypt
  @param error    Error on failure

  @return JWE compact string.
 */
- (NSString *)encrypt:(WPCardData *)cardData  error:(NSError * __autoreleasing *)error;

/**
 Validates the payment card field values and returns a set of `WPCardValidatorError` error codes.
 If the card data is invalid, it returns the set of errors, otherwise an empty set.
 
 @see For a list of possible error codes please see `WPCardValidatorError`
 @param data       card data

 @return a set of erros. If no errors, an empty set
 */
+ (NSSet *)validate:(WPCardData *)data;

@end
