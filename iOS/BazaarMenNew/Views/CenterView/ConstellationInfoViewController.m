//
//  ConstellationInfoViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-26.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ConstellationInfoViewController.h"

@interface ConstellationInfoViewController ()

@end

@implementation ConstellationInfoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor blackColor];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"天蝎座";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_image_001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1006/2);
    [self.backgroundView addSubview:_scrollView];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starinfo.png"]];
    image.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1006/2);
    [_scrollView addSubview:image];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
