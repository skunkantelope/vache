//
//  CityFirstViewController.h
//  City 311
//
//  Created by Qian Wang on 1/9/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "LargerImage.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface CityFirstViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, LargerImageDelegate, UserInfoProxy, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *coverView;

@end
