//
//  WPCardValidatorTests.m
//  WorldpayCSE
//
//  Created by Nicolae Ghimbovschi on 24/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//
//  License information can be found in the LICENSE file

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "WPCardValidator.h"
#import "WPErrorCodes.h"

@interface WPCardValidator (TestingInterface)
- (BOOL)matchValue:(NSString *)value withRegexPattern:(NSString *)pattern;
- (int)validateNumber:(NSString *)value withExpectedLength:(NSString *)length;
- (BOOL)isFutureDateMonth:(int)expiryMonth
                                  andYear:(int)expiryYear;
- (WPCardValidatorError)validateMonth:(NSString *)expiryMonth;
- (WPCardValidatorError)validateYear:(NSString *)expiryYear;
- (WPCardValidatorError)validateFutureDateMonth:(NSString *)expiryMonth
                                        andYear:(NSString *)expiryYear;
- (BOOL)passesLuhnCheck:(NSString *)value;
- (WPCardValidatorError)validateCardHolderName:(NSString *)cardHolderName;
- (WPCardValidatorError)validateCvc:(NSString *)cvc;
- (WPCardValidatorError)validateCardNumber:(NSString *)cardNumber;
- (void)addError:(WPCardValidatorError)error
           toSet:(NSMutableSet *)errorsSet;
@end


@interface WPCardValidatorTests : XCTestCase
{
    WPCardValidator *_validator;
    WPCardData *_validCardData;
    WPCardData *_invalidCardData;
    WPCardData *_invalidCardDataWithPastDate;

    NSString *_emptyName;
    NSString *_longName;
    NSString *_validName;
    
    NSString *_emptyCVC;
    NSString *_longCVC;
    NSString *_validCVC1;
    NSString *_validCVC2;
    NSString *_invalidCVC;
    
    NSArray *_validCardNumbers;
    NSArray *_invalidCardNumbers;
}
@end

@implementation WPCardValidatorTests

- (void)setUp {
    [super setUp];
    _validator = [[WPCardValidator alloc] init];
    _emptyName = @"";
    _longName = @"Ni34co7890   4567lae123ghi78901";
    _validName = @"Nicolae Ghimbovschi";
    
    _emptyCVC = @"";
    _longCVC = @"12345";
    _validCVC1 = @"123";
    _validCVC2 = @"1234";
    _invalidCVC = @"1a3";
    
    _validCardNumbers = @[@"6011111111111117",
                          @"1234567812345670",
                          @"4444333322221111"];
    _invalidCardNumbers = @[@"49927398717",
                            @"499273a98717",
                            @"lskfjkdlsksf",
                            @"1234567812345678",
                            @""];
    
    _validCardData = [WPCardData new];
    _validCardData.cvc = @"123";
    _validCardData.expiryMonth = @"11";
    _validCardData.expiryYear = @"2090";
    _validCardData.cardHolderName = @"John Doe";
    _validCardData.cardNumber = @"4444333322221111";
    
    _invalidCardData = [WPCardData new];
    _invalidCardData.cvc = @"12";
    _invalidCardData.expiryMonth = @"1";
    _invalidCardData.expiryYear = @"090";
    _invalidCardData.cardHolderName = _longName;
    _invalidCardData.cardNumber = @"444333322221111";

    _invalidCardDataWithPastDate = [WPCardData new];
    _invalidCardDataWithPastDate.cvc = @"122";
    _invalidCardDataWithPastDate.expiryMonth = @"12";
    _invalidCardDataWithPastDate.expiryYear = @"1990";
    _invalidCardDataWithPastDate.cardHolderName = @"John Doe";
    _invalidCardDataWithPastDate.cardNumber = @"4444333322221111";
}

- (void)tearDown {
    [super tearDown];
}

- (NSDate *)getDateWithDay:(int)day withMonth:(int)month withYear:(int)year {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = 23;
    components.second = 59;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)testMatchValueValid {
    XCTAssert([_validator matchValue:@"12" withRegexPattern:@"^[0-9]{2}$"], @"Value should match the regex pattern");
}

- (void)testMatchValueInValid {
    XCTAssert(![_validator matchValue:@"a2" withRegexPattern:@"^[0-9]{2}$"], @"Value should match the regex pattern");
}

- (void)testValidateNumberPositive {
    XCTAssert(0 == [_validator validateNumber:@"1234" withExpectedLength:@"4"], @"Should return 0");
    XCTAssert(0 == [_validator validateNumber:@"1234" withExpectedLength:@"1,10"], @"Should return 0");
    XCTAssert(0 == [_validator validateNumber:@"1234567890" withExpectedLength:@"1,10"], @"Should return 0");
    XCTAssert(0 == [_validator validateNumber:@"1" withExpectedLength:@"1,10"], @"Should return 0");
}

