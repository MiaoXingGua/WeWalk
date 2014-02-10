//
//  ALBazaarEngine.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-17.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBazaarConfig.h"

@interface ALBazaarEngine : NSObject

@property (nonatomic, readonly) User *user;

+ (instancetype)defauleEngine;

- (void)cancelAll;

#pragma mark - 注册登录
/**
 *
 *  手动登录
 *  @param   username    用户名
 *  @param   password    密码
 *
 */
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                    block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  手动注册
 *  @param   username    用户名
 *  @param   password    密码
 */
- (void)signUpWithUsername:(NSString *)theUsername
                  password:(NSString *)thePassword
                     block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  登出
 */
- (void)logOut;

/**
 *  是否已登录
 */
- (BOOL)isLoggedIn;


#pragma mark - 用户资料
/**
 *
 *  完善个人资料
 *  @param   theHeadViewFile        头像
 *  @param   theNickname            昵称
 *  @param   theGender              性别
 *  @param   theBackgroundViewFile  背景图
 *  @param   theCity                城市
 *  @param   resultBlock            回调
 */
- (void)updateUserInfoWithHeadView:(AVFile *)theHeadViewFile
                          nickname:(NSString *)theNickname
                            gender:(BOOL)theGender
                    backgroundView:(AVFile *)theBackgroundViewFile
                              city:(NSString *)theCity
                             block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  是否已完善个人资料
 */
- (BOOL)isCompleteSignUp;

#pragma mark - 用户关系
/**
 *
 *  关注用户
 *  @param   theUser        用户
 *  @param   resultBlock    回调
 */
- (void)addFriendWithUser:(User *)theUser
                    block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  解除关注
 *  @param   theUser        用户
 *  @param   resultBlock    回调
 */
- (void)removeFriendWithUser:(User *)theUser
                       block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  我关注的人
 *  @param   resultBlock    回调
 */
- (void)getFriendListWithBlock:(AVArrayResultBlock)resultBlock;

/**
 *
 *  我关注的人数
 *  @param   resultBlock    回调
 */
- (void)getFriendCountWithBlock:(AVIntegerResultBlock)resultBlock;

/**
 *
 *  我的粉丝
 *  @param   resultBlock    回调
 */
- (void)getFollowListWithBlock:(AVArrayResultBlock)resultBlock;

/**
 *
 *  我的粉丝数
 *  @param   resultBlock    回调
 */
- (void)getFollowCountWithBlock:(AVIntegerResultBlock)resultBlock;

#pragma mark - 设备
/**
 *
 *  添加设备绑定
 */
- (void)bindingUser;

/**
 *
 *  解除设备绑定
 */
- (void)unbindingUser;

#pragma mark - 手机认证
/**
 *
 *  发送认证码
 *  @param   thePhoneNumber     手机号
 *  @param   resultBlock        回调
 */
- (void)postPhoneAuthenticationMessageWithPhone:(NSString *)thePhoneNumber
                                          block:(AVBooleanResultBlock)resultBlock;

/**
 *
 *  输入认证码
 *  @param   theAuthentNumber       验证码
 *  @param   resultBlock            回调
 */
- (void)authenticationPhoneWithNumber:(NSString *)theAuthentNumber
                                block:(AVBooleanResultBlock)resultBlock;

#pragma mark - 第三方帐号
/**
 *
 *  绑定已有帐号
 *  @param   theTokenType   绑定帐号类型
 *  @param   resultBlock    回调
 */
//- (void)bindingOldAccountsWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                                        block:(PFBooleanResultBlock)resultBlock;

//绑定新账号
//- (void)bindingNewAccountsWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                                        block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  解除绑定
 *  @param   theTokenType   绑定帐号类型
 *  @param   resultBlock    回调
 */
//- (void)unbindingWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                               block:(PFBooleanResultBlock)resultBlock;

/**
 *
 *  第三方登录
 *  @param   theTokenType   绑定帐号类型
 *  @param   resultBlock    回调
 */
//- (void)logInWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                           block:(PFUserResultBlock)resultBlock;

/**
 *
 *  是否已经绑定了
 *  @param   theTokenType   绑定帐号类型
 *  @param   resultBlock    回调
 */
//- (void)isBindingWIthAccessTokenType:(AVOSCloudSNSType)theTokenType
//                               block:(AVBooleanResultBlock)resultBlock;

#pragma mark - 消息

/**
 *
 *  发私信
 *  @param   theText        文字内容
 *  @param   theVoiceFile   声音内容
 *  @param   theURL         链接地址（暂无作用）
 *  @param   resultBlock    回调
 */
- (void)postMessageWithText:(NSString *)theText
                      voice:(AVFile *)theVoiceFile
                        URL:(NSString *)theURL
                     toUser:(User *)theUser
                      block:(void (^)(BOOL succeeded, NSError *error))resultBlock;

