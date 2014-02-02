//
//  ParkingMeterViewController.h
//  City 311
//
//  Created by Qian Wang on 1/22/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkingMeterViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *problemLabel;

@end
