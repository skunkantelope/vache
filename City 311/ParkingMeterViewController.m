//
//  ParkingMeterViewController.m
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "ParkingMeterViewController.h"

@interface ParkingMeterViewController () {
    CGSize kbSize;
}
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *IDField;
@property (weak, nonatomic) IBOutlet UIScrollView *meterScroll;
@property (weak, nonatomic) IBOutlet UITextView *observation;
- (IBAction)cancel:(id)sender;
- (IBAction)sendReport:(id)sender;
- (IBAction)chooseProblemType:(id)sender;

@end

@implementation ParkingMeterViewController

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
    // Do any additional setup after loading the view.
    self.meterScroll.frame = CGRectMake(0, 162, self.view.bounds.size.width, self.view.bounds.size.height - 200);
    self.meterScroll.contentSize = CGSizeMake(280, 792);
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

}

#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
 //   CGRect newFrame = CGRectMake(self.meterScroll.frame.origin.x, self.meterScroll.frame.origin.y, self.meterScroll.bounds.size.width, self.meterScroll.bounds.size.height - kbSize.height);
 //   self.meterScroll.frame = newFrame;
 //   [self.meterScroll scrollRectToVisible:self.observation.frame animated:YES];
    return YES;
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)cancel:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendReport:(id)sender {
}

- (IBAction)chooseProblemType:(id)sender {
    [self performSegueWithIdentifier:@"ShowProblems" sender:self];
}
@end