/**
 *
 *  更改会话中未读状态为已读
 *  @param   theUser        会话的对象
 *  @param   resultBlock    回调
 */
- (void)updateUnreadStateOfUser:(User *)theUser
                          block:(void (^)(BOOL succeeded, NSError *error))resultBlock;

/**
 *
 *  获得全部未读的聊天记录数
 */
- (void)getALLUnreadMessageCountWithBlock:(void(^)(NSInteger messagesCount, NSError *error))resultBlock;


/**
 *
 *  获得全部未读的聊天记录数(具体到人)
 */
- (void)getALLUnreadMessageCountAboutUserWithBlock:(void(^)(NSArray *messagesCount, NSError *error))resultBlock;

/**
 *
 *  获取与某用户的聊天记录
 *  @param   theUser            会话的对象
 *  @param   theLimit           返回条数
 *  @param   theLessThanDate    返回的时间节点（只返回时间点之前的）
 *  @param   resultBlock        回调
 */
- (void)getUserMessageWithUser:(User *)theUser
                         limit:(int)theLimit
                  lessThanDate:(NSDate *)theLessThanDate
                         block:(void (^)(NSArray *messages, NSError *error))resultBlock;

/**
 *
 *  获取与某用户的未读聊天记录
 *  @param   theUser            会话的对象
 *  @param   theLimit           返回条数
 *  @param   theLessThanDate    返回的时间节点（只返回时间点之前的）
 *  @param   resultBlock        回调
 */
- (void)getUserUnreadMessageWithUser:(User *)theUser
                               limit:(int)theLimit
                        lessThanDate:(NSDate *)theLessThanDate
                               block:(void (^)(NSArray *messages, NSError *error))resultBlock;

/**
 *
 *  获取最近联系人列表
 *  @param   resultBlock        回调
 */
- (void)getContactsWithblock:(void (^)(NSArray *likers, NSError *error))resultBlock;

/**
 *
 *  删除联系人（同时将所有该联系人的消息delete）
 *  @param   theUser            会话的对象
 *  @param   resultBlock        回调
 */
- (void)deleteContactsWithUser:(User *)theUser
                         block:(AVBooleanResultBlock)resultBlock;

#pragma mark - 日程

/**
 *
 *  创建日程
 *  @param   theDate            日程日期
 *  @param   theType            日程种类
 *  @param   theRemindDate      提醒时间
 *  @param   theWoeid           目的地woeid
 *  @param   thePlace           目的地城市名
 *  @param   theText            备注（文字）
 *  @param   theVoiceFile       备注（声音）
 *  @param   theURL             （）
 *  @param   resultBlock        回调
 */
- (void)createScheduleWithDate:(NSDate *)theDate
                       andType:(int)theType
                 andRemindDate:(NSDate *)theRemindDate
                      andWoeid:(NSString *)theWoeid
                      andPlace:(NSString *)thePlace
                          text:(NSString *)theText
                         voice:(AVFile *)theVoiceFile
                           URL:(NSString *)theURL
                         block:(AVBooleanResultBlock)resultBlock;

/**
 *
 *  查看全部日程
 */
- (void)getMyScheduleListWihtBlock:(AVArrayResultBlock)resultBlock;

/**
 *
 *  编辑日程
 *  @param   theSchedule        日程对象
 *  @param   theDate            日程日期
 *  @param   theType            日程种类
 *  @param   theRemindDate      提醒时间
 *  @param   theWoeid           目的地woeid
 *  @param   thePlace           目的地城市名
 *  @param   theText            备注（文字）
 *  @param   theVoiceFile       备注（声音）
 *  @param   theURL             （）
 *  @param   resultBlock        回调
 */
- (void)updateSchedule:(Schedule *)theSchedule
               andDate:(NSDate *)theDate
               andType:(int)theType
         andRemindDate:(NSDate *)theRemindDate
              andWoeid:(NSString *)theWoeid
              andPlace:(NSString *)thePlace
                  text:(NSString *)theText
                 voice:(AVFile *)theVoiceFile
                   URL:(NSString *)theURL
                 block:(AVBooleanResultBlock)resultBlock;

/**
 *
 *  删除日程
 *  @param   theSchedule        日程对象
 */
- (void)deleteSchedule:(Schedule *)theSchedule
                 block:(AVBooleanResultBlock)resultBlock;

#pragma mark - 照片

/**
 *
 *  上传街拍
 *  @param   theImageFiles      图片文件数组 AVFile 必须
 *  @param   theWeatherInfo     天气信息
 *  @param   theWoeid           目的地woeid
 *  @param   thePlace           目的地城市名
 *  @param   theText            备注（文字）
 *  @param   theVoiceFile       备注（声音）
 *  @param   theIsShareToSinaWeibo            日程种类
 *  @param   theIsShareToQQWeibo      提醒时间
 *  @param   theLatitude/theLongitude           坐标 必填
 */
