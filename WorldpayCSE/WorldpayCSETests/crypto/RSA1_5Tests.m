//
//  RSA1_5Tests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <openssl/rsa.h>
#import <openssl/err.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import <openssl/evp.h>
#import <openssl/aes.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "WPPublicKey.h"
#import "WPPrivateKey.h"
#import "NSError+WP.h"
#import "RSA1_5.h"
#import "WPCryptoUtils.h"

static NSString const *kPrivateKey =
@"-----BEGIN RSA PRIVATE KEY-----\n"\
"MIIEpAIBAAKCAQEAzMosTvgL5/epjV4O735ebq/nAO8FTAf6c8+GzXjRQfkjz/L7\n"\
"cK+0C+Nux4x6M07yNFHDTMjfA8L0ls1/T8zP01q6ckF8hZ1+XpYKXRZnAQu22dh7\n"\
"Etg2QFpfsRuii7Ol6Y4cidBl/EfenRG/rAU7PWVQIHdSck2fox7CJV1JUqDdDcTy\n"\
"vopmm0jrJHod9dlNkhQ1r2ZYhWiZnmqYQVLFOvIRqrZO3NlKDOGs62bFDA08B0us\n"\
"MNbwuoGjZ6A8O5TxemuJbTQ2Ddf0WbcVVV3Ajs4R/EUf/iagiakxIqaZlY0quKTa\n"\
"TSWGR0/G53elWNgCOBSIwkp0z/T8zjEE5yft4wIDAQABAoIBAQCNYaJXXn3xxpSi\n"\
"yWXsR8TwC7aieWGhzPxGieZZ4mgtcNAdl3WppVPaxUhMsZoH5B/oqO35C9CTazur\n"\
"BPI46IAuPTvs93L9V+7PZCyBeZ7hJPI20XKeXvCNWxcnUZnVctA/PuJK7roKAqAY\n"\
"thEqtG3ihBheYaJk0Vw9pFWKsC2XwcM1tNyUj4/9014e6zgNBQ9kEHxgcjbU1koG\n"\
"wmyznYvlgGWwQluadAoWMRIkyBubRxTJ+T/lVxo5/uAx2Kh62gqXuVu+W4KZSJPC\n"\
"AcWN7gF428+rQaj8Wr6zqm85I1mW31N8PsWxyo4ZOquu7wdvGFJaAa9jctpM6nsz\n"\
"xrrREpmBAoGBAP1X4DyDz2l8EjSCwZF/NXL0ZJixf/vibi88btU7Lqb4xz/GCUNS\n"\
"0ZhhJuVnKBMV5n3tcB3J+B3Rgco6zKAxMRLtZaKD1T+NuANvj3064b+RkVaJo0Ts\n"\
"YtEioBODKrG95W1nzLGH4cub1nXK77ohFJHh/Kfs8SZ6dHz5hEgXvn/BAoGBAM7v\n"\
"81pz8bR4TcsEJC692K5hXxuHkaoYc10QN0bOYop6+QcWPB8vY7skIfsdDSUm+3x0\n"\
"or6CWgrbUr/frH5MfwgCTGYp3EAF1eqHb2F4fvX06xJfXsoCm8AoQ5kp/CixsKHK\n"\
"qVVTJS/9zOGu8mEWGWZJItR/feGamYY9aucCYhajAoGBAJaPNvA/1W/3EEqsuqTh\n"\
"WL5sh6xHMKxdMOZZn/SRK3SHvMIlyzN7cJyCgD8tQx+0kDqedVb+xLnT3LJ2p008\n"\
"btG0zAX9Gyqd6pIAJuJhr+/NbvZi7ej0IvXvAfsWpLTlCggu+/M1sfbzMkzmwfl3\n"\
"12WrTB/wLJCVjc0H7Jl7ovcBAoGAKIfOvhSfbp1xfyXcgFsmqWDg4991pD8NuViH\n"\
"uxKJMl5LkBvGwsThX7IABdL21CQCdanShkW5pQ638mS4wDPzXXo1xHzGarO55imI\n"\
"oyqak0nZEMwlIKPKJaS9OK6EeOP0mHu9Fr0mN3QaQMmnJ2TQrLv+WmhuG1XQY/57\n"\
"hatt0skCgYBH1xvwhsusgmsrCXUca0rIE62vDGz3u/KcNTOyeLVJZBTWTCkWWCOZ\n"\
"M3RKOCXAgJz9S0j+k8ZfXu55lzvOG53uNhbYP38QvxYKBZdoZSuONymsSJ6LjaRH\n"\
"pXm70D4CGxEjh3NHOHQKdXmu3/H8TXEizUURQlkgmrO9MOSdlnQHPw==\n"\
"-----END RSA PRIVATE KEY-----";

