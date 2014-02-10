//
//  ALWeatherSDK.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-13.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Weather.h"
#import "WeatherInfo.h"
#import "WeatherType.h"
#import "AirQualityIndex.h"
#import "ALWeatherEngine.h"

@interface ALWeatherSDK : AVObject

+ (void)registerLKSDK;

@end
