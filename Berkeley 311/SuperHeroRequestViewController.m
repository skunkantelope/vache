//
//  SuperHeroRequestViewController.m
//  Berkeley 311
//
//  Created by Qian Wang on 9/2/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import "SuperHeroRequestViewController.h"
#import "BasicFormViewController.h"
#import "GeneralRequestViewController.h"

@interface SuperHeroRequestViewController ()

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *descriptions;

@end

const NSString *parkingMeter = @"Please tell us ID#. What are the problems? i.e. Change Not Accepted. Credit Card Not Accepted. Jammed Coin. Time Not Registered / Not Credited.";
const NSString *parkingEZ = @"Please tell us ID#. What are the problems? i.e. Change Not Accepted. Credit Card Not Accepted. Jammed Coin. Time Not Registered / Not Credited.";
const NSString *graffiti = @"Nature of the graffiti - Is it offensive, or not offensive? Type of building or object that the graffiti is found on - Is it a business, house, bus bench, traffic sign, etc.?";
const NSString *dumping = @"Is it a public safety hazard? i.e. blcoking traffic, leaking fluids, etc. Type of material dumped? i.e. household appliance, furniture, debris, waste, etc";
const NSString *pickups = @"Missed pickups must be reported no later than 5:00 p.m. the business day following the missed pick up (Monday – Friday). Crews are in the field until 2:30 p.m. We cannot accept a report for a missed pick up until after 2:30 p.m. on your collection day.";
const NSString *pothole = @"Is this pothole on public or private property? Street, Bike Lane, Crosswalk, Pathway, Sidewalk, freeway on/off ramp";
const NSString *trees = @"By applying to have a street tree planted, the applicant: Agrees to water the tree once each week, year-round, of the first two years after planting. Understands that the tree is the property of the City and any pruning or removal of the tree will be by the City or under the City’s direction.";

@implementation SuperHeroRequestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.categories = [NSArray arrayWithObjects:@"Broken Parking Meter", @"Park EZ Pay Station", @"Street or Sidewalk Pothole", @"Graffiti", @"Illegal Dumping", @"Missed Pick-ups", @"Plant Trees", @"Request General Service", nil];
    
    self.descriptions = [NSArray arrayWithObjects:parkingMeter, parkingEZ, pothole, graffiti, dumping, pickups, trees, nil];
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Issue";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.row == [self.categories count] -1) {

        GeneralRequestViewController *viewController = [[GeneralRequestViewController alloc] initWithNibName:@"GeneralRequestViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:viewController animated:YES];
        
        return;
    }
    
    UIStoryboard *basicForm = [UIStoryboard storyboardWithName:@"BasicForm" bundle:[NSBundle mainBundle]];
    BasicFormViewController *formViewController = [basicForm instantiateInitialViewController];
    formViewController.infomation = [self.descriptions objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:formViewController animated:YES];
}

@end
