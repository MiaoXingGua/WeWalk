//
//  Content.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Content : AVObject <AVSubclassing>

@property (nonatomic, retain) NSString *text;

@property (nonatomic, retain) NSString *voiceURL;

@property (nonatomic, retain) NSString *URL;

@end
