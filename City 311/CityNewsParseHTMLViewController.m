//
//  CityNewsParseHTMLViewController.m
//  City 311
//
//  Created by Qian Wang on 1/17/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityNewsParseHTMLViewController.h"
#import "CityNews.h"
#import "TFHpple.h"
#import "NewsViewController.h"

@interface CityNewsParseHTMLViewController () {
    NSMutableArray *newsFeed;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)loadNews;
@end

@implementation CityNewsParseHTMLViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadNews {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURL *cityNewsURL = [NSURL URLWithString:@"http://www.cityofberkeley.info/PressReleaseMain.aspx"];
        NSData *newsHtmlData = [NSData dataWithContentsOfURL:cityNewsURL];
        
        TFHpple *newsParser = [TFHpple hppleWithHTMLData:newsHtmlData];
        
        NSString *xPathQuery = @"//div[@id='ctl00_Col2ContentPlaceholder_pnlMain']/ul/li/a";
        NSArray *newsNodes = [newsParser searchWithXPathQuery:xPathQuery];
        
        for (TFHppleElement *element in newsNodes) {
            CityNews *aNews = [[CityNews alloc] init];
            aNews.title = [[element firstChild] content];
            aNews.link = [@"http://www.cityofberkeley.info" stringByAppendingString:[element objectForKey:@"href"]];
            [newsFeed addObject:aNews];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
            
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    if (newsFeed.count < 1) {
        [self loadNews];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    newsFeed = [[NSMutableArray alloc] initWithCapacity:2];
    [self loadNews];

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
    return [newsFeed count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsHTMLCell" forIndexPath:indexPath];
    
    // Configure the cell...
    CityNews *news = newsFeed[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = news.title;
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityNews *news = newsFeed[indexPath.row];

    [self performSegueWithIdentifier:@"LoadNews" sender:news.link];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LoadNews"]) {
        NewsViewController *viewController = [segue destinationViewController];
        viewController.newsURLString = (NSString *)sender;
    }
}

@end
