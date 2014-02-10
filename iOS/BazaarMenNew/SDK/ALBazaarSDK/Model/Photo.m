//
//  Photo.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@dynamic originalURL;
@dynamic thumbnailURL;
@dynamic width;
@dynamic height;
@dynamic content;
@dynamic brand;
@dynamic temperature;
@dynamic style;
@dynamic weatherType;
@dynamic location;
@dynamic user;
@dynamic faviconUsers;
@dynamic hot;
@dynamic isOfficial;
@dynamic coat;
@dynamic underwear;
@dynamic sweater;
@dynamic accessory;
@dynamic trousers;
@dynamic shoe;
@dynamic waistcoat;
@dynamic hoodies;
@dynamic weatherName;
@dynamic collocation;
@dynamic place;

+ (NSString *)parseClassName
{
    return @"Photo";
}

@end
