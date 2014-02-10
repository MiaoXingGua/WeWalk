//
//  VCManager.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"

@interface VCManager : NSObject
{
    
}

@property(nonatomic,strong)HomeViewController *homeVC;

+ (VCManager *)defaultManager;

@end
