//
//  Temperature.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Temperature : AVObject <AVSubclassing>

//最低温度
@property (nonatomic, assign) float minTemperture;

//最高温度
@property (nonatomic, assign) float maxTemperture;

//名字
@property (nonatomic, retain) NSString *name;//(非常热、热、常温、冷、非常冷) 

@end
