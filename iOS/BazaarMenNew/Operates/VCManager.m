//
//  VCManager.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "VCManager.h"

static VCManager *vcmanage = nil;

@implementation VCManager
@synthesize homeVC;

+ (VCManager *)defaultManager
{
    if (vcmanage==nil)
    {
        vcmanage = [[VCManager alloc] init];
    }
    
    return vcmanage;
}


@end
