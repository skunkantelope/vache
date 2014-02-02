//
//  TreeViewController.m
//  City 311
//
//  Created by Qian Wang on 1/25/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "TreeViewController.h"

@interface TreeViewController ()
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
    self.treeScrollView.frame = CGRectMake(0, 91, self.view.bounds.size.width, self.view.bounds.size.height - 110);
    self.treeScrollView.contentSize = CGSizeMake(280, 800);
    
    self.commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.0;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
