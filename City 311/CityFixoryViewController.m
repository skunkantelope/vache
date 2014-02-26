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

@interface CityFixoryViewController () {
    UIImage *incidentPhoto;
    UITapGestureRecognizer *tapGesture;
    
    BOOL scrollTextView;
    
    UserInfoManager *manager;
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D incidentCoord;
}
@property (weak, nonatomic) IBOutlet UIImageView *incidentImage;
@property (weak, nonatomic) IBOutlet UILabel *instruction;
@property (weak, nonatomic) IBOutlet UITextView *observation;
@property (weak, nonatomic) IBOutlet UITextField *landMarks;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)sendReport:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
- (IBAction)loadImage:(id)sender;

- (void)startUpdates;

@end

@implementation CityFixoryViewController
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
    
    scrollTextView = FALSE;
    // Do any additional setup after loading the view.
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;

    self.instruction.text = self.guidance;
    
    self.incidentImage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"photo"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
/*
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
*/
- (void)viewDidAppear:(BOOL)animated {
    self.incidentImage.image = incidentPhoto;
}

- (void)startUpdates {
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 300;
    
    [locationManager startUpdatingLocation];
}

- (void)keyboardWasHidden:(NSNotification*)aNotification {

    
  //  [self.scrollView setContentOffset:CGPointMake(0.0, kbSize.height - self.observation.frame.origin.y - self.observation.bounds.size.height) animated:YES];
    [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.scrollView.contentInset = UIEdgeInsetsZero;
                     } completion:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
   // NSLog(@"text view frame: %@", NSStringFromCGRect(self.observation.frame));
   // NSLog(@"scroll view frame: %@", NSStringFromCGRect(self.scrollView.frame));
    
    // frame and bounds change in landscape orientation.
    if (scrollTextView) {
        NSDictionary* info = [aNotification userInfo];
        CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
      //  NSLog(@"keyboard frame %@", NSStringFromCGRect(keyboardRect));
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.bottom = keyboardRect.size.height;
        [self.scrollView setContentInset:contentInset];
        
        // scroll the comment text view visible. (keyboardRect.size.height - self.observation.frame.size.height) this much needs get scrolled up.
        [self.scrollView setContentOffset:CGPointMake(0.0, self.scrollView.frame.origin.y + self.observation.frame.origin.y + self.observation.frame.size.height - keyboardRect.origin.y) animated:YES];
    }
   
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
    
    incidentCoord = location.coordinate;
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

    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:maskView];
    [maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(maskView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[maskView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[maskView]|" options:0 metrics:nil views:views]];
    
    manager = [[UserInfoManager alloc] init];
    manager.delegate = self;
    manager.proxy = self.chief;
    [[NSBundle mainBundle] loadNibNamed:@"userInfo" owner:manager options:nil];
    [manager setDefaultUserInfo];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[self.theme, self.landMarks.text, [NSString stringWithFormat:@"lat - %f; long - %f", incidentCoord.latitude, incidentCoord.longitude], self.observation.text] forKeys:@[@"subject", @"landmark", @"location", @"discription"]];

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

- (IBAction)cancel:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loadImage:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion:nil];

}

- (void)resignTextView {
    [self.observation resignFirstResponder];
    scrollTextView = FALSE;
    [self.view removeGestureRecognizer:tapGesture];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    scrollTextView = TRUE;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextView)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
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
