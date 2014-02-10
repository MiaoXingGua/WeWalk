//
//  TextViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-15.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "TextViewController.h"
#import "RecommendView.h"

@interface TextViewController ()

@end

@implementation TextViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*5, self.view.frame.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<5; i++)
    {
        RecommendView *reco = [[RecommendView alloc] init];
        reco.frame = CGRectMake(320*i, 50, 320, self.view.frame.size.height-50);
        [_scrollView addSubview:reco];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