- (void)testValidateNumberNegative {
    XCTAssert(1 == [_validator validateNumber:@"" withExpectedLength:@"0"], @"Should return 1");
    XCTAssert(1 == [_validator validateNumber:@"" withExpectedLength:@"12"], @"Should return 1");
    XCTAssert(2 == [_validator validateNumber:@"12d34" withExpectedLength:@"5"], @"Should return 2");
}

- (void)verifyWithCurrentDate:(NSDate *)nowTestDate
              withExpiryMonth:(int)month withExpiryYear:(int)year
                   isPositive:(BOOL)isPositive {
    id dateMock = [OCMockObject niceMockForClass:[NSDate class]];
    
    [[[dateMock expect] andReturn:nowTestDate] date];
    
    if (isPositive) {
        XCTAssert([_validator isFutureDateMonth:month andYear:year],
                  @"Date should pass validation");
    } else {
        XCTAssert(![_validator isFutureDateMonth:month andYear:year],
                  @"Date should not pass validation");
    }
    
    [dateMock verify];
    [dateMock stopMocking];
}

- (void)verifyWithCurrentDate:(NSDate *)nowTestDate
              withExpiryMonth:(NSString *)month withExpiryYear:(NSString *)year
            expectedErrorCode:(WPCardValidatorError)expectedError {
    id dateMock = [OCMockObject niceMockForClass:[NSDate class]];
    
    [[[dateMock expect] andReturn:nowTestDate] date];
    
    XCTAssert(expectedError == [_validator validateFutureDateMonth:month andYear:year],
                  @"Expiry date should pass validation");
    
    [dateMock stopMocking];
}

- (void)testIsFutureDateAlmostExpired {
    NSDate *currentTestDate = [self getDateWithDay:31 withMonth:12 withYear:2010];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:12 withExpiryYear:2010 isPositive:YES];
}

- (void)testIsFutureDateExpired {
    NSDate *currentTestDate = [self getDateWithDay:01 withMonth:01 withYear:2011];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:12 withExpiryYear:2010 isPositive:NO];
}

- (void)testIsFutureDateExpiredNew {
    NSDate *currentTestDate = [self getDateWithDay:11 withMonth:11 withYear:2011];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:10 withExpiryYear:2011 isPositive:NO];
}

- (void)testIsFutureDateExpiredBelow1970 {
    NSDate *currentTestDate = [self getDateWithDay:11 withMonth:11 withYear:2011];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:10 withExpiryYear:1800 isPositive:NO];
}

- (void)testLuhnCheckPositive {
    for (NSString *validCardNumber in _validCardNumbers) {
        XCTAssert([_validator passesLuhnCheck:validCardNumber], @"Luhn result should be YES");
    }
}

- (void)testLuhnCheckNegative {
    for (NSString *invalidCardNumber in _invalidCardNumbers) {
        XCTAssert(![_validator passesLuhnCheck:invalidCardNumber], @"Luhn result should be NO");
    }
}

- (void)testCardholderEmptyName {
    XCTAssert(WPCardValidatorErrorEmpyCardholderName == [_validator validateCardHolderName:_emptyName],
              @"Should return the expected error code for the empty name");
}


- (void)testCardholderNameTooLong {
    XCTAssert(WPCardValidatorErrorCardholderNameTooLong == [_validator validateCardHolderName:_longName],
              @"Should return the expected error code for the too long name");
}

- (void)testCardholderNameValid {
    XCTAssert(WPCardValidatorErrorNone == [_validator validateCardHolderName:_validName],
              @"Should return no error");
}

- (void)testEmptyCVC {
    XCTAssert(WPCardValidatorErrorNone == [_validator validateCvc:_emptyCVC],
              @"Should return no error");
}

- (void)testCVCTooLong {
    XCTAssert(WPCardValidatorErrorInvalidSecurityCode == [_validator validateCvc:_invalidCVC],
              @"Should return the expected error code for the invalid cvc");
}

- (void)testValidCVC1 {
    XCTAssert(WPCardValidatorErrorNone == [_validator validateCvc:_validCVC1],
              @"Should return no error");
}

- (void)testValidCVC2 {
    XCTAssert(WPCardValidatorErrorNone == [_validator validateCvc:_validCVC2],
              @"Should return no error");
}

- (void)testValidCardNumber {
    for (NSString *validCardNumber in _validCardNumbers) {
        XCTAssert(WPCardValidatorErrorNone == [_validator validateCardNumber:validCardNumber],
                  @"Card number should be valid");
    }
}

