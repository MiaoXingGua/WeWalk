//
//  ALWeatherEngine.m
//  WeatherDEMO
//
//  Created by Albert on 13-12-16.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "ALWeatherEngine.h"


@interface ALWeatherEngine()
@property (nonatomic, retain) ASINetworkQueue *queue;
@end

static ALWeatherEngine *defauleEngine = nil;

@implementation ALWeatherEngine

#pragma mark - 基本

+ (instancetype)defauleEngine
{
    if (!defauleEngine)
    {
        defauleEngine = [[ALWeatherEngine alloc] init];
        defauleEngine.queue = [[ASINetworkQueue alloc] init];
        [defauleEngine.queue go];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"citylist.db"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
                [defauleEngine setupCityDB:dbPath];
            }
        });
    }
    return defauleEngine;
}

- (void)currentDateWithBlock:(void(^)(NSDate *date))block
{
    [AVCloud callFunctionInBackground:@"datetime" withParameters:@{} block:^(id object, NSError *error) {
        

        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[object longLongValue]/1000];
        
        if (block)
        {
            block(date);
        }
        
    }];
}

- (void)getCityNameWithQueryCondition:(NSString *)conditionString block:(PFArrayResultBlock)resultBlock
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"citylist.db"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        [self setupCityDB:dbPath];
        [self getCityNameWithQueryCondition:conditionString block:resultBlock];
        return;
    }

    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *conditionStr = [[@"%" stringByAppendingString:conditionString] stringByAppendingString:@"%"];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM City ",conditionStr,conditionStr,conditionStr,conditionStr];
    NSLog(@"sql=%@",sql);
    //WHERE cityName LIKE '%@' or districtName LIKE '%@' or districtSpell1 LIKE '%@' or districtSpell2 LIKE '%@'
    
    FMResultSet *rs = [db executeQuery:sql];
    
    NSMutableArray *citys = [NSMutableArray array];
    
	while ([rs next]) {

        NSString *cityName = [rs stringForColumn:@"cityName"];

        NSString *districtName = [rs stringForColumn:@"districtName"];
	 
        [citys addObject:@{@"cityName":cityName,@"districtName":districtName}];
	}
	 
    if (resultBlock) {
        resultBlock(citys,nil);
    }
    
	[rs close];
}

