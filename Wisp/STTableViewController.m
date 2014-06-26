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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

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
    
    if(indexPath.row==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
        if (item.imageURL) {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [item imageURL]];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
        } else {
            //  set cell background view to solid color
            cell.backgroundColor = [UIColor grayColor];
        }
        STTopCell *topCell = (STTopCell *)cell;
        topCell.topDate.text = @"topDate";
        topCell.topItemTimeAgo.text = @"topTimeAgo";
        [topCell.topItemTitle setNumberOfLines:0];
        [topCell.topItemTitle sizeToFit];
        topCell.topItemTitle.text = [item title];
        return topCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
        
        if (item.imageURL) {
            
            UIImageView *imageBackground = [[UIImageView alloc] init];
            
            UIImage *image = item.imageData;
            if (image.size.height > image.size.width) {
                UIImage *resizedImage = [image scaleToFitSize:(CGSize){320, 320/image.size.width*image.size.height}];
                UIImage *croppedImage = [resizedImage cropToSize:(CGSize){cell.frame.size.width, cell.frame.size.height} usingMode:NYXCropModeTopCenter];
                imageBackground.image = croppedImage;
            } else {
                UIImage *resizedImage = [image scaleToFitSize:(CGSize){150*image.size.width/image.size.height, 150}];
                UIImage *croppedImage = [resizedImage cropToSize:(CGSize){cell.frame.size.width, cell.frame.size.height} usingMode:NYXCropModeCenter];
                imageBackground.image = croppedImage;
            }

//            CAGradientLayer *gradient = [CAGradientLayer layer];
//            gradient.frame = CGRectMake(0, 5*imageBackground.frame.size.height / 9, imageBackground.frame.size.width, 4*imageBackground.frame.size.height / 9);
//            gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//            gradient.opacity = 1;
//            [imageBackground.layer insertSublayer:gradient atIndex:0];
            UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, imageBackground.frame.size.height / 2, imageBackground.frame.size.width, imageBackground.frame.size.height / 2)];
            [overlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
            [imageBackground addSubview:overlay];
            cell.backgroundView = imageBackground;
        } else {
            // reset cell background view since cells are dequeued and reused!
            cell.backgroundView = nil;
        }
        //  set cell background view to random solid color from a palette
        cell.backgroundColor = [UIColor grayColor];
        STTableViewCell *standardCell = (STTableViewCell *)cell;
        standardCell.itemTimeAgo.text = @"timeAgo";
        [standardCell.itemTitle setNumberOfLines:0];
        [standardCell.itemTitle sizeToFit];
        standardCell.itemTitle.text = [item title];
        return standardCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 175;
    }
    return 150;
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
    UIViewController *sc = (UIViewController *)segue.sourceViewController;
    if ([segue.identifier isEqualToString:@"showFeedItem"]) {
        [sc.navigationController setNavigationBarHidden:NO animated: NO];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        STWebViewController *wbc = (STWebViewController *)segue.destinationViewController;
        wbc.itemURL = ((STFeedItem *)[self.items objectAtIndex:indexPath.row]).itemURL;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
