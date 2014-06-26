//
//  STWebViewController.m
//  Wisp
//
//  Created by Benjamin Shyong on 6/25/14.
//  Copyright (c) 2014 ShyongTech. All rights reserved.
//

#import "STWebViewController.h"

@interface STWebViewController ()

@end

@implementation STWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.itemURL];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated: NO];
}


@end
