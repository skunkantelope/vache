//
//  GeneralRequestViewController.m
//  Berkeley 311
//
//  Created by Qian Wang on 9/9/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "GeneralRequestViewController.h"

@interface GeneralRequestViewController ()

@property (retain, nonatomic) UIView *activeField;

@end

@implementation GeneralRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextFieldOrTextView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)resignTextFieldOrTextView:(UIGestureRecognizer *)gestureRecognizer {
    [self.activeField resignFirstResponder];
}

#pragma mark UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.activeField = textView;
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextFiledDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    // validate information
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
