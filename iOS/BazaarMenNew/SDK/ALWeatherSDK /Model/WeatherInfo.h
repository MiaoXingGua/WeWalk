//
//  WeatherInfo.h
//  WeatherDEMO
//
//  Created by Albert on 13-12-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "ALWeatherConfig.h"


@interface WeatherInfo : AVObject <AVSubclassing>

//天气
@property (nonatomic, retain) NSMutableArray *weathers; //当前 当天 明天 后天 大后天 大大后天

//湿度气压能见度
@property (nonatomic, assign) int humidity;     //湿度
@property (nonatomic, assign) float pressure;   //气压
@property (nonatomic, assign) float visibility; //能见度 km
@property (nonatomic, assign) int rising;       //气压状态:稳定0 上升1 下降2

//风
@property (nonatomic, assign) int chill;        //寒意 11;
@property (nonatomic, assign) int direction;    //方向 300;
@property (nonatomic, assign) float speed;      //风速 4.83";

//单位
@property (nonatomic, retain) NSString *distanceUnit;   //距离 km;
@property (nonatomic, retain) NSString *pressureUnit;   // 压力 mb;
@property (nonatomic, retain) NSString *speedUnit;     //速度 km/h
@property (nonatomic, retain) NSString *temperatureUnit; //温度 C;
@end
