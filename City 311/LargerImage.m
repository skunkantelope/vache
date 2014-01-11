//
//  LargerImage.m
//  City 311
//
//  Created by Qian Wang on 1/10/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "LargerImage.h"

@implementation LargerImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.largeImageview = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, frame.size.height - 20.0, frame.size.width, 20.0)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.caption = label;
    }
    return self;
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
