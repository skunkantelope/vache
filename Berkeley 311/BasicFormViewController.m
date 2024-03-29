//
//  BasicFormViewController.m
//  Berkeley 311
//
//  Created by Qian Wang on 9/7/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "BasicFormViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

@interface BasicFormViewController ()

@property (retain, nonatomic) UIView *activeField;
@end

#define PHOTO_ALBUM 0
#define CAMERA 1

@implementation BasicFormViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextFieldOrTextView:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.guides.text = self.infomation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignTextFieldOrTextView:(UIGestureRecognizer *)gestureRecognizer {
    [self.activeField resignFirstResponder];
}

#pragma mark UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    self.activeField = textView;
    
    return YES;
}

#pragma mark UITextFiledDelegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.activeField = textField;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    // validate information
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == PHOTO_ALBUM) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;

        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else if (buttonIndex == CAMERA) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;

        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    
}

#pragma mark UIImagePickerController delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    // Get the image metadata;
    UIImagePickerControllerSourceType pickerType = picker.sourceType;
    if (pickerType == UIImagePickerControllerSourceTypeCamera) {
        NSDictionary *imageMetadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
            
        // Get the assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock = ^(NSURL *newURL, NSError *error) {
            if (error) {
                NSLog(@"Can not save the photo %@.", error);
            } else {
                NSLog(@"Wrote image with metadata to Photo Library");
            }
        };
        
        // save the new image to the camera roll
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:imageMetadata completionBlock:imageWriteCompletionBlock];
        NSLog(@"metadata: %@", [imageMetadata description]);
    } else if (pickerType == UIImagePickerControllerSourceTypePhotoLibrary) {
        // Get the assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        // Enumerate just the photos group by using ALAssetsGroupSavedPhotos.
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            // Within the group enumeration block, filter to enumerate just photos.
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0]
                                    options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                    //     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                    //     NSDictionary *imageMetadata = [representation metadata];
                                         
                                         CLLocation *location = [alAsset valueForProperty:ALAssetPropertyLocation];
                                         NSDate *date = [alAsset valueForProperty:ALAssetPropertyDate];
                                         NSLog(@"location %@ and date %@", location, date);
                                     }
                                 }];
        } failureBlock:^(NSError *error) {
            NSLog(@"Photo is not found");
        }];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)sendPhotoEvidence:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Enter manually" destructiveButtonTitle:nil otherButtonTitles:@"Select a photo", /*@"Take a new photo",*/ nil];
   // NSLog(@"cancel index %i", sheet.cancelButtonIndex); why is the index is 2? It's supposed to be -1.
    [sheet showInView:(UIView *)sender];
    
}

@end
