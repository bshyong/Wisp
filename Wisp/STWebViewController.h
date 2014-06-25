//
//  STWebViewController.h
//  Wisp
//
//  Created by Benjamin Shyong on 6/25/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *itemURL;
@end
