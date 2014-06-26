//
//  STFeedItem.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/21/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STFeedItem.h"

@implementation STFeedItem

-(id)init {
    self = [super init];
    if (self){
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.7;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.4;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        //  set cell background view to random solid color from a palette
        self.color = color;
        self.imageCropped = NO;
        return self;
    }
    return nil;
}

-(NSString *)formattedDate {
    // use this method to format publication date
    // look into formatting according to User settings/locale
    NSDateFormatter *nd = [[NSDateFormatter alloc] init];
    return [nd stringFromDate:self.pubDate];
}

@end