//创建bd文件
- (BOOL)setupCityDB:(NSString *)dbPath
{
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"csv"];
    NSArray *citylist = [self csv2json:csvFilePath];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath] ;
    if (![db open]) {
        NSLog(@"Could not open db.");
        return NO;
    }
    BOOL createTb = [db executeUpdate:@"CREATE TABLE City (cityNo integer, districtNo integer, cityName text, districtName text, districtSpell1 text, districtSpell2 text)"];
    if (!createTb) {
        NSLog(@"Could not created table.");
        return NO;
    }
    
    BOOL insertSuccess = YES;
    for (NSDictionary *cityInfo in citylist) {
        
        insertSuccess = [db executeUpdate:@"INSERT INTO city (cityNo, districtNo, cityName, districtName, districtSpell1, districtSpell2) VALUES (:cityNo, :districtNo, :cityName, :districtName, :districtSpell1, :districtSpell2)" withParameterDictionary:cityInfo];
        if (!insertSuccess)
        {
            NSLog(@"Insert tabel not success.");
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)csv2json:(NSString *)csvFilePath
{
    NSString* fileContents = [NSString stringWithContentsOfFile:csvFilePath encoding:NSUTF8StringEncoding error:nil];
    
    // first, separate by new line
    NSArray* cityCvs = [fileContents componentsSeparatedByString:@"\r\n"];
    
    // then break down even further
    NSMutableArray *districtList = [NSMutableArray array];
    NSMutableArray *cityList = [NSMutableArray array];
    
    for (NSString *cityCvsString in cityCvs) {
        
        //修正
        NSString *trimmedString = [cityCvsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray* singleStrs = [trimmedString componentsSeparatedByString:@","];
        
        if (singleStrs.count<=1) {
            continue;
        }
        //城市
        if ([singleStrs[0] isEqualToString:@"0"])
        {
            [cityList addObject:@{@"cityNo":singleStrs[1],@"cityName":singleStrs[2]}];
            //            [cityList setObject:singleStrs[1] forKey:@"cityNo"];
            //            [cityList setObject:singleStrs[2] forKey:@"cityName"];
        }
    }
    
    for (NSString *cityCvsString in cityCvs) {
        
        //修正
        NSString *trimmedString = [cityCvsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray* singleStrs = [trimmedString componentsSeparatedByString:@","];
        
        if (singleStrs.count<=1) {
            continue;
        }
        //区
        if (![singleStrs[0] isEqualToString:@"0"]){
            NSString *cityNo = singleStrs[0];
            NSString *cityName = @"";
            for (NSDictionary *cityInfo in cityList) {
                if ([cityInfo[@"cityNo"] isEqualToString:cityNo]){
                    cityName = cityInfo[@"cityName"];
                }
            }
            [districtList addObject:@{@"cityNo":singleStrs[0],@"cityName":cityName,@"districtNo":singleStrs[1],@"districtName":singleStrs[2],@"districtSpell1":singleStrs[3],@"districtSpell2":singleStrs[4]}];
        }
    }
    //    NSLog(@"cityList=%@",cityList);
    NSLog(@"districtList=%@",districtList);
    
    return districtList;
}

- (void)getWoeidWithCityName:(NSString *)cityName block:(PFArrayResultBlock)resultBlock
{
    if (!cityName)
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@'%@'",YAHOO_CITY_NAME_TO_WOEID,[cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:[cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"cityName"];
    
//    [AVCloud callFunctionInBackground:@"get_woeid_from_city_name" withParameters:params block:^(id object, NSError *error) {
//        if (object && !error)
//        {
//            if (resultBlock)
//            {
//                resultBlock([self _createWoeidFormResult:object],error);
//            }
//        }
//        else
//        {
//            if (resultBlock)
//            {
//                resultBlock(nil,error);
//            }
//        }
//    }];
    
    [self _requestWithUrl:urlStr timeOut:REQUEST_DEFAULE_TIME_OUT block:^(NSDictionary *dict, NSError *error) {
        
        if (dict && !error)
        {
            if (resultBlock)
            {
                resultBlock([self _createWoeidFormResult:dict],error);
            }
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(nil,error);
            }
        }
    }];
}

- (NSMutableArray *)_createWoeidFormResult:(NSDictionary *)dict
{
    
    //            NSMutableArray *woeids = [NSMutableArray array];
    //            NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *resultInfo = [NSMutableArray array];
    if ([dict isKindOfClass:[NSDictionary class]])
    {
        NSArray *plases = [dict valueForKeyPath:@"query.results.place"];
        
        if ([plases isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *plase in plases)
            {
                if ([plase isKindOfClass:[NSDictionary class]])
                {
                    NSString *name = [plase valueForKeyPath:@"name.text"];
                    NSString *country = [plase valueForKeyPath:@"country.text"];
                    NSString *woeid = [NSString stringWithFormat:@"%@",[plase valueForKeyPath:@"woeid.text"]];
                    
                    //                            [names addObject:[NSString stringWithFormat:@"%@,%@",name,country]];
                    
                    //                            [woeids addObject:woeid];
                    
                    [resultInfo addObject:@{@"name":name,@"country":country,@"woeid":woeid}];
                }
            }
        }
        else if ([plases isKindOfClass:[NSDictionary class]])
        {
            NSString *name = [plases valueForKeyPath:@"name.text"];
            NSString *country = [plases valueForKeyPath:@"country.text"];
            NSString *woeid = [NSString stringWithFormat:@"%@",[plases valueForKeyPath:@"woeid.text"]];
            
            //                            [names addObject:[NSString stringWithFormat:@"%@,%@",name,country]];
            
            //                            [woeids addObject:woeid];
            
            [resultInfo addObject:@{@"name":name,@"country":country,@"woeid":woeid}];
        }
        
        //                [self translateToCN:str];
        
        return resultInfo;
    }
    else
    {
        return nil;
    }
    
}

- (void)getPM25WithCityName:(NSString *)cityName block:(AVIntegerResultBlock)resultBlock
{
    AVQuery *aqiQ = [AVQuery queryWithClassName:@"AirQualityIndex"];
    [aqiQ whereKey:@"area" equalTo:cityName];
    [aqiQ orderByDescending:@"createdAt"];
    aqiQ.limit = 10;
    [aqiQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error && objects && objects.count) {
            NSMutableArray *aqis = [NSMutableArray array];
            for (AVObject *obj in objects) {
                if ([obj objectForKey:@"createdAt"]>=[objects[0] objectForKey:@"createdAt"]) {
                    [aqis addObject:obj];
                }
            }
            
            int pm25 = 0;
            for (AirQualityIndex *temAqi in aqis) {
                pm25+=temAqi.pm2_5;
            }
            pm25/=aqis.count;
            
            if (resultBlock) {
                resultBlock(pm25,nil);
            }
        }
        else
        {
            if (resultBlock) {
                resultBlock(0,error);
            }
        }
    }];
}

