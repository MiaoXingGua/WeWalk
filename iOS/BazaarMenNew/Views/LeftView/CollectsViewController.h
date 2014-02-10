//
//  CollectsViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "WaterFlowView.h"
#import "ImageViewCell.h"
#import "ALBazaarSDK.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadTableFooterView.h"

@interface CollectsViewController : SuperViewController<WaterFlowViewDelegate,WaterFlowViewDataSource,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,EGOLoadTableFooterDelegate>
{
    WaterFlowView *waterFlow;
    
    NSMutableArray *_datalist;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGOLoadTableFooterView *_loadFooterView;

    BOOL _reloading;

}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isLoadMore;

@end
