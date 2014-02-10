//
//  Advertisement.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Advertisement : AVObject <AVSubclassing>

//文字描述 text (string)
@property (nonatomic, retain) NSString *text;

//连接 url
@property (nonatomic, retain) NSString *url;

@end
