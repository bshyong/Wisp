//
//  STTableViewController.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/20/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STFeedLoader.h"

@interface STTableViewController : UITableViewController <STFeedLoaderDelegate>
@property(nonatomic, strong) NSArray *items;
@end
