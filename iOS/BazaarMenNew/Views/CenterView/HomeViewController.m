//
//  HomeViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "HomeViewController.h"
#import "ClothInfoViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "WelcoViewController.h"
#import "CommissionViewController.h"
#import "AllScheduleViewController.h"
#import "CommissionViewController.h"
#import "SchedleInfoViewController.h"
#import "UserInfoViewController.h"
#import "ClothInfoViewController.h"
#import "SendPhotosViewController.h"
#import "AddCityViewController.h"
#import "ScheduleRequestManager.h"
#import "FinishUserDataViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "SystemConfigManager.h"
#import "ConstellationListViewController.h"

#import "textAViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize schArray = _schArray;

- (void)showCenterViewController
{
    [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.2];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    
}

- (void)havenickname
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==YES)
    {
        if ([[[ALBazaarEngine defauleEngine].user objectForKey:@"nickname"] length]==0)
        {
            FinishUserDataViewController *finishview = [[FinishUserDataViewController alloc] init];
            finishview.isDismiss=YES;
            [self presentViewController:finishview animated:YES completion:nil];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"myCity"];
    if (array.count==0)
    {
        [self addCityView];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDate) name:REFRESHDATE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeStreetView) name:SHOWHOMEVIEWCONTROLLER object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftView) name:SHOWLEFTVIEW object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didselectedSchedule:) name:DIDSELECTEDSCHEDULE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didselectedSchedulePhoto:) name:DIDSELECTSCHEDULEPHOTO object:nil];
    
    
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.schArray = [NSMutableArray arrayWithCapacity:0];
    
    CGRect _frame;
    if (self.view.frame.size.height>480)
    {
        isPhone5=YES;
        _frame = CGRectMake(0, 44+70, SCREEN_WIDTH, SCREEN_HEIGHT-44-70);
    }
    else
    {
        isPhone5=NO;
        _frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    }
    
    RecommendView *review = [[RecommendView alloc] initWithFrame:_frame];
    review.backgroundColor = [UIColor whiteColor];
    review.recommendDelegate = self;
    [self.backgroundView addSubview:review];
    
    headView = [[UIView alloc] initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:headView];
    
    UIView *coloview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
    coloview.backgroundColor = [UIColor whiteColor];
    coloview.alpha = 0.85;
    [headView addSubview:coloview];
    coloview.hidden=YES;
    
    if (isPhone5==YES)
    {
        headView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 70);
    }
    else
    {
        headView.frame = CGRectMake(0, -44+17, SCREEN_WIDTH, 90);
        coloview.hidden=NO;
        
        UIButton *tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tapBtn.frame = CGRectMake(135, 70, 88*0.7, 50*0.7);
        tapBtn.backgroundColor = [UIColor clearColor];
        [tapBtn setImage:[UIImage imageNamed:@"xiala.png"] forState:UIControlStateNormal];
        [tapBtn addTarget:self action:@selector(tapheadviewBtn) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:tapBtn];
    }
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 70, SCREEN_WIDTH-20, 1)];;
    lineview.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [headView addSubview:lineview];
    

    for (int i=0; i<5; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12+64*i, 7, 40, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.tag = 2000+i;
        label.backgroundColor = [UIColor clearColor];
        label.adjustsFontSizeToFitWidth = YES;
        [label setTextAlignment:NSTextAlignmentCenter];
        [headView addSubview:label];
        
        UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dateBtn.frame = CGRectMake(12+64.2*i, 24, 40, 40);
        dateBtn.titleLabel.font = [UIFont systemFontOfSize:19];
        [dateBtn setTitleColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.35 alpha:1] forState:UIControlStateNormal];
        dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        dateBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [dateBtn addTarget:self action:@selector(tapSchedleInfo:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:dateBtn];
        dateBtn.tag = 1000+i;
        
        
        if (i==0)
        {
            label.text = @"周一";
            [dateBtn setTitle:@"--" forState:UIControlStateNormal];
        }
        if (i==1)
        {
            label.text = @"周二";
            [dateBtn setTitle:@"--" forState:UIControlStateNormal];
        }
        if (i==2)
        {
            label.text = @"周三";
            [dateBtn setTitle:@"--" forState:UIControlStateNormal];
        }
        if (i==3)
        {
            label.text = @"周四";
            [dateBtn setTitle:@"--" forState:UIControlStateNormal];
        }
        if (i==4)
        {
            label.text = @"周五";
            [dateBtn setTitle:@"--" forState:UIControlStateNormal];
        }
    }
    
    UIImageView *timeimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ooooo.png"]];
    timeimage.frame = CGRectMake(0, 0, 572/2, 62/2);
    timeimage.center = CGPointMake(headView.frame.size.width/2, 43);
    [headView addSubview:timeimage];
    
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    showLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showLeftBtn.frame = CGRectMake(10, 7, 30, 30);
    [showLeftBtn setImage:[UIImage imageNamed:@"首页_0002_Rectangle-3.png"] forState:UIControlStateNormal];
    [showLeftBtn addTarget:self action:@selector(showLeftView) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:showLeftBtn];
    
    UIButton *autodyneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autodyneBtn.frame = CGRectMake(235, 7, 30, 30);
    [autodyneBtn setImage:[UIImage imageNamed:@"首页_0000_Rounded-Rectangle-2.png"] forState:UIControlStateNormal];
    [autodyneBtn addTarget:self action:@selector(showSendAutodyneBtnView) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:autodyneBtn];
    
    UIButton *streetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    streetBtn.frame = CGRectMake(276, 9, 30, 30);
    [streetBtn setImage:[UIImage imageNamed:@"首页_0001_Shape-1.png"] forState:UIControlStateNormal];
    [streetBtn addTarget:self action:@selector(showStreetView) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:streetBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"微行";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];

    //检查是否填写用户资料
    [self havenickname];
    
    if ([[SystemConfigManager defaultManager] isOrNotNetWorking]==NO)
    {
        [ProgressHUD showError:@"当前无网络，请检查您的网络设置"];
    }
   
}