- (void)getAQIWithCityName:(NSString *)cityName block:(AVIntegerResultBlock)resultBlock
{
    AVQuery *aqiQ = [AVQuery queryWithClassName:@"AirQualityIndex"];
    [aqiQ whereKey:@"area" equalTo:cityName];
    [aqiQ orderByDescending:@"createdAt"];
    aqiQ.limit = 10;
    [aqiQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error && objects && objects.count) {
            NSMutableArray *aqis = [NSMutableArray array];
            for (AVObject *obj in objects) {
                if ([obj objectForKey:@"createdAt"]>=[objects[0] objectForKey:@"createdAt"]) {
                    [aqis addObject:obj];
                }
            }
            
            int aqi = 0;
            for (AirQualityIndex *temAqi in aqis) {
                aqi+=temAqi.aqi;
            }
            aqi/=aqis.count;
            
            if (resultBlock) {
                resultBlock(aqi,nil);
            }
        }
        else
        {
            if (resultBlock) {
                resultBlock(0,error);
            }
        }
    }];
}


- (void)getWeatherWithWoeid:(NSString *)woeid block:(void(^)(WeatherInfo *weatherInfo,NSError *error))resultBlock
{
    if (!woeid)
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@w=%@&u=c",YAHOO_BASIC_WEATHER,woeid];
    
    [self _requestWithUrl:urlStr timeOut:REQUEST_DEFAULE_TIME_OUT block:^(NSDictionary *dict, NSError *error) {
        
        if (dict && !error)
        {
            WeatherInfo * weatherInfo = [WeatherInfo object];
            
            weatherInfo.weathers = [NSMutableArray array];
            
            //当前天气
            NSDictionary *condition = [dict valueForKeyPath:@"rss.channel.item.yweather:condition"];
            if ([condition isKindOfClass:[NSDictionary class]])
            {
                WeatherCode code = [[condition valueForKey:@"code"] intValue];
                
                NSString *dateStr = [condition valueForKey:@"date"];
                
                //                dateStr = @"Tue, 17 Dec 2013 11:59 am PST";
                
                NSDate *date = nil;
                
                if ([dateStr isKindOfClass:[NSString class]])
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    //                    NSString *timeZoneName = [dateStr substringFromIndex:dateStr.length-3];
                    //
                    //                    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
                    
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy K:mm a z"];
                    [dateFormatter setDateFormat:@"ccc, dd LLL yyyy k:mm a z"];
                    
                    date = [dateFormatter dateFromString:dateStr];
                }
                
                int temp = [[condition valueForKey:@"temp"] intValue];
                
                Weather *todayWeather = [Weather object];
                todayWeather.weatherCode = code;
                todayWeather.date = date;
                todayWeather.temperature = temp;
                [weatherInfo.weathers addObject:todayWeather];
                
            }
            
            //天气预报
            NSArray *forecast = [dict valueForKeyPath:@"rss.channel.item.yweather:forecast"];
            if ([forecast isKindOfClass:[NSArray class]])
            {
                for (int i=0; i<forecast.count; ++i)
                {
                    NSDictionary *weatherData = forecast[i];
                    if ([weatherData isKindOfClass:[NSDictionary class]])
                    {
                        WeatherCode code = [[weatherData valueForKey:@"code"] intValue];
                        NSString *dateStr = [weatherData valueForKey:@"date"];
                        NSDate *date = nil;
                        
                        if ([dateStr isKindOfClass:[NSString class]])
                        {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            
                            NSString *timeZoneName = [dateStr substringFromIndex:dateStr.length-3];
                            
                            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
                            
                            [dateFormatter setDateFormat:@"d MMM yyyy"];
                            
                            date = [dateFormatter dateFromString:dateStr];
                        }
                        
                        int high = [[weatherData valueForKey:@"high"] intValue];
                        int low = [[weatherData valueForKey:@"low"] intValue];
                        
                        Weather *forecastWeather = [Weather object];
                        forecastWeather.weatherCode = code;
                        forecastWeather.date = date;
                        forecastWeather.high = high;
                        forecastWeather.low = low;
                        [weatherInfo.weathers addObject:forecastWeather];
                    }
                }
            }
            
            
            
            //湿度
            NSDictionary *atmosphere = [dict valueForKeyPath:@"rss.channel.yweather:atmosphere"];
            if ([atmosphere isKindOfClass:[NSDictionary class]])
            {
                int humidity = [[atmosphere valueForKey:@"humidity"] intValue]; //湿度
                float pressure = [[atmosphere valueForKey:@"pressure"] floatValue]; //气压
                float visibility = [[atmosphere valueForKey:@"visibility"] floatValue];//能见度 km
                int rising = [[atmosphere valueForKey:@"humidity"] intValue]; //气压状态:稳定0 上升1 下降2
                weatherInfo.humidity = humidity;
                weatherInfo.pressure = pressure;
                weatherInfo.visibility = visibility;
                weatherInfo.rising = rising;
            }
            
            //单位
            NSDictionary *units = [dict valueForKeyPath:@"rss.channel.yweather:units"];
            if ([units isKindOfClass:[NSDictionary class]])
            {
                NSString *distance = [units valueForKey:@"humidity"]; //距离 km;
                NSString *pressure = [units valueForKey:@"pressure"]; // 压力 mb;
                NSString *speed = [units valueForKey:@"speed"]; //速度 km/h
                NSString *temperature = [units valueForKey:@"temperature"]; //温度 C;
                weatherInfo.distanceUnit = distance;
                weatherInfo.pressureUnit = pressure;
                weatherInfo.speedUnit = speed;
                weatherInfo.temperatureUnit = temperature;
            }
            
            //风
            NSDictionary *wind = [dict valueForKeyPath:@"rss.channel.yweather:wind"];
            if ([wind isKindOfClass:[NSDictionary class]])
            {
                int chill = [[wind valueForKey:@"chill"] intValue]; //寒意 11;
                int direction = [[wind valueForKey:@"direction"] intValue]; //方向 300;
                float speed = [[wind valueForKey:@"speed"] floatValue]; //风速 4.83";
                weatherInfo.chill = chill;
                weatherInfo.direction = direction;
                weatherInfo.speed = speed;
            }
            
            if (resultBlock)
            {
                resultBlock(weatherInfo,error);
            }
            
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(nil,error);
            }
        }
    }];
}

//通用天气请求
- (void)_requestWithUrl:(NSString *)theUrlStr timeOut:(NSTimeInterval)timeout block:(AVDictionaryResultBlock)resultBlock
{
    

    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:theUrlStr]];
    
    if (timeout)
    {
        request.timeOutSeconds = timeout;
    }
    else
    {
        request.timeOutSeconds = REQUEST_DEFAULE_TIME_OUT;
    }
    
//    request.numberOfTimesToRetryOnTimeout = 100;
    request.validatesSecureCertificate = NO;
    
    [request setCompletionBlock:^{
        
        //JSON
        NSDictionary *resultInfo = [request.responseString objectFromJSONString];
        if (!resultInfo)
        {
            //XML
            NSError *error = nil;
            
            NSData *responseData = request.responseData;
            
            resultInfo = [XMLReader dictionaryForXMLData:responseData error:&error];
        }
        //        NSLog(@"request.response=%@",resultInfo);
        
        if (resultBlock)
        {
            resultBlock(resultInfo,nil);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"request.error=%@",request.error);
        if (resultBlock)
        {
            resultBlock(nil,request.error);
        }
    }];
    
    //    [request startAsynchronous];
    [self.queue addOperation:request];
}

@end
