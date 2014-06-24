//
//  STFeedItem.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/21/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STFeedItem.h"

@implementation STFeedItem

-(NSString *)formattedDate {
    // use this method to format publication date
    // look into formatting according to User settings/locale
    NSDateFormatter *nd = [[NSDateFormatter alloc] init];
    return [nd stringFromDate:self.pubDate];
}

@end
