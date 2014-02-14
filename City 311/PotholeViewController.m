//
//  PotholeViewController.m
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "PotholeViewController.h"
#import "DrawOnPhotoViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface PotholeViewController () {
    UIImage *incidentPhoto;
    UITapGestureRecognizer *tapGesture;
    BOOL scrollTextView;
    UserInfoManager *manager;
    NSString *property;
    
    UIView *circle;
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D incidentCoord;
}

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITextField *landMarks;
@property (weak, nonatomic) IBOutlet UIImageView *incidentImage;
@property (weak, nonatomic) IBOutlet UIScrollView *potholeScroll;
@property (weak, nonatomic) IBOutlet UITextView *observation;
- (IBAction)sendReport:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)showSurfaceSheet:(id)sender;
- (IBAction)propertySelected:(id)sender;

- (void)startUpdates;

@end

@implementation PotholeViewController
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
   // self.potholeScroll.frame = CGRectMake(0, 160, self.view.bounds.size.width, self.view.bounds.size.height - 193);
   // self.potholeScroll.contentSize = CGSizeMake(280, 615);
    
    self.observation.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.observation.layer.borderWidth = 1.0;
    
    circle = [[UIView alloc] initWithFrame:CGRectZero];
    circle.layer.borderWidth = 1;
    circle.layer.borderColor = [[UIColor orangeColor] CGColor];
    [self.view addSubview:circle];
    
    property = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)startUpdates {
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 300;
    
    [locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

- (void)resignTextView {
    [self.observation resignFirstResponder];
    [self.view removeGestureRecognizer:tapGesture];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (scrollTextView) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        // scroll the comment text view to be visible.
        
        [self.potholeScroll setContentOffset:CGPointMake(0.0, self.observation.frame.origin.y-kbSize.height+self.observation.bounds.size.height) animated:YES];
    }
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

- (IBAction)sendReport:(id)sender {
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[self.theme, property, self.surface.text, self.landMarks.text, [NSString stringWithFormat:@"lat - %f; long - %f", incidentCoord.latitude, incidentCoord.longitude], self.observation.text] forKeys:@[@"subject", @"Property", @"Surface", @"landmark", @"location", @"discription"]];
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
    
    if(![CityUtility sendJSON:JSONData andImage:incidentPhoto]) {
        // store the failure status
        [savedDictionary setValue:[NSNumber numberWithBool:true] forKey:@"showButton"];
        // generate a file path.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMddHHmmss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        
        [savedDictionary setValue:dateString forKey:@"path"];
        
        [CityUtility saveJSON:JSONData andImage:incidentPhoto atFilePath:dateString];
    }
    // after all, save the request
    [CityUtility saveRequest:savedDictionary];
}

- (IBAction)cancel:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showSurfaceSheet:(id)sender {
    [self performSegueWithIdentifier:@"ShowSurfaceSheet" sender:self];
}

- (IBAction)propertySelected:(id)sender {

    UIButton *button = (UIButton*)sender;
    circle.frame = CGRectInset(button.frame, 2, -1);
    property = button.titleLabel.text;
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
