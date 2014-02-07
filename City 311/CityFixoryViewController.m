//
//  CityFixoryViewController.m
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFixoryViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DrawOnPhotoViewController.h"
#import "CityUtility.h"
#import "UserInfoViewController.h"

@interface CityFixoryViewController () {
    UIImage *incidentPhoto;
    NSMutableDictionary *JSON;
    UITapGestureRecognizer *tapGesture;
    
    BOOL scrollTextView;
}
@property (weak, nonatomic) IBOutlet UILabel *instruction;
@property (weak, nonatomic) IBOutlet UITextView *observation;
@property (weak, nonatomic) IBOutlet UITextField *landMarks;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)sendReport:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
- (IBAction)loadImage:(id)sender;

@end

@implementation CityFixoryViewController

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
    self.scrollView.frame = CGRectMake(0, 79, self.view.bounds.size.width, self.view.bounds.size.height - 99);
    self.scrollView.contentSize = CGSizeMake(280, 650);
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;

    self.instruction.text = self.guidance;
    // set the map dispaly region.
    NSLog(@"we are at %f, %f", self.map.userLocation.coordinate.latitude, self.map.userLocation.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.map.userLocation.coordinate, 200000, 200000);
    [self.map setRegion:region animated:YES];
    // display a drop pin at current user location.
    MKPointAnnotation *annotation;
    annotation.coordinate = self.map.userLocation.coordinate;
    annotation.title = @"Work for me";
    annotation.subtitle = @"Please!";
    [self.map addAnnotation:annotation];
    self.map.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (scrollTextView) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        // scroll the comment text view to be visible.
        
        [self.scrollView setContentOffset:CGPointMake(0.0, self.observation.frame.origin.y-kbSize.height+self.observation.bounds.size.height+35) animated:YES];
    }
   
}

#pragma mark - MKMapView Delegate methods.

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        aView.pinColor = MKPinAnnotationColorRed;
        aView.animatesDrop = YES;
        return aView;
    }
    aView.annotation = annotation;
    return aView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DrawImage"]) {
        DrawOnPhotoViewController *viewController = [segue destinationViewController];
        viewController.image = incidentPhoto;
    }
}


- (IBAction)sendReport:(UIButton *)sender {
    CALayer *greyLayer = [CALayer layer];
    greyLayer.opacity = 0.7;
    greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
    greyLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:greyLayer];
    
    UserInfoViewController *viewController = [[UserInfoViewController alloc] initWithNibName:@"userInfo" bundle:nil];
    CGRect frame = CGRectMake((320 - viewController.view.bounds.size.width)/2, (self.view.frame.size.height - viewController.view.bounds.size.height)/2, viewController.view.bounds.size.width, viewController.view.bounds.size.height);
    viewController.view.frame = frame;
    //[self.view addSubview:viewController.view];
    [self presentViewController:viewController animated:YES completion:nil];
    
/*    if ([CityUtility sendJSON:@"hi"]) {
        self.tabBarController.selectedIndex = 3;
    }*/
}

- (IBAction)cancel:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loadImage:(id)sender {
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion:nil];
//    [self performSegueWithIdentifier:@"PickPhoto" sender:nil];
        
/*        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionRepeat
                             animations: ^{
                                 glitterCircle.backgroundColor = [UIColor colorWithHue:0.3 saturation:1.0 brightness:0.7 alpha:1.0];
                                 
                             }
                             completion:^(BOOL finished) {
                                 glitterCircle.backgroundColor = [UIColor colorWithHue:0.0 saturation:1.0 brightness:0.7 alpha:1.0];
                                 
                             }];
        });
    });*/
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

#pragma UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    incidentPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion: ^(void) {
        [self performSegueWithIdentifier:@"DrawImage" sender:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
