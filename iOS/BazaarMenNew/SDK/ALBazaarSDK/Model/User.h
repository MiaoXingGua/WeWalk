//
//  User.h
//  ParseTest
//
//  Created by Jack on 13-5-30.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@class UserInfo;
@class UserCount;
//@class UserRelation;
@class UserFavicon;

//@class Friend;
//@class Follow;
//@class BanList;

@interface User : AVUser <AVSubclassing>

@property (nonatomic, retain) NSString *nickname;//昵称

@property (nonatomic, retain) NSString *largeHeadViewURL;//头像

@property (nonatomic, retain) NSString *smallHeadViewURL;//头像

//@property (nonatomic, retain) NSString *registerIp;//注册ip

@property (nonatomic, assign) BOOL gender;//性别

@property (nonatomic, assign) BOOL isCompleteSignUp;//完全注册

@property (nonatomic, retain) NSString *userKey;

@property (nonatomic, assign) BOOL isAdmin;//是否是管理员

//UserCount
@property (nonatomic, assign) NSInteger numberOfFollows;//粉丝数
@property (nonatomic, assign) NSInteger numberOfFriends;//关注数
@property (nonatomic, assign) NSInteger numberOfBanList;//黑名单数

@property (nonatomic, assign) NSInteger numberOfThreads;//发主题数
@property (nonatomic, assign) NSInteger numberOfPosts;//回答数
@property (nonatomic, assign) NSInteger numberOfComments;//评论数
@property (nonatomic, assign) NSInteger numberOfSupports;//赞数
@property (nonatomic, assign) NSInteger numberOfAbums;
@property (nonatomic, assign) NSInteger numberOfBestPosts;//最佳回答数
@property (nonatomic, assign) NSInteger numberOfFavicon;//收藏主题数


//UserRelation  用户关系
@property (nonatomic, readonly) AVRelation *friends;//Friend

@property (nonatomic, readonly) AVRelation *follows;//Follow

@property (nonatomic, readonly) AVRelation *banList;//BanList

@property (nonatomic, readonly) AVRelation *contacts;

//UserInfo
@property (nonatomic, retain) NSString *backgroundViewURL;//背景图

@property (nonatomic, retain) NSString *signature;//个性签名

@property (nonatomic, retain) NSString *city;//城市？？？

//UserFavicon
@property (nonatomic, readonly) AVRelation *faviconPhotos;

//@property (nonatomic, retain) NSString *SinaWeibo;
//@property (nonatomic, retain) NSString *QQWeibo;
//@property (nonatomic, retain) NSString *RenRen;
//@property (nonatomic, retain) NSString *WeChat;




@end