#pragma mark - 刷新时间
- (void)refreshDate
{
    NSDate *_date = [WeatherRequestManager defaultManager].date;
    
    [[ScheduleRequestManager defaultManager].dateArray removeAllObjects];;
    
    for (int i=0; i<5; i++)
    {
        UILabel *templabel = (UILabel *)[self.view viewWithTag:2000+i];
        UIButton *tempbutton = (UIButton *)[self.view viewWithTag:1000+i];
        
        NSDate *userdate = [NSDate dateWithTimeInterval:+(24*60*60)*(i) sinceDate:_date];
        
        
        NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
        [formatter3 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter3 setDateFormat:@"yyyy"];
        NSString *yearStr = [formatter3 stringFromDate:userdate];
        
        NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
        [formatter4 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter4 setDateFormat:@"MM"];
        NSString *monthStr = [formatter4 stringFromDate:userdate];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"dd"];
        NSString *dayStr = [formatter stringFromDate:userdate];
        
        [[ScheduleRequestManager defaultManager].dateArray addObject:[NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,dayStr]];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter2 setDateFormat:@"EEEE"];
        NSString *weekStr = [formatter2 stringFromDate:userdate];

        
        if ([weekStr isEqualToString:@"星期一"])
        {
            weekStr = @"周一";
        }
        if ([weekStr isEqualToString:@"星期二"])
        {
            weekStr = @"周二";
        }
        if ([weekStr isEqualToString:@"星期三"])
        {
            weekStr = @"周三";
        }
        if ([weekStr isEqualToString:@"星期四"])
        {
            weekStr = @"周四";
        }
        if ([weekStr isEqualToString:@"星期五"])
        {
            weekStr = @"周五";
        }
        if ([weekStr isEqualToString:@"星期六"])
        {
            weekStr = @"周六";
        }
        if ([weekStr isEqualToString:@"星期日"])
        {
            weekStr = @"周日";
        }
        
        templabel.text = weekStr;
        [tempbutton setTitle:dayStr forState:UIControlStateNormal];
        
        [self showTextLabelAnimation:templabel];
        [self showTextBtnAnimation:tempbutton];
    }
}

- (void)addCityView
{
    AddCityViewController *addcity = [[AddCityViewController alloc] init];
    [self presentViewController:addcity animated:YES completion:nil];
}

