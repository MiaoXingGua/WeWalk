//
//  ALWeatherEngine.h
//  WeatherDEMO
//
//  Created by Albert on 13-12-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ALWeatherConfig.h"

@interface ALWeatherEngine : NSObject

+ (instancetype)defauleEngine;

- (void)currentDateWithBlock:(void(^)(NSDate *date))block;

//获取城市名
- (void)getCityNameWithQueryCondition:(NSString *)conditionString block:(PFArrayResultBlock)resultBlock;

//获取woeid
- (void)getWoeidWithCityName:(NSString *)cityName block:(PFArrayResultBlock)resultBlock;

//获取pm25
- (void)getPM25WithCityName:(NSString *)cityName block:(AVIntegerResultBlock)resultBlock;

//获取AQI
- (void)getAQIWithCityName:(NSString *)cityName block:(AVIntegerResultBlock)resultBlock;

//获取天气
- (void)getWeatherWithWoeid:(NSString *)woeid block:(void(^)(WeatherInfo *weatherInfo, NSError *error))resultBlock;

- (BOOL)setupCityDB;

@end
