//
//  CommissionViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-28.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "CommissionViewController.h"
#import "SystemConfigManager.h"
#import "ALBazaarSDK.h"
#import "ALWeatherSDK.h"
#import "WeatherRequestManager.h"
#import "ScheduleRequestManager.h"
#import "Content.h"

@interface CommissionViewController ()

@end

@implementation CommissionViewController
@synthesize schedule = _schedule;
@synthesize cityName = _cityName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    title.text = @"添加";
    title.textColor = [UIColor whiteColor];
    title.center = CGPointMake(SCREEN_WIDTH/2,naviView.frame.size.height/2);
    title.font = [UIFont systemFontOfSize:20];
    title.font = [UIFont boldSystemFontOfSize:20];
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentCenter];
    [naviView addSubview:title];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"close_image0001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(270, 2, 40, 40);
    [sendBtn setImage:[UIImage imageNamed:@"sure_image0001.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(setSchedle) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:sendBtn];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-44);
    [self.backgroundView addSubview:_scrollView];
    
    itemView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH-30, 48)];
    itemView.layer.borderWidth = 1;
    itemView.layer.borderColor = [UIColor grayColor].CGColor;
    itemView.layer.cornerRadius = 5;
    [_scrollView addSubview:itemView];
    
    UIImageView *itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0007_待办事项.png"]];
    itemImageView.frame = CGRectMake(10, 10, 25, 25);
    itemImageView.userInteractionEnabled = YES;
    [itemView addSubview:itemImageView];
    
    UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 48)];
    itemLabel.text = @"待办事项";
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.font = [UIFont systemFontOfSize:19];
    [itemLabel setTextAlignment:NSTextAlignmentLeft];
    [itemView addSubview:itemLabel];
    
    
    for (int i=0; i<4; i++)
    {
        int j=0;
        
        if (i==0)
        {
            j=5;
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(148+i*36.2, 4+j, 25, 25);
        btn.tag = 7000+i;
        [btn addTarget:self action:@selector(selectItemClass:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:btn];
  
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150+i*37, 27, 50, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:10];
        [label setTextAlignment:NSTextAlignmentLeft];
        
        if (i==0)
        {
            label.text = @"会议";
            [btn setImage:[UIImage imageNamed:@"huiyi_small_color.png"] forState:UIControlStateNormal];
        }
        
        if (i==1)
        {
            label.text = @"聚会";
            [btn setImage:[UIImage imageNamed:@"jihui_small_gray.png"] forState:UIControlStateNormal];
        }
        
        if (i==2)
        {
            label.text = @"运动";
            [btn setImage:[UIImage imageNamed:@"yundong_small_gray.png"] forState:UIControlStateNormal];
        }
        
        if (i==3)
        {
            label.text = @"晚礼";
            [btn setImage:[UIImage imageNamed:@"lifu_small_gray.png"] forState:UIControlStateNormal];
        }
        
        [itemView addSubview:label];
     }
    
    _textView = [[NoteView alloc] initWithFrame:CGRectMake(10, 55, 270, 140)];
    _textView.font = [UIFont systemFontOfSize:20];
    _textView.delegate = self;
    _textView.alpha=0;
    _textView.textColor = [UIColor grayColor];
    _textView.returnKeyType = UIReturnKeyDone;
    [itemView addSubview:_textView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH-30, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.alpha = 0;
    [itemView addSubview:lineView];
    
    openItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openItemBtn.frame = CGRectMake(0, 0, 140, 48);
    openItemBtn.backgroundColor = [UIColor clearColor];
    [openItemBtn addTarget:self action:@selector(openItem) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:openItemBtn];
    
    //////////////////////////////////////////////////////////////////////////

    
    timeView = [[UIView alloc] initWithFrame:CGRectMake(15, 75, SCREEN_WIDTH-30, 48)];
    timeView.layer.borderWidth = 1;
    timeView.layer.borderColor = [UIColor grayColor].CGColor;
    timeView.layer.cornerRadius = 5;
    [_scrollView addSubview:timeView];
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0005_时间.png"]];
    timeImageView.frame = CGRectMake(10, 12, 25, 25);
    timeImageView.userInteractionEnabled = YES;
    [timeView addSubview:timeImageView];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 48)];
    timeLabel.text = @"时间";
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.font = [UIFont systemFontOfSize:19];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeView addSubview:timeLabel];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter3 setDateFormat:@"yyyyMMdd"];
    NSString *yearStr = [formatter3 stringFromDate:[WeatherRequestManager defaultManager].date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *_date = [formatter dateFromString:yearStr];
    
    
    selecttimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 48)];
    selecttimeLabel.backgroundColor = [UIColor clearColor];
    selecttimeLabel.font = [UIFont systemFontOfSize:16];
    selecttimeLabel.textColor = [UIColor grayColor];
    [selecttimeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeView addSubview:selecttimeLabel];
    
    _timePiker = [[UIDatePicker alloc] init];
    _timePiker.minimumDate = _date;
    _timePiker.alpha = 0;
    _timePiker.datePickerMode = UIDatePickerModeDateAndTime;
    _timePiker.backgroundColor = [UIColor clearColor];
    [_timePiker addTarget:self action:@selector(timeDateChange) forControlEvents:UIControlEventValueChanged];

    
    if ([SystemConfigManager defaultManager].systemVersion>=7)
    {
        
    }
    else
    {
        _timePiker.frame = CGRectMake(15, 75+itemHeight+55, SCREEN_WIDTH-30, 150);
        
        UIView *v = [[_timePiker subviews] objectAtIndex:0];
        
        //改变最外层的背景
        UIView *v0 = [[v subviews] objectAtIndex:0];
        v0.backgroundColor = [UIColor clearColor];
        
        //去掉最大的框
        UIView *v20 = [[v subviews] objectAtIndex:20];
        v20.backgroundColor = [UIColor clearColor];
        v20.alpha = 0;
        
    }
    [_scrollView addSubview:_timePiker];
    
    
    openTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openTimeBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 48);
    [openTimeBtn addTarget:self action:@selector(openTime) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:openTimeBtn];
    
    //////////////////////////////////////////////////////////////////////////
    
    
    remindView = [[UIView alloc] initWithFrame:CGRectMake(15, 135, SCREEN_WIDTH-30, 48)];
    remindView.layer.borderWidth = 1;
    remindView.layer.borderColor = [UIColor grayColor].CGColor;
    remindView.layer.cornerRadius = 5;
    [_scrollView addSubview:remindView];
    
    UIImageView *remindImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0008_提醒.png"]];
    remindImageView.frame = CGRectMake(10, 12, 25, 25);
    remindImageView.userInteractionEnabled = YES;
    [remindView addSubview:remindImageView];
    
    
    NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
    [formatter4 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter4 setDateFormat:@"yyyyMMdd"];
    NSString *str4 = [formatter4 stringFromDate:[WeatherRequestManager defaultManager].date];
    
    NSDateFormatter *formatter5 = [[NSDateFormatter alloc] init];
    [formatter5 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter5 setDateFormat:@"yyyyMMdd"];
    NSDate *date5 = [formatter dateFromString:str4];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 48)];
    remindLabel.text = @"提醒";
    remindLabel.font = [UIFont systemFontOfSize:19];
    [remindLabel setTextAlignment:NSTextAlignmentLeft];
    remindLabel.backgroundColor = [UIColor clearColor];
    [remindView addSubview:remindLabel];
    
    
    remindtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 0, 150, 48)];
    remindtimeLabel.backgroundColor = [UIColor clearColor];
    remindtimeLabel.font = [UIFont systemFontOfSize:16];
    remindtimeLabel.textColor = [UIColor grayColor];
    [remindtimeLabel setTextAlignment:NSTextAlignmentLeft];
    [remindView addSubview:remindtimeLabel];
    
    openRemindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openRemindBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 48);
    [openRemindBtn addTarget:self action:@selector(openRemind) forControlEvents:UIControlEventTouchUpInside];
    [remindView addSubview:openRemindBtn];
    
    
    _remindPiker = [[UIDatePicker alloc] init];
    _remindPiker.minimumDate = date5;
    _remindPiker.alpha = 0;
    _remindPiker.datePickerMode = UIDatePickerModeDateAndTime;
    _remindPiker.backgroundColor = [UIColor clearColor];
    [_remindPiker addTarget:self action:@selector(remindDateChange) forControlEvents:UIControlEventValueChanged];
    
    if ([SystemConfigManager defaultManager].systemVersion>=7)
    {
        
    }
    else
    {
        _remindPiker.frame = CGRectMake(15, 135+itemHeight+timeHeight+55, SCREEN_WIDTH-30, 150);
        
        UIView *v = [[_remindPiker subviews] objectAtIndex:0];
        
        //改变最外层的背景
        UIView *v0 = [[v subviews] objectAtIndex:0];
        v0.backgroundColor = [UIColor clearColor];
        
        //去掉最大的框
        UIView *v20 = [[v subviews] objectAtIndex:20];
        v20.backgroundColor = [UIColor clearColor];
        v20.alpha = 0;
        
    }
    [_scrollView addSubview:_remindPiker];
    
    
    //////////////////////////////////////////////////////////////////////////

    cityView = [[UIView alloc] initWithFrame:CGRectMake(15, 195, SCREEN_WIDTH-30, 48)];
    cityView.layer.borderWidth = 1;
    cityView.backgroundColor = [UIColor clearColor];
    cityView.layer.borderColor = [UIColor grayColor].CGColor;
    cityView.layer.cornerRadius = 5;
    [_scrollView addSubview:cityView];
    
    UIImageView *cityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0004_定位.png"]];
    cityImageView.frame = CGRectMake(10, 12, 25, 25);
    cityImageView.userInteractionEnabled = YES;
    [cityView addSubview:cityImageView];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 48)];
    cityLabel.text = @"地点";
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:19];
    [cityLabel setTextAlignment:NSTextAlignmentLeft];
    [cityView addSubview:cityLabel];
    
    selectCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 190, 48)];
    selectCityLabel.text = @"选择城市";
    selectCityLabel.backgroundColor = [UIColor clearColor];
    selectCityLabel.font = [UIFont systemFontOfSize:17];
    [selectCityLabel setTextAlignment:NSTextAlignmentRight];
    [cityView addSubview:selectCityLabel];
    
    openCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openCityBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 48);
    openCityBtn.backgroundColor = [UIColor clearColor];
    [openCityBtn addTarget:self action:@selector(openCity) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:openCityBtn];
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden=YES;
    _coverView.alpha = 0.4;
    _coverView.userInteractionEnabled = YES;
    [self.view addSubview:_coverView];
    
    if (self.schedule!=nil)
    {
        _textView.text = self.schedule.content.text;
        [_timePiker setDate:self.schedule.date animated:NO];
        [_remindPiker setDate:self.schedule.remindDate animated:NO];
        
        self.cityName = self.schedule.place;
        selectCityLabel.text = self.schedule.place;
    }
    else
    {
        [self timeDateChange];
        [self remindDateChange];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOpenHeight:) name:@"changeOpenHeight" object:nil];

}

