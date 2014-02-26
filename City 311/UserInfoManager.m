//
//  UserInfoManager.m
//  City 311
//
//  Created by Qian Wang on 2/8/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "UserInfoManager.h"

@interface UserInfoManager () {
    NSString *userFirst;
    NSString *userLast;
    NSString *emailAddress;
    NSString *phoneNo;
    
    int kFields;
}

@property (strong, nonatomic) NSDictionary *fixRequest;
@property (assign, nonatomic) id image;

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;

//@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continue:(id)sender;
//- (IBAction)confirm:(id)sender;

@end

static NSString * const PHONE = @"phone";
static NSString * const EMAIL = @"email";
static NSString * const LAST = @"lastName";
static NSString * const FIRST = @"firstName";

@implementation UserInfoManager

- (id)init {
    self = [super init];
    if (self) {
        kFields = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // empty string and nil string are different.
        phoneNo = [defaults stringForKey:PHONE];
        if (phoneNo) ++kFields;
        emailAddress = [defaults objectForKey:EMAIL];
        if (emailAddress) ++kFields;
        userLast = [defaults objectForKey:LAST];
        if (userLast) ++kFields;
        userFirst = [defaults objectForKey:FIRST];
        if (userFirst) ++kFields;
    }
    return self;
}

- (void)setDefaultUserInfo {
    if (kFields < 4) {
       // self.confirmButton.enabled = NO;
        self.continueButton.enabled = NO;
    }
    
    self.phone.placeholder = phoneNo;
    self.email.placeholder = emailAddress;
    self.lastName.placeholder = userLast;
    self.firstName.placeholder = userFirst;
    
}

- (void)packageServiceRequest:(NSDictionary *)request andImage:(id)image {
    self.fixRequest = request;
    self.image = image;
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // default return does nothing.

    // user wants to resign first responder. grant it. but verify the input in textFieldShouldEndEditing
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *userText = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!textField.placeholder) {
        
        if (textField == self.phone) {
            NSString *regEx = @"[0-9]{3}\\s*[0-9]{3}\\s*[0-9]{4}$";
            NSRange r = [textField.text rangeOfString:regEx options:NSRegularExpressionSearch];
            if (r.location == NSNotFound) {
                return NO;
            }
            return YES;
        } else {
    
            if ([userText isEqualToString:@""]) {
                return NO;
            }
            return YES;
        }
    } else {
        if (![userText isEqualToString:@""]) {
            //verify the phone number
            if (textField == self.phone) {
                NSString *regEx = @"[0-9]{3}\\s*[0-9]{3}\\s*[0-9]{4}$";
                NSRange r = [textField.text rangeOfString:regEx options:NSRegularExpressionSearch];
                //NSLog(@"maching phone number");
                if (r.location == NSNotFound) {
                    return NO;
                }
                return YES;
            }
            return YES;
        }
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
 
    NSString *userText = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![userText isEqualToString:@""]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ++kFields;
        NSLog(@"kFields %i", kFields);
        if (kFields == 4) {
            self.continueButton.enabled = YES;
        }
        
        if (textField == self.phone) {
            phoneNo = textField.text;
            [defaults setObject:phoneNo forKey:PHONE];
            
            return;
        }
        if (textField == self.email) {
            emailAddress = textField.text;
            [defaults setObject:emailAddress forKey:EMAIL];
    
            return;
        }
        if (textField == self.lastName) {
            userLast = textField.text;
            [defaults setObject:userLast forKey:LAST];

            return;
        }
        if (textField == self.firstName) {
            userFirst = textField.text;
            [defaults setObject:userFirst forKey:FIRST];

        }
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)continue:(id)sender {
    // send placeholder text which is instance string variables.
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[userFirst, userLast, phoneNo, emailAddress] forKeys:@[FIRST, LAST, PHONE, EMAIL]];
    [self.proxy appendUserInfo:dictionary serviceRequest:self.fixRequest andImage:self.image];
    // self.proxy can't be nil. 
    [self.delegate dismissViews];
}
/*
- (IBAction)confirm:(id)sender {
    
}
*/
@end