- (void)testInvalidCardNumber {
    for (NSString *invalidCardNumber in _invalidCardNumbers) {
        XCTAssert(WPCardValidatorErrorNone != [_validator validateCardNumber:invalidCardNumber],
                  @"Card number should be invalid");
    }
}

- (void)testEmptyCardNumber {
    XCTAssert(WPCardValidatorErrorEmptyCardNumber == [_validator validateCardNumber:@""],
              @"Eppty card number should be invalid");
}

- (void)testTooShortValidLuhnCardNumber {
    XCTAssert(WPCardValidatorErrorInvalidCardNumber == [_validator validateCardNumber:@"49927398716"],
              @"Short luhn valid card number should be invalid");
}

- (void)testValidLuhnCardNumber {
    XCTAssert(WPCardValidatorErrorNone == [_validator validateCardNumber:_validCardNumbers[0]],
              @"Card number should be valid");
}

- (void)testEmptyExpiryMonth {
    XCTAssert(WPCardValidatorErrorEmptyExpiryMonth == [_validator validateMonth:@""],
              @"Expiry month expected value should be met");
}

- (void)testInvalidExpiryMonthValue1 {
    XCTAssert(WPCardValidatorErrorInvalidExpiryMonthValue == [_validator validateMonth:@"June"],
              @"Expiry month expected value should be met");
}

- (void)testInvalidExpiryMonthValue2 {
    XCTAssert(WPCardValidatorErrorInvalidExpiryMonthValue == [_validator validateMonth:@"1"],
              @"Expiry month expected value should be met");
}


- (void)testInvalidExpiryMonthRange1 {
    XCTAssert(WPCardValidatorErrorInvalidExpiryMonthRange == [_validator validateMonth:@"13"],
              @"Expiry month expected value should be met");
}

- (void)testInvalidExpiryMonthRange2 {
    XCTAssert(WPCardValidatorErrorInvalidExpiryMonthRange == [_validator validateMonth:@"00"],
              @"Expiry month expected value should be met");
}

- (void)testEmptyExpiryYear {
    XCTAssert(WPCardValidatorErrorEmptyExpiryYear == [_validator validateYear:@""],
              @"Expiry month expected value should be met");
}

- (void)testInvalidExpiryYearValue {
    XCTAssert(WPCardValidatorErrorInvalidExpiryYearValue == [_validator validateYear:@"2oo2"],
              @"Expiry month expected value should be met");
}

- (void)testExpiryYearFromPast {
    NSDate *currentTestDate = [self getDateWithDay:31 withMonth:12 withYear:2010];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:@"11" withExpiryYear:@"2002"
              expectedErrorCode:WPCardValidatorErrorExpiryYearFromPast];
}

- (void)testValidExpiryYear {
    NSDate *currentTestDate = [self getDateWithDay:31 withMonth:12 withYear:2010];
    [self verifyWithCurrentDate:currentTestDate
                withExpiryMonth:@"01" withExpiryYear:@"2011"
              expectedErrorCode:WPCardValidatorErrorNone];
}

- (void)testAddErrorAdded {
    id _setMock = [OCMockObject niceMockForClass:[NSMutableSet class]];
    [[_setMock expect] addObject:@(WPCardValidatorErrorEmptyCardNumber)];
    
    [_validator addError:WPCardValidatorErrorEmptyCardNumber toSet:_setMock];
    
    [_setMock verify];
    [_setMock stopMocking];
}

- (void)testAddErrorNotAdded {
    id _setMock = [OCMockObject mockForClass:[NSMutableSet class]];
    
    [_validator addError:WPCardValidatorErrorNone toSet:_setMock];
    
    [_setMock verify];
    [_setMock stopMocking];
}

- (void)testValidateNoErrors {
    NSSet *errors = [_validator validate:_validCardData];
    XCTAssert(errors.count == 0, @"The card validation must pass");
}

- (void)testValidateWithErrors {
    NSSet *errors = [_validator validate:_invalidCardData];
    XCTAssert(errors.count == 5, @"The card validation must not pass");
}

- (void)testValidateWithErrors2 {
    NSSet *errors = [_validator validate:_invalidCardDataWithPastDate];
    NSSet *expectedErrors = [[NSSet alloc] initWithArray:@[@(WPCardValidatorErrorExpiryYearFromPast)]];
    XCTAssert(errors.count == 1, @"The card validation must not pass");
    XCTAssert([errors isEqualToSet:expectedErrors], @"Unexpected errors codes");
}

@end
