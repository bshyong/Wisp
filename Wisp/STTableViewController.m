//
//  STTableViewController.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/20/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STTableViewController.h"
#import "STTopCell.h"

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
    NSLog(@"loading cell %d", indexPath.row);
    if(indexPath.row==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
        STTopCell *topCell = (STTopCell *)cell;
        topCell.topDate.text = @"topDate";
        topCell.topItemTimeAgo.text = @"topTimeAgo";
        topCell.topItemTitle.text = [[self.items objectAtIndex:0] title];
        return topCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
        cell.textLabel.text = [[self.items objectAtIndex:indexPath.row] title];
        return cell;
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
