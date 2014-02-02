//
//  CityNewsViewController.m
//  City 311
//
//  Created by Qian Wang on 1/12/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityNewsViewController.h"
#import "CityNews.h"

@interface CityNewsViewController () {
   // NSString *today;
    
    NSMutableDictionary *news;
    NSMutableArray *monthlyNews;
    NSMutableArray *newsMonth;
    
    NSMutableString *currentStringValue;
    CityNews *currentNews;
}

- (void)parseXMLContent:(NSString *)path;
@end

@implementation CityNewsViewController

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
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateStyle:NSDateFormatterLongStyle];
    //[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    //today = [dateFormatter stringFromDate:[NSDate date]];
    // parse the news page at http://www.cityofberkeley.info/PressReleaseMain.aspx
    // seems not work for aspx webpages.
    [self parseXMLContent:@"http://www.cityofberkeley.info/PressReleaseMain.aspx"];
    [self.tableView reloadData];
}

- (void)parseXMLContent:(NSString *)path {
    BOOL test;
    NSURL *xmlURL = [NSURL URLWithString:path];
    NSData *newsHtmlData = [NSData dataWithContentsOfURL:xmlURL];
    
    NSXMLParser *cityNewsParser = [[NSXMLParser alloc] initWithData:newsHtmlData];
    
    [cityNewsParser setDelegate:self];
    test = [cityNewsParser parse];
    NSLog(@"Parsing succesful? %i", test);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSXMLParser methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"div"]) {
        NSString *position = [attributeDict objectForKey:@"id"];
        if ([position isEqualToString:@"ctl00_Col2ContentPlaceholder_pnlMain"]) {
            // Find where the news lie.
            if (!news) {
                news = [[NSMutableDictionary alloc] init];
            }
            return;
        }
    }
    
    if (news && [elementName isEqualToString:@"h2"]) {
        // find a section.
        if (!newsMonth) {
            newsMonth = [[NSMutableArray alloc] init];
        }
        return;
    }
    if (newsMonth && [elementName isEqualToString:@"ul"]) {
        monthlyNews = [[NSMutableArray alloc] init];
        return;
    }
    if (newsMonth && [elementName isEqualToString:@"li"]) {
        currentNews = [[CityNews alloc] init];
        return;
    }
    
    if (newsMonth && [elementName isEqualToString:@"a"]) {
        if (currentNews)
            currentNews.link = [attributeDict objectForKey:@"href"];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    
    [currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"div"]) {
        [parser abortParsing];
        return;
    }
    if ([elementName isEqualToString:@"h2"]) {
        // add the month which is a section
        [newsMonth addObject:currentStringValue];
        NSLog(@"%@", currentStringValue);
        currentStringValue = nil;
        return;
    }
    if ([elementName isEqualToString:@"li"]) {
        [monthlyNews addObject:currentNews];
        return;
    }
    if ([elementName isEqualToString:@"a"]) {
        // add the title to currentNews.
        currentNews.title = currentStringValue;
        currentStringValue = nil;
        return;
    }
    if ([elementName isEqualToString:@"ul"]) {
        // set the reference in news
        [news setObject:monthlyNews forKey:[newsMonth lastObject]];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"error: %@", parseError);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [newsMonth count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *array = [news objectForKey:newsMonth[section]];
    return [array count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    NSArray *array = [news objectForKey:newsMonth[indexPath.section]];
    CityNews *aNews = array[indexPath.row];
    cell.textLabel.text = aNews.title;
    
    // Configure the cell...
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return newsMonth[section];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
