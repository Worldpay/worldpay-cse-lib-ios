//
//  WPPublicKey.h
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <Foundation/Foundation.h>

/**
  RSA public key used for encryption.
 
  The accepted string format for this key is: sequenceId#exponent#modulus.
 
  sequenceId - keySequenceId used by Worldpay to match their private key
 
  exponent - RSA key public exponent
 
  modulus - RSA key modulus
 
  An example of a public key:
 
 `1#10001#bf49edcaba456c6357e4ace484c3fba212543e78bf72a8c2238caaa1
 c7ed20262956caa61d74840598d9b0707bc82e66f18c8b369c77ae6be0429c93
 323bb7511fc73d9c7f698872a8384370cd77c7516caa25a195d48701e3e0462d
 61200983ba26cc4a20bb059d5beda09270ea6dcf15dd92084c4d5867b6098615
 1717a8022e4054462ee74ab8533dda77cee227a49fdaf58eaeb95df90cb8c05e
 e81f58bec95339b6262633aef216f3ae503e8be0650350c48859eef406e63d43
 99994b147e45aaa14cf9936ac6fdd7d4ec5e66b527d041750ba63a8296b3e6e7
 74a02ee6025c6ee66ef54c3688e4844be8951a8435e6b6e8d6763d9ee5f16521577e159d`
 */
@interface WPPublicKey : NSObject

/**
  RSA keySequenceId used to match the private key when decrypting.
 */
@property (strong, nonatomic) NSString *sequenceId;

/**
  RSA key exponent
 */
@property (strong, nonatomic) NSString *exponent;

/**
  RSA key public modulus
 */
@property (strong, nonatomic) NSString *modulus;

/**
  Creates an RSA public key by parsing the accepted string format:
  sequenceId#exponent#modulus.
 
 sequenceId - keySequenceId used by Worldpay to match their private key
 
 exponent - RSA key public exponent
 
 modulus - RSA key modulus
 
 An example of a public key:
 
 `1#10001#bf49edcaba456c6357e4ace484c3fba212543e78bf72a8c2238caaa1
 c7ed20262956caa61d74840598d9b0707bc82e66f18c8b369c77ae6be0429c93
 323bb7511fc73d9c7f698872a8384370cd77c7516caa25a195d48701e3e0462d
 61200983ba26cc4a20bb059d5beda09270ea6dcf15dd92084c4d5867b6098615
 1717a8022e4054462ee74ab8533dda77cee227a49fdaf58eaeb95df90cb8c05e
 e81f58bec95339b6262633aef216f3ae503e8be0650350c48859eef406e63d43
 99994b147e45aaa14cf9936ac6fdd7d4ec5e66b527d041750ba63a8296b3e6e7
 74a02ee6025c6ee66ef54c3688e4844be8951a8435e6b6e8d6763d9ee5f16521577e159d`
 
 Possible error codes:
 
 `WPErrorRSAInvalidPublicKey` - invalid key format

 
  @param publicKey public key in format sequenceId#exponent#modulus (e.g. 1#324324324875757567#9873495877678634875634)
  @param error     error information when this initWithString method returns nil

  @return if successfully parsed, an RSAPublicKey instance is returned, otherwise nil.
 */
+ (id)parseKey:(NSString*)publicKey
         error:(NSError * __autoreleasing *)error;
@end
