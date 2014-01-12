//
//  CityFirstViewController.m
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"
#import "CityFixoryViewController.h"

@interface CityFirstViewController () {
    NSArray *fixory;
    CALayer *greyLayer;
    LargerImage *topImage;
    UITapGestureRecognizer *tapGesture;
}

- (void)tapOnGray:(UITapGestureRecognizer *)sender;

@end

@implementation CityFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    fixory = @[@"EZ", @"pickups", @"parkingMeters", @"canard"];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnGray:)];
    tapGesture.numberOfTapsRequired = 1;
    
    greyLayer = [CALayer layer];
    greyLayer.opacity = 0.7;
    greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
    greyLayer.frame = self.view.bounds;
    
    
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
    return 3;
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
    
    // Step 2. Add a view to controller view. Center the view.
    topImage = [[LargerImage alloc] initWithFrame:CGRectMake(70.0, 100.0, 180.0, self.view.bounds.size.height - 100.0 - 49.0 - 50.0)];
    topImage.delegate = self;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    for (id aView in [cell subviews]) {
        NSLog(@"number of subviews: %i", [[cell subviews] count]);
        for (id anotherView in [aView subviews]) {
            if ([anotherView isKindOfClass:[UIImageView class]]) {
                UIImage *originalImage = [(UIImageView *)anotherView image];
                NSLog(@"find an image");
                topImage.largeImageview.image = originalImage;
                topImage.caption.text = fixory[indexPath.row];
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
    [topImage removeFromSuperview];
    [greyLayer removeFromSuperlayer];
    [self performSegueWithIdentifier:@"PresentReportSheet" sender:item];
    
    //    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma Seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentReportSheet"]) {
        CityFixoryViewController *fixorySheet = segue.destinationViewController;
        fixorySheet.title = (NSString*)sender;
    }
}
@end
