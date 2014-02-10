//
//  MessagelistViewController.h
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface MessagelistViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_datalist;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isRequest;

@end
