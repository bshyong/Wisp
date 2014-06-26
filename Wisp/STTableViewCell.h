//
//  STTableViewCell.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/24/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemTimeAgo;
@end
