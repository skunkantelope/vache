//
//  CityFixoryViewController.h
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CityFixoryViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserInfoProxy, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (retain, nonatomic) NSString *guidance;
@property (strong, nonatomic) UIImage *userImage;
@property (copy, nonatomic) NSString *theme;

@end
