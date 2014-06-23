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
    RXMLElement *root_node = [RXMLElement elementFromXMLData:feed_data];
    
    [root_node iterate:@"item" usingBlock: ^(RXMLElement *item) {
        STFeedItem *new_item = [[STFeedItem alloc] init];
        new_item.title = [item child:@"title"].text;
        new_item.source = [item child:@"source"].text;
        new_item.itemURL = [NSURL URLWithString:[item child:@"link"].text];
        // parse for date
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE dd, MMM yyyy HH:mm:ss ZZZ"];
        [df setLocale:[NSLocale localeWithLocaleIdentifier:@"EN"]];
        NSDate *pubDate = [df dateFromString:[item child:@"pubDate"].text];
        new_item.pubDate = pubDate;
        // TODO: parse for larger version of picture
        new_item.imageURL = [NSURL URLWithString:[[item child:@"media:content"] attribute:@"url"]];
        // add new item to array of items
        [[self items]addObject:new_item];
    }];
    // call delegate method to indicate that method has completed
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted)
                                          withObject:nil
                                       waitUntilDone:NO];
}

@end
