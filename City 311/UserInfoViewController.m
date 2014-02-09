//
//  UserInfoViewController.m
//  City 311
//
//  Created by Qian Wang on 2/4/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController () {
    NSString *userFirst;
    NSString *userLast;
    NSString *emailAddress;
    NSString *phoneNo;
    
    int kFields;
}
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

- (IBAction)continue:(id)sender;
- (IBAction)confirm:(id)sender;

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        kFields = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // empty string and nil string are different.
        phoneNo = [defaults stringForKey:@"phoneKey"];
        if (phoneNo) ++kFields;
        emailAddress = [defaults objectForKey:@"emailKey"];
        if (emailAddress) ++kFields;
        userLast = [defaults objectForKey:@"lastName"];
        if (userLast) ++kFields;
        userFirst = [defaults objectForKey:@"firstName"];
        if (userFirst) ++kFields;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (kFields < 4) {
        self.confirmButton.enabled = NO;
        self.continueButton.enabled = NO;
    }
    
    self.phone.placeholder = phoneNo;
    self.email.placeholder = emailAddress;
    self.lastName.placeholder = userLast;
    self.firstName.placeholder = userFirst;
    
    //[self.lastName becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.placeholder) {
        [textField resignFirstResponder];
        return YES;
    } else {
        NSString *userText = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![userText isEqualToString:@""]) {
            ++kFields;
            [textField resignFirstResponder];
            return YES;
        }
        return NO;
    }

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (kFields == 4) {
        self.continueButton.enabled = YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *userText = [textField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![userText isEqualToString:@""]) { // update user defaults, and instance variables
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (textField == self.phone) {
            if ([userText length] == 10) {
                phoneNo = userText;
                [defaults setObject:userText forKey:@"phoneKey"];
            }
            return;
        }
        if (textField == self.email) {
            emailAddress = userText;
            [defaults setObject:userText forKey:@"emailKey"];
            return;
        }
        if (textField == self.lastName) {
            userLast = userText;
            [defaults setObject:userText forKey:@"lastName"];
            return;
        }
        if (textField == self.firstName) {
            userFirst = userText;
            [defaults setObject:userText forKey:@"firstName"];
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
    
    [CityUtility sendJSON:@"hi"];
}
       
- (IBAction)confirm:(id)sender {

}
@end
