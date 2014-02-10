//
//  SelectScheduleViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 14-1-2.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "AllScheduleViewController.h"
#import "ScheduleCell.h"
#import "CommissionViewController.h"
#import "ScheduleRequestManager.h"
#import "ALBazaarSDK.h"
#import "WeatherRequestManager.h"
#import "CompleteInfoViewController.h"
#import "Content.h"

#define NOTWEATHERCOLOR [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
#define HAVEWEATHERCOLOR [UIColor colorWithRed:0 green:0.62 blue:0.91 alpha:1];

@interface AllScheduleViewController ()

@end

@implementation AllScheduleViewController
@synthesize datalist=_datalist;;
@synthesize selectArray = _selectArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(<#selector#>) name:COMPLETEREFRESHSCHEDULE object:nil];
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];

    
    self.datalist = [NSMutableArray arrayWithArray:[ScheduleRequestManager defaultManager].scheduleArray];

    self.selectArray = [NSMutableArray arrayWithCapacity:0];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_image_001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backtoprevious) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"日程";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter3 setDateFormat:@"yyyyMMdd"];
    NSString *yearStr = [formatter3 stringFromDate:[WeatherRequestManager defaultManager].date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *_date = [formatter dateFromString:yearStr];
    
    
    calendar = [[VRGCalendarView alloc] init];
    calendar.userDate = _date;
    calendar.delegate=self;
    [self.backgroundView addSubview:calendar];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    lineView.alpha = 0;
    [self.backgroundView addSubview:lineView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headView.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 245, 320, SCREEN_HEIGHT-_calenderHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0;
    _tableView.tableHeaderView = headView;
    _tableView.separatorColor = [UIColor clearColor];
    [self.backgroundView addSubview:_tableView];
  
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    footView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    _tableView.tableFooterView = footView;

    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden=YES;
    _coverView.alpha = 0.4;
    _coverView.userInteractionEnabled = YES;
    [self.view addSubview:_coverView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Celldentifier = @"cell";
    
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:Celldentifier];;
    
    if (cell==nil)
    {
        cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Celldentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Schedule *_schedule = [[self.selectArray objectAtIndex:indexPath.row] objectForKey:@"schedule"];
    BOOL _haveweather = [[[self.selectArray objectAtIndex:indexPath.row] objectForKey:@"haveweather"] boolValue];
    int _statenum = _schedule.type;

    [cell.longpress addTarget:self action:@selector(longPressCell:)];
    cell.longpress.tapRow = indexPath.row;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    [formatter setDateFormat:@"HH:mm"];
    NSString *timerStr = [formatter stringFromDate:_schedule.date];
//
    if (_statenum==0)
    {
        if (_haveweather==YES)
        {
            cell.stateView.image = [UIImage imageNamed:@"huiyi_large_color.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_haveweather.png"];
        }
        else
        {
            cell.stateView.image = [UIImage imageNamed:@"huiyi_large_gray.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_noweather.png"];
        }
        
        cell.timeLabel.text = timerStr;
        cell.contentLabel.text = _schedule.content.text;
    }
    if (_statenum==1)
    {
        if (_haveweather==YES)
        {
            cell.stateView.image = [UIImage imageNamed:@"juhui_large_color.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_haveweather.png"];
        }
        else
        {
            cell.stateView.image = [UIImage imageNamed:@"juhui_large_gray.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_noweather.png"];
        }
        
        cell.timeLabel.text = timerStr;
        cell.contentLabel.text = _schedule.content.text;
    }
    if (_statenum==2)
    {
        if (_haveweather==YES)
        {
            cell.stateView.image = [UIImage imageNamed:@"yundong_large_color.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_haveweather.png"];
        }
        else
        {
            cell.stateView.image = [UIImage imageNamed:@"yundong_large_gray.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_noweather.png"];
        }
        
        cell.timeLabel.text = timerStr;
        cell.contentLabel.text = _schedule.content.text;
    }
    if (_statenum==3)
    {
        if (_haveweather==YES)
        {
            cell.stateView.image = [UIImage imageNamed:@"lifu_large_color.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_haveweather.png"];
        }
        else
        {
            cell.stateView.image = [UIImage imageNamed:@"lifu_large_gray.png"];
            cell.stateColorView.image = [UIImage imageNamed:@"Rectangle_noweather.png"];
        }
        
        cell.timeLabel.text = timerStr;
        cell.contentLabel.text = _schedule.content.text;
    }
    
    return cell;
}

- (void)longPressCell:(CustomLongPress *)sender
{
    
    if (sender.state==UIGestureRecognizerStateBegan)
    {
        NSLog(@"%d",sender.tapRow);
        
        self.longpressrow = sender.tapRow;

        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",@"删除", nil];
        [sheet showInView:self.view];
       
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectrow = indexPath.row;
    
    Schedule *temp = [[self.selectArray objectAtIndex:indexPath.row] objectForKey:@"schedule"];
    
    
    if (temp!=nil)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:DIDSELECTEDSCHEDULE object:temp];
        
        [self backtoprevious];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==0)
    {
        Schedule *sch=nil;
        sch = [[self.selectArray objectAtIndex:self.selectrow] objectForKey:@"schedule"];
        
        if (sch!=nil)
        {
            CommissionViewController *comm = [[CommissionViewController alloc] init];
            comm.schedule = sch;
            [self.navigationController pushViewController:comm animated:YES];
        }
    }
    if (buttonIndex==1)
    {
        Schedule *sch=nil;
        sch = [[self.selectArray objectAtIndex:self.selectrow] objectForKey:@"schedule"];
        
        if (sch!=nil)
        {
            if (self.isRequest==YES)
            {
                return;
            }
            
            self.isRequest=YES;
            
            __block typeof(self) bself = self;
            
            __block UITableView *__tableview = _tableView;
            
            _coverView.hidden=NO;
            
            __block UIView *__coverview = _coverView;
            
            [ProgressHUD show:@"删除中"];

            [[ALBazaarEngine defauleEngine] deleteSchedule:sch block:^(BOOL succeeded, NSError *error) {
                
                __coverview.hidden=YES;
                
                if (succeeded)
                {
                    NSMutableArray *temparray = [ScheduleRequestManager defaultManager].scheduleArray;
                    
                    for (int i=0; i<temparray.count; i++)
                    {
                        Schedule *temp = [temparray objectAtIndex:i];
                        Schedule *temp2 = [bself.datalist objectAtIndex:i];
                        
                        if ([temp.objectId isEqualToString:sch.objectId])
                        {
                            [temparray removeObjectAtIndex:i];
                        }
                        
                        if ([temp2.objectId isEqualToString:sch.objectId])
                        {
                            [bself.datalist removeObjectAtIndex:i];
                        }
                    }
                    
                    [ProgressHUD showSuccess:@"成功"];
                    [bself.selectArray removeObjectAtIndex:bself.longpressrow];
                    [__tableview reloadData];
                }
                else
                {
                    [ProgressHUD showError:@"失败"];
                }
                
                bself.isRequest=NO;
            }];
        }
    }
}


#pragma mark - 添加日程
- (void)addSchedule
{
    CommissionViewController *comm = [[CommissionViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];
}

#pragma mark - 标记日程提醒日期
- (void)setCalendarRemindTagWithYear:(int)year Month:(int)month Day:(int)day
{
    NSMutableArray *dateArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.selectArray removeAllObjects];
    
    for (Schedule *schedule in self.datalist)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyy"];
        int setyear = [[formatter stringFromDate:schedule.date] intValue];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter2 setDateFormat:@"MM"];
        int setmonth = [[formatter2 stringFromDate:schedule.date] intValue];

        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter3 setDateFormat:@"dd"];
        int setday = [[formatter3 stringFromDate:schedule.date] intValue];
        
        
        if (year==setyear)
        {
            if (setmonth==month)
            {
                int selecttime = [[NSString stringWithFormat:@"%d%d%d",setyear,setmonth,setday] intValue];
                
                [dateArray addObject:[NSNumber numberWithInt:setday]];
                
                NSDate *nowdate = [WeatherRequestManager defaultManager].date;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                [formatter setDateFormat:@"yyyyMd"];
                int nowtime = [[formatter stringFromDate:nowdate] intValue];
                
                NSDate *fivedate = [NSDate dateWithTimeInterval:+(24*60*60)*4 sinceDate:nowdate];
                NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                [formatter2 setDateFormat:@"yyyyMd"];
                int fivetime = [[formatter stringFromDate:fivedate] intValue];
                
                UIColor *color1;
                
                BOOL haveWeather=NO;
                
                if (selecttime>=nowtime && selecttime<=fivetime)
                {
                    haveWeather=YES;
                    color1 = HAVEWEATHERCOLOR;
                }
                else
                {
                    haveWeather=NO;
                    color1 = NOTWEATHERCOLOR;
                }
                
                [colorArray addObject:color1];
                
                if (setday==day)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:schedule forKey:@"schedule"];
                    [dic setValue:[NSNumber numberWithBool:haveWeather] forKey:@"haveweather"];
                    [self.selectArray addObject:dic];
                }
            }
        }
        
    }
    
    [_tableView reloadData];
    
    [calendar markDates:dateArray withColors:colorArray];

}

