//
//  CommissionViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-28.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "NoteView.h"
#import "AddCityViewController.h"
#import "ALBazaarSDK.h"

@interface CommissionViewController : SuperViewController<UITextViewDelegate,didSelectCityDelegate>
{
    UIScrollView *_scrollView;
    
    UIView *itemView;
    UIButton *openItemBtn;
    UIView *lineView;
    
    UIView *timeView;
    UIButton *openTimeBtn;
    
    UIView *remindView;
    UIButton *openRemindBtn;
    
    UIView *cityView;
    UIButton *openCityBtn;
    
    BOOL isOpenItem;
    BOOL isOpenTime;
    BOOL isOpenRemind;
    BOOL isOpenCity;
    
    BOOL isAnimation;
    
    
    
    float itemHeight,timeHeight,remindHeight;
    
    NoteView *_textView;
    
    UIDatePicker *_timePiker,*_remindPiker;
    
    NSTimer *_timer;
    
    UILabel *selecttimeLabel;
    UILabel *remindtimeLabel;
    
    UILabel *selectCityLabel;
    
    NSString *_cityName;
    
    UIView *_coverView;
    
    Schedule *_schedule;
}

@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,assign)BOOL isSetting;
@property(nonatomic,assign)int schedleType;
@property(nonatomic,strong)Schedule *schedule;

@end
