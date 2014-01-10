//
//  CityFirstViewController.m
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"

@interface CityFirstViewController () {
    NSArray *fixory;
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
    
}

@end