#pragma mark - calendarDelegate
-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(NSDate *)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *nowyear = [formatter stringFromDate:month];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    NSString *nowmonth = [formatter2 stringFromDate:month];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"dd"];
    NSString *nowday = [formatter3 stringFromDate:month];
    
    [self setCalendarRemindTagWithYear:[nowyear intValue] Month:[nowmonth intValue] Day:[nowday intValue]];
    
    
    _calenderHeight = targetHeight;
    
    if (_tableView.alpha==0)
    {
        lineView.frame = CGRectMake(0, _calenderHeight+60, SCREEN_WIDTH, 1);
        lineView.alpha = 1;
        
        _tableView.frame = CGRectMake(0, _calenderHeight+65, 320, SCREEN_HEIGHT-_calenderHeight-65);
        _tableView.alpha = 1;
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            lineView.frame = CGRectMake(0, _calenderHeight+60, SCREEN_WIDTH, 1);

            _tableView.frame = CGRectMake(0, _calenderHeight+65, 320, SCREEN_HEIGHT-_calenderHeight-65);
            
        } completion:nil];
    }
    
    NSLog(@"%f",targetHeight);
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int selectyear = [[formatter stringFromDate:date] intValue];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    int selectmonth = [[formatter2 stringFromDate:date] intValue];
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"dd"];
    int selectday = [[formatter3 stringFromDate:date] intValue];
    
    [self.selectArray removeAllObjects];
    
    for (Schedule *schedule in self.datalist)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        int setyear = [[formatter stringFromDate:schedule.date] intValue];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"MM"];
        int setmonth = [[formatter2 stringFromDate:schedule.date] intValue];
        
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setDateFormat:@"dd"];
        int setday = [[formatter3 stringFromDate:schedule.date] intValue];
        
        if (selectyear==setyear)
        {
            if (setmonth==selectmonth)
            {
                if (setday==selectday)
                {
                    int selecttime = [[NSString stringWithFormat:@"%d%d%d",selectyear,selectmonth,selectday] intValue];
                    
                    NSDate *nowdate = [WeatherRequestManager defaultManager].date;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [formatter setDateFormat:@"yyyyMd"];
                    int nowtime = [[formatter stringFromDate:nowdate] intValue];
                    
                    NSDate *fivedate = [NSDate dateWithTimeInterval:+(24*60*60)*4 sinceDate:nowdate];
                    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
                    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    [formatter2 setDateFormat:@"yyyyMd"];
                    int fivetime = [[formatter stringFromDate:fivedate] intValue];
                    
                    BOOL haveWeather=NO;
                    
                    if (selecttime>=nowtime && selecttime<=fivetime)
                    {
                        haveWeather=YES;
                    }
                    else
                    {
                        haveWeather=NO;
                    }
                    
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:schedule forKey:@"schedule"];
                    [dic setValue:[NSNumber numberWithBool:haveWeather] forKey:@"haveweather"];
                    [self.selectArray addObject:dic];

                }
            }
        }
    }
    
    [_tableView reloadData];
}

- (void)backtoprevious
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
