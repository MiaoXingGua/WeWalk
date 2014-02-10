//
//  SettingViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-11.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface SettingViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_datalist;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)NSString *ImageCachePath;
@property(nonatomic,strong)NSString *cacheDBPath;

@end