static NSString const *kPublicKeyIdModulusExponent =
            @"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054"
            "c07fa73cf86cd78d141f923cff2fb70afb40be36ec78c7a334ef2"
            "3451c34cc8df03c2f496cd7f4fcccfd35aba72417c859d7e5e960"
            "a5d1667010bb6d9d87b12d836405a5fb11ba28bb3a5e98e1c89d0"
            "65fc47de9d11bfac053b3d6550207752724d9fa31ec2255d4952a"
            "0dd0dc4f2be8a669b48eb247a1df5d94d921435af66588568999e"
            "6a984152c53af211aab64edcd94a0ce1aceb66c50c0d3c074bac3"
            "0d6f0ba81a367a03c3b94f17a6b896d34360dd7f459b715555dc0"
            "8ece11fc451ffe26a089a93122a699958d2ab8a4da4d2586474fc"
            "6e777a558d802381488c24a74cff4fcce3104e727ede3";

static const unsigned char kSecretKey[] = {
    0xee, 0xbc, 0x1f, 0x57, 0x48, 0x7f, 0x51, 0x92, 0x1c, 0x04, 0x65, 0x66,
    0x5f, 0x8a, 0xe6, 0xd1, 0x65, 0x8b, 0xb2, 0x6d, 0xe6, 0xf8, 0xa0, 0x69,
    0xa3, 0x52, 0x02, 0x93, 0xa5, 0x72, 0x07, 0x8f
};

static const unsigned char kEncryptedSecretKey[] = {
    0x12, 0x4a, 0xb2, 0xe4, 0x59, 0x7d, 0x54, 0xaf, 0x09, 0x1a, 0x66, 0x0b,
    0xd5, 0x9c, 0x29, 0x54, 0xd5, 0x0b, 0xca, 0x49, 0xf8, 0xfb, 0x7a, 0xc7,
    0x80, 0x5b, 0x1d, 0x84, 0x67, 0x1c, 0x74, 0x88, 0x6f, 0x03, 0x3e, 0x58,
    0xbf, 0x90, 0x00, 0x02, 0x3f, 0xa6, 0xdf, 0x97, 0xa6, 0xfb, 0x51, 0x1f,
    0x85, 0xc7, 0xe0, 0xd6, 0x91, 0xe4, 0xba, 0x51, 0xd4, 0xb4, 0x76, 0x13,
    0x33, 0x73, 0x21, 0x51, 0xe3, 0xa9, 0x51, 0x0e, 0x8c, 0x4d, 0xf5, 0xa2,
    0x46, 0xef, 0xa0, 0x29, 0x07, 0xa8, 0x2a, 0xc5, 0x58, 0xd6, 0x58, 0xf1,
    0xb0, 0xc0, 0xbf, 0x5f, 0xbb, 0xb7, 0x84, 0x75, 0x14, 0x8f, 0xc8, 0xd4,
    0xc4, 0x7d, 0xfa, 0x40, 0xda, 0xd5, 0x95, 0xe1, 0xdf, 0x24, 0x0d, 0xed,
    0xbc, 0x38, 0x38, 0x50, 0x51, 0xad, 0x6f, 0xc7, 0x36, 0x94, 0x7e, 0xec,
    0xad, 0x05, 0x77, 0x83, 0x85, 0xfd, 0x4f, 0x8b, 0xfe, 0x5a, 0xa8, 0xfc,
    0xc0, 0x39, 0x90, 0xcf, 0xda, 0x00, 0x68, 0x11, 0xcd, 0xfc, 0x9a, 0x24,
    0xcd, 0xaa, 0x32, 0x0b, 0x94, 0x71, 0x2c, 0xab, 0x30, 0x29, 0xa4, 0x52,
    0x71, 0x12, 0x0f, 0x9f, 0xdf, 0x54, 0x40, 0xdc, 0x6a, 0x1d, 0x35, 0x15,
    0x55, 0x47, 0x2a, 0x64, 0x81, 0x55, 0x15, 0x3b, 0x8c, 0x18, 0x93, 0xbb,
    0x0e, 0x40, 0xb8, 0x16, 0xe5, 0x93, 0x4f, 0xc4, 0x09, 0xa1, 0x69, 0xd9,
    0x86, 0x14, 0xa4, 0x6c, 0x07, 0xb3, 0x97, 0x31, 0xcf, 0x57, 0xe8, 0x34,
    0x62, 0xe5, 0xe4, 0x2d, 0xc3, 0x3d, 0xb3, 0x6d, 0x60, 0xbb, 0x71, 0xad,
    0x94, 0xe1, 0x87, 0x12, 0x56, 0xb7, 0xb3, 0xca, 0x42, 0xf9, 0x0c, 0x56,
    0xab, 0x57, 0xf6, 0x29, 0xb8, 0x51, 0x80, 0x58, 0xfd, 0x97, 0xfc, 0x08,
    0x17, 0x1a, 0xf0, 0xa9, 0xcc, 0xd2, 0x21, 0xa4, 0x7b, 0x9c, 0x4b, 0x4b,
    0x94, 0xce, 0x7b, 0xae
};

