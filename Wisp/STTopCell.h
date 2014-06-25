//
//  STTopCell.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/24/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topDate;
@property (weak, nonatomic) IBOutlet UILabel *topItemTimeAgo;
@property (weak, nonatomic) IBOutlet UILabel *topItemTitle;

@end