#pragma mark - 单击日程View
- (void)tapheadviewBtn
{
    if (isOpen==YES)
    {
        [self closeHeadView];
    }
    else
    {
        [self openHeadView];
    }
}

- (void)openHeadView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        headView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 90);
        
    } completion:^(BOOL finished) {
        isOpen=YES;
    }];
}

- (void)closeHeadView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        headView.frame = CGRectMake(0, -44+17, SCREEN_WIDTH, 90);
        
    } completion:^(BOOL finished) {
        isOpen=NO;
    }];
}

#pragma mark - 监听选中日期
- (void)didselectedSchedule:(NSNotification *)info
{
    if (isShowSchedleView==YES)
    {
        [self hideSchedleView:0];
    }
    
    NSMutableArray *temp = [ScheduleRequestManager defaultManager].dateArray;

    if (temp.count==0)
    {
        [ProgressHUD showError:@"日程信息没有加载完成"];
        
        return;
    }
    
    [self.schArray removeAllObjects];
    
    Schedule *tempsch = (Schedule *)[info object];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *tapDateStr = [formatter stringFromDate:tempsch.date];

    
    NSMutableArray *allsch = [ScheduleRequestManager defaultManager].scheduleArray;
    
    for (int i=0; i<allsch.count; i++)
    {
        Schedule *_sch = [allsch objectAtIndex:i];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSString *dateStr = [formatter stringFromDate:_sch.date];
        
        if ([dateStr isEqualToString:tapDateStr])
        {
            [self.schArray addObject:_sch];
        }
    }
    
    if (self.schArray.count==0)
    {
        [ProgressHUD showError:@"还没有设置日程"];
        
        return;
    }
    
    self.showSch = [info object];
    
    [self showSchedleView];
}

#pragma mark - 单击日期
- (void)tapSchedleInfo:(UIButton *)sender
{
    NSMutableArray *temp = [ScheduleRequestManager defaultManager].dateArray;
    
    if (isShowSchedleView==YES)
    {
        [self hideSchedleView:0.2];
    }
    else
    {
        if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        
        if (temp.count==0)
        {
            [ProgressHUD showError:@"日程信息没有加载完成"];
            
            return;
        }
        
        [self.schArray removeAllObjects];
        
        NSString *tapDateStr = [temp objectAtIndex:sender.tag-1000];
        
        NSMutableArray *allsch = [ScheduleRequestManager defaultManager].scheduleArray;
        
        for (int i=0; i<allsch.count; i++)
        {
            Schedule *_sch = [allsch objectAtIndex:i];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString *dateStr = [formatter stringFromDate:_sch.date];
            
            if ([dateStr isEqualToString:tapDateStr])
            {
                [self.schArray addObject:_sch];
            }
        }
        
        if (self.schArray.count==0)
        {
            [ProgressHUD showError:@"还没有设置日程"];
            
            return;
        }
        
        NSLog(@"%@",self.schArray);
        
        [self showSchedleView];
    }
}

- (void)showSchedleView
{
    self.sidePanelController.recognizesPanGesture = NO;
    
    [showLeftBtn setImage:[UIImage imageNamed:@"首页.png"] forState:UIControlStateNormal];

    if (schview!=nil)
    {
        [schview.view removeFromSuperview];
        schview=nil;
    }
    
    schview = [[SchedleInfoViewController alloc] initWithSchedleArray:self.schArray ShowSchedule:self.showSch];
    schview.view.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:schview.view];
    schview.view.alpha = 0;
    
    CGRect _frame2;
    if (isPhone5==YES)
    {
        _frame2 = CGRectMake(0, 44+80, SCREEN_WIDTH, SCREEN_HEIGHT-44-80);
    }
    else
    {
        _frame2 = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    }
    
    schview.view.frame = _frame2;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        schview.view.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        isShowSchedleView=YES;
        
    }];
}

- (void)hideSchedleView:(float)time
{
    self.sidePanelController.recognizesPanGesture = YES;
    
    self.showSch=nil;
    
    [showLeftBtn setImage:[UIImage imageNamed:@"首页_0002_Rectangle-3.png"] forState:UIControlStateNormal];
    
    if (time==0)
    {
        isShowSchedleView=NO;
        [schview.view removeFromSuperview];
        schview=nil;

    }
    else
    {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            schview.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            isShowSchedleView=NO;
            [schview.view removeFromSuperview];
            schview=nil;
            
        }];
    }


}