- (void)timeDateChange
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *destDateString1 = [dateFormatter1 stringFromDate:_timePiker.date];
    
    selecttimeLabel.text = destDateString1;

}

- (void)remindDateChange
{
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *destDateString2 = [dateFormatter2 stringFromDate:_remindPiker.date];
    
    remindtimeLabel.text = destDateString2;
}


#pragma mark - 选择提醒类型
- (void)selectItemClass:(UIButton *)sender
{
    NSLog(@"schedleType=%d",sender.tag-7000);
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:7000];
    UIButton *btn2 = (UIButton *)[self.view viewWithTag:7001];
    UIButton *btn3 = (UIButton *)[self.view viewWithTag:7002];
    UIButton *btn4 = (UIButton *)[self.view viewWithTag:7003];
    
    if (sender.tag==7000)
    {
        [btn1 setImage:[UIImage imageNamed:@"huiyi_small_color.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"jihui_small_gray.png"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"yundong_small_gray.png"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"lifu_small_gray.png"] forState:UIControlStateNormal];
    }
    if (sender.tag==7001)
    {
        [btn1 setImage:[UIImage imageNamed:@"huiyi_small_gray.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"jihui_small_color.png"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"yundong_small_gray.png"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"lifu_small_gray.png"] forState:UIControlStateNormal];
    }
    if (sender.tag==7002)
    {
        [btn1 setImage:[UIImage imageNamed:@"huiyi_small_gray.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"jihui_small_gray.png"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"yundong_smanll_color.png"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"lifu_small_gray.png"] forState:UIControlStateNormal];
    }
    if (sender.tag==7003)
    {
        [btn1 setImage:[UIImage imageNamed:@"huiyi_small_gray.png"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"jihui_small_gray.png"] forState:UIControlStateNormal];
        [btn3 setImage:[UIImage imageNamed:@"yundong_small_gray.png"] forState:UIControlStateNormal];
        [btn4 setImage:[UIImage imageNamed:@"lifu_small_color.png"] forState:UIControlStateNormal];
    }
    
    self.schedleType = sender.tag-7000;
}

#pragma mark - 展开选择项目
- (void)openItem
{
    if (isAnimation==YES)
    {
        return;
    }
    
    isAnimation=YES;
    
    if (isOpenItem==YES)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            itemView.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 48);
            
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height-100);
            
            _textView.alpha = 0;
            lineView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            isOpenItem=NO;
            isAnimation=NO;
           
            [_textView resignFirstResponder];
        }];
        
        itemHeight -=150;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"item"];
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            itemView.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, 48+150);
            
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height+100);
            
            _textView.alpha = 1;
            lineView.alpha = 1;

        } completion:^(BOOL finished) {
            
            isOpenItem=YES;
            isAnimation=NO;
           
            [_textView becomeFirstResponder];
        }];
        
        itemHeight +=150;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"item"];
    }
}

