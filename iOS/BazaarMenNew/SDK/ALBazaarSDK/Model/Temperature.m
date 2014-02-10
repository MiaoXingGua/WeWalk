//
//  Temperature.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Temperature.h"

@implementation Temperature
@dynamic minTemperture;
@dynamic maxTemperture;
@dynamic name;

+ (NSString *)parseClassName
{
    return @"Temperature";
}

@end
