//
//  ParkingMeterViewController.m
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "ParkingMeterViewController.h"

@interface ParkingMeterViewController () {
    UITapGestureRecognizer *tapGesture;
    BOOL scrollTextView;
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
    scrollTextView = FALSE;
    // Do any additional setup after loading the view.
    self.meterScroll.frame = CGRectMake(0, 162, self.view.bounds.size.width, self.view.bounds.size.height - 180);
    self.meterScroll.contentSize = CGSizeMake(280, 615);
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (scrollTextView) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // scroll the comment text view to be visible.
    
        [self.meterScroll setContentOffset:CGPointMake(0.0, self.observation.frame.origin.y-kbSize.height+self.observation.bounds.size.height*2 + 25) animated:YES];
    }
}

- (void)resignTextView {
    [self.observation resignFirstResponder];
    [self.view removeGestureRecognizer:tapGesture];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    scrollTextView = TRUE;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    scrollTextView = FALSE;
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