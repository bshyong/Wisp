//
//  STTableViewCell.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/24/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STTableViewCell.h"

@implementation STTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
