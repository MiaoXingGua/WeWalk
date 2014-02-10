//
//  FansViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface FansViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_datalist;
}

@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,assign)BOOL isRequest;

@end
