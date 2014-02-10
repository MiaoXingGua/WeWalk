//
//  AttentionListViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOLoadTableFooterView.h"

@interface AttentionListViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,EGOLoadTableFooterDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGOLoadTableFooterView *_loadFooterView;

    BOOL _reloading;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isLoadMore;

@end
