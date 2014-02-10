//
//  HomeViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "RecommendView.h"
#import "SchedleInfoViewController.h"
#import "ALBazaarSDK.h"

@interface HomeViewController : SuperViewController<UIScrollViewDelegate,didSelectRecommendDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    SchedleInfoViewController *schview;
    
    BOOL isShowSchedleView;
    
    UIView *selectView;
    
    UIScrollView *_scrollView;
    
    UIButton *showLeftBtn;
    
    UIView *headView;
    
    BOOL isOpen;
    
    BOOL isPhone5;
    
    NSMutableArray *_schArray;
    
    int _showPage;
    
    Schedule *_showSch;
}

@property(nonatomic,strong)NSMutableArray *schArray;
@property(nonatomic,strong)Schedule *showSch;

@end
