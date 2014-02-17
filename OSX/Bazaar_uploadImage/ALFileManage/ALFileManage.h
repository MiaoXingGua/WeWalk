//
//  ALFileManage.h
//  BAZAAR_UPLOAD
//
//  Created by Albert on 14-1-23.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "ALFileItem.h"

@interface ALFileManage : NSObject

+ (instancetype)defaultManage;

//查询
- (NSArray *)scanDirectory:(NSString *)rootDir hasSuffix:(NSString *)aString recurse:(BOOL)isr;

//写入文件
- (BOOL)writeToPlist:(NSDictionary *)plistInfo ToPath:(NSString *)plistPath;

//上传
- (void)uploadWithPlistPath:(NSString *)plistPath finsh:(AVBooleanResultBlock)finshBlock;

@end
