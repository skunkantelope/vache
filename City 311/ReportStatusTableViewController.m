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
        [records removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [CityUtility saveUserRecords:records];
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

- (IBAction)sendReport:(id)sender {
    // need to find the indexpath;
   // UIButton *button = (UIButton*) sender;

//    [self.tableView indexPathForRowAtPoint:[button ]
//    if ([CityUtility loadFilesAtPath:<#(NSString *)#>]) {
//        <#statements#>
//    }
}
@end
