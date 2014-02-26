//
//  GeneralRequestViewController.m
//  City 311
//
//  Created by Qian Wang on 1/15/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "GeneralRequestViewController.h"

@interface GeneralRequestViewController () {
    UITapGestureRecognizer *tapGesture;
    UserInfoManager *manager;
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
    
    self.requestTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.requestTextView.layer.borderWidth = 1.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
/*
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    
    contentInset.bottom = keyboardRect.size.height - (self.scrollView.frame.size.height - (self.requestTextView.frame.origin.y + self.requestTextView.frame.size.height));
    NSLog(@"edge insets %@", NSStringFromUIEdgeInsets(contentInset));
    [self.scrollView setContentInset:contentInset];
        
    // scroll the comment text view visible. (keyboardRect.size.height - self.observation.frame.size.height) this much needs get scrolled up.
    if (keyboardRect.origin.y - self.requestTextView.frame.size.height < self.scrollView.frame.origin.y) {
        [self.scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0.0, self.scrollView.frame.origin.y + self.requestTextView.frame.origin.y + self.requestTextView.frame.size.height - keyboardRect.origin.y) animated:YES];
    }

}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.scrollView.contentInset = UIEdgeInsetsZero;
                     } completion:nil];
//    if (keyboardRect.origin.y - self.requestTextView.frame.size.height < self.scrollView.frame.origin.y)
//        [self.scrollView setContentOffset:CGPointMake(0, -50) animated:YES];
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
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:maskView];
    [maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(maskView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[maskView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[maskView]|" options:0 metrics:nil views:views]];
    /*   CALayer *greyLayer = [CALayer layer];
     greyLayer.opacity = 0.7;
     greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
     greyLayer.frame = self.view.bounds;
     [self.view.layer addSublayer:greyLayer];*/
    
    manager = [[UserInfoManager alloc] init];
    manager.delegate = self;
    manager.proxy = self.chief;
    [[NSBundle mainBundle] loadNibNamed:@"userInfo" owner:manager options:nil];
    [manager setDefaultUserInfo];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:@[self.theme, self.requestTextView.text] forKeys:@[@"subject", @"discription"]];
    [manager packageServiceRequest:dictionary andImage:nil];
    
    [self.view addSubview:manager.view];
    
    [manager.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:manager.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:manager.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:240.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:manager.view
                                                          attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:manager.view
                                                          attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

}

- (void)dismissViews {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}
@end
