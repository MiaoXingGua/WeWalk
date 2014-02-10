//
//  StreetSnapViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 14-1-5.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "SuperViewController.h"
#import "WaterFlowView.h"
#import "ImageViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadTableFooterView.h"
#import "AsyncImageView.h"

@interface StreetSnapViewController : SuperViewController<EGOLoadTableFooterDelegate,EGORefreshTableHeaderDelegate,WaterFlowViewDelegate,WaterFlowViewDataSource,UIScrollViewDelegate>
{
    PSCollectionView *_psView;
    NSMutableArray *_datalist;
    
    UIView *coverView;
    
    WaterFlowView *waterFlow;
    
    UIView *headView;
    
    UIView *footView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGOLoadTableFooterView *_loadFooterView;
    
    BOOL _reloading;
    
    AsyncImageView *waterHeadView;
    UIView *footview;
    
    UIButton *newBtn;
    UIButton *nearBtn;
    UIButton *hotBtn;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isLoadMore;
@property(nonatomic,assign)int selectedNum;

@end
