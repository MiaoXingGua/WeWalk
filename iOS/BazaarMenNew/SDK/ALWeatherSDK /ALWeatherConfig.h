//
//  ALWeatherConfig.h
//  WeatherDEMO
//
//  Created by Albert on 13-12-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#ifndef WeatherDEMO_ALWeatherConfig_h
#define WeatherDEMO_ALWeatherConfig_h

typedef NS_ENUM(NSInteger, WeatherCode) {
    /*
     #风
     #雨
     #雪
     #晴
     #雾
     #云
     */
    tornado = 0,                //龙卷风   #风
    tropicalStorm = 1,          //热带风暴  #风
    hurricane = 2,              //飓风    #风
    severeThunderstorms = 3,    //严重雷雨  #雨
    thunderstorms = 4,          //雷暴    #雨
    mixedRainAndSnow = 5,       //雨加雪   #雨雪
    mixedRainAndSleet = 6,      //雨加雹   #雨
    mixedSnowAndSleet = 7,      //雪加雹   #雪
    freezingDrizzle = 8,        //冻小雨   #雨
    drizzle = 9,                //小雨    #雨
    freezingRain = 10,          //冻雨    #雨
    showers = 11,               //阵雨    #雨
    //    showers = 12,             //阵雨    #雨
    snowFlurries = 13,          //阵雪    #雪
    lightSnowShowers = 14,      //小阵雪   #雪
    blowingSnow = 15,           //飞雪    #雪
    snow = 16,                  //雪     #雪
    hail = 17,                  //冰雹    #雪
    sleet = 18,                 //雨夹雪   #雨
    dust = 19,                  //粉尘    #雾
    foggy = 20,                 //雾     #雾
    haze = 21,                  //霾     #雾
    smoky = 22,                 //烟     #雾
    blustery = 23,              //大风    #风
    windy = 24,                 //多风    #风
    cold = 25,                  //冷     #雪
    cloudy = 26,                //云     #云
    mostlyCloudyNight = 27,     //夜间多云  #云
    mostlyCloudyDay = 28,       //日间多云  #云
    partlyCloudyNight = 29,     //夜间局部云 #云
    partlyCloudyDay = 30,       //日间多云  #云
    clearNight = 31,            //晴夜    #晴
    sunny = 32,                 //阳光    #晴
    fairNight = 33,             //夜间晴朗  #晴
    fairDay = 34,               //日间晴朗  #晴
    mixedRainAndHail = 35,      //雨加雹   #雪
    hot = 36,                   //热      #晴
    isolatedThunderstorms = 37, //局部雷雨  #雨
    scatteredThunderstorms = 38,//分散雷雨  #雨
//    scattered thunderstorms = 39, //分散雷雨  #雨
    scatteredShowers = 40,      //分散阵雨  #雨
    heavySnow = 41,             //大雪        #雪
    scatteredSnowShowers = 42,  //分散雨雪  #雪
    //    heavySnow = 43,             //大雪  #雪
    partlyCloudy = 44,          //局部多云  #云
    thundershowers = 45,        //雷阵雨   #雨
    snowShowers = 46,           //雨加雪   #雪
    isolatedThundershowers = 47,//局部雷阵雨 #雨
    notAvailable = 3200
};

#import <AVOSCloud/AVOSCloud.h>

#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "XMLReader.h"
#import "FMDatabase.h"
#import "Weather.h"
#import "WeatherInfo.h"
#import "AirQualityIndex.h"


#define ALERROR(_domain,_code,_error) !_error ? ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":[NSNull null]}]) : ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":_error}])

#define TID_TIME_OUT 60*1
#define REQUEST_DEFAULE_TIME_OUT 15

#define YAHOO_BASIC_WEATHER @"http://weather.yahooapis.com/forecastrss?"

#define YAHOO_CITY_NAME_TO_WOEID @"http://query.yahooapis.com/v1/public/yql?q=select%20woeid,name,country%20from%20geo.places%20where%20text="

#define BAIDU_TRANSFORM @"http://openapi.baidu.com/public/2.0/bmt/translate?client_id=uvo4jom8E8TkTpU2RE5AKYeR&from=auto&to=auto&q="

#define PM25_API @"http://www.pm25.in/api/querys/pm2_5.json?token=5j1znBVAsnSf5xQyNQyq&city="







#endif
