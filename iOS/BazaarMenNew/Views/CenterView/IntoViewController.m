//
//  IntoViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-10.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "IntoViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface IntoViewController ()

@end

@implementation IntoViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backview.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [self.backgroundView addSubview:backview];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"你已经完成注册啦！";
    label.center = CGPointMake(SCREEN_WIDTH/2, 120);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:label];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(0, 0, 295/2, 68/2);
//    [btn1 setBackgroundImage:[UIImage imageNamed:@"blackbtn_image.png"] forState:UIControlStateNormal];
//    [btn1 setTitle:@"认证达人" forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont systemFontOfSize:19];
//    btn1.titleLabel.font = [UIFont boldSystemFontOfSize:19];
//    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btn1.center = CGPointMake(SCREEN_WIDTH/2, 180);
//    [btn1 addTarget:self action:@selector(daren) forControlEvents:UIControlEventTouchUpInside];
//    [self.backgroundView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 295/2, 68/2);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"blackbtn_image.png"] forState:UIControlStateNormal];
    [btn2 setTitle:@"进入首页" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:19];
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn2.center = CGPointMake(SCREEN_WIDTH/2, 230);
    [btn2 addTarget:self action:@selector(intoHomeView) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:btn2];
}

- (void)daren
{
    
}

- (void)intoHomeView
{
    [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.2];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWCENTERVIEWCONTROLLER object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