@interface RSA1_5 (TestInterface)

+ (NSData *)decrypt:(NSData *)data
     withPrivateKey:(WPPrivateKey *)privateKey
              error:(NSError * __autoreleasing *)error;

@end

@implementation RSA1_5 (TestInterface)
+ (NSData *)decrypt:(NSData *)data
     withPrivateKey:(WPPrivateKey *)privateKey
              error:(NSError * __autoreleasing *)error {
    
    NSError *localError = nil;
    NSData *decryptedData = nil;
    RSA *rsa= NULL;
    
    //read rsa private key from memory
    BIO *keybio = BIO_new_mem_buf((void*)privateKey.data.bytes,
                                  (int)privateKey.data.length);
    
    if (!keybio) {
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
        return nil;
    }
    
    //init rsa with the private key
    rsa = PEM_read_bio_RSAPrivateKey(keybio, NULL, 0, NULL);
    
    if (!rsa) {
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
        BIO_free(keybio);
        return nil;
    }
    
    unsigned char * decrypted = [WPCryptoUtils allocBufferOfSize:RSA_size(rsa)
                                                           error:&localError];
    
    int dencryptedSize = RSA_private_decrypt((int)data.length,
                                             data.bytes,
                                             decrypted,
                                             rsa,
                                             RSA_PKCS1_PADDING);
    if (dencryptedSize >= 0) {
        decryptedData = [NSData dataWithBytes:decrypted length:dencryptedSize];
    } else {
        NSLog(@"%@", [WPCryptoUtils getOpenSSLError]);
    }
    
    free(decrypted);
    RSA_free(rsa);
    BIO_free(keybio);
    
    return decryptedData;
}

@end


@interface RSA1_5Tests : XCTestCase
{
    WPPublicKey *_publicKey;
    WPPrivateKey *_privateKey;
    NSData *_secretKey;
    NSData *_encryptedSecretKey;
}
@end

@implementation RSA1_5Tests

- (void)setUp {
    [super setUp];
    NSError *error = nil;
    _privateKey = [[WPPrivateKey alloc] initWithString:(NSString *)kPrivateKey];
    _publicKey =  [WPPublicKey parseKey:(NSString *)kPublicKeyIdModulusExponent error:&error];
    _secretKey = [NSData dataWithBytes:kSecretKey length:sizeof(kSecretKey)];
    _encryptedSecretKey = [NSData dataWithBytes:kEncryptedSecretKey length:sizeof(kEncryptedSecretKey)];
}

- (void)testEncryptSuccess {
    NSError *error;
    NSData *cryptedData = [RSA1_5 encrypt:_secretKey
                            withPublicKey:_publicKey
                                    error:&error];
    
    NSData *decryptedData = [RSA1_5 decrypt:cryptedData
                             withPrivateKey:_privateKey
                                      error:&error];

    
    XCTAssert([decryptedData isEqualToData:_secretKey], @"RSA keys should match");
}

- (void)testEncryptFailure {
    NSError *error;
    _publicKey =  [WPPublicKey parseKey:@"1#1233432#4353454545" error:&error];
    NSData *cryptedData = [RSA1_5 encrypt:_secretKey
                            withPublicKey:_publicKey
                                    error:&error];
    
    XCTAssert(![cryptedData isEqualToData:_encryptedSecretKey], @"RSA crypted data should no match");
}


- (void)testDecryptSuccess {
    NSError *error;
    NSData *decryptedData = [RSA1_5 decrypt:_encryptedSecretKey
                           withPrivateKey:_privateKey
                                    error:&error];
    
    XCTAssert([decryptedData isEqualToData:_secretKey], @"RSA crypted data should match");
}

- (void)testDecryptDailure {
    NSError *error;
    NSData *decryptedData = [RSA1_5 decrypt:_encryptedSecretKey
                             withPrivateKey:nil
                                      error:&error];
    
    XCTAssert(![decryptedData isEqualToData:_secretKey], @"RSA crypted data should not match");
}


@end
