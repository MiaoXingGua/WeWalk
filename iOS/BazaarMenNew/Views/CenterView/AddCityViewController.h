//
//  AddCityViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-12.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "ALGPSHelper.h"

@protocol didSelectCityDelegate <NSObject>

- (void)didSelectedCity:(NSString *)cityName;

@end


@interface AddCityViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_cityArray;
    
    NSMutableArray *_myCityArray;
    
    NSMutableArray *_searchCityArray;
    
    UIScrollView *_scrollView;
    
    UITableView *_tabelView;
    
    UITextField *searchtextfield;
    
    UIButton *cancelBtn;
    
    UIView *GPSView;
    
    BOOL isAllowGPS;
    
    NSTimer *_timer;
}

@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)NSMutableArray *myCityArray;
@property(nonatomic,strong)NSMutableArray *searchCityArray;
@property(nonatomic,assign)id<didSelectCityDelegate>citydelegate;

@property(nonatomic,assign)BOOL setSchedle;
@end
