//
//  WPAESEncrypter.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 22/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import "WPAESEncrypter.h"
#import "AESGCM.h"

@interface WPAESEncrypter()

/// AES secret key
@property (strong, nonatomic) NSData *key;

/// AES authentication tag
@property (strong, nonatomic) NSData *authenticationTag;

/// AES IV vector
@property (strong, nonatomic) NSData *initializationVect;

/// AES aad data
@property (strong, nonatomic) NSData *aad;

@end

@implementation WPAESEncrypter

- (id)initWithKey:(NSData *)key
           withIV:(NSData *)initializationVect
           andAad:(NSData *)aad {
    self = [super init];
    
    self.authenticationTag = nil;
    self.key = key;
    self.initializationVect = initializationVect;
    self.aad = aad;
    
    return self;
}

- (NSData *)encrypt:(NSData *)data error:(NSError * __autoreleasing *)error {
    self.authenticationTag = nil;
    NSError *localError = nil;
    NSData *authTag = nil;
    NSData *result = [AESGCM encrypt:data
                       withSecretKey:self.key
                              withIV:self.initializationVect
                        withAuthData:self.aad
                          andAuthTag:&authTag
                               error:&localError];
    
    if (error) {
        *error = localError;
    }
    
    self.authenticationTag = authTag;
    
    return result;
}

- (NSData *)getAuthenticationTag {
    return self.authenticationTag;
}

- (id)getKey {
    return self.key;
}

@end
