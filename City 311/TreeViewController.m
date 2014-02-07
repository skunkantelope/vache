//
//  TreeViewController.m
//  City 311
//
//  Created by Qian Wang on 1/25/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "TreeViewController.h"

@interface TreeViewController () {
    UITapGestureRecognizer *tapGesture;
    BOOL scrollTextView;
}

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *treeScrollView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation TreeViewController

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
    scrollTextView = FALSE;
    self.treeScrollView.frame = CGRectMake(0, 91, self.view.bounds.size.width, self.view.bounds.size.height - 100);
    self.treeScrollView.contentSize = CGSizeMake(280, 715);
    
    self.commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];

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

        [self.treeScrollView setContentOffset:CGPointMake(0.0, self.commentTextView.frame.origin.y-kbSize.height+self.commentTextView.bounds.size.height+45) animated:YES];
    }
  
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    //[self.treeScrollView scrollRectToVisible:self.commentTextView.frame animated:YES];
  //  if (scrollTextView)
        //[self.treeScrollView setContentOffset:currentOffSet animated:YES];
        //[self.treeScrollView setContentOffset:CGPointMake(0, self.treeScrollView.contentSize.height - self.commentTextView.bounds.size.height) animated:YES];
}

- (void)resignTextView {
    [self.commentTextView resignFirstResponder];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender {
}
@end
