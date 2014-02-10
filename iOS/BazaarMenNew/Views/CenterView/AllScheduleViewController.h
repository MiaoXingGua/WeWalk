//
//  SelectScheduleViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 14-1-2.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "VRGCalendarView.h"

@interface AllScheduleViewController : SuperViewController<VRGCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    VRGCalendarView *calendar;
    
    UITableView *_tableView;
    
    float _calenderHeight;
    
    NSMutableArray *_datalist;
    
    NSMutableArray *_selectArray;
    
    UIView *lineView;
    
    UIView *_coverView;
}

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)int selectrow;
@property(nonatomic,assign)int longpressrow;

@end
