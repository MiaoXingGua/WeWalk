//
//  SystemConfigManager.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemConfigManager : NSObject

@property(nonatomic,assign)BOOL systemVersion;

+ (SystemConfigManager *)defaultManager;

- (BOOL)isOrNotNetWorking;

@end
