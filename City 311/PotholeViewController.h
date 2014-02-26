//
//  PotholeViewController.h
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//
#import <MapKit/MapKit.h>
#import "CityFirstViewController.h"
@interface PotholeViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserInfoDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *surface;
@property (strong, nonatomic) UIImage *userImage;
@property (copy, nonatomic) NSString *theme;
@property (assign, nonatomic) CityFirstViewController *chief;
@end
