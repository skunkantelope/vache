//
//  CityFirstViewController.m
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"
#import "CityFixoryViewController.h"
#import "ParkingMeterViewController.h"
#import "TreeViewController.h"
#import "PotholeViewController.h"
#import "MissedPickupsViewController.h"
#import "GeneralRequestViewController.h"

enum Fixory {
    Graffiti, Pothole, Meter, Dumping,
};

@interface CityFirstViewController () {
    NSArray *fixory;
    NSArray *captions;
    UIView *maskView;
    LargerImage *topImage;
    UITapGestureRecognizer *tapGesture;
    
    BOOL isFirstLoad; // rely on the default value 0. As I can't initialize it in app delegate. Can't initialize City First View Controller in application didFinishLauch method.
    
    NSMutableDictionary *_savedDictionary;
    NSData *JSONData;
    id incidentImage;
}
@property (retain, nonatomic) NSMutableDictionary *savedDictionary;

+ (NSString *)instructionFor:(int)category;

- (void)tapOnGray:(UITapGestureRecognizer *)sender;

@end

@implementation CityFirstViewController
@synthesize savedDictionary = _savedDictionary;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!isFirstLoad) {
        
        [[NSBundle mainBundle] loadNibNamed:@"startView" owner:self options:nil];
        self.coverView.frame = self.view.bounds;
        [self.view addSubview:self.coverView];
        isFirstLoad = YES;
    }
    fixory = @[@"EZ", @"pickups", @"parkingMeters", @"pothole", @"graffiti", @"dumping", @"tree", @"request"];
    captions = @[@"Park EZ Pay Station", @"Missed Pick-ups", @"Broken Parking Meter", @"Street or Sidewalk Pothole", @"Graffiti", @"Illegal Dumping", @"Plant Trees", @"Request General Service"];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGray:)];
    tapGesture.numberOfTapsRequired = 1;
    
    maskView = [[UIView alloc] init];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    // create the eight LargerImage objects.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReportStatusToUser) name:@"ShowStatusTab" object:nil];
}

- (void) showReportStatusToUser {

    self.tabBarController.selectedIndex = 2;
}

+ (NSString *)instructionFor:(int)category {
    NSString *instruction;
    switch (category) {
        case Graffiti:
            instruction = @"Is it offensive, not offensive? Is it a business, house, bus bench, traffic sign, etc.?";
            break;
        case Pothole:
            instruction = @"";
            break;
        case Meter:
            instruction = @"";
            break;
        case Dumping:
            instruction = @"Is it a public safety hazard? What material is dumped?";
            break;
        default:
            instruction = @"";
            break;
    }
    return instruction;
}

