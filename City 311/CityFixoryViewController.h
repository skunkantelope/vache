//
//  CityFixoryViewController.h
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CityFixoryViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIImageView *incidentImage;
@property (retain, nonatomic) NSString *guidance;

@end