- (void)postPhotoWithImage:(NSArray *)theImageFiles             //AVFile             //图片文件 必须
//               weatherInfo:(WeatherInfo *)theWeatherInfo        //天气信息 必须
               temperature:(int)theTemperature
               weatherCode:(int)theWeatherCode
                      text:(NSString *)theText                  //文字 选填
                     voice:(AVFile *)theVoiceFile               //声音 选填
        isShareToSinaWeibo:(BOOL)theIsShareToSinaWeibo          //是否同时分享到sina
          isShareToQQWeibo:(BOOL)theIsShareToQQWeibo            //是否同时分享到QQ
                  latitude:(CGFloat)theLatitude                 //坐标 必填
                 longitude:(CGFloat)theLongitude
                     place:(NSString *)thePlace
                     block:(AVBooleanResultBlock)resultBlock;

/**
 *
 * 查看用户的相册
 */
- (void)searchPhotoWithUser:(User *)theUser
                      limit:(int)theLimit                        //返回条数 0默认返回20
               lessThenDate:(NSDate *)theLessThenDate         //时间点
                      block:(AVArrayResultBlock)resultBlock;

/**
 *
 * 查看照片
 */
- (void)searchAllPhotoWithType:(int)theType //0.官方 1.最新街拍 2.最热街拍 3.附近街拍
                         limit:(int)theLimit                        //返回条数 0默认返回20
                      latitude:(CGFloat)theLatitude
                     longitude:(CGFloat)theLongitude
                  lessThenDate:(NSDate *)theLessThenDate         //时间点
                         block:(AVArrayResultBlock)resultBlock;

/**
 *
 * 查找某张图片（根据天气）
 */
- (void)getPhototWithTemperature:(int)theTemperature
                     weatherCode:(int)theWeatherCode
                      isOfficial:(BOOL)theIsOffical
                        latitude:(CGFloat)theLatitude
                       longitude:(CGFloat)theLongitude
                           block:(AVObjectResultBlock)resultBlock;

#pragma mark - 评论照片

/**
 *
 * 评论照片
 */
- (void)commentPhoto:(Photo *)thePhoto
                text:(NSString *)theText                  //文字 选填
               voice:(AVFile *)theVoiceFile               //声音 选填
               block:(AVBooleanResultBlock)resultBlock;

/**
 *
 *  查看照片评论
 */
- (void)getCommentListFromPhoto:(Photo *)thePhoto
                          limit:(int)theLimit                        //返回条数 0默认返回20
                   lessThenDate:(NSDate *)theLessThenDate         //时间点
                          block:(AVArrayResultBlock)resultBlock;

/**
 *
 *  查看照片评论数
 */
- (void)getCommentCountFromPhoto:(Photo *)thePhoto
                           block:(AVIntegerResultBlock)resultBlock;

/**
 *
 *  查看我评论的照片
 */

/**
 *
 *  查看我评论的照片
 */


#pragma mark - 收藏照片
/**
 *
 *  收藏照片
 */
- (void)faviconPhoto:(Photo *)thePhoto
               block:(AVBooleanResultBlock)resultBlock;

/**
 *
 *  是否收藏过
 */
- (void)isMyFaviconPhotos:(NSArray *)photos
                    block:(AVArrayResultBlock)resultBlock;

/**
 *
 *  查看照片的收藏者
 */
- (void)searchFaviconUsersFromPhoto:(Photo *)thePhoto
                              limit:(int)theLimit                        //返回条数 0默认返回20
                       lessThenDate:(NSDate *)theLessThenDate         //时间点
                              block:(AVArrayResultBlock)resultBlock;
/**
 *
 * 查看照片的收藏者数
 */
- (void)searchFaviconUsersCountFromPhoto:(Photo *)thePhoto
                                   block:(AVIntegerResultBlock)resultBlock;

/**
 *
 *  查看我收藏的照片
 */
- (void)getMyFaviconPhotosWithLimit:(int)theLimit                        //返回条数 0默认返回20
                       lessThenDate:(NSDate *)theLessThenDate         //时间点
                              block:(AVArrayResultBlock)resultBlock;

/**
 *
 *  查看我收藏的照片数
 */
- (void)getMyFaviconPhotosCountWithBlock:(AVIntegerResultBlock)resultBlock;


#pragma mark - 打标
- (void)getOfficialPhotoWithSkip:(int)theSkip
                           block:(AVObjectResultBlock)resultBlcok;

- (void)getOfficialPhotoCountWithBlock:(AVIntegerResultBlock)resultBlcok;

- (void)updatePhoto:(Photo *)thePhoto
        temperature:(Temperature *)theTemperature
        weatherType:(WeatherType *)theWeatherType
              style:(NSString *)theStyle
        collocation:(NSArray *)theCollocation
              block:(AVBooleanResultBlock)resultBlock;

@end