- (void)openTime
{
    if (isAnimation==YES)
    {
        return;
    }
    
    isAnimation=YES;
    
    if (isOpenTime==YES)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _timePiker.alpha = 0;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height-150);
            
        } completion:^(BOOL finished) {
            
            isOpenTime=NO;
            isAnimation=NO;
        }];
        
        timeHeight -=170;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"time"];
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _timePiker.alpha = 1;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height+150);
            
        } completion:^(BOOL finished) {
            
            isOpenTime=YES;
            isAnimation=NO;
        }];
        
        timeHeight +=170;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"time"];
    }
}

- (void)openRemind
{
    if (isAnimation==YES)
    {
        return;
    }
    
    isAnimation=YES;
    
    if (isOpenRemind==YES)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            _remindPiker.alpha = 0;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height-150);
            
        } completion:^(BOOL finished) {
            
            isOpenRemind=NO;
            isAnimation=NO;
        }];
        
        remindHeight -=170;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"remind"];
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
          //  remindView.frame = CGRectMake(15, remindView.frame.origin.y, SCREEN_WIDTH-30, 48+150);
            _remindPiker.alpha = 1;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _scrollView.contentSize.height+150);
            
        } completion:^(BOOL finished) {
            
            isOpenRemind=YES;
            isAnimation=NO;
        }];
        
        remindHeight +=170;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOpenHeight" object:@"remind"];
    }
}

