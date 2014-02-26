//
//  GeneralRequestViewController.h
//  City 311
//
//  Created by Qian Wang on 1/15/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityFirstViewController.h"
@interface GeneralRequestViewController : UIViewController <UITextViewDelegate, UserInfoDelegate>
@property (copy, nonatomic) NSString *theme;
@property (assign, nonatomic) CityFirstViewController *chief;
@end
