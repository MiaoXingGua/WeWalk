//
//  ScheduleRequestManager.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-14.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleRequestManager : NSObject
{
    NSMutableArray *_scheduleArray;
    NSMutableArray *_dateArray;
}

@property(nonatomic,strong)NSMutableArray *scheduleArray;
@property(nonatomic,assign)BOOL requestSuccess;
@property(nonatomic,strong)NSMutableArray *dateArray;

+ (ScheduleRequestManager *)defaultManager;
- (void)requestAllSchedule;

@end