- (void)openCity
{
    AddCityViewController *addcity = [[AddCityViewController alloc] init];
    addcity.setSchedle=YES;
    addcity.citydelegate = self;
    [self presentViewController:addcity animated:YES completion:nil];
 }

- (void)changeOpenHeight:(NSNotification *)info
{
    [self moveAllView];
}

- (void)moveAllView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        timeView.frame = CGRectMake(15, 75+itemHeight, SCREEN_WIDTH-30, timeView.frame.size.height);
        
        remindView.frame = CGRectMake(15, 135+itemHeight+timeHeight, SCREEN_WIDTH-30, remindView.frame.size.height);
        
        cityView.frame = CGRectMake(15, 195+itemHeight+timeHeight+remindHeight, SCREEN_WIDTH-30, cityView.frame.size.height);
        
        _timePiker.frame = CGRectMake(15, 75+itemHeight+55, SCREEN_WIDTH-30, 150);
        _remindPiker.frame = CGRectMake(15, 135+itemHeight+timeHeight+55, SCREEN_WIDTH-30, 150);
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)beginOpenRemindAnimation
{
    
}

- (void)beginOpenCityAnimation
{
    
}

#pragma mark - 选择城市delegate
- (void)didSelectedCity:(NSString *)cityName
{
    self.cityName = cityName;
    
    selectCityLabel.text = cityName;
}

