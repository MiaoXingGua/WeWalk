//
//  Schedule.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Content;

@interface Schedule : AVObject <AVSubclassing>

@property (nonatomic, retain) NSDate *date;

@property (nonatomic, assign) int type;

@property (nonatomic, retain) NSDate *remindDate;

@property (nonatomic, retain) NSString *woeid;

@property (nonatomic, retain) NSString *place;

@property (nonatomic, retain) AVUser *user;

//@property (nonatomic, retain) AVObject *push;

//@property (nonatomic, retain) NSString *pushId;

@property (nonatomic, retain) Content *content;
/*
 https://parse.com/docs/push_guide#scheduled/JavaScript
*/

@end
