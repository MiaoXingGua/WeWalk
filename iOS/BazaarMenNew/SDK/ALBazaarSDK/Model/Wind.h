//
//  Wind.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-7.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Wind : AVObject <AVSubclassing>

//最低风速
@property (nonatomic, assign) float minWindSpeed;

//最高风速
@property (nonatomic, assign) float maxWindSpeed;

//名字
@property (nonatomic, retain) NSString *name;//(大风、有风、微风、无风)

@end
