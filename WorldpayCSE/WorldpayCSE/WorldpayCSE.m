//
//  WorldpayCSE.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 13/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WorldpayCSE.h"
#import "WPCardData.h"
#import "WPJWEObject.h"
#import "WPRSAEncrypter.h"
#import "WPJWEHeader.h"
#import "NSError+WP.h"
#import "WPConstants.h"
#import "WPCardValidator.h"

extern NSString* const kWPJWEHeaderDefaultAlgValue;
extern NSString* const kWPJWEHeaderDefaultEncValue;

extern NSString* const kWPJWEHeaderApiVersion;
extern NSString* const kWPJWEHeaderLibraryVersion;
extern NSString* const kWPJWEHeaderChannelVersion;

extern NSString* const kWPCardDataNilMessage;


@interface WorldpayCSE()

/// RSA public key
@property (strong, nonatomic) WPPublicKey *rsaPublicKey;

/// JWE header
@property (strong, nonatomic) WPJWEHeader *jweHeader;

/// JWE object
@property (strong, nonatomic) WPJWEObject *jweObject;

@end

@implementation WorldpayCSE

- (void)setPublicKey:(WPPublicKey *)publicKey {
    self.rsaPublicKey = publicKey;
}

- (BOOL)setPublicKey:(NSString *)publicKey
                           error:(NSError * __autoreleasing *)error {
    NSError *localError = nil;
    WPPublicKey *newPublicKey = [WPPublicKey parseKey:publicKey
                                                error:&localError];
    
    if (newPublicKey) {
        self.rsaPublicKey = newPublicKey;
        return YES;
    }
    
    if (error) {
        *error = localError;
    }
    return NO;
}

- (WPPublicKey *)getPublicKey {
    return self.rsaPublicKey;
}

- (NSString *)encrypt:(WPCardData *)cardData error:(NSError	* __autoreleasing *)error {
    NSError *localError = nil;
    NSData *jsonPayload = [[cardData jsonString] dataUsingEncoding:NSUTF8StringEncoding];
    
    //validate cardData
    NSSet *errors = [WorldpayCSE validate:cardData];
    if (errors.count > 0) {
        if (error) {
            *error = [NSError invalidCardDataErrorWithSet:errors];
        }
        return nil;
    }
    
    //check that public key is set
    if (self.rsaPublicKey == nil) {
        if (error) {
            *error = [NSError rsaInvalidKey];
        }
        return nil;
    }
    
    //encrypt data
    self.jweHeader = [[WPJWEHeader alloc] init];
    self.jweHeader.alg = kWPJWEHeaderDefaultAlgValue;
    self.jweHeader.enc = kWPJWEHeaderDefaultEncValue;
    self.jweHeader.kid = self.rsaPublicKey.sequenceId;
    self.jweHeader.additionalHeaders = @{
        kWPJWEHeaderApiVersion : kWPJWEHeaderApiVersionValue,
        kWPJWEHeaderLibraryVersion : kWPJWEHeaderLibraryVersionValue,
        kWPJWEHeaderChannelVersion : kWPJWEHeaderChannelValue
        };

    self.jweObject = [[WPJWEObject alloc] initWithHeader:self.jweHeader
                                             withPayload:jsonPayload];
    [self.jweObject setPublicKey:self.rsaPublicKey];
    [self.jweObject encrypt:&localError];
    
    if (localError) {
        if (error) {
            *error = localError;
        }
        return nil;
    }
    
    return [self.jweObject serialize];
}

+ (NSSet *)validate:(WPCardData *)data {
    NSAssert(data != nil, kWPCardDataNilMessage);

    WPCardValidator *cardValidator = [WPCardValidator new];

    return [cardValidator validate:data];
}
@end