#pragma mark - 完成/取消设置日程
- (void)setSchedle
{
    if (_textView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写代办事项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
         alert=nil;
        
        return;
    }
    
    if (self.cityName.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
         alert=nil;
        
        return;
    }
    
    NSLog(@"%@,%@",_remindPiker.date,_timePiker.date);
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyyMMddHHmm"];
    long long remindtime = [[dateFormatter2 stringFromDate:_remindPiker.date] longLongValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
    long long timetime = [[dateFormatter stringFromDate:_timePiker.date] longLongValue];
    
    if (remindtime-timetime>=0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提醒时间需要小于日程时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert=nil;
        
        return;
    }
    
    if (self.isSetting==YES)
    {
        return;
    }
    
    self.isSetting=YES;
    
    [self.view bringSubviewToFront:_coverView];
    _coverView.hidden=NO;
    
    
    __block typeof(self) bself = self;
    
    __block NoteView *__textview = _textView;
    __block UIDatePicker *__timedate = _timePiker;
    __block UIDatePicker *__reminddate = _remindPiker;
    __block UIView *__coverview = _coverView;
    __block NSTimer *__timer = _timer;
    
    if (self.schedule==nil)
    {
        [ProgressHUD show:@"添加中"];

        [[ALWeatherEngine defauleEngine] getWoeidWithCityName:self.cityName block:^(NSArray *objects, NSError *error) {
            
            if (objects.count>0)
            {
                NSString *woeid = [[objects objectAtIndex:0] objectForKey:@"woeid"];
                
                NSLog(@"%@,%d,%@,%@,%@",__timedate.date,bself.schedleType,__reminddate.date,woeid,bself.cityName);
                
                [[ALBazaarEngine defauleEngine] createScheduleWithDate:__timedate.date andType:bself.schedleType andRemindDate:__reminddate.date andWoeid:woeid andPlace:bself.cityName text:__textview.text voice:nil URL:nil block:^(BOOL succeeded, NSError *error) {
                    
                    __coverview.hidden=YES;
                    
                    if (succeeded && !error)
                    {
                        [ProgressHUD showSuccess:@"成功"];
                        
                        [[ScheduleRequestManager defaultManager] requestAllSchedule];
                        [__timer invalidate]; __timer=nil;
                        [bself.navigationController popViewControllerAnimated:YES];
                        
                    }
                    else
                    {
                        [ProgressHUD showError:@"失败"];
                        NSLog(@"error=%@",error);
                    }
                    
                    bself.isSetting=NO;
                    
                    
                }];
            }
            else
            {
                [ProgressHUD showError:@"失败"];
                NSLog(@"error=%@",error);
                
                bself.isSetting=NO;
            }
            
        }];
    }
    else
    {
        [ProgressHUD show:@"修改中"];
        
        
        [[ALWeatherEngine defauleEngine] getWoeidWithCityName:self.cityName block:^(NSArray *objects, NSError *error) {
            
            if (objects.count>0)
            {
                NSString *woeid = [[objects objectAtIndex:0] objectForKey:@"woeid"];
                
                NSLog(@"%@,%d,%@,%@,%@",__timedate.date,bself.schedleType,__reminddate.date,woeid,bself.cityName);


                [[ALBazaarEngine defauleEngine] updateSchedule:bself.schedule andDate:__timedate.date andType:bself.schedleType andRemindDate:__reminddate.date andWoeid:woeid andPlace:bself.cityName text:__textview.text voice:nil URL:nil block:^(BOOL succeeded, NSError *error) {
                
                
                    __coverview.hidden=YES;
                    
                    if (succeeded && !error)
                    {
                        [ProgressHUD showSuccess:@"成功"];
                        
                        [[ScheduleRequestManager defaultManager] requestAllSchedule];
                        [__timer invalidate]; __timer=nil;
                        [bself.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [ProgressHUD showError:@"失败"];
                        NSLog(@"error=%@",error);
                    }
                    
                    bself.isSetting=NO;
                    
                }];
            }
            else
            {
                [ProgressHUD showError:@"失败"];
                NSLog(@"error=%@",error);
                
                bself.isSetting=NO;
            }
        }];
    }
}

- (void)cancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"日程还没有添加成功，是否要退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
     alert=nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [_timer invalidate]; _timer=nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeOpenHeight" object:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    // to update NoteView
    [_textView setNeedsDisplay];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [_textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
