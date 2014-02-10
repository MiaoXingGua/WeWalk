//
//  textBViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-2-10.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "textBViewController.h"
#import "textAViewController.h"

@interface textBViewController ()

@end

@implementation textBViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor blueColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"pushA" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushB) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.backgroundView addSubview:btn];
}

- (void)pushB
{
    textAViewController *bview = [[textAViewController alloc] init];
    [self.navigationController pushViewController:bview animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
