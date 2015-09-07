//
//  WPCardDataTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 17/07/2015.
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "WPCardData.h"
#import "WPConstants.h"

static NSString* const kJsonFormat = @"{  \"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\","
                                         "\"%@\" : \"%@\"}";

extern NSString* const kWPCardNumber;
extern NSString* const kWPCVC;
extern NSString* const kWPExpiryMonth;
extern NSString* const kWPExpiryYear;
extern NSString* const kWPCardHolderName;

@interface WPCardData (TestingInterface)
- (id)initFromJSONData:(NSData *)jsonData
                 error:(NSError * __autoreleasing *)error;

- (id)initWithDictionary:(NSDictionary *)dict;
@end

@implementation WPCardData (TestingInterface)

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (dict[kWPCardNumber]) {
        self.cardNumber = dict[kWPCardNumber];
    }
    
    if (dict[kWPCVC]) {
        self.cvc = dict[kWPCVC];
    }
    
    if (dict[kWPExpiryMonth]) {
        self.expiryMonth = dict[kWPExpiryMonth];
    }
    
    if (dict[kWPExpiryYear]) {
        self.expiryYear = dict[kWPExpiryYear];
    }
    
    if (dict[kWPCardHolderName]) {
        self.cardHolderName = dict[kWPCardHolderName];
    }
    
    return self;
}

- (id)initFromJSONData:(NSData *)jsonData
                 error:(NSError * __autoreleasing *)error {
    NSError *jsonError = nil;
    
    if (!jsonData) {
        return nil;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    
    if (!json) {
        return nil;
    }
    
    return [self initWithDictionary:json];
}
@end


@interface WPCardDataTests : XCTestCase
{
    NSString *_cardNumber;
    NSString *_cvc;
    NSString *_expiryMonth;
    NSString *_expiryYear;
    NSString *_cardHolderName;
    NSString *_validJSON;
    NSString *_invalidJSON;
    id _jsonMockObject;
}
@end

@implementation WPCardDataTests

- (void)setUp {
    [super setUp];
    
    _cardNumber = @"123";
    _cvc = @"345";
    _expiryMonth = @"12";
    _expiryYear = @"2020";
    _cardHolderName = @"Nicu Bunu";

    _validJSON = [NSString stringWithFormat:kJsonFormat,
                           kWPCardNumber, _cardNumber,
                           kWPCVC, _cvc,
                           kWPExpiryMonth, _expiryMonth,
                           kWPExpiryYear, _expiryYear,
                           kWPCardHolderName, _cardHolderName];
    
    _invalidJSON = [NSString stringWithFormat:kJsonFormat,
                             @"\'\"", _cardNumber,
                             kWPCVC, _cvc,
                             kWPExpiryMonth, _expiryMonth,
                             kWPExpiryYear, _expiryYear,
                             kWPCardHolderName, _cardHolderName];


}

- (void)tearDown {
    [_jsonMockObject stopMocking];
    [super tearDown];
}

- (void)testInitializer {
    WPCardData *cardData = [WPCardData new];
    
    XCTAssert([cardData.cardNumber isEqualToString:@""], @"cardNumber should be blank");
    XCTAssert([cardData.cvc isEqualToString:@""], @"cvc should be blank");
    XCTAssert([cardData.expiryMonth isEqualToString:@""], @"expiryMonth should be blank");
    XCTAssert([cardData.expiryYear isEqualToString:@""], @"expiryYear should be blank");
    XCTAssert([cardData.cardHolderName isEqualToString:@""], @"cardHolderName should be blank");
}

- (void)testInitializerWithInValidJSONAndNilError {
    WPCardData *cardData = [[WPCardData alloc] initFromJSONData:nil
                                                          error:nil];
    
    XCTAssert(cardData == nil, @"CardData should be nil");
}

- (void)testToJsonString {
    WPCardData *cardData = [WPCardData new];
    
    cardData.cardNumber = _cardNumber;
    cardData.cvc = _cvc;
    cardData.expiryMonth = _expiryMonth;
    cardData.expiryYear = _expiryYear;
    cardData.cardHolderName = _cardHolderName;
    
    NSError *error = nil;
    NSString *cardDataJson = [cardData jsonString];
    
    WPCardData *newCardData = [[WPCardData alloc] initFromJSONData:[cardDataJson dataUsingEncoding:NSUTF8StringEncoding]
                                                             error:&error];
    
    XCTAssert([cardData.cardNumber isEqualToString:newCardData.cardNumber], @"cardNumber should have expected value");
    XCTAssert([cardData.cvc isEqualToString:newCardData.cvc], @"cvc should have expected value");
    XCTAssert([cardData.expiryMonth isEqualToString:newCardData.expiryMonth], @"expiryMonth should have expected value");
    XCTAssert([cardData.expiryYear isEqualToString:newCardData.expiryYear], @"expiryYear should have expected value");
    XCTAssert([cardData.cardHolderName isEqualToString:newCardData.cardHolderName], @"cardHolderName should have expected value");
}

- (void)testToJsonStringInvalidJson {
    WPCardData *cardData = [WPCardData new];
    
    cardData.cardNumber = _cardNumber;
    cardData.cvc = _cvc;
    cardData.expiryMonth = _expiryMonth;
    cardData.expiryYear = _expiryYear;
    cardData.cardHolderName = _cardHolderName;
    
    _jsonMockObject = [OCMockObject niceMockForClass:[NSJSONSerialization class]];
    [[[_jsonMockObject expect] andReturn:nil] dataWithJSONObject:OCMOCK_ANY
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:[OCMArg anyObjectRef]];

    
    NSString *cardDataJson = [cardData jsonString];
    
    XCTAssert([cardDataJson isEqualToString:@""], @"The resulting json data should be blannk");
    
    

}

@end
