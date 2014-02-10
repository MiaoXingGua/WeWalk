//
//  AirQualityIndex.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-12.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface AirQualityIndex : AVObject <AVSubclassing>

@property (nonatomic, assign) int aqi;                      //空气质量指数(AQI)
@property (nonatomic, retain) NSString *area;               //城市名称
@property (nonatomic, retain) NSString *position_name;      //监测点名称
@property (nonatomic, retain) NSString *station_code;       // 	监测点编码
@property (nonatomic, assign) int so2;                      // 	二氧化硫1小时平均
@property (nonatomic, assign) int so2_24h;                  // 	二氧化硫24小时滑动平均
@property (nonatomic, assign) int no2;                      // 	二氧化氮1小时平均
@property (nonatomic, assign) int no2_24h;                  // 	二氧化氮24小时滑动平均
@property (nonatomic, assign) int pm10;                     // 	颗粒物（粒径小于等于10μm）1小时平均
@property (nonatomic, assign) int pm10_24h;                 // 	颗粒物（粒径小于等于10μm）24小时滑动平均
@property (nonatomic, assign) int co;                       //一氧化碳1小时平均
@property (nonatomic, assign) int co_24h;                   // 	一氧化碳24小时滑动平均
@property (nonatomic, assign) int o3;                       // 	臭氧1小时平均
@property (nonatomic, assign) int o3_24h;                   // 	臭氧24小时滑动平均
@property (nonatomic, assign) int o3_8h;                    // 	臭氧8小时滑动平均
@property (nonatomic, assign) int o3_8h_24h;                // 	臭氧8小时滑动平均的24小时均值
@property (nonatomic, assign) int pm2_5;                    // 	颗粒物（粒径小于等于2.5μm）1小时平均
@property (nonatomic, assign) int pm2_5_24h;                // 	颗粒物（粒径小于等于2.5μm）24小时滑动平均
@property (nonatomic, retain) NSString *primary_pollutant; 	// 	首要污染物
@property (nonatomic, retain) NSString *quality;            // 	空气质量指数类别，有“优、良、轻度污染、中度污染、重度污染、严重污染”6类
@property (nonatomic, retain) NSDate *time_point;           // 	数据发布的时间
@end
