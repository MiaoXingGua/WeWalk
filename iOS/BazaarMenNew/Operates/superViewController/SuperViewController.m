//
//  SuperViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "SuperViewController.h"
#import "SystemConfigManager.h"

@interface SuperViewController ()

@end

@implementation SuperViewController
@synthesize backgroundView = _backgroundView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect _frame;
    
    if ([SystemConfigManager defaultManager].systemVersion>=7)
    {
        _frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    }
    else
    {
        _frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.backgroundView = [[UIView alloc] initWithFrame:_frame];
    self.backgroundView.clipsToBounds = YES;
    [self.view addSubview:self.backgroundView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
