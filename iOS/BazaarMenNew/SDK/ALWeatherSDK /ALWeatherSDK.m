//
//  ALWeatherSDK.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-13.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "ALWeatherSDK.h"

@implementation ALWeatherSDK

+ (void)registerLKSDK
{
    [AirQualityIndex registerSubclass];
    [Weather registerSubclass];
    [WeatherInfo registerSubclass];
}

@end
