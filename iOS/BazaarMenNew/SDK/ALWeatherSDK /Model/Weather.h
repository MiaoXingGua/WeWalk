//
//  Weather.h
//  WeatherDEMO
//
//  Created by Albert on 13-12-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "ALWeatherConfig.h"

@interface Weather : AVObject <AVSubclassing>

@property (nonatomic, assign) WeatherCode weatherCode;

@property (nonatomic, retain) NSDate *date;

@property (nonatomic, assign) float temperature;//温度：只有当天的

@property (nonatomic, assign) float high,low;//

@end
