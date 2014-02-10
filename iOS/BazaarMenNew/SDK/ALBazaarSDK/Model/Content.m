//
//  Content.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Content.h"

@implementation Content
@dynamic text;
@dynamic voiceURL;
@dynamic URL;

+ (NSString *)parseClassName
{
    return @"Content";
}

@end