#pragma mark - 显示/关闭街拍
- (void)showStreetView
{
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (void)closeStreetView
{
    [self.sidePanelController showCenterPanelAnimated:YES];
}

#pragma mark - 显示发送自拍View
- (void)showSendAutodyneBtnView
{
    textAViewController *aview = [[textAViewController alloc] init];
    [self.navigationController pushViewController:aview animated:YES];
    
//    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        return;
//    }
//    
//    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"打开相册", nil];
//    [_sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UIImagePickerController *imagePiker = [[UIImagePickerController alloc] init];
        imagePiker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePiker.delegate = self;
        imagePiker.allowsEditing = NO;
        [self presentViewController:imagePiker
                           animated:YES
                         completion:nil];
    }
    
    if (buttonIndex == 1)
    {
        
        UIImagePickerController *imagPickerC = [[UIImagePickerController alloc] init];//图像选取器
        imagPickerC.delegate = self;
        imagPickerC.allowsEditing = NO;
        imagPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagPickerC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        
        [self presentViewController:imagPickerC animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self presentSendPhotosView:image];
        
    }];
 }

- (void)presentSendPhotosView:(UIImage *)image
{
    SendPhotosViewController *sendphotos = [[SendPhotosViewController alloc] initWithUserImage:image];
    [self presentViewController:sendphotos animated:YES completion:nil];
}

#pragma mark - 选择衣服delegate
//选择T台图
- (void)didSelectExampleClother:(Photo *)photo
{
    if (photo!=nil)
    {
        ClothInfoViewController *clothview = [[ClothInfoViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:clothview animated:YES];
    }
    else
    {
        [ProgressHUD showError:@"数据加载中"];
    }
}

//选择街拍图
- (void)didSelectStreetClother:(Photo *)photo
{
    if (photo!=nil)
    {
        ClothInfoViewController *clothview = [[ClothInfoViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:clothview animated:YES];
    }
    else
    {
        [ProgressHUD showError:@"数据加载中"];
    }
}

//选中日程推荐
- (void)didselectedSchedulePhoto:(NSNotification *)info
{
    Photo *photo=nil;
    photo = [info object];
    
    if (photo!=nil)
    {
        ClothInfoViewController *clothview = [[ClothInfoViewController alloc] initWithPhoto:photo];
        [self.navigationController pushViewController:clothview animated:YES];
    }
    else
    {
        [ProgressHUD showError:@"数据加载中"];
    }
}

#pragma mark - 设置/添加日程delegate
//查看全部日程
- (void)didSelectedAllSchedule:(NSString *)cityid
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    if ([ScheduleRequestManager defaultManager].requestSuccess==NO)
    {
        [ProgressHUD showError:@"日程信息没有加载完成"];
        
        return;
    }
    
    if ([ScheduleRequestManager defaultManager].scheduleArray.count==0)
    {
        [ProgressHUD showError:@"还没有设置日程"];
    }
    
    AllScheduleViewController *sched = [[AllScheduleViewController alloc] init];
    [self.navigationController pushViewController:sched animated:YES];
}

//添加日程
- (void)didSelectedAddSchedule:(NSString *)cityid
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    CommissionViewController *comm = [[CommissionViewController alloc] init];
    [self.navigationController pushViewController:comm animated:YES];
}

- (void)didselectedFortune:(NSString *)cityid
{
    ConstellationListViewController *constellation = [[ConstellationListViewController alloc] init];
    [self.navigationController pushViewController:constellation animated:YES];
}

#pragma animation
- (void)showTextLabelAnimation:(UILabel *)label
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [label.layer addAnimation: animation forKey: @"FadeIn"];
}

- (void)showTextBtnAnimation:(UIButton *)btn
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [btn.layer addAnimation: animation forKey: @"FadeIn"];
}

- (void)showLeftView
{
    if (isShowSchedleView==YES)
    {
        [self hideSchedleView:0.2];
        
        return;
    }
    
    [self.sidePanelController showLeftPanelAnimated:YES];
}

- (void)showRightView
{
    [self.sidePanelController showRightPanelAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
