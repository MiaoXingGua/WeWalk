//
//  AirQualityIndex.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-12.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "AirQualityIndex.h"

@implementation AirQualityIndex
@dynamic aqi;
@dynamic area;
@dynamic position_name;
@dynamic station_code;
@dynamic so2;
@dynamic so2_24h;
@dynamic no2;
@dynamic no2_24h;
@dynamic pm10;
@dynamic pm10_24h;
@dynamic co;
@dynamic co_24h;
@dynamic o3;
@dynamic o3_24h;
@dynamic o3_8h;
@dynamic o3_8h_24h;
@dynamic pm2_5;
@dynamic pm2_5_24h;
@dynamic primary_pollutant;
@dynamic quality;
@dynamic time_point;

+ (NSString *)parseClassName
{
    return @"AirQualityIndex";
}

@end
