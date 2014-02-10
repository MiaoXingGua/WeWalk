//
//  schedleInfoViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-6.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALBazaarSDK.h"
#import "AsyncImageView.h"

@interface SchedleInfoViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    NSMutableArray *_schedleArray;
    
    UIPageControl *_page;
    
    
    int _showpage;
    
    Schedule *_tempsch;
}

@property(nonatomic,strong)NSMutableArray *schedleArray;
@property(nonatomic,strong)Schedule *tempsch;

- (id)initWithSchedleArray:(NSMutableArray *)schArray ShowSchedule:(Schedule *)schedule;

@end