- (void)tapOnGray:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [topImage removeFromSuperview];
        [maskView removeFromSuperview];
        [self.view removeGestureRecognizer:tapGesture];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionviewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:fixory[indexPath.row] forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // special effect - animate to a large display of selected image.
    // Step 1. Add one grey transparent layer to controller view. See it in viewDidLoad method.
    [self.view addSubview:maskView];
    // set constraints for maskView;
    [maskView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(maskView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[maskView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[maskView]|" options:0 metrics:nil views:views]];

    // Step 2. Add a view to controller view. Center the view.
    topImage = [[LargerImage alloc] initWithFrame:CGRectMake(0.0, 0.0, 300, 199)];
    topImage.delegate = self;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    for (id aView in [cell subviews]) {
        for (id anotherView in [aView subviews]) {
            if ([anotherView isKindOfClass:[UIImageView class]]) {
                UIImage *originalImage = [(UIImageView *)anotherView image];
                topImage.largeImageview.image = originalImage;
                topImage.caption.text = captions[indexPath.row];
            } else {
                NSLog(@"didn't find an image");
            }
        }
        
    }

    [self.view addSubview:topImage];
    // place the topImage.
    [topImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    // pin width.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[topImage(==300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topImage)]];
    // pin height.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:199.00]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:topImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    // Step 3. Controller view receives tap event. When tapped, remove the layer created in step 1. Remove the view created in step 2. See the tap gesture method.
    [self.view addGestureRecognizer:tapGesture];
    // Step 4. When the view receives tap, brings the CityFixoryViewController. Create a subclass of UIView, use protocol method, set this view controller to be a delegate that does presenting modal view transition.
    NSLog(@"view frame %@", NSStringFromCGRect(self.view.frame));
}

#pragma mark - LargerImageDelegateMethod
- (void)presentReportSheetWithItem:(NSString *)item {
    NSLog(@"scene %@", item);
    [topImage removeFromSuperview];
    [maskView removeFromSuperview];
    if ([item isEqualToString:@"Missed Pick-ups"]) {
        [self performSegueWithIdentifier:@"Pickups" sender:item];
        return;
    }
    if ([item isEqualToString:@"Request General Service"]) {
        [self performSegueWithIdentifier:@"Request" sender:item];
        return;
    }
    if ( [item isEqualToString:@"Park EZ Pay Station"] ) {
        [self performSegueWithIdentifier:@"ParkingMeter" sender:item];
        return;
    }
    if ( [item isEqualToString:@"Broken Parking Meter"]) {
        [self performSegueWithIdentifier:@"ParkingMeter" sender:item];
        return;
    }
    if ([item isEqualToString:@"Street or Sidewalk Pothole"]){
        [self performSegueWithIdentifier:@"Pothole" sender:item];
        return;
    }
    if ([item isEqualToString:@"Plant Trees"]) {
        [self performSegueWithIdentifier:@"PlantTree" sender:item];
        return;
    }
    
    [self performSegueWithIdentifier:@"PresentReportSheet" sender:item];
    
    //    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma Seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentReportSheet"]) {
        CityFixoryViewController *fixorySheet = segue.destinationViewController;
        fixorySheet.theme = (NSString *)sender;
        fixorySheet.chief = self;
        enum Fixory k = Dumping;
        if ([(NSString *)sender isEqualToString:@"Graffiti"]) {
            k = Graffiti;
        }
        fixorySheet.guidance = [CityFirstViewController instructionFor:k];
        return;
    }
    if ([segue.identifier isEqualToString:@"Pickups"]) {
        MissedPickupsViewController *viewController = segue.destinationViewController;
        viewController.theme = @"No Pickups Noticed";
        viewController.chief = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"Request"]) {
        GeneralRequestViewController *viewController = segue.destinationViewController;
        viewController.theme = @"Service Request";
        viewController.chief = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"ParkingMeter"]) {
        ParkingMeterViewController *viewController = segue.destinationViewController;
        viewController.theme = @"Parking Meter Problem";
        viewController.chief = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"Pothole"]) {
        PotholeViewController *viewController = segue.destinationViewController;
        viewController.theme = @"Pothole Fix";
        viewController.chief = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"PlantTree"]) {
        TreeViewController *viewController = segue.destinationViewController;
        viewController.theme = @"Missing Tree Found";
        viewController.chief = self;
        return;
    }

}

#pragma mark UserInfoProxy delegate method
- (void)appendUserInfo:(NSDictionary *)userInfo serviceRequest:(NSDictionary *)request andImage:(id)image {

    incidentImage = image;
    _savedDictionary = [[NSMutableDictionary alloc] init];
    [_savedDictionary addEntriesFromDictionary:request];
    //NSLog(@"request %@", [request description]);
    
    // combine request and userInfo
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:request];
    [dictionary addEntriesFromDictionary:userInfo];
    
    NSError *error;
    
    JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        // not able to create JSON.
        NSLog(@"No JSON String");
    }
    
    if (![self sendByEmail:JSONData andImage:image]) {
        NSLog(@"can't send emails");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey Citizen -" message:@"Berkeley City Service team currently receives only email request. It seems your email service is not set up yet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    
    /*    if(![CityUtility sendJSON:JSONData andImage:incidentPhoto]) {
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
     [CityUtility saveRequest:savedDictionary];*/
}

- (BOOL)sendByEmail:(NSData *)JSON andImage:(id)image {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"311 Service Request from Berkeley 311 App"];
        [mailController setToRecipients:@[@"nicklittlejohn@gmail.com"]];
        NSString *body = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
        [mailController setMessageBody:body isHTML:NO];
        
        if (image) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [mailController addAttachmentData:imageData mimeType:@"image/png"
                                     fileName:@"image"];
        }
        [self presentViewController:mailController animated:NO completion:nil];
        return TRUE;
    }
    return FALSE;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller.presentingViewController dismissViewControllerAnimated:NO completion:^{
        
        if (result == MFMailComposeResultSent) {
            NSLog(@"queued at outbox");
        } else {
            // store the failure status
            [_savedDictionary setValue:[NSNumber numberWithBool:true] forKey:@"showButton"];
            // generate a file path.
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyMMddHHmmss"];
            NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
            
            [_savedDictionary setValue:dateString forKey:@"path"];
       // NSLog(@"json %@",[[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding]);

            [CityUtility saveJSON:JSONData andImage:incidentImage atFilePath:dateString];
        }
        // after all, save the request
        [CityUtility saveRequest:_savedDictionary];
    }];
    
}

@end
