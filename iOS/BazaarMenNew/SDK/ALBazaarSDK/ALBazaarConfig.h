//
//  ALBazaarConfig.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-17.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#ifndef BAZAAR_PUSH_ALBazaarConfig_h
#define BAZAAR_PUSH_ALBazaarConfig_h

#import "AVRelation+AddUniqueObject.h"
#import <AVOSCloud/AVOSCloud.h>
//#import <AVOSCloudSNS/AVOSCloudSNS.h>
//#import <AVOSCloudSNS/AVUser+SNS.h>
//#import <ASIHTTPRequest/ASIHTTPRequest.h>
//#import <ASIHTTPRequest/ASINetworkQueue.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "XMLReader.h"

#import "Photo.h"
#import "Brand.h"
#import "Temperature.h"
#import "Comment.h"
#import "Content.h"
#import "WeatherType.h"
#import "User.h"
#import "Content.h"
#import "Schedule.h"
#import "Message.h"

#define DEFAULE_LIMITE 20

//请先登录
#define NOTIFICATION_PARSE_IS_NEED_LOGIN @"FBI72TG483TKUFK24RFGIL3RCDUD34FKU37GV4KYF873"

//登录成功
#define LOGIN_SUCCESS @"ILUDHF2DSFIOAFHIAUWFWAYEFBILUWYERO8732UYVFRU4"

#define ALERROR(_domain,_code,_error) !_error ? ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":[NSNull null]}]) : ([NSError errorWithDomain:_domain code:_code userInfo:@{@"code":[NSNumber numberWithInteger:_code],@"error":_error}])

#define ALDOMAIN @"cn.avoscloud.com"

#define ALCHECK_LOGIN(block) if (![self _checkLoggedInWithBlock:block]) return;

#define ALPHONE_CorpID @""
#define ALPHONE_Pwd @""

#define ERROR_CODE_OF_ALREADY_SUPPORT                           120001 //该用户已经赞过该帖
#define ERROR_CODE_OF_ALREADY_FAVICON                           120002 //该用户已经收藏该帖
#define ERROR_CODE_OF_CREDITS_IS_NOT_ENOUGH                     120003 //积分不足
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_THEAD_POSTUSER            120004 //你不是该帖子的作者
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_POST_POSTUSER             120005 //你不是该回复的作者
#define ERROR_CODE_OF_YOU_ARE_NOT_THE_COMMENT_POSTUSER          120006 //你不是该评论的作者
#define ERROR_CODE_OF_THE_POST_IS_NOT_IN_THE_THREAD             120007 //这个post不数据这个thread
#define ERROR_CODE_OF_THE_POST_IS_NOT_SUPPORT_YOUSELF_POST      120008 //您不能赞您自己发的回复
#define ERROR_CODE_OF_THE_THREAD_IS_NOT_EXIST                   120009 //此主题已不存在
#define ERROR_CODE_OF_THE_POST_IS_NOT_EXIST                     120010 //此回复已不存在
#define ERROR_CODE_OF_THE_POST_IS_NOT_COMMENT                   120011 //此评论已不存在
#define ERROR_CODE_OF_TOKEN_IS_EXIST                            120021 //token已经被使用

#define NSLOG_SUCCESS NSLog(@"success")
#define NSLOG_FAILE NSLog(@"faile")
#define NSLOG_ERRER NSLog(@"Error: %@ %@", error, [error userInfo])

#define USER_AVOS_STATUS YES

#endif
