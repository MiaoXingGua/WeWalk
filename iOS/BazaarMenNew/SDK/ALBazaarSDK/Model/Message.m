//
//  Message.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Message.h"

@implementation Message
@dynamic fromUser;
@dynamic toUser;
@dynamic content;
@dynamic isRead;
@dynamic isDelete;

+ (NSString *)parseClassName
{
    return @"Message";
}

@end
