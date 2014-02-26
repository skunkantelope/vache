//
//  ParkingMeterViewController.m
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "ParkingMeterViewController.h"
#import "DrawOnPhotoViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ParkingMeterViewController () {
    UIImage *incidentPhoto;
    UITapGestureRecognizer *tapGesture;
    UserInfoManager *manager;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D incidentCoord;
    
    UIView *firstResponder;
}
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIImageView *incidentImage;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *IDField;
@property (weak, nonatomic) IBOutlet UIScrollView *meterScroll;
@property (weak, nonatomic) IBOutlet UITextView *observation;
- (IBAction)cancel:(id)sender;
- (IBAction)sendReport:(id)sender;
- (IBAction)chooseProblemType:(id)sender;

- (void)startUpdates;

@end

@implementation ParkingMeterViewController
@synthesize userImage=incidentPhoto;

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
    
    [self startUpdates];
    
    // Do any additional setup after loading the view.
 //   self.meterScroll.frame = CGRectMake(0, 162, self.view.bounds.size.width, self.view.bounds.size.height - 180);
 //   self.meterScroll.contentSize = CGSizeMake(280, 615);
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;

    self.incidentImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)startUpdates {
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 300;
    
    [locationManager startUpdatingLocation];
}
/*
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
- (void)viewDidAppear:(BOOL)animated {
    self.incidentImage.image = incidentPhoto;
}

#pragma mark - CLLocation Manager Delegate.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSLog(@"we are at latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 300, 300);
    [self.map setRegion:region animated:YES];
    //self.map.showsPointsOfInterest = NO;
    
    // display a drop pin at current user location.
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = @"Incident Location"; // display in a callout.
    
    [self.map addAnnotation:annotation];
    
    //[self.map showAnnotations:@[annotation] animated:YES];
}

#pragma mark - MKMapView Delegate methods.

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        aView.pinColor = MKPinAnnotationColorPurple;
        aView.animatesDrop = YES;
        aView.draggable = YES;

        return aView;
    }
    aView.annotation = annotation;
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
        incidentCoord = view.annotation.coordinate;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Am I called");

    NSDictionary* info = [aNotification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    NSLog(@"keyboard frame %@", NSStringFromCGRect(keyboardRect));

        
    // scroll the comment text view visible. (keyboardRect.size.height - self.observation.frame.size.height) this much needs get scrolled up.
    float yOffset = self.meterScroll.frame.origin.y + firstResponder.frame.origin.y + firstResponder.frame.size.height - keyboardRect.origin.y;
    NSLog(@"how much is covered %f", yOffset);
    if (yOffset > 0.0) {
        UIEdgeInsets contentInset = self.meterScroll.contentInset;
        contentInset.bottom = keyboardRect.size.height;
        [self.meterScroll setContentInset:contentInset];
        
        [self.meterScroll setContentOffset:CGPointMake(0.0, yOffset) animated:YES];
    }

}

- (void)keyboardWasHidden:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.meterScroll.contentInset = UIEdgeInsetsZero;
                     } completion:nil];
    
}

- (void)resignTextView {
    [self.observation resignFirstResponder];
    firstResponder = nil;
    [self.view removeGestureRecognizer:tapGesture];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    firstResponder = nil;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    firstResponder = textField;
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"I am here");
    firstResponder = textView;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DrawPhoto"]) {
        DrawOnPhotoViewController *viewController = [segue destinationViewController];
        viewController.image = incidentPhoto;
    }
}


- (IBAction)cancel:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendReport:(id)sender {
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
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[self.theme, self.IDField.text, self.problemLabel.text, self.locationField.text, [NSString stringWithFormat:@"lat - %f; long - %f", incidentCoord.latitude, incidentCoord.longitude], self.observation.text] forKeys:@[@"subject", @"ID", @"problem", @"landmark", @"location", @"discription"]];
    [manager packageServiceRequest:dictionary andImage:incidentPhoto];
    
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

- (IBAction)chooseProblemType:(id)sender {
    [self performSegueWithIdentifier:@"ShowProblems" sender:self];
}

- (IBAction)loadImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion:nil];
}

#pragma UIImagePickerControllerDelegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    incidentPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion: ^(void) {
        [self performSegueWithIdentifier:@"DrawPhoto" sender:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
