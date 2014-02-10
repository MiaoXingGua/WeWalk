//
//  Comment.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class Content;
@class Photo;

@interface Comment : AVObject <AVSubclassing>

@property (nonatomic, retain) AVUser *user;

@property (nonatomic, retain) Content *content;

@property (nonatomic, retain) Photo *photo;

@end
