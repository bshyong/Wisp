//
//  STTableViewController.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/20/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STTableViewController.h"
#import "STTopCell.h"
#import "STTableViewCell.h"
#import "STWebViewController.h"
#import "STFeedItem.h"
#import "NYXImagesKit.h"
#import "NYXProgressiveImageView.h"

@interface STTableViewController ()
{
    UIRefreshControl *refreshControl;
    NSURL *feedURL;
}
@end

@implementation STTableViewController

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
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMM dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSString *title = @"#entertainment";
    
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ ~ %@", dateString, title];
//    self.navigationController.navigationBar.topItem.prompt = title;
    //  hide the status bar
//  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    feedURL = [NSURL URLWithString:@"https://tw.news.yahoo.com/rss/entertainment"];
    
    //add refresh control to the table view
    refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    NSString* fetchMessage = [NSString stringWithFormat:@"Fetching: %@",feedURL];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    [self.tableView addSubview: refreshControl];
    [self refreshFeed];
}

// implement refresh control delegate
-(void)refreshInvoked:(id)sender forState:(UIControlState)state{
    [self refreshFeed];
}

-(void)refreshFeed {
    STFeedLoader *feedloader = [[STFeedLoader alloc] init];
    // assign ViewController as delegate of feedloader
    feedloader.delegate = self;
    [feedloader loadItemsFromURL:feedURL];
}

# pragma mark - Implement protocol methods
-(void)processCompleted:(NSArray *)results{
//  completion finished parsing, returns object
    self.items = results;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [refreshControl endRefreshing];
    [self.tableView reloadData];
}

-(void)processHasErrors {
//    handle errors
    NSLog(@"An error occured: processHasErrors delegate method in STTableViewController");
}

-(void)imageLoadedForItemAtIndex:(NSNumber *)index{
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[index integerValue] inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STFeedItem *item = [self.items objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
    STTableViewCell *standardCell = (STTableViewCell *)cell;
    
    if (item.imageURL) {
        
        UIImageView *imageBackground = [[UIImageView alloc] init];
        
        UIImage *image = item.imageData;
        if (image.size.height > image.size.width) {
            UIImage *resizedImage = [image scaleToFitSize:(CGSize){320, 320/image.size.width*image.size.height}];
            UIImage *croppedImage = [resizedImage cropToSize:(CGSize){cell.frame.size.width, cell.frame.size.height} usingMode:NYXCropModeTopCenter];
            imageBackground.image = croppedImage;
        } else {
            UIImage *resizedImage = [image scaleToFitSize:(CGSize){180*image.size.width/image.size.height, 180}];
            UIImage *croppedImage = [resizedImage cropToSize:(CGSize){cell.frame.size.width, cell.frame.size.height} usingMode:NYXCropModeCenter];
            imageBackground.image = croppedImage;
        }
        // Calculate label height to generate overlay
        CGSize maximumLabelSize = CGSizeMake(280, 4*cell.frame.size.height/9);
        CGRect expectedLabelSize = [[item title] boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:standardCell.itemTitle.font} context:nil];

        UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-30-expectedLabelSize.size.height, cell.frame.size.width, expectedLabelSize.size.height+30)];
        [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.45]];
        [imageBackground addSubview:overlay];

        cell.backgroundView = imageBackground;
    } else {
        // reset cell background view since cells are dequeued and reused!
        cell.backgroundView = nil;
    }

    // set cell background color
    // items are assigned a color when initialized
    cell.backgroundColor = [item color];

    standardCell.itemTimeAgo.text = @"timeAgo";
    standardCell.itemTitle.text = [item title];
    return standardCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    if ([segue.identifier isEqualToString:@"showFeedItem"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        STWebViewController *wbc = (STWebViewController *)segue.destinationViewController;
        wbc.itemURL = ((STFeedItem *)[self.items objectAtIndex:indexPath.row]).itemURL;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
