//
//  STFeedLoader.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/22/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STFeedLoader.h"

@implementation STFeedLoader

-(void)loadItemsFromURL:(NSURL *)url {
//  activate activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//  code to load items from URL
//  and parse them using NXMLParser
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    
}

@end
