//
//  Humidity.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-7.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Humidity : AVObject <AVSubclassing>

//最低湿度
@property (nonatomic, assign) float minHumidity;

//最高湿度
@property (nonatomic, assign) float maxHumidity;

//名字
@property (nonatomic, retain) NSString *name;//(大湿、湿、微湿、微干、干、非常干)

@end
