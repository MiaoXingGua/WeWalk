//
//  CollectUserViewController.h
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-25.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "Photo.h"

@interface CollectUserViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)Photo *photo;

@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isRequest;

@end
