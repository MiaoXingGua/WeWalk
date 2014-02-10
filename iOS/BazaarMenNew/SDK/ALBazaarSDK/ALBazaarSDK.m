//
//  ALBazaarSDK.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-17.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "ALBazaarSDK.h"

@implementation ALBazaarSDK

+ (void)registerLKSDK
{
    [Brand registerSubclass];
    [Comment registerSubclass];
    [Content registerSubclass];
    [Photo registerSubclass];
    [Temperature registerSubclass];
    [WeatherType registerSubclass];
    [User registerSubclass];
    [Message registerSubclass];
    [Schedule registerSubclass];
}

@end
