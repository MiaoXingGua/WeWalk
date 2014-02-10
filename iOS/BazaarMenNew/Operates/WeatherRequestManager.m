//
//  WeatherRequestManager.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-11.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "WeatherRequestManager.h"
#import "ScheduleRequestManager.h"
#import "ALBazaarSDK.h"

static WeatherRequestManager *weather=nil;

@implementation WeatherRequestManager
@synthesize weatherinfo = _weatherinfo;
@synthesize cityArray = _cityArray;
@synthesize woeid = _woeid;
@synthesize recommendArray;
@synthesize weatherState;

+ (WeatherRequestManager *)defaultManager
{
    if (weather==nil)
    {
        weather = [[WeatherRequestManager alloc] init];
        
        weather.cityArray = [NSMutableArray arrayWithCapacity:0];
        
        weather.recommendArray = [NSMutableArray arrayWithCapacity:0];
        
        weather.scheduleCityWeatherArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    
    return weather;
}

- (void)requestScheduleCityWeather
{
    NSMutableArray *temp = [ScheduleRequestManager defaultManager].scheduleArray;
    
    
    if (temp.count==0)
    {
        return;
    }
    
    NSMutableArray *tempcityarray = [NSMutableArray array];

    [self.scheduleCityWeatherArray removeAllObjects];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyyMMdd"];
    int time1 = [[formatter stringFromDate:self.date] intValue];
    
    NSDate *tempdate = [NSDate dateWithTimeInterval:+(24*60*60)*4 sinceDate:self.date];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter2 setDateFormat:@"yyyyMMdd"];
    int time2 = [[formatter stringFromDate:tempdate] intValue];
    
    NSLog(@"%d,%d",time1,time2);
    
    for (int i=0; i<temp.count; i++)
    {
        Schedule *_sch = [temp objectAtIndex:i];
        NSString *_city = _sch.place;
  
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [formatter setDateFormat:@"yyyyMMdd"];
        int schtime = [[formatter stringFromDate:_sch.date] intValue];
        
        if (time1<=schtime && schtime<=time2)
        {
            __block typeof(self) bself = self;
            
            //去除重复城市的请求
            if (tempcityarray.count>0)
            {
                if ([tempcityarray containsObject:_city]==YES)
                {
                    return;
                }
            }
            
            [[ALWeatherEngine defauleEngine] getWoeidWithCityName:_city block:^(NSArray *objects, NSError *error) {
                
                if (objects.count>0)
                {
                    NSString *woeid = [[objects objectAtIndex:0] objectForKey:@"woeid"];
                    
                    [[ALWeatherEngine defauleEngine] getWeatherWithWoeid:woeid block:^(WeatherInfo *weatherInfo, NSError *error) {
                        
                        if (weatherInfo!=nil)
                        {
                            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                            [dic setValue:_city forKey:@"schCity"];
                            [dic setValue:weatherInfo forKey:@"weather"];
                            
                            [bself.scheduleCityWeatherArray addObject:dic];
                            
                            //[[NSNotificationCenter defaultCenter] postNotificationName:COMPLETEREQUESTSCHEDULEWEATHER object:nil];
                        }
                    }];
                }
            }];

        }
    }
    
 
}

//刷新选中城市天气
- (void)openRefreshWeatherTimer
{
    if (_timer!=nil)
    {
        [_timer invalidate];
        _timer=nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(requestWeather) userInfo:nil repeats:YES];
    
    [self requestWeather];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer=nil;
}

//请求用户选中城市天气
- (void)requestWeather
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BEGINREFRESHWEATHER object:nil];
    
  
    __block typeof(self) bself = self;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"useCity"]];
    NSString *city = [dic objectForKey:@"cityname"];
    NSString *district = [dic objectForKey:@"districtname"];
    
    NSLog(@"%@",dic);
    
    NSString *useStr;
    
    if (district.length==0)
    {
        useStr = city;
    }
    else
    {
        useStr = district;
    }
    
    if (city.length==0 && district.length==0)
    {
        return;
    }

    NSLog(@"使用城市：%@",useStr);
    
    [[ALWeatherEngine defauleEngine] getWoeidWithCityName:useStr block:^(NSArray *objects, NSError *error) {
        
        if (objects.count>0)
        {
            [bself.cityArray addObjectsFromArray:objects];
            
            NSString *woeid = [[objects objectAtIndex:0] objectForKey:@"woeid"];
          //  NSString *cityname = [[objects objectAtIndex:0] objectForKey:@"name"];
            bself.woeid = woeid;
            
            if (woeid.length>0)
            {
                [[ALWeatherEngine defauleEngine] getWeatherWithWoeid:woeid block:^(WeatherInfo *weatherInfo, NSError *error) {
                    
                    if (weatherInfo!=nil && !error)
                    {
                        NSLog(@"%@",weatherInfo);
                        bself.weatherinfo = weatherInfo;

                        AVQuery *query = [WeatherType query];
                        [query whereKey:@"weatherCode" equalTo:[NSNumber numberWithInt:[weatherInfo.weathers[0] weatherCode]]];
                        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                            
                            bself.weatherState = [object objectForKey:@"name"];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETEREFRESHWEATHER object:nil];

                        }];
                    }
                }];
                
                NSLog(@"city%@",city);
            
                [[ALWeatherEngine defauleEngine] getPM25WithCityName:city block:^(NSInteger number, NSError *error) {
                    
                    if (!error)
                    {
                        bself.PM25Num = number;
                        
                        NSLog(@"pm25%d",number);
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHPM25 object:nil];
                    }
                }];
            }
        }
    }];
}

//刷新日期
- (void)refreshDate
{
    __block typeof(self) bself = self;

    [[ALWeatherEngine defauleEngine] currentDateWithBlock:^(NSDate *date) {
        
        if (date==nil)
        {
            [bself refreshDate];
        }
        else
        {
            bself.date = date;
            [bself requestScheduleCityWeather];
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHDATE object:nil];
        }
    }];
}


@end
