//
//  TreeViewController.m
//  City 311
//
//  Created by Qian Wang on 1/25/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "TreeViewController.h"
#import "DrawOnPhotoViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TreeViewController () {
    UIImage *incidentPhoto;
    UITapGestureRecognizer *tapGesture;
    BOOL scrollTextView;
    UserInfoManager *manager;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D incidentCoord;
}

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *landMarks;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIImageView *incidentImage;
@property (weak, nonatomic) IBOutlet UIScrollView *treeScrollView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

- (void)startUpdates;

@end

@implementation TreeViewController
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
    // Do any additional setup after loading the view.
    [self startUpdates];
    
    scrollTextView = FALSE;
  //  self.treeScrollView.frame = CGRectMake(0, 91, self.view.bounds.size.width, self.view.bounds.size.height - 100);
  //  self.treeScrollView.contentSize = CGSizeMake(280, 715);
    
    self.commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.0;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];

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

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (scrollTextView) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        // scroll the comment text view to be visible.

        [self.treeScrollView setContentOffset:CGPointMake(0.0, self.commentTextView.frame.origin.y-kbSize.height+self.commentTextView.bounds.size.height) animated:YES];
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
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjects:@[self.theme, self.landMarks.text, [NSString stringWithFormat:@"lat - %f; long - %f", incidentCoord.latitude, incidentCoord.longitude], self.commentTextView.text] forKeys:@[@"subject", @"landmark", @"location", @"discription"]];
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
