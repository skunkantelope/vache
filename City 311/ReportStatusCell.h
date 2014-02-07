//
//  ReportStatusCell.h
//  City 311
//
//  Created by Qian Wang on 2/2/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *brief;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;

@end
