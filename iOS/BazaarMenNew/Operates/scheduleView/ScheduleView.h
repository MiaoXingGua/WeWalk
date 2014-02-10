//
//  ScheduleView.h
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-23.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALBazaarSDK.h"
#import "Schedule.h"
#import "AsyncImageView.h"
#import "Photo.h"

@interface ScheduleView : UIView
{
    UIActivityIndicatorView *_activity;
    UILabel *weatherLabel;
}

@property(nonatomic,strong)Schedule *schedule;
@property(nonatomic,assign)float h;
@property(nonatomic,strong)Photo *schedulePhoto;
@property(nonatomic,strong)AsyncImageView *personView;
@property(nonatomic,strong)UILabel *suggestinfoLabel;
@property(nonatomic,strong)UILabel *brandLabel;
@property(nonatomic,assign)WeatherInfo *weatherinfo;
@property(nonatomic,strong)UIImageView *scheduleStateView;
@property(nonatomic,strong)UIImageView *scheduleTypeView;

- (id)initWithFrame:(CGRect)frame Schedule:(Schedule *)sch;

@end
