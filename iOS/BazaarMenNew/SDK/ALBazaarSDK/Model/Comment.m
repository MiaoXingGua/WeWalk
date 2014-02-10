//
//  Comment.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@dynamic user;
@dynamic content;
@dynamic photo;

+ (NSString *)parseClassName
{
    return @"Comment";
}

@end
