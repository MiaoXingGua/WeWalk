//
//  CityViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface CityViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_cityList;
    
}

@property(nonatomic,retain)NSMutableArray *cityList;

@end
