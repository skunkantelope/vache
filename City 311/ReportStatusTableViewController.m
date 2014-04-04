//
//  ReportStatusTableViewController.m
//  City 311
//
//  Created by Qian Wang on 1/29/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "ReportStatusTableViewController.h"
#import "ReportStatusCell.h"

@interface ReportStatusTableViewController () {
    NSMutableArray *records;
    NSString *path;
    
    int index;
}

- (IBAction)sendReport:(id)sender;

@end

@implementation ReportStatusTableViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // call CityUtility to get the content.
    records = [[NSMutableArray alloc] initWithArray:[CityUtility userRecords]];
}

- (void)viewWillAppear:(BOOL)animated {

    records = [CityUtility userRecords];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.statusButton.tag = indexPath.row;
    NSDictionary *request = records[indexPath.row];
    cell.title.text = [request valueForKey:@"subject"];
    NSString *moreText = [request valueForKey:@"landmark"];
    if (!moreText) {
        moreText = @"";
    }
    cell.brief.text = moreText;
    NSNumber *showButton = [request valueForKey:@"showButton"];
    if (showButton) {
        NSLog(@"showButton %i", [showButton boolValue]);
        if (![showButton boolValue]) {
            // remove the button.
            [cell.statusButton removeFromSuperview];
        }
    } else {
        [cell.statusButton removeFromSuperview];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *dictionary = records[indexPath.row];
        if (dictionary[@"path"]) {
            [CityUtility removeUserRequest:dictionary[@"path"]];
        }
        [records removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [CityUtility saveUserRecords:records];
        // if the record has associated files, remove them as well.
        
    }   
 
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
- (IBAction)sendReport:(id)sender {
    // need to find the indexpath;
    UIButton *button = (UIButton*) sender;
    
    NSMutableDictionary *dictionary = records[button.tag];
    //   NSLog(@"indexpath %i", button.tag);
    if ([CityUtility loadFilesAtPath:[dictionary valueForKey:@"path"]]) {
     // remove the button.
     ReportStatusCell *cell = (ReportStatusCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
     [cell.statusButton removeFromSuperview];
     [dictionary removeObjectsForKeys:@[@"path", @"showButton"]];
     [CityUtility saveUserRecords:records];
    }

}
*/
- (IBAction)sendReport:(id)sender {
    // need to find the indexpath;
    UIButton *button = (UIButton*) sender;
    index = button.tag;
    NSMutableDictionary *dict = records[index];
 //   NSLog(@"indexpath %i", button.tag);
    NSLog(@"%@", [dict description]);
    
    path = [dict valueForKey:@"path"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:path];
    NSLog(@"%@",documentDirectory);

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[documentDirectory stringByAppendingPathComponent:@"text"]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastName = [userDefaults objectForKey:@"lastName"];
    NSString *firstName = [userDefaults objectForKey:@"firstName"];
    NSString *phone = [userDefaults objectForKey:@"phone"];
    NSString *email = [userDefaults objectForKey:@"email"];
    
    [dictionary setValue:lastName forKey:@"lastName"];
    [dictionary setValue:firstName forKey:@"firstName"];
    [dictionary setValue:phone forKey:@"phone"];
    [dictionary setValue:email forKey:@"email"];
    
    NSLog(@"%@", [dictionary description]);

    UIImage *image;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"image"]]) {
        image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:@"image"]];
    }
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"311 Service Request from Berkeley 311 App"];
        [mailController setToRecipients:@[@"nicklittlejohn@gmail.com"]];
        NSString *body = [dictionary description];
        [mailController setMessageBody:body isHTML:NO];
        
        if (image) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [mailController addAttachmentData:imageData mimeType:@"image/png"
                                     fileName:@"image"];
        }
        [self presentViewController:mailController animated:NO completion:nil];
        
    } else {
        NSLog(@"can't send emails");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hey Citizen -" message:@"Berkeley City Service team currently receives only email request. It seems your email service is not set up yet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes", nil];
        [alert show];
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller.presentingViewController dismissViewControllerAnimated:NO completion:^{
        
        if (result == MFMailComposeResultSent) {
            NSLog(@"queued at outbox");
            // remove the button.
            ReportStatusCell *cell = (ReportStatusCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [cell.statusButton removeFromSuperview];
            NSMutableDictionary *dictionary = records[index];
            [dictionary removeObjectsForKeys:@[@"path", @"showButton"]];
            [CityUtility saveUserRecords:records];
            // remove the file store at path as well.
            [CityUtility removeUserRequest:path];
                            
            return;
        }
          {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Greetings from City Hall:" message:@"We didn't receive your request. It could be poor network connection. Please send it again soon!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        
    }];
    
}

@end
