//
//  TreeViewController.h
//  City 311
//
//  Created by Qian Wang on 1/25/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface TreeViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserInfoProxy, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) UIImage *userImage;
@property (copy, nonatomic) NSString *theme;

@end
