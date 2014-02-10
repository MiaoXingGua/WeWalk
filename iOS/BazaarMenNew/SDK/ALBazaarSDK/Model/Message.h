//
//  Message.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Content;

@interface Message : AVObject <AVSubclassing>

@property (nonatomic, retain) AVUser *fromUser;

@property (nonatomic, retain) AVUser *toUser;

@property (nonatomic, retain) Content *content;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, assign) BOOL isDelete;

@end
