//
//  GeneralRequestViewController.m
//  City 311
//
//  Created by Qian Wang on 1/15/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "GeneralRequestViewController.h"
#import "CityFirstViewController.h"

@interface GeneralRequestViewController () {
    UITapGestureRecognizer *tapGesture;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *requestTextView;
- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

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
    // Do any additional setup after loading the view.
    // Set the height of the textview;
    self.scrollView.frame = CGRectMake(0, 79, 320, self.view.bounds.size.height - 100);
    self.scrollView.contentSize = CGSizeMake(280, 300);
    
    self.requestTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.requestTextView.layer.borderWidth = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
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
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    // scroll the comment text view to be visible.
    
    [self.scrollView setContentOffset:CGPointMake(0.0, self.requestTextView.frame.origin.y-kbSize.height+self.requestTextView.bounds.size.height+30) animated:YES];
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
}

- (void)resignTextView {
    [self.requestTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGesture];
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
#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
    
        //self.presentingViewController.tabBarController.selectedIndex = 3;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    if (viewController.tabBarController) {
//        NSLog(@"tab bar controller is cool");
//    }
/*    if (viewController.cityTabBarController) {
        NSLog(@"city tab bar controller is cool");
    }*/
    [CityUtility sendJSON:@"Hey"];

}
@end
