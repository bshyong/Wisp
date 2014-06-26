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
#import "AFNetworking.h"
#import "NYXImagesKit.h"


@implementation STFeedLoader

-(void)loadItemsFromURL:(NSURL *)url {
//    TODO: this method should be asynchronous: use AFNetworking
//  activate activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//  code to load items from URL
//  and parse them using RaptureXML
    NSData *feed_data = [NSData dataWithContentsOfURL:url];
    // fetch the root node (should be 'channel')
    RXMLElement *root_node = [[RXMLElement elementFromXMLData:feed_data] child:@"channel"];
    NSArray *feed_items = [root_node children:@"item"];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:feed_items.count];
    NSUInteger count = 0;
    
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
        NSString *fullImageUrlString = [[e child:@"content"] attribute:@"url"];

        if (fullImageUrlString){
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://(.+)" options:0 error:NULL];
            NSTextCheckingResult *regexMatch = [regex firstMatchInString:fullImageUrlString options:0 range:NSMakeRange(0, [fullImageUrlString length])];
            NSString *parsedImageUrlString = [fullImageUrlString substringWithRange:[regexMatch rangeAtIndex:0]];
            new_item.imageURL = [NSURL URLWithString:parsedImageUrlString];

            NSURLRequest *imageRequest = [NSURLRequest requestWithURL:new_item.imageURL];
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:imageRequest];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                new_item.imageData = responseObject;
                
                UIImage *image = responseObject;
                
                if (image.size.height > image.size.width) {
                    UIImage *resizedImage = [image scaleToFitSize:(CGSize){320, 320/image.size.width*image.size.height}];
                    UIImage *croppedImage = [resizedImage cropToSize:(CGSize){320, 180} usingMode:NYXCropModeTopCenter];
                    new_item.imageData = croppedImage;
                    new_item.imageCropped = YES;
                } else {
                    UIImage *resizedImage = [image scaleToFitSize:(CGSize){180*image.size.width/image.size.height, 180}];
                    UIImage *croppedImage = [resizedImage cropToSize:(CGSize){320, 180} usingMode:NYXCropModeCenter];
                    new_item.imageData = croppedImage;
                    new_item.imageCropped = YES;
                }
                
                
                [[self delegate] performSelectorOnMainThread:@selector(imageLoadedForItemAtIndex:) withObject:[NSNumber numberWithInteger:count] waitUntilDone:NO];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
        } else {
            new_item.imageURL = nil;
            new_item.imageData = nil;
        }

        // add new item to array of items
        [results addObject:new_item];
        count++;
    }

    // call delegate method to indicate that method has completed
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted:)
                                          withObject:results
                                       waitUntilDone:NO];
}

@end
