//
//  STFeedItem.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/21/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STFeedItem : NSObject
    @property(strong, nonatomic) NSString *title;
    @property(strong, nonatomic) NSURL *imageURL;
    @property(strong, nonatomic) NSDate *pubDate;
    @property(strong, nonatomic) NSURL *itemURL;
    @property(strong, nonatomic) NSString *source;
    @property(strong, nonatomic) UIImage *imageData;
@end
