//
//  STFeedLoader.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/22/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STFeedLoader.h"
#import "RXMLElement.h"
#import "STFeedItem.h"

@implementation STFeedLoader

-(void)loadItemsFromURL:(NSURL *)url {
//  activate activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//  code to load items from URL
//  and parse them using RaptureXML
    NSData *feed_data = [NSData dataWithContentsOfURL:url];
    // fetch the root node (should be 'channel')
    RXMLElement *root_node = [[RXMLElement elementFromXMLData:feed_data] child:@"channel"];
    NSArray *feed_items = [root_node children:@"item"];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:feed_items.count];

    for (RXMLElement *e in feed_items) {
        STFeedItem *new_item = [[STFeedItem alloc] init];
        new_item.title = [e child:@"title"].text;
        new_item.source = [e child:@"source"].text;
        new_item.itemURL = [NSURL URLWithString:[e child:@"link"].text];
        // parse for date
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE dd, MMM yyyy HH:mm:ss ZZZ"];
        [df setLocale:[NSLocale localeWithLocaleIdentifier:@"EN"]];
        NSDate *pubDate = [df dateFromString:[e child:@"pubDate"].text];
        new_item.pubDate = pubDate;
        // TODO: parse for larger version of picture
        new_item.imageURL = [NSURL URLWithString:[[e child:@"media:content"] attribute:@"url"]];
        // add new item to array of items
        [results addObject:new_item];
    }

    // call delegate method to indicate that method has completed
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted:)
                                          withObject:results
                                       waitUntilDone:NO];
}

@end
