//
//  WeatherType.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-9.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "WeatherType.h"

@implementation WeatherType
@dynamic name;
@dynamic yahooNameCN;
@dynamic yahooNameUS;
@dynamic weatherCode;

+ (NSString *)parseClassName
{
    return @"WeatherType";
}

@end
