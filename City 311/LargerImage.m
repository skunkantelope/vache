//
//  LargerImage.m
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "LargerImage.h"

@interface LargerImage ()

- (void)dismissSelf;

@end

@implementation LargerImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // self.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
        gestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gestureRecognizer];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height - 22.0)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.largeImageview = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 22.0, frame.size.width, 22.0)];
        //label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        

        [self addSubview:label];
        self.caption = label;
      
    }
    return self;
}

- (void)dismissSelf {
    [self.delegate presentReportSheetWithItem:self.caption.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
