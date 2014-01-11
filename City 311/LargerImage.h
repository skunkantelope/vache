//
//  LargerImage.h
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LargerImageDelegate <NSObject>

- (void)presentReportSheet;

@end

@interface LargerImage : UIView

@property (strong) UIImageView *largeImageview;
@property (strong) UILabel *caption;
@property (assign) id<LargerImageDelegate> delegate;

@end
