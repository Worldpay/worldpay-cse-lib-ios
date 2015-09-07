//
//  MainViewController.m
//  DemoApp
//
//  Created by Nicolae Ghimbovschi on 19/07/2015.
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import <WorldpayCSE/WorldpayCSE.h>

#import "MainViewController.h"

@interface MainViewController () <UITextFieldDelegate>

// card data input
@property (weak, nonatomic) IBOutlet UITextField *cardHolderNameInputView;
@property (weak, nonatomic) IBOutlet UITextField *cardNumberInputView;
@property (weak, nonatomic) IBOutlet UITextField *cardCVCInputView;
@property (weak, nonatomic) IBOutlet UITextField *cardExpiryMonthInputView;
@property (weak, nonatomic) IBOutlet UITextField *cardExpiryYearInputView;

// encrypted data view
@property (weak, nonatomic) IBOutlet UITextView *encryptedDataView;

@property (strong, nonatomic) NSDictionary *errorCodeMsgMap;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *encryptedDataViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *encryptedDataViewWidthConstraint;

@end

@implementation MainViewController

#pragma mark - Encrypt methods
// encrypt the WPCardData instance with the public key
- (IBAction)encryptAction:(id)sender {
    // hide the keyboard
    [self.view endEditing:YES];
    // reset encrypted data view
    self.encryptedDataView.text = @"";
    
    
    NSError *error = nil;
    
    WorldpayCSE *wpCSE = [WorldpayCSE new];
    
    // set public key
    [wpCSE setPublicKey:
     @"1#10001#00ccca2c4ef80be7f7a98d5e0eef7e5e6eafe700ef054"
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
        [self showErrorMessage:@"Invalid public key."];
        return;
    }
    
    // set card data
    WPCardData *cardData = [[WPCardData alloc] init];
    cardData.cardHolderName = self.cardHolderNameInputView.text;
    cardData.cardNumber = self.cardNumberInputView.text;
    cardData.cvc = self.cardCVCInputView.text;
    cardData.expiryMonth = self.cardExpiryMonthInputView.text;
    cardData.expiryYear = self.cardExpiryYearInputView.text;
    
    // encrypt card data and validate
    NSString *encryptedData = [wpCSE encrypt:cardData error:&error];
    
    // handle error
    if (error) {
        NSString *errorMessage = [error description];

        if (error.code == WPErrorInvalidCardData) {
            NSArray *cardValidationErrors = error.userInfo[kWPErrorDetailsKey];
            
            errorMessage = @"Invalid card data.\n";
            for (NSNumber *errorCode in cardValidationErrors) {
                errorMessage = [errorMessage stringByAppendingFormat:@"%@ - %@\n", errorCode, self.errorCodeMsgMap[errorCode]];
            }
        }
        [self showErrorMessage:errorMessage];
    }
    
    // show the encrypted data
    self.encryptedDataView.text = encryptedData;
    
    
    // update ui
    [self updateConstraints];
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

#pragma mark - Controller Life cycle

// update constraints

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add border to data
    self.encryptedDataView.layer.borderWidth = 1;
    self.encryptedDataView.layer.borderColor = [UIColor blackColor].CGColor;
    
    // init error code -> message mapping
    self.errorCodeMsgMap = @{
                             @(WPCardValidatorErrorEmptyCardNumber) :  @"Credit card number is mandatory.",
                             @(WPCardValidatorErrorInvalidCardNumber) : @"Enter a valid credit card number; numbers only and should be between 12 and 20 digits.",
                             @(WPCardValidatorErrorInvalidCardNumberLuhn) : @"Enter a valid credit card number; input doesn't verify Luhn check.",
                             @(WPCardValidatorErrorInvalidSecurityCode) : @"Enter a valid security code; numbers only and should be between 3 and 4 digits.",
                             @(WPCardValidatorErrorEmptyExpiryMonth) : @"Expiry month is mandatory.",
                             @(WPCardValidatorErrorInvalidExpiryMonthValue) : @"Enter a valid expiry month; only numbers expected and in XX form (e.g. 09).",
                             @(WPCardValidatorErrorInvalidExpiryMonthRange) : @"Enter a valid expiry month; should range from 01 to 12.",
                             @(WPCardValidatorErrorEmptyExpiryYear) : @"Expiry year is mandatory.",
                             @(WPCardValidatorErrorInvalidExpiryYearValue) : @"Enter a valid expiry year; only numbers expected.",
                             @(WPCardValidatorErrorExpiryYearFromPast) : @"Expiry date should be in future.",
                             @(WPCardValidatorErrorEmpyCardholderName) : @"Card holder's name is mandatory.",
                             @(WPCardValidatorErrorCardholderNameTooLong) : @"Name should not exceed thirty characters."
                             };

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateConstraints];
}

// reseizes the encrypted data view box
- (void)updateConstraints {
    CGFloat kMarginWidth = 19.;
    CGFloat newHeight = self.view.frame.size.height
                        - self.encryptedDataView.frame.origin.y
                        - kMarginWidth;
    CGFloat newWidth = self.view.frame.size.width
                        - 2*kMarginWidth;
    CGSize size = [self.encryptedDataView sizeThatFits:CGSizeMake(newWidth, CGFLOAT_MAX)];
    
    if (size.height > newHeight) {
        newHeight = size.height;
    }
    
    self.encryptedDataViewHeightConstraint.constant = newHeight;
    self.encryptedDataViewWidthConstraint.constant = newWidth;
    [self.view needsUpdateConstraints];
}



@end
