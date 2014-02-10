//
//  WeatherType.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-9.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface WeatherType : AVObject <AVSubclassing>

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *yahooNameCN;

@property (nonatomic, retain) NSString *yahooNameUS;

@property (nonatomic, assign) int weatherCode;

@end
