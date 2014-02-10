//
//  ConstellationListViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-25.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ConstellationListViewController.h"
#import "ConstellationInfoViewController.h"

@interface ConstellationListViewController ()

@end

@implementation ConstellationListViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"星座运势";
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
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(285, 14, 20, 20);
    [setBtn setImage:[UIImage imageNamed:@"_0012_config.png"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(set) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:setBtn];
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 120*4+30);
    [self.backgroundView addSubview:_scrollView];
    
    int m=0;
    
    for (int i=0; i<4; i++)
    {
        for (int j=0; j<3; j++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(20+97*j, 20+120*i, 175/2, 175/2);
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_%d",m+1]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didselectstar) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20+97*j, 105+120*i, 175/2, 30)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:16];
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor blackColor];
            [_scrollView addSubview:label];
            
            if (m==0)
            {
                label.text = @"双鱼座";
            }
            if (m==1)
            {
                label.text = @"白羊座";
            }
            if (m==2)
            {
                label.text = @"金牛座";
            }
            if (m==3)
            {
                label.text = @"双子座";
            }
            if (m==4)
            {
                label.text = @"巨蟹座";
            }
            if (m==5)
            {
                label.text = @"狮子座";
            }
            if (m==6)
            {
                label.text = @"处女座";
            }
            if (m==7)
            {
                label.text = @"天平座";
            }
            if (m==8)
            {
                label.text = @"天蝎座";
            }
            if (m==9)
            {
                label.text = @"射手座";
            }
            if (m==10)
            {
                label.text = @"摩羯座";
            }
            if (m==11)
            {
                label.text = @"水瓶座";
            }
            
            
            m++;
        }
    }
}

- (void)set
{
    
}

- (void)didselectstar
{
    ConstellationInfoViewController *constellView = [[ConstellationInfoViewController alloc] init];
    [self.navigationController pushViewController:constellView animated:YES];
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
