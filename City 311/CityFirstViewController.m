//
//  CityFirstViewController.m
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"
#import "CityFixoryViewController.h"

enum Fixory {
    Graffiti, Pothole, Meter, Dumping,
};

@interface CityFirstViewController () {
    NSArray *fixory;
    NSArray *captions;
    CALayer *greyLayer;
    LargerImage *topImage;
    UITapGestureRecognizer *tapGesture;
    
    BOOL isFirstLoad; // rely on the default value 0. As I can't initialize it in app delegate. Can't initialize City First View Controller in application didFinishLauch method.
    
}

+ (NSString *)instructionFor:(int)category;

- (void)tapOnGray:(UITapGestureRecognizer *)sender;

@end

@implementation CityFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (!isFirstLoad) {
        
        [[NSBundle mainBundle] loadNibNamed:@"startView" owner:self options:nil];
        self.coverView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 49);
        [self.view addSubview:self.coverView];
        isFirstLoad = YES;
    }
    fixory = @[@"EZ", @"pickups", @"parkingMeters", @"pothole", @"graffiti", @"dumping", @"tree", @"request"];
    captions = @[@"Park EZ Pay Station", @"Missed Pick-ups", @"Broken Parking Meter", @"Street or Sidewalk Pothole", @"Graffiti", @"Illegal Dumping", @"Plant Trees", @"Request General Service"];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGray:)];
    tapGesture.numberOfTapsRequired = 1;
    
    greyLayer = [CALayer layer];
    greyLayer.opacity = 0.7;
    greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
    greyLayer.frame = self.view.bounds;
    
    // create the eight LargerImage objects.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReportStatusToUser) name:@"ShowStatusTab" object:nil];
}

- (void) showReportStatusToUser {

    self.tabBarController.selectedIndex = 3;
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
        [greyLayer removeFromSuperlayer];
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
    [self.view.layer addSublayer:greyLayer];
    NSLog(@"selected me");
    // Step 2. Add a view to controller view. Center the view.
    topImage = [[LargerImage alloc] initWithFrame:CGRectMake(70.0, 100.0, 180.0, self.view.bounds.size.height - 100.0 - 49.0 - 50.0)];
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
    // Step 3. Controller view receives tap event. When tapped, remove the layer created in step 1. Remove the view created in step 2. See the tap gesture method.
    [self.view addGestureRecognizer:tapGesture];
    // Step 4. When the view receives tap, brings the CityFixoryViewController. Create a subclass of UIView, use protocol method, set this view controller to be a delegate that does presenting modal view transition.
    
}

#pragma mark - LargerImageDelegateMethod
- (void)presentReportSheetWithItem:(NSString *)item {
    NSLog(@"scene %@", item);
    [topImage removeFromSuperview];
    [greyLayer removeFromSuperlayer];
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
        enum Fixory k = Dumping;
        if ([(NSString *)sender isEqualToString:@"Graffiti"]) {
            k = Graffiti;
        }
        fixorySheet.guidance = [CityFirstViewController instructionFor:k];
    }
}

@end
