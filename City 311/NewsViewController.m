//
//  NewsViewController.m
//  City 311
//
//  Created by Qian Wang on 1/17/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "NewsViewController.h"
#import "TFHpple.h"

@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *newsView;

- (NSString *)findNewsContent:(NSString *)link;
@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)findNewsContent:(NSString *)link {

    NSData *htmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:link]];
    
    TFHpple *newsParser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xPathQuery = @"//a[@class='contentToolbar']";
    NSArray *nodes = [newsParser searchWithXPathQuery:xPathQuery];
    
    for (TFHppleElement *element in nodes) {
        if ([[[element firstChild] content] isEqualToString:@"printable version"])
            return [@"http://www.cityofberkeley.info" stringByAppendingString: [element objectForKey:@"href"]];
    }
    return @"404 Error";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.newsView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *urlString = [self findNewsContent:self.newsURLString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.newsView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
        });
    });
    
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.newsView.loading) {
        [self.newsView stopLoading];
    }
   // self.newsView.delegate = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *errorString = [NSString stringWithFormat:@"<html><center><font size=+5 color='red'>We did not find the page:<br>%@</font></center></html>", error.localizedDescription];
    [webView loadHTMLString:errorString baseURL:nil];

}

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
