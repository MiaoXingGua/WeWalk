//
//  WeatherRequestManager.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-11.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALWeatherSDK.h"

@interface WeatherRequestManager : NSObject
{
    NSMutableArray *_cityArray;
    
    WeatherInfo *_weatherinfo;
        
    NSTimer *_timer;
    
    NSString *_woeid;
    
    NSDate *_date;
}

@property(nonatomic,strong)NSMutableArray *cityArray;
@property(nonatomic,strong)WeatherInfo *weatherinfo;
@property(nonatomic,assign)int PM25Num;
@property(nonatomic,strong)NSString *woeid;
@property(nonatomic,strong)NSDate *date;
@property(nonatomic,strong)NSMutableArray *recommendArray;
@property(nonatomic,strong)NSMutableArray *scheduleCityWeatherArray;
@property(nonatomic,strong)NSMutableArray *scheduleCityArray;
@property(nonatomic,strong)NSString *weatherState;
+ (WeatherRequestManager *)defaultManager;

- (void)requestWeather;
- (void)openRefreshWeatherTimer;
- (void)stopTimer;

- (void)requestScheduleCityWeather;

- (void)refreshDate;

@end
