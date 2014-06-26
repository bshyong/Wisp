//
//  STFeedLoader.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/22/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <Foundation/Foundation.h>

// declare the class
@class STFeedLoader;

// define protocol for the delegate
@protocol STFeedLoaderDelegate <NSObject>
// define protocol functions that can be used
// in any class using this delegate
-(void)processCompleted:(NSArray *)results;
-(void)processHasErrors;
-(void)imageLoadedForItemAtIndex:(NSNumber *)index;

@end


@interface STFeedLoader : NSObject <NSXMLParserDelegate>{
    id <STFeedLoaderDelegate> _delegate;
}

// define the delegate property
@property(strong, nonatomic) id delegate;

// define public functions
-(void)loadItemsFromURL:(NSURL *)url;

@end


