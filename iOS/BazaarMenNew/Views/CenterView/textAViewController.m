//
//  textAViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-2-10.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "textAViewController.h"
#import "textBViewController.h"

@interface textAViewController ()

@end

@implementation textAViewController

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
    
    self.backgroundView.backgroundColor = [UIColor redColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"pushB" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushB) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.backgroundView addSubview:btn];
}

- (void)pushB
{
    textBViewController *bview = [[textBViewController alloc] init];
    [self.navigationController pushViewController:bview animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
