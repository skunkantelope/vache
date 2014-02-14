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
    
    [self.scrollView setContentOffset:CGPointMake(0.0, self.requestTextView.frame.origin.y-kbSize.height+self.requestTextView.bounds.size.height) animated:YES];
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
    CALayer *greyLayer = [CALayer layer];
    greyLayer.opacity = 0.7;
    greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
    greyLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:greyLayer];
    
    manager = [[UserInfoManager alloc] init];
    manager.proxy = self;
    [[NSBundle mainBundle] loadNibNamed:@"userInfo" owner:manager options:nil];
    [manager setDefaultUserInfo];
    
    [self.view addSubview:manager.view];
    CGRect frame = CGRectMake((320 - manager.view.bounds.size.width)/2, (self.view.frame.size.height - manager.view.bounds.size.height)/2, manager.view.bounds.size.width, manager.view.bounds.size.height);
    [UIView animateWithDuration:1 animations:^{
        manager.view.frame = frame;
    }];

}

- (void)appendUserInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[self.theme, self.requestTextView.text] forKeys:@[@"subject", @"discription"]];
    NSMutableDictionary *savedDictionary = [[NSMutableDictionary alloc] init];
    [savedDictionary addEntriesFromDictionary:dictionary];
    
    [dictionary addEntriesFromDictionary:userInfo];
    
    NSError *error;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        // not able to create JSON.
        NSLog(@"No JSON String");
    }
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if(![CityUtility sendJSON:JSONData andImage:nil]) {
        // store the failure status
        [savedDictionary setValue:[NSNumber numberWithBool:true] forKey:@"showButton"];
        // generate a file path.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [savedDictionary setValue:dateString forKey:@"path"];
        
        [CityUtility saveJSON:JSONData andImage:nil atFilePath:dateString];
    }
    // after all, save the request
    [CityUtility saveRequest:savedDictionary];
}
@end
