//
//  schedleInfoViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-6.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "SchedleInfoViewController.h"
#import "AsyncImageView.h"
#import "WeatherRequestManager.h"
#import "ScheduleView.h"

@interface SchedleInfoViewController ()

@end

@implementation SchedleInfoViewController
@synthesize schedleArray = _schedleArray;
@synthesize tempsch = _tempsch;


- (id)initWithSchedleArray:(NSMutableArray *)schArray ShowSchedule:(Schedule *)schedule
{
    if (self = [super init])
    {
        self.schedleArray = [NSMutableArray arrayWithArray:schArray];
        self.tempsch = schedule;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.schedleArray.count, self.view.frame.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    for (int i=0; i<self.schedleArray.count; i++)
    {
        Schedule *_sch = [self.schedleArray objectAtIndex:i];
        
        if ([_sch.objectId isEqualToString:self.tempsch.objectId])
        {
            _showpage=i;
        }
        
        ScheduleView *sch = [[ScheduleView alloc] initWithFrame:CGRectMake(320*i, 0, 320, self.view.frame.size.height) Schedule:_sch];
        sch.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:sch];
        
    }
    
    _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    _page.numberOfPages = self.schedleArray.count;
    _page.center = CGPointMake(160, 400);
    _page.userInteractionEnabled=NO;
    _page.pageIndicatorTintColor = [UIColor lightGrayColor];
    _page.currentPageIndicatorTintColor = [UIColor blackColor];
    _page.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_page];
    
    [self movepage];
}

- (void)movepage
{
    _scrollView.contentOffset = CGPointMake(320*_showpage, 0);
    _page.currentPage = _showpage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float _x = scrollView.contentOffset.x;
    
    _page.currentPage = (int)_x/320;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
