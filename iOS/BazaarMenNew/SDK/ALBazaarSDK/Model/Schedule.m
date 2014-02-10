//
//  Schedule.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
@dynamic date;
@dynamic type;
@dynamic remindDate;
@dynamic woeid;
@dynamic place;
@dynamic user;
//@dynamic push;
@dynamic content;

+ (NSString *)parseClassName
{
    return @"Schedule";
}

@end
