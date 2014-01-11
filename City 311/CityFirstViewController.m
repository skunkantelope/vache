//
//  CityFirstViewController.m
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"
#import "CityFixoryViewController.h"
#import "LargerImage.h"

@interface CityFirstViewController () {
    NSArray *fixory;
    CALayer *greyLayer;
    LargerImage *topImage;
}

@end

@implementation CityFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    fixory = @[@"EZ", @"pickups", @"parkingMeters", @"canard"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionviewDatasource

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

#pragma UICollectionviewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // special effect - animate to a large display of selected image.
    // Step 1. Add one grey transparent layer to controller view.
    greyLayer = [CALayer layer];
    greyLayer.opacity = 0.37;
    greyLayer.backgroundColor = [UIColor grayColor].CGColor; // Todo: Use color space to make a nicer color;
    greyLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:greyLayer];
    
    // Step 2. Add a view to controller view. Center the view.
    topImage = [[LargerImage alloc] initWithFrame:CGRectMake(70.0, 100.0, 180.0, self.view.bounds.size.height - 100.0 - 49.0 - 50.0)];
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
    // Step 3. Controller view receives tap event. When tapped, remove the layer created in step 1. Remove the view created in step 2.
    // Step 4. When the view receives tap, brings the CityFixoryViewController. Create a subclass of UIView, use protocol method, set this view controller to be a delegate that does presenting modal view transition.
    
//    [self performSegueWithIdentifier:@"PresentReportSheet" sender:[collectionView cellForItemAtIndexPath:indexPath]];
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma Seque
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"PresentReportSheet"]) {
        CityFixoryViewController *fixorySheet = segue.destinationViewController;
    }
}
@end
