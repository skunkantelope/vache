//
//  LargerImage.h
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LargerImageDelegate <NSObject>

- (void)presentReportSheetWithItem:(NSString*)item;

@end

@interface LargerImage : UIView

@property (weak, nonatomic) UIImageView *largeImageview;
@property (weak, nonatomic) UILabel *caption;
@property (assign, nonatomic) id<LargerImageDelegate> delegate;

@end
