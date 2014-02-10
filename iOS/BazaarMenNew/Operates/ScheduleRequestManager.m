//
//  ScheduleRequestManager.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-14.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ScheduleRequestManager.h"
#import "ALBazaarSDK.h"
#import "WeatherRequestManager.h"

static ScheduleRequestManager *schedule = nil;

@implementation ScheduleRequestManager
@synthesize scheduleArray = _scheduleArray;
@synthesize dateArray = _dateArray;
@synthesize requestSuccess;

+ (ScheduleRequestManager *)defaultManager
{
    if (schedule==nil)
    {
        schedule = [[ScheduleRequestManager alloc] init];
        schedule.scheduleArray = [NSMutableArray arrayWithCapacity:0];
        schedule.dateArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return schedule;
}

- (void)requestAllSchedule
{
    __block typeof(self) bself = self;

    [[ALBazaarEngine defauleEngine] getMyScheduleListWihtBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            bself.requestSuccess = YES;
            [bself.scheduleArray removeAllObjects];
            [bself.scheduleArray addObjectsFromArray:objects];
            
            [[WeatherRequestManager defaultManager] requestScheduleCityWeather];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:COMPLETEREFRESHSCHEDULE object:nil];

        }
        else
        {
            bself.requestSuccess = NO;
            
            [bself requestAllSchedule];
        }
        
        
    }];
}

@end
