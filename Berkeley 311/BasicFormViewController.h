//
//  BasicFormViewController.h
//  Berkeley 311
//
//  Created by Qian Wang on 9/7/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicFormViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

- (IBAction)sendPhotoEvidence:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *guides;
@property (retain, nonatomic) NSString *infomation;

@end
