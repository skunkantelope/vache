//
//  LargerImage.h
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

//@class LargerImage;
@protocol LargerImageDelegate <NSObject>

//- (void)presentReportSheetWithItem:(LargerImage*)item;
- (void)presentReportSheetWithItem:(NSString*)item;
@end

@interface LargerImage : UIView

@property (weak, nonatomic) UIImageView *largeImageview;
@property (weak, nonatomic) UILabel *caption;
//@property (retain, nonatomic) NSString *description;
@property (assign, nonatomic) id<LargerImageDelegate> delegate;

@end
