//
//  ALBazaarEngine.m
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-17.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "ALBazaarEngine.h"
#import "ALNotificationSDK.h"

static ALBazaarEngine *engine = nil;

@interface ALBazaarEngine()
@property (nonatomic ,strong) ASINetworkQueue *queue;
@property (nonatomic, strong) NSMutableData *webData;
@end

@implementation ALBazaarEngine

#pragma mark - 初始化
+ (ALBazaarEngine *)defauleEngine
{
    if (!engine)
    {
        engine = [[ALBazaarEngine alloc] init];
        engine.queue = [ASINetworkQueue queue];
        [engine.queue go];
//        engine.errorCode = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ErrorCode" ofType:@"plist"]] valueForKey:ERROR_CODE_KEY];
    }
    return engine;
}



#pragma mark - 通用
- (void)_addLimit:(int)theLimit
     lessThenDate:(NSDate *)theLessThenDate
         toParams:(NSMutableDictionary *)params
{
    if (theLimit)
    {
        [params setValue:[NSNumber numberWithInt:abs(theLimit)] forKey:@"limit"];
    }
    else
    {
        [params setValue:[NSNumber numberWithInt:DEFAULE_LIMITE] forKey:@"limit"];
    }
    
    if (theLessThenDate)
    {
        NSDateFormatter *fomater=[[NSDateFormatter alloc] init];
        [fomater setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
        NSString *theLessThenDateSTR = [fomater stringFromDate:theLessThenDate];
        
        [params setValue:theLessThenDateSTR forKey:@"lessThenDateStr"];
    }
}

- (void)_addLimit:(int)theLimit
     lessThenDate:(NSDate *)theLessThenDate
          toQuery:(AVQuery *)query
{
    if (theLimit)
    {
        query.limit = theLimit;
    }
    else
    {
        query.limit = DEFAULE_LIMITE;
    }
    
    if (theLessThenDate)
    {
        [query whereKey:@"createdAt" lessThan:theLessThenDate];
    }
    [query orderByDescending:@"createdAt"];
}

- (void)_includeKeyWithComment:(AVQuery *)commentQuery
{
    [commentQuery includeKey:@"user"];
    [commentQuery includeKey:@"content"];
    [commentQuery includeKey:@"photo"];
}

- (void)_includeKeyWithMessage:(AVQuery *)messageQuery
{
    [messageQuery includeKey:@"fromUser"];
    [messageQuery includeKey:@"toUser"];
    [messageQuery includeKey:@"content"];
}

- (void)_includeKeyWithUser:(AVQuery *)userQ
{
    [userQ includeKey:@"headView"];
    [userQ includeKey:@"userInfo"];
    [userQ includeKey:@"userCount"];
    [userQ includeKey:@"userFavicon"];
}

- (void)_includeKeyWithPhoto:(AVQuery *)photoQuery
{
    [photoQuery includeKey:@"content"];
    [photoQuery includeKey:@"brand"];
    [photoQuery includeKey:@"temperature"];
    [photoQuery includeKey:@"user"];
}

- (void)_includeKeyWithSchedule:(AVQuery *)scheduleQuery
{
    [scheduleQuery includeKey:@"content"];
    [scheduleQuery includeKey:@"push"];
    [scheduleQuery includeKey:@"user"];
}

//通用天气请求
- (void)_requestWithUrl:(NSString *)theUrlStr timeOut:(NSTimeInterval)timeout block:(AVDictionaryResultBlock)resultBlock
{
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:theUrlStr]];
    
    if (timeout)
    {
        request.timeOutSeconds = timeout;
    }
    else
    {
        request.timeOutSeconds = REQUEST_DEFAULE_TIME_OUT;
    }
    
    //    request.numberOfTimesToRetryOnTimeout = 100;
    request.validatesSecureCertificate = NO;
    
    [request setCompletionBlock:^{
        
        //JSON
        NSDictionary *resultInfo = [request.responseString objectFromJSONString];
        if (!resultInfo)
        {
            //XML
            NSError *error = nil;
            
            NSData *responseData = request.responseData;
            
            resultInfo = [XMLReader dictionaryForXMLData:responseData error:&error];
        }
        //        NSLog(@"request.response=%@",resultInfo);
        
        if (resultBlock)
        {
            resultBlock(resultInfo,nil);
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"request.error=%@",request.error);
        if (resultBlock)
        {
            resultBlock(nil,request.error);
        }
    }];
    
    //    [request startAsynchronous];
    [self.queue addOperation:request];
}

- (NSString *)guid
{
    CFUUIDRef identifier = CFUUIDCreate(NULL);
    NSString* identifierString = (NSString*)CFBridgingRelease(CFUUIDCreateString(NULL, identifier));
    CFRelease(identifier);
    return identifierString;
}

#pragma mark - 用户
- (User *)user
{
    return (User *)[User currentUser];
}

//是否已登录
- (BOOL)isLoggedIn
{
    return [User currentUser].isAuthenticated && self.user;
}

- (BOOL)_checkLoggedIn
{
    if (![self isLoggedIn])
    {
        NSLog(@"请先登录！！！");
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PARSE_IS_NEED_LOGIN object:nil];
        
        return NO;
    }
    else
    {
        return YES;
    }
}



#pragma mark - 注册登录
//手动登录
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                    block:(PFBooleanResultBlock)resultBlock
{
    __block typeof (self) bself = self;
    
    [User logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        
        //        NSDictionary *authData = [user objectForKey:@"authData"];
        //        if ([authData valueForKey:@"qq"])
        //        {
        //            [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        //                [[AVUser currentUser] addAuthData:object block:^(AVUser *user, NSError *error) {
        //                    if (user && !error)
        //                    {
        //                        NSLog(@"qq登录成功！");
        //                    }
        //                    else
        //                    {
        //                        NSLog(@"qq登录失败！");
        //                    }
        //                }];
        //            } toPlatform:AVOSCloudSNSQQ];
        //        }
        //        else if ([authData valueForKey:@"weibo"])
        //        {
        //            [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
        //                [[AVUser currentUser] addAuthData:object block:^(AVUser *user, NSError *error) {
        //                    if (user && !error)
        //                    {
        //                        NSLog(@"weibo登录成功！");
        //                    }
        //                    else
        //                    {
        //                        NSLog(@"weibo登录失败！");
        //                    }
        //                }];
        //            } toPlatform:AVOSCloudSNSSinaWeibo];
        //        }
        
        if (user && !error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:bself userInfo:nil];
            
            [self bindingUser];
        }
        
        if (resultBlock)
        {
            resultBlock(user!=nil,error);
        }
        
    }];
}

//手动注册
- (void)signUpWithUsername:(NSString *)theUsername
                  password:(NSString *)thePassword
                     block:(PFBooleanResultBlock)resultBlock
{
    if ([self _checkLoggedIn])
    {
        [User logOut];
    }
    
//    __block typeof (self) bself = self;
    
    User *user = [User user];
    user.username = theUsername;
    user.password = thePassword;
    [user signUpInBackgroundWithBlock:resultBlock];
}

//登出
- (void)logOut
{
    [User logOut];
    //    [self unbindingUser];
//    [AVOSCloudSNS logout:AVOSCloudSNSSinaWeibo];
//    [AVOSCloudSNS logout:AVOSCloudSNSQQ];
}


#pragma mark - 绑定设备
//添加设备绑定
- (void)bindingUser
{
    [[AVInstallation currentInstallation] setObject:self.user forKey:@"user"];
    [[AVInstallation currentInstallation] saveEventually];
}

//解除设备绑定
- (void)unbindingUser
{
    [[AVInstallation currentInstallation] removeObjectForKey:@"user"];
    [[AVInstallation currentInstallation] saveEventually];
}

#pragma mark - 手机认证
//发送认证码
- (void)postPhoneAuthenticationMessageWithPhone:(NSString *)thePhoneNumber
                                          block:(AVBooleanResultBlock)resultBlock
{
    
    //    'CorpID'=>$uid,
    //    'Pwd'=>$passwd,
    //    'Mobile'=>$telphone,
    //    'Content'=>$message,
    //    'Cell'=>'',
    //    'SendTime'=>''
    
    NSString *xmlStr = [NSString stringWithFormat:
                        @"<?xml version=\"1.0\"?>"
                        "<Request>"
                        "<Header AllianceID=\"%@\" SID=\"%@\" TimeStamp=\"%@\"  RequestType=\"%@\" Signature=\"%@\" />"
                        "<DomesticHotelListRequest>"
                        "<CityID>%@</CityID>"//城市ID(必填)
                        "<CheckInDate>%@</CheckInDate>"//入住日期
                        "<CheckOutDate>%@</CheckOutDate>"//离店时间
                        "%@"//酒店名称（模糊查询）
                        "<PageSize>20</PageSize>"//请求条数
                        "<PageNumber>%@</PageNumber>"//请求的页码
                        "<StarList>%@</StarList>"//酒店星级列表
                        "<LowPrice>%@</LowPrice>"//最低价
                        "<HighPrice>%@</HighPrice>"//最高价
                        "<OrderName>%@</OrderName>"//排序字段,默认携程推荐
                        /*
                         Recommend：推荐级别排序
                         Star：星级排序
                         Price：价格排序        MinPrice：按照起价排序
                         HRatingOverall：酒店点评分
                         Distance：按照距离排序
                         CustomerEval：客户点评分
                         PriceRate：价格折扣
                         PreferentialPrice：优惠价(门市价-均价)
                         */
                        "<OrderType>%@</OrderType>"//升降顺序，ASC/DESC
                        //                  "<PriceType>FG</PriceType>"//价格类型，FG为只显示现付价格;PP为只显示预付价格
                        "</DomesticHotelListRequest>"
                        "</Request>"];
    //服务器不认ios发的<>
    xmlStr = (NSMutableString*)[xmlStr stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    xmlStr = (NSMutableString*)[xmlStr stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
							 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
							 "<soap:Body>"
							 "<Request xmlns=\"http://ctrip.com/\">"
							 "<requestXML>"
                             "%@"
                             "</requestXML>"
                             "</Request>"
							 "</soap:Body>"
							 "</soap:Envelope>",xmlStr
							 ];
    
    //请求发送到的路径
	NSString *urlStr = @"http://qxt.ccme.cc/ws/LinkWS.asmx?wsdl";
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://ctrip.com/Request" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    //请求
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	//如果连接已经建好，则初始化data
	if( theConnection )
	{
		self.webData = [NSMutableData data];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
}

//输入认证码
- (void)authenticationPhoneWithNumber:(NSString *)theAuthentNumber
                                block:(AVBooleanResultBlock)resultBlock
{
    
}

#pragma mark - URLConnection代理

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.webData setLength: 0];
	NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.webData appendData:data];
	NSLog(@"connection: didReceiveData:2");
}

//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *retDict = [XMLReader dictionaryForXMLData:self.webData error:&error];
    if (error)
    {
//        self.soapResultBlock(nil,error);
    }
    else
    {
        //        NSLog(@"first:%@",retDict);
        NSString *requestResult = [retDict valueForKeyPath:@"soap:Envelope.soap:Body.RequestResponse.RequestResult.text"];
        NSDictionary *requestDict = [XMLReader dictionaryForXMLString:requestResult error:&error];
        //        NSLog(@"requestDict:%@",requestDict);
        //        NSLog(@"request = %@",[requestDict valueForKeyPath:@"Response.Header.ResultMsg"]);
        
        
//        if (error)
//        {
//            self.soapResultBlock(nil,error);
//        }
//        else
//        {
//            self.soapResultBlock([requestDict valueForKey:@"Response"],error);
//        }
    }
}

#pragma mark - 第三方帐号
//绑定已有帐号
//- (void)bindingOldAccountsWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                                        block:(PFBooleanResultBlock)resultBlock
//{
//    if (![self _checkLoggedIn]) {
//        if (resultBlock) {
//            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
//        }
//        return;
//    }
//    
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        [self.user addAuthData:object block:^(AVUser *user, NSError *error) {
//            if (resultBlock) {
//                resultBlock(user!=nil,error);
//            }
//        }];
//    } toPlatform:theTokenType];
//}

//绑定新账号
//- (void)bindingNewAccountsWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                                        block:(PFBooleanResultBlock)resultBlock
//{
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        [AVUser loginWithAuthData:object block:^(AVUser *user, NSError *error) {
//            if (resultBlock) {
//                resultBlock(user!=nil,error);
//            }
//        }];
//    } toPlatform:theTokenType];
//}

//解除绑定
//- (void)unbindingWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                               block:(PFBooleanResultBlock)resultBlock
//{
//    if (![self _checkLoggedIn]) {
//        if (resultBlock) {
//            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
//        }
//        return;
//    }
//    
//    [self.user deleteAuthForPlatform:theTokenType block:^(AVUser *user, NSError *error) {
//        if (resultBlock) {
//            resultBlock(user!=nil,error);
//        }
//    }];
//}

//第三方登录
//- (void)logInWithAccessTokenType:(AVOSCloudSNSType)theTokenType
//                           block:(PFUserResultBlock)resultBlock
//{
//    [AVUser logOut];
//    
//    [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
//        [AVUser loginWithAuthData:object block:^(AVUser *user, NSError *error) {
//            if (resultBlock) {
//                resultBlock(user,error);
//            }
//        }];
//    } toPlatform:theTokenType];
//}

//是否已经绑定了
//- (void)isBindingWIthAccessTokenType:(AVOSCloudSNSType)theTokenType
//                               block:(AVBooleanResultBlock)resultBlock
//{
//    if (![self _checkLoggedIn]) {
//        if (resultBlock) {
//            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
//        }
//        return;
//    }
//    //    __block typeof (self) bself = self;
//    [self.user fetchInBackgroundWithKeys:@[@"authData"] block:^(AVObject *object, NSError *error) {
//        
//        NSDictionary *authData = [object objectForKey:@"authData"];
//        if (!authData)
//        {
//            if (resultBlock) {
//                resultBlock(NO,ALERROR(ALDOMAIN, 12300, @"没有绑定任何第三方"));
//            }
//        }
//        else if (theTokenType == AVOSCloudSNSQQ)
//        {
//            if ([authData valueForKey:@"weibo"])
//            {
//                if (resultBlock) {
//                    resultBlock(YES,ALERROR(ALDOMAIN, 12311, @"绑定了weibo"));
//                }
//            }
//            else
//            {
//                if (resultBlock) {
//                    resultBlock(NO,ALERROR(ALDOMAIN, 12310, @"没有绑定weibo"));
//                }
//            }
//        }
//        else if (theTokenType == AVOSCloudSNSSinaWeibo)
//        {
//            if ([authData valueForKey:@"qq"])
//            {
//                if (resultBlock) {
//                    resultBlock(YES,ALERROR(ALDOMAIN, 12321, @"绑定了QQ"));
//                }
//            }
//            else
//            {
//                if (resultBlock) {
//                    resultBlock(NO,ALERROR(ALDOMAIN, 12320, @"没有绑定QQ"));
//                }
//            }
//        }
//        else
//        {
//            if (resultBlock) {
//                resultBlock(NO,ALERROR(ALDOMAIN, 22222, @"未知错误"));
//            }
//        }
//    }];
//}


#pragma mark - 用户资料

//更新用户资料
- (void)updateUserInfoWithHeadView:(AVFile *)theHeadViewFile
                          nickname:(NSString *)theNickname
                            gender:(BOOL)theGender
                    backgroundView:(AVFile *)theBackgroundViewFile
                              city:(NSString *)theCity
                             block:(PFBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    __block typeof (self) bself = self;

//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (theHeadViewFile)
    {
        __block AVFile *__theHeadViewFile = theHeadViewFile;
        if (!theHeadViewFile.objectId)
        {
            [theHeadViewFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [bself updateUserInfoWithHeadView:__theHeadViewFile nickname:theNickname gender:theGender backgroundView:theBackgroundViewFile city:theCity block:resultBlock];
            }];
            return;
        }
        //        [self.user setObject:theHeadView forKey:@"headView"];
//        else
//        {
//            [params setValue:theHeadViewFile.url forKey:@"headViewURL"];
//            
//            //            __block AVFile *file = [AVFile fileWithURL:[theHeadViewFile.url stringByAppendingString:@"?imageMogr/auto-orient/thumbnail/100x100"]];
//            //            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            //                if (succeeded && !error) {
//            //
//            //                }
//            //            }];
//        }
    }
    
    
    if (theBackgroundViewFile)
    {
        __block AVFile *__theBackgroundViewFile = theBackgroundViewFile;
        if (!theBackgroundViewFile.objectId)
        {
            [theBackgroundViewFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [bself updateUserInfoWithHeadView:theHeadViewFile nickname:theNickname gender:theGender backgroundView:__theBackgroundViewFile city:theCity block:resultBlock];
            }];
            
            return;
        }
        //        [self.user setObject:theBackgroundView forKey:@"backgroundView"];
//        else
//        {
//            [params setValue:theBackgroundViewFile.url forKey:@"backgroundViewURL"];
//        }
    }
    
//    if (theNickname) [params setValue:theNickname forKey:@"nickname"];
    
//    if (theCity) [params setValue:theCity forKey:@"city"];
    
//    [params setValue:[NSNumber numberWithBool:theGender] forKey:@"gender"];
    
//    [AVCloud callFunctionInBackground:@"update_user_info" withParameters:params block:^(id object, NSError *error) {
//        
//        if (!error)
//        {
//            [bself.user refreshInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//                if (resultBlock)
//                {
//                    resultBlock(object!=nil,error);
//                }
//            }];
//        }
//        else
//        {
//            if (resultBlock)
//            {
//                resultBlock(object!=nil,error);
//            }
//        }
//    }];
    
    //    [self.user saveInBackgroundWithBlock:resultBlock];
    
    
    if (theHeadViewFile)
    {
        self.user.largeHeadViewURL = theHeadViewFile.url;
        self.user.smallHeadViewURL = [NSString stringWithFormat:@"%@?imageMogr/auto-orient/thumbnail/100x100",theHeadViewFile.url];
    }
    
    if (theBackgroundViewFile)
    {
        self.user.backgroundViewURL = theBackgroundViewFile.url;
    }
    
    if (theNickname)
    {
        self.user.nickname = theNickname;
    }

    if (theCity)
    {
        self.user.city = theCity;
    }
    
    self.user.gender = theGender;
    self.user.isCompleteSignUp = YES;
    
    [self.user saveInBackgroundWithBlock:resultBlock];
}

/**
 *
 *  是否已完善个人资料
 */
- (void)isCompleteSignUpWithBlock:(AVBooleanResultBlock)block
{
    [self.user refreshInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (object && !error)
        {
            if (block) block([[object objectForKey:@"isCompleteSignUp"] boolValue],nil);
        }
        else
        {
            if (block) block(NO,error);
        } 
    }];
}

#pragma mark - 用户关系
//关注用户

#pragma mark - 好友
//关注
- (void)addFriendWithUser:(User *)theUser
                    block:(PFBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
//    __block typeof (self) bself = self;
    
    if (USER_AVOS_STATUS)
    {
        //BUG
        [self.user follow:theUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(succeeded,error);
                });
            }
        }];
    }
    else
    {
        [self.user.friends addObject:theUser];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded && !error)
            {
                [theUser.follows addObject:[User currentUser]];
                [theUser saveInBackgroundWithBlock:resultBlock];
            }
            else
            {
                if (resultBlock) {
                    resultBlock(succeeded,error);
                }
            }
        }];
    }
    
    //    [self _friendRequestWithToUser:theUser isAdd:YES block:resultBlock];
    //    [AVCloud callFunctionInBackground:@"add_friend" withParameters:@{@"friend":theUser.objectId} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
}

//解除关注
- (void)removeFriendWithUser:(User *)theUser
                       block:(PFBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    if (USER_AVOS_STATUS)
    {
        //BUG
        [self.user unfollow:theUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(succeeded,error);
                });
            }
        }];
    }
    else
    {
        [self.user.friends removeObject:theUser];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded && !error)
            {
                [theUser.follows removeObject:[User currentUser]];
                [theUser saveInBackgroundWithBlock:resultBlock];
            }
            else
            {
                if (resultBlock) {
                    resultBlock(succeeded,error);
                }
            }
        }];
    }
    
    
    //    [self _friendRequestWithToUser:theUser isAdd:NO block:resultBlock];
    //    [AVCloud callFunctionInBackground:@"remove_friend" withParameters:@{@"friend":theUser} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
}


//关注人
- (void)getFriendListWithBlock:(AVArrayResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(nil,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (USER_AVOS_STATUS)
    {
        [self.user getFollowees:^(NSArray *objects, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(objects,error);
                });
            }
        }];
//        [[AVUser query] findObjectsInBackgroundWithBlock:resultBlock];
    }
    else
    {
        [[self.user.friends query] findObjectsInBackgroundWithBlock:resultBlock];
    }
    //    [AVCloud callFunctionInBackground:@"get_friends" withParameters:@{} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
}

//关注人数
- (void)getFriendCountWithBlock:(AVIntegerResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(0,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (USER_AVOS_STATUS)
    {
        [self.user getFollowees:^(NSArray *objects, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(objects.count,error);
                });
            }
        }];
//        [[AVUser query] countObjectsInBackgroundWithBlock:resultBlock];
    }
    else
    {
        [[self.user.friends query] countObjectsInBackgroundWithBlock:resultBlock];
    }

    //    [[self.user.friends query] countObjectsInBackgroundWithBlock:resultBlock];
    //    [AVCloud callFunctionInBackground:@"get_friends_count" withParameters:@{} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
}

//粉丝
- (void)getFollowListWithBlock:(AVArrayResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(nil,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    NSLog(@"self.user=%@",self.user.class);
    
    if (USER_AVOS_STATUS)
    {
        [self.user getFollowers:^(NSArray *objects, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(objects,error);
                });
            }
        }];
//        [[AVUser query] findObjectsInBackgroundWithBlock:resultBlock];
    }
    else
    {
        [[self.user.follows query] findObjectsInBackgroundWithBlock:resultBlock];
    }
    //    [AVCloud callFunctionInBackground:@"get_follows" withParameters:@{} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
}

//粉丝人数
- (void)getFollowCountWithBlock:(AVIntegerResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(0,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (USER_AVOS_STATUS)
    {
        [self.user getFollowers:^(NSArray *objects, NSError *error) {
            
            if (resultBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultBlock(objects.count,error);
                });
            }
        }];
//        [[AVUser query] countObjectsInBackgroundWithBlock:resultBlock];
    }
    else
    {
        [[self.user.follows query] countObjectsInBackgroundWithBlock:resultBlock];
    }
    
    //    [AVCloud callFunctionInBackground:@"get_follows_count" withParameters:@{} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
}



#pragma mark - 消息
//发消息
- (void)postMessageWithText:(NSString *)theText
                      voice:(AVFile *)theVoiceFile
                        URL:(NSString *)theURL
                     toUser:(User *)theUser
                      block:(void (^)(BOOL succeeded, NSError *error))resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    __block typeof (self) bself = self;
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (theVoiceFile)
    {
        __block AVFile *__theVoiceFile = theVoiceFile;
        if (!theVoiceFile.objectId) {
            [theVoiceFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [bself postMessageWithText:theText voice:__theVoiceFile URL:theURL toUser:theUser block:resultBlock];
            }];
            return;
        }
//        else
//        {
//            [params setValue:theVoiceFile.url forKey:@"voiceURL"];
//        }
    }
    
    
//    [params setValue:theUser forKey:@"toUser"];
//    [params setValue:theText forKey:@"text"];
    
    //    [theUser addUniqueObject:self.user forKey:@"contacts"];
    
//    [AVCloud callFunctionInBackground:@"post_message" withParameters:params block:^(id object, NSError *error) {
//        
//        if (resultBlock) {
//            resultBlock(object!=nil,error);
//        }
//    }];
    
//    [theUser fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        if (object && !error)
//        {
////            [[object relationforKey:@"contacts"] addObject:bself.user];
//            [theUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded && !error)
//                {
                    Message *msg = [Message object];
                    msg.fromUser = bself.user;
                    msg.toUser = theUser;
                    
                    Content *content = [Content object];
                    if (theText) content.text = theText;
                    if (theVoiceFile) content.voiceURL = theVoiceFile.url;
                    if (theURL) content.URL = theURL;
                    msg.content = content;
                    [msg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        POST_NOTIFICATION_FRIEND_NOTIFICATION(ALFriendNotificationTypeOfNewMessage, theUser, bself.user);
                        
                        if (resultBlock) {
                            resultBlock(succeeded,error);
                        }
                    }];
//                }
//                else
//                {
//                    if (resultBlock) resultBlock(NO,error);
//                }
//            }];
//        }
//        else
//        {
//            if (resultBlock) resultBlock(NO,error);
//        }
//    }];

    
}

//更改会话中未读状态为已读
- (void)updateUnreadStateOfUser:(User *)theUser
                          block:(void (^)(BOOL succeeded, NSError *error))resultBlock
{
    if (![self _checkLoggedIn]|| !theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
//    __block typeof (self) bself = self;
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:theUser forKey:@"fromUser"];
//    
//    [AVCloud callFunctionInBackground:@"update_message_to_is_read" withParameters:params block:^(id object, NSError *error) {
//        
//        if (resultBlock) {
//            resultBlock(object!=nil,error);
//        }
//        
//    }];
    
    AVQuery *msgQ = [Message query];
    [msgQ whereKey:@"toUser" equalTo:self.user];
    [msgQ whereKey:@"fromUser" equalTo:theUser];
    [msgQ whereKey:@"isRead" notEqualTo:@YES];
    [msgQ whereKey:@"isDelete" notEqualTo:@YES];
    [msgQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        for (Message *msg in objects) {
            msg.isRead = YES;
        }
        [AVObject saveAllInBackground:objects block:resultBlock];

    }];
}

//获得全部未读的聊天记录数
- (void)getALLUnreadMessageCountWithBlock:(void(^)(NSInteger messagesCount, NSError *error))resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    AVQuery *msgQ = [Message query];
    [msgQ whereKey:@"toUser" equalTo:self.user];
    [msgQ whereKey:@"isRead" notEqualTo:@YES];
    [msgQ whereKey:@"isDelete" notEqualTo:@YES];
    [msgQ countObjectsInBackgroundWithBlock:resultBlock];
    
//    [AVCloud callFunctionInBackground:@"get_all_message_count_for_unread" withParameters:@{} block:^(id object, NSError *error) {
//        
//        if (resultBlock) {
//            resultBlock(object!=nil,error);
//        }
//    }];
}

- (void)getALLUnreadMessageCountAboutUserWithBlock:(void(^)(NSArray *messagesCount, NSError *error))resultBlock
{
    AVQuery *msgQ = [Message query];
    [msgQ selectKeys:@[@"fromUser"]];
    [msgQ whereKey:@"toUser" equalTo:self.user];
    [msgQ whereKey:@"isRead" notEqualTo:@YES];
    [msgQ whereKey:@"isDelete" notEqualTo:@YES];
    [msgQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            NSMutableArray *messages = [NSMutableArray array];
            for (Message *msg in objects) {
                
                BOOL isExsit = NO;
                for (NSMutableDictionary *msgDic in messages) {
                    if ([[msgDic[@"user"] objectForKey:@"objectId"] isEqualToString:msg.fromUser.objectId])
                    {
                        isExsit = YES;
                        msgDic[@"count"] = [NSNumber numberWithInt:[msgDic[@"count"] intValue]+1];
                    }
                }
                if (!isExsit)
                {
                    NSMutableDictionary *msgDic = [NSMutableDictionary dictionary];
                    [msgDic setValue:msg.fromUser forKey:@"user"];
                    [msgDic setValue:@1 forKey:@"count"];
                    [messages addObject:msgDic];
                }
            }
            if (resultBlock) {
                resultBlock(messages,nil);
            }
        }
        else
        {
            if (resultBlock) {
                resultBlock(objects,error);
            }
        }
    }];
}

//获取与某用户的聊天记录
- (void)getUserMessageWithUser:(User *)theUser
                         limit:(int)theLimit
                  lessThanDate:(NSDate *)theLessThanDate
                         block:(void (^)(NSArray *messages, NSError *error))resultBlock
{
    if (![self _checkLoggedIn] || !theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //
    //    [self _addLimit:theLimit lessThenDate:theLessThanDate toParams:params];
    //
    //    [params setValue:theUser forKey:@"fromUser"];
    //
    //    [AVCloud callFunctionInBackground:@"search_messages_about_user" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    
    AVQuery *msgQ1 = [Message query];
    [msgQ1 whereKey:@"toUser" equalTo:self.user];
    [msgQ1 whereKey:@"fromUser" equalTo:theUser];
    [msgQ1 whereKey:@"isDelete" notEqualTo:@YES];
    
    AVQuery *msgQ2 = [Message query];
    [msgQ2 whereKey:@"fromUser" equalTo:self.user];
    [msgQ2 whereKey:@"toUser" equalTo:theUser];
    [msgQ2 whereKey:@"isDelete" notEqualTo:@YES];
    
    AVQuery *msgQ = [AVQuery orQueryWithSubqueries:@[msgQ1,msgQ2]];
    
    [self _addLimit:theLimit lessThenDate:theLessThanDate toQuery:msgQ];
    [self _includeKeyWithMessage:msgQ];
    
    [msgQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error && objects.count)
        {
            if (resultBlock) {
                __block NSMutableArray *objs = [NSMutableArray arrayWithCapacity:objects.count];
                [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [objs insertObject:obj atIndex:0];
                }];
                resultBlock(objs,nil);
            }
        }
        else
        {
            if (resultBlock) {
            
                resultBlock(objects,error);
            }
        }
        
    }];
}

//获取与某用户的未读聊天记录
- (void)getUserUnreadMessageWithUser:(User *)theUser
                               limit:(int)theLimit
                        lessThanDate:(NSDate *)theLessThanDate
                               block:(void (^)(NSArray *messages, NSError *error))resultBlock
{
    if (![self _checkLoggedIn] || !theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //
    //    [self _addLimit:theLimit lessThenDate:theLessThanDate toParams:params];
    //
    //    [params setValue:theUser forKey:@"fromUser"];
    //
    //    [AVCloud callFunctionInBackground:@"search_messages_about_user_for_unread" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    
    AVQuery *msgQ = [Message query];
    [msgQ whereKey:@"toUser" equalTo:self.user];
    [msgQ whereKey:@"fromUser" equalTo:theUser];
    [msgQ whereKey:@"isRead" notEqualTo:@YES];
    [msgQ whereKey:@"isDelete" notEqualTo:@YES];
    [self _addLimit:theLimit lessThenDate:theLessThanDate toQuery:msgQ];
    [self _includeKeyWithMessage:msgQ];
    [msgQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error && objects.count)
        {
            if (resultBlock) {
                __block NSMutableArray *objs = [NSMutableArray arrayWithCapacity:objects.count];
                [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [objs insertObject:obj atIndex:0];
                }];
                resultBlock(objs,nil);
            }
        }
        else
        {
            if (resultBlock) {
                
                resultBlock(objects,error);
            }
        }
        
    }];
}

//获取最近联系人列表
- (void)getContactsWithblock:(void (^)(NSArray *contacts, NSError *error))resultBlock
{
    //    id contacts = [self.user objectForKey:@"contacts"];
    //    //没有联系人
    //    if (![contacts isKindOfClass:[NSArray class]] || !contacts)
    //    {
    //        if (resultBlock) {
    //            resultBlock(@[],nil);
    //        }
    //        return;
    //    }
    
    //    NSMutableArray *contactList = [NSMutableArray array];
    //    [contactList addObjectsFromArray:contacts];
    
    //    [AVObject fetchAllIfNeededInBackground:contacts block:resultBlock];
    AVQuery *contactsQ = [self.user.contacts query];
    [self _includeKeyWithUser:contactsQ];
    [contactsQ findObjectsInBackgroundWithBlock:resultBlock];
    
    //    [AVCloud callFunctionInBackground:@"get_contacts" withParameters:@{} block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
}

//删除联系人（同时将所有该联系人的消息delete）
- (void)deleteContactsWithUser:(User *)theUser
                         block:(AVBooleanResultBlock)resultBlock
{
    //    id contacts = [self.user objectForKey:@"contacts"];
    //    //没有联系人
    //    if (![contacts isKindOfClass:[NSArray class]] || !contacts)
    //    {
    //        return;
    //    }
    
    if (!theUser) {
        return;
    }
    
    __block typeof (self) bself = self;
    
    //    [contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    //        if ([[obj objectForKey:@"objectId"] isEqualToString:theUser.objectId])
    //        {
    //            [bself.user removeObject:obj forKey:@"contacts"];
    //            [bself.user saveEventually:^(BOOL succeeded, NSError *error) {
    //                [bself updateUnreadStateOfUser:theUser block:nil];
    //            }];
    //        }
    //    }];
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:theUser forKey:@"fromUser"];
//    
//    [AVCloud callFunctionInBackground:@"delete_contacts" withParameters:params block:nil];
    

    [self updateUnreadStateOfUser:theUser block:^(BOOL succeeded, NSError *error) {
       
        if (succeeded && !error)
        {
            [bself.user.contacts removeObject:theUser];
            [bself.user saveInBackgroundWithBlock:resultBlock];
        }
        else
        {
            if (resultBlock) {
                resultBlock(succeeded,error);
            }
        }
    }];
}

#pragma mark - 日程
//创建日程
- (void)createScheduleWithDate:(NSDate *)theDate
                       andType:(int)theType
                 andRemindDate:(NSDate *)theRemindDate
                      andWoeid:(NSString *)theWoeid
                      andPlace:(NSString *)thePlace
                          text:(NSString *)theText
                         voice:(AVFile *)theVoiceFile
                           URL:(NSString *)theURL
                         block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    //    Schedule *schedule = [Schedule object];
    //    schedule.date = theDate;
    //    schedule.remindDate = theRemindDate;
    //    schedule.type = theType;
    //    schedule.woeid = theWoeid;
    //    schedule.place = thePlace;
    //    schedule.user = self.user;
    //    [schedule saveEventually:resultBlock];
    
    //    AVQuery *myInstall = [AVInstallation query];
    //    [myInstall whereKey:@"user" equalTo:self.user];
    
//    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __block typeof (self) bself = self;
    
    if (theVoiceFile)
    {
        __block AVFile *__theVoiceFile = theVoiceFile;
        if (!theVoiceFile.objectId) {
            [theVoiceFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [bself createScheduleWithDate:theDate andType:theType andRemindDate:theRemindDate andWoeid:theWoeid andPlace:thePlace text:theText voice:__theVoiceFile URL:theURL block:resultBlock];
            }];
            return;
        }
//        else
//        {
//            [params setValue:theVoiceFile.url forKey:@"voiceURL"];
//        }
    }
    
//    NSDateFormatter *fomater=[[NSDateFormatter alloc] init];
//    [fomater setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
//    NSString *theDateStr = [fomater stringFromDate:theDate];
//    NSString *theRemindDateStr = [fomater stringFromDate:theRemindDate];
    
//    [params setValue:theDateStr forKey:@"dateStr"];
//    [params setValue:theText forKey:@"text"];
//    [params setValue:theURL forKey:@"URL"];
//    [params setValue:[NSNumber numberWithInt:theType] forKey:@"type"];
//    [params setValue:theWoeid forKey:@"woeid"];
//    [params setValue:thePlace forKey:@"place"];
//    [params setValue:theRemindDateStr forKey:@"remindDateStr"];
    
//    [AVCloud callFunctionInBackground:@"create_schedule" withParameters:params block:^(id object, NSError *error) {
//        if (resultBlock) {
//            resultBlock(object!=nil,error);
//        }
//    }];
    
    //    __block AVPush *push = [AVPush push];
    //    [push setQuery:myInstall];
    //    [push setMessage:@"提醒~叮叮叮~~"];
    //    [push setPushDate:theRemindDate];
    //    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //
    //        if (succeeded && !error)
    //        {
    //            [params setValue:push forKey:@"push"];
    //            [AVCloud callFunctionInBackground:@"create_schedule" withParameters:params block:^(id object, NSError *error) {
    //                if (resultBlock) {
    //                    resultBlock(object!=nil,error);
    //                }
    //            }];
    //        }
    //        else
    //        {
    //            if (resultBlock) {
    //                resultBlock(NO,error);
    //            }
    //        }
    //    }];
    
//    [AVCloud callFunctionInBackground:@"created_push" withParameters:@{@"remindDateStr":theRemindDateStr,@"alert":@"你有一条新得提醒"} block:^(id object, NSError *error) {
//       
//        if (object && !error) {
    
            Schedule *schedule = [Schedule object];
            schedule.date = theDate;
            schedule.remindDate = theRemindDate;
            schedule.type = theType;
            schedule.woeid = theWoeid;
            schedule.user = bself.user;
            schedule.place = thePlace;
//            schedule.push = [AVObject objectWithoutDataWithClassName:@"_Notification" objectId:object];
    
            Content *content = [Content object];
            if (theText) content.text = theText;
            if (theVoiceFile) content.voiceURL = theVoiceFile.url;
            if (theText) content.URL = theURL;
            schedule.content = content;
            
            [schedule saveEventually:resultBlock];
//        }
//        else
//        {
//            if (resultBlock) {
//                resultBlock(object!=nil,error);
//            }
//        }
//        
//    }];
}

//查看全部日程
- (void)getMyScheduleListWihtBlock:(AVArrayResultBlock)resultBlock
{
    if (![self _checkLoggedIn]) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    AVQuery *scQuery = [Schedule query];
    [scQuery whereKey:@"user" equalTo:self.user];
    [self _includeKeyWithSchedule:scQuery];
    [scQuery findObjectsInBackgroundWithBlock:resultBlock];
    
    //    [AVCloud callFunctionInBackground:@"my_schedule" withParameters:@{} block:^(id object, NSError *error) {
    //
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //
    //    }];
}

//编辑日程
- (void)updateSchedule:(Schedule *)theSchedule
               andDate:(NSDate *)theDate
               andType:(int)theType
         andRemindDate:(NSDate *)theRemindDate
              andWoeid:(NSString *)theWoeid
              andPlace:(NSString *)thePlace
                  text:(NSString *)theText
                 voice:(AVFile *)theVoiceFile
                   URL:(NSString *)theURL
                 block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn] || !theSchedule){
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    //    AVQuery *pushQ = [AVQuery queryWithClassName:@"_Notification"];
    //    [pushQ whereKey:@"objectId" equalTo:theSchedule.push];
    //
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setValue:theSchedule forKey:@"schedule"];
    //    [params setValue:theDate forKey:@"date"];
    ////    [params setValue:theRemindDate forKey:@"remindDate"];
    //    [params setValue:[NSNumber numberWithInt:theType] forKey:@"type"];
    //    [params setValue:theWoeid forKey:@"woeid"];
    //    [params setValue:thePlace forKey:@"place"];
    //    [params setValue:self.user forKey:@"user"];
    //    [params setValue:push forKey:@"push"];
    
    //    theSchedule.date = theDate;
    //    theSchedule.remindDate = theRemindDate;
    //    theSchedule.type = theType;
    //    theSchedule.woeid = theWoeid;
    //    theSchedule.place = thePlace;
    //    theSchedule.user = self.user;
    //    [theSchedule saveEventually:resultBlock];
    
//    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    __block typeof (self) bself = self;
    
    if (theVoiceFile)
    {
        __block AVFile *__theVoiceFile = theVoiceFile;
        if (!theVoiceFile.objectId) {
            [theVoiceFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [bself updateSchedule:theSchedule andDate:theDate andType:theType andRemindDate:theRemindDate andWoeid:theWoeid andPlace:thePlace text:theText voice:__theVoiceFile URL:theURL block:resultBlock];
            }];
            return;
        }
//        else
//        {
//            [params setValue:theVoiceFile.url forKey:@"voiceURL"];
//        }
    }
    
    [self deleteSchedule:theSchedule block:^(BOOL succeeded, NSError *error) {
       
        if (succeeded && !error)
        {
            [self createScheduleWithDate:theDate andType:theType andRemindDate:theRemindDate andWoeid:theWoeid andPlace:thePlace text:theText voice:theVoiceFile URL:theURL block:resultBlock];
        }
        else
        {
            if (resultBlock) {
                resultBlock(succeeded,error);
            }
        }
        
    }];
    
//    NSDateFormatter *fomater=[[NSDateFormatter alloc] init];
//    [fomater setDateFormat:@"YYYY-MM-DD HH:mm:ss"];
//    NSString *theDateStr = [fomater stringFromDate:theDate];
//    NSString *theRemindDateStr = [fomater stringFromDate:theRemindDate];
//    
//    [params setValue:theSchedule.objectId forKey:@"scheduleId"];
//    [params setValue:theDateStr forKey:@"dateStr"];
//    [params setValue:theText forKey:@"text"];
//    [params setValue:theURL forKey:@"URL"];
//    [params setValue:[NSNumber numberWithInt:theType] forKey:@"type"];
//    [params setValue:theWoeid forKey:@"woeid"];
//    [params setValue:thePlace forKey:@"place"];
//    
//    [params setValue:theRemindDateStr forKey:@"remindDateStr"];
    
    //    [AVCloud callFunctionInBackground:@"update_schedule" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
    
//    theSchedule.type = theType;
//    if (theWoeid) theSchedule.woeid = theWoeid;
//    if (thePlace) theSchedule.place = thePlace;
//    if (theDate) theSchedule.date = theDate;
//    
//    if (theText || theVoiceFile || theURL)
//    {
//        Content *content = [Content object];
//        if (theText) content.text = theText;
//        if (theVoiceFile) content.voiceURL = theVoiceFile.url;
//        if (theURL) content.URL = theURL;
//        theSchedule.content = content;
//    }
//    
//    if (theRemindDate)
//    {
//        theSchedule.remindDate = theRemindDate;
//    }
//    
//    if (!theRemindDate)
//    {
//        [theSchedule saveInBackgroundWithBlock:resultBlock];
//    }
//    else
//    {
//        
//    }
    
//    if (theRemindDate) {
//        [theSchedule.push deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded && !error) {
//                [AVCloud callFunctionInBackground:@"created_push" withParameters:@{@"remindDateStr":theRemindDateStr,@"alert":@"你有一条新得提醒"} block:^(id object, NSError *error) {
        
//                    theSchedule.push = [AVObject objectWithoutDataWithClassName:@"_Notificaiton" objectId:object];
//                    [theSchedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        if (resultBlock) {
//                            resultBlock(object!=nil,error);
//                        }
//                    }];
//                }];
//                
//            }
//            else
//            {
//                if (resultBlock) {
//                    resultBlock(succeeded,error);
//                }
//            }
//        }];
//    }
//    else
//    {
//        [theSchedule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (resultBlock) {
//                resultBlock(succeeded,error);
//            }
//        }];
//    }
}

//删除日程
- (void)deleteSchedule:(Schedule *)theSchedule
                 block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn] || !theSchedule){
        return;
    }
    
//    [theSchedule.push fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//        if (object)
//        {
//            [AVCloud callFunctionInBackground:@"delete_push" withParameters:@{@"pushId":object.objectId} block:^(id object, NSError *error) {
//                
//                if (!error)
//                {
//                    [theSchedule deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                        
//                        if (resultBlock) {
//                            resultBlock(succeeded,error);
//                        }
//                    }];
//                }
//                else
//                {
//                    if (resultBlock) {
//                        resultBlock(NO,nil);
//                    }
//                }
//                
//            }];
//        }
//        else
//        {
//            if (resultBlock) {
//                resultBlock(NO,nil);
//            }
//        }
//    }];
    
    
    
//    [theSchedule.push deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded && !error)
//        {
            [theSchedule deleteInBackgroundWithBlock:resultBlock];
//        }
//        else
//        {
//            if (resultBlock) {
//                resultBlock(succeeded,error);
//            }
//        }
//        
//    }];
    
//    [theSchedule deleteEventually];
    //    [AVCloud callFunctionInBackground:@"delete_schedule" withParameters:@{@"schedule":theSchedule} block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
}


#pragma mark - 图片
//上传街拍
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
                     block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn])
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
    if (!theImageFiles || !theImageFiles.count)
    {
        if (resultBlock)
        {
            resultBlock(NO,nil);
        }
        return;
    }
    
//    if (!(theText || theVoiceFile))
//    {
//        if (resultBlock)
//        {
//            resultBlock(NO,nil);
//        }
//        return;
//    }
    
    __block typeof (self) bself = self;
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //    __block NSMutableArray *waitUploadFile = [NSMutableArray array];
    BOOL isNeetToSave = NO;
    
    for (AVFile *imgFile in theImageFiles) {
        if ([imgFile isKindOfClass:[AVFile class]]) {
            if (!imgFile.objectId) {
                isNeetToSave = YES;
            }
        }
    }
    
    if (isNeetToSave)
    {
        //dispatch_async() 调用以后立即返回，dispatch_sync() 调用以后等到block执行完以后才返回，dispatch_sync()会阻塞当前线程。
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 处理耗时操作的代码块...
            for (AVFile *imgFile in theImageFiles) {
                if ([imgFile isKindOfClass:[AVFile class]]) {
                    if (!imgFile.objectId) {
                        [imgFile save];
                    }
                }
            }
            
            //通知主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                [bself postPhotoWithImage:theImageFiles temperature:theTemperature weatherCode:theWeatherCode text:theText voice:theVoiceFile isShareToSinaWeibo:theIsShareToSinaWeibo isShareToQQWeibo:theIsShareToQQWeibo latitude:theLatitude longitude:theLongitude place:thePlace block:resultBlock];
                
            });
            
        });
        
        return;
    }
//    else
//    {
//        NSMutableArray *imageURLs = [NSMutableArray array];
//        for (AVFile *imageFile in theImageFiles) {
//            [imageURLs addObject:imageFile.url];
//        }
//        [params setObject:imageURLs  forKey:@"imageURLs"];
//    }
    
    
    if (theVoiceFile)
    {
        //        NSString *base64Voice = [ASIHTTPRequest base64forData:theVoice];
        //        [params setObject:base64Voice forKey:@"voice"];
        __block AVFile *__theVoiceFile = theVoiceFile;
        if (!theVoiceFile.objectId) {
            [theVoiceFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [bself postPhotoWithImage:theImageFiles temperature:theTemperature weatherCode:theWeatherCode text:theText voice:__theVoiceFile isShareToSinaWeibo:theIsShareToSinaWeibo isShareToQQWeibo:theIsShareToQQWeibo latitude:theLatitude longitude:theLongitude place:thePlace block:resultBlock];
            }];
            return;
        }
//        else
//        {
//            [params setObject:theVoiceFile.url forKey:@"voiceURL"];
//        }
    }
    
//    if (theText)
//    {
//        [params setObject:theText forKey:@"text"];
//    }
    
    //天气
//    Weather *weather = theWeatherInfo.weathers[0];
//    [params setObject:[NSNumber numberWithFloat:weather.temperature] forKey:@"temperature"];
//    [params setObject:[NSNumber numberWithInteger:weather.weatherCode] forKey:@"weatherCode"];

    //坐标
//    [params setObject:[NSNumber numberWithFloat:theLatitude] forKey:@"latitude"];
//    [params setObject:[NSNumber numberWithFloat:theLongitude]forKey:@"longitude"];
    
    //    [AVCloud callFunctionInBackground:@"upload_photo" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
    
//    AVObject *obj;
    
    
    __block NSMutableArray *photos = [NSMutableArray arrayWithCapacity:theImageFiles.count];
    for (AVFile *imgFile in theImageFiles) {
        
        __block Photo *photo = [Photo object];
        //坐标
        photo.location = [AVGeoPoint geoPointWithLatitude:theLatitude longitude:theLongitude];
        //用户
        photo.user = self.user;
        //内容
        Content *content = [Content object];
        if (theVoiceFile) content.voiceURL = theVoiceFile.url;
        if (theText) content.text = theText;
        photo.content = content;
        //图片
        photo.originalURL = imgFile.url;
        photo.place = thePlace;
        photo.thumbnailURL = [NSString stringWithFormat:@"%@?imageMogr/auto-orient/thumbnail/200x",imgFile.url];
        [self _requestWithUrl:[NSString stringWithFormat:@"%@?imageInfo",imgFile.url] timeOut:0 block:^(NSDictionary *dict, NSError *error) {
            
            photo.width = [[dict valueForKey:@"width"] floatValue];
            photo.height = [[dict valueForKey:@"height"] floatValue];
            
            AVQuery *tempQ = [Temperature query];
            [tempQ whereKey:@"maxTemperture" greaterThanOrEqualTo:[NSNumber numberWithInt:theTemperature]];
            [tempQ whereKey:@"minTemperture" lessThanOrEqualTo:[NSNumber numberWithInt:theTemperature]];
            [tempQ getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                
                photo.temperature = object;
                
                AVQuery *weatherQ = [WeatherType query];
                [weatherQ whereKey:@"weatherCode" equalTo:[NSNumber numberWithInt:theWeatherCode]];
                [weatherQ getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                   
                    photo.weatherType = object;
                    photo.weatherName = [object objectForKey:@"name"];
                    [photos addObject:photo];
                    if (photos.count == theImageFiles.count)
                    {
                        [AVObject saveAllInBackground:photos block:resultBlock];
                    }
                }];
            }];
            
        }];
    }
}


//查看用户的相册
- (void)searchPhotoWithUser:(User *)theUser
                      limit:(int)theLimit                        //返回条数 0默认返回20
               lessThenDate:(NSDate *)theLessThenDate         //时间点
                      block:(AVArrayResultBlock)resultBlock
{
    if (!theUser) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    AVQuery *pQ = [Photo query];
    [self _includeKeyWithPhoto:pQ];
    [self _addLimit:theLimit lessThenDate:theLessThenDate toQuery:pQ];
    [pQ whereKey:@"user" equalTo:theUser];
    [pQ findObjectsInBackgroundWithBlock:resultBlock];
    
    //    [AVCloud callFunctionInBackground:@"search_user_photo" withParameters:@{@"user":theUser} block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
}

//查看
- (void)searchAllPhotoWithType:(int)theType //0.官方 1.最新街拍 2.最热街拍 3.附近街拍
                         limit:(int)theLimit                        //返回条数 0默认返回20
                      latitude:(CGFloat)theLatitude
                     longitude:(CGFloat)theLongitude
                  lessThenDate:(NSDate *)theLessThenDate         //时间点
                         block:(AVArrayResultBlock)resultBlock
{
    AVQuery *pQ = [Photo query];
    [self _includeKeyWithPhoto:pQ];
    [self _addLimit:theLimit lessThenDate:theLessThenDate toQuery:pQ];
    
    switch (theType) {
        case 0:
        {
            [pQ whereKey:@"isOfficial" equalTo:@YES];
            [pQ orderByDescending:@"updatedAt"];
        }
            break;
        case 1:
        {
            [pQ whereKey:@"isOfficial" notEqualTo:@YES];
            [pQ orderByDescending:@"createdAt"];
        }
            break;
        case 2:
        {
            [pQ whereKey:@"isOfficial" notEqualTo:@YES];
            [pQ orderByDescending:@"hot"];
        }
            break;
        case 3:
        {
            [pQ whereKey:@"isOfficial" notEqualTo:@YES];
            [pQ whereKey:@"location" nearGeoPoint:[AVGeoPoint geoPointWithLatitude:theLatitude longitude:theLongitude]];
        }
            break;
        default:
            break;
    }
    [pQ findObjectsInBackgroundWithBlock:resultBlock];
}


/**
 *
 * 查找某张图片（根据天气）
 */
- (void)getPhototWithTemperature:(int)theTemperature
                     weatherCode:(int)theWeatherCode
                      isOfficial:(BOOL)theIsOffical
                        latitude:(CGFloat)theLatitude
                       longitude:(CGFloat)theLongitude
                           block:(AVObjectResultBlock)resultBlock
{
    AVQuery *temperQ = [Temperature query];
    [temperQ whereKey:@"minTemperture" lessThanOrEqualTo:[NSNumber numberWithFloat:theTemperature]];
    [temperQ whereKey:@"maxTemperture" greaterThanOrEqualTo:[NSNumber numberWithFloat:theTemperature]];
    [temperQ getFirstObjectInBackgroundWithBlock:^(AVObject *temperature, NSError *error) {
        
        if (!error && temperature)
        {
            AVQuery *weatherTypeQ = [WeatherType query];
            [weatherTypeQ whereKey:@"weatherCode" equalTo:[NSNumber numberWithInt:theWeatherCode]];
            [weatherTypeQ getFirstObjectInBackgroundWithBlock:^(AVObject *weatherType, NSError *error) {
                
                if (!error && weatherType)
                {
                    AVQuery *photoQ = [Photo query];
                    [photoQ whereKey:@"temperature" equalTo:temperature];
         
                    [photoQ whereKey:@"weatherName" equalTo:[weatherType objectForKey:@"name"]];

                    [self _includeKeyWithPhoto:photoQ];
                    
                    if (theIsOffical)
                    {
                        [photoQ whereKey:@"isOfficial" equalTo:@YES];
                    }
                    else if (theLatitude==0 && theLatitude==0)
                    {
                        [photoQ whereKey:@"isOfficial" notEqualTo:@YES];
                        [photoQ orderByDescending:@"createdAt"];
                    }
                    else
                    {
                        [photoQ whereKey:@"isOfficial" notEqualTo:@YES];
                        [photoQ whereKey:@"location" nearGeoPoint:[AVGeoPoint geoPointWithLatitude:theLatitude longitude:theLongitude]];
                    }
                    photoQ.limit = 10;
                    [photoQ findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (!error && objects.count)
                        {
                            if (resultBlock)
                            {
                                resultBlock(objects[arc4random()%objects.count],nil);
                            }
                        }
                        else
                        {
                            if (resultBlock)
                            {
                                resultBlock(nil,error);
                            }
                        }
                    }];
                }
                else
                {
                    if (resultBlock)
                    {
                        resultBlock(nil,error);
                    }
                }
            }];
        }
        else
        {
            if (resultBlock)
            {
                resultBlock(nil,error);
            }
        }
    }];
}

#pragma mark - 评论照片
//评论照片
- (void)commentPhoto:(Photo *)thePhoto
                text:(NSString *)theText                  //文字 选填
               voice:(AVFile *)theVoiceFile               //声音 选填
               block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn] || !thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    if (!theText && !theVoiceFile)
    {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 115, @"参数错误"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    Content *content = [Content object];
    if (theVoiceFile)
    {
        if (!theVoiceFile.objectId) {
            __block typeof (self) bself = self;
            __block AVFile *__theVoiceFile = theVoiceFile;
            [theVoiceFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [bself commentPhoto:thePhoto text:theText voice:__theVoiceFile block:resultBlock];
            }];
            return;
        }
        else
        {
            //            [params setObject:theVoiceFile.url forKey:@"voiceURL"];
            content.voiceURL = theVoiceFile.url;
        }
    }
    
    //    [params setObject:theText forKey:@"text"];
    //    [params setObject:thePhoto forKey:@"photo"];
    
    //    [AVCloud callFunctionInBackground:@"comment_photo" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
    content.text = theText;
    
    Comment *comment = [Comment object];
    comment.photo = thePhoto;
    
    comment.content = content;
    comment.user = self.user;
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error)
        {
            [thePhoto incrementKey:@"hot"];
            [thePhoto saveEventually];
        }
        
        if (resultBlock) {
            resultBlock(succeeded,error);
        }
        
    }];
}




//查看照片评论
- (void)getCommentListFromPhoto:(Photo *)thePhoto
                          limit:(int)theLimit                        //返回条数 0默认返回20
                   lessThenDate:(NSDate *)theLessThenDate         //时间点
                          block:(AVArrayResultBlock)resultBlock
{
    if (!thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 11000, @"参数不能为空"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //
    //    [self _addLimit:theLimit lessThenDate:theLessThenDate toParams:params];
    //
    //    [params setObject:thePhoto forKey:@"photo"];
    //    [AVCloud callFunctionInBackground:@"search_photo_comments" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    
    AVQuery *commentQuery = [Comment query];
    [commentQuery whereKey:@"photo" equalTo:thePhoto];
    [self _includeKeyWithComment:commentQuery];
    //    if (theLimit)
    //    {
    //        commentQuery.limit = theLimit;
    //    }
    //    else
    //    {
    //        commentQuery.limit = DEFAULE_LIMITE;
    //    }
    //    [commentQuery whereKey:@"createdAt" lessThan:theLessThenDate];
    //    [commentQuery orderByDescending:@"createdAt"];
    [self _addLimit:theLimit lessThenDate:theLessThenDate toQuery:commentQuery];
    
    [commentQuery findObjectsInBackgroundWithBlock:resultBlock];
}

//查看照片评论数
- (void)getCommentCountFromPhoto:(Photo *)thePhoto
                           block:(AVIntegerResultBlock)resultBlock
{
    if (!thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 11000, @"参数不能为空"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setObject:thePhoto forKey:@"photo"];
    //    [AVCloud callFunctionInBackground:@"search_photo_comments_count" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    AVQuery *commentQuery = [Comment query];
    [commentQuery whereKey:@"photo" equalTo:thePhoto];
    [commentQuery countObjectsInBackgroundWithBlock:resultBlock];
    
    //    AVQuery *commentQuery = [Comment query];
    //    [commentQuery whereKey:@"user" equalTo:self.user];
    //    [commentQuery countObjectsInBackgroundWithBlock:resultBlock];
}

#pragma mark - 赞照片
//收藏照片
- (void)faviconPhoto:(Photo *)thePhoto
               block:(AVBooleanResultBlock)resultBlock
{
    if (![self _checkLoggedIn] || !thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setObject:thePhoto forKey:@"photo"];
    //    [AVCloud callFunctionInBackground:@"favicon_photo" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object!=nil,error);
    //        }
    //    }];
    
    [self.user.faviconPhotos addObject:thePhoto];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error)
        {
            [thePhoto.faviconUsers addObject:self.user];
            [thePhoto incrementKey:@"hot"];
            [thePhoto saveInBackgroundWithBlock:resultBlock];
        }
    }];
}

/**
 *
 *  是否收藏过
 */
- (void)isMyFaviconPhotos:(NSArray *)photos
                    block:(AVArrayResultBlock)resultBlock
{
    if (![self _checkLoggedIn])
    {
        if (resultBlock)
        {
            resultBlock(NO,ALERROR(ALDOMAIN, 110, @"请先登录"));
        }
        
        return;
    }
    
    NSMutableArray *photosId = [NSMutableArray arrayWithCapacity:photos.count];
    
    for (Photo *photo in photos)
    {
        [photosId addObject:photo.objectId];
    }
    
    AVQuery *myFPQ = [self.user.faviconPhotos query];
//    [myFPQ whereKey:@"objectId" containedIn:photosId];
    [myFPQ findObjectsInBackgroundWithBlock:resultBlock];
    
}


//查看照片的收藏者
- (void)searchFaviconUsersFromPhoto:(Photo *)thePhoto
                              limit:(int)theLimit                        //返回条数 0默认返回20
                       lessThenDate:(NSDate *)theLessThenDate         //时间点
                              block:(AVArrayResultBlock)resultBlock
{
    if (!thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 11000, @"参数不能为空"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setValue:thePhoto forKey:@"photo"];
    //    [self _addLimit:theLimit lessThenDate:theLessThenDate toParams:params];
    //
    //    [AVCloud callFunctionInBackground:@"search_photo_favicon_users" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
//    AVQuery *userFPQ = [thePhoto.faviconUsers query];
//    [self _includeKeyWithUser:userFPQ];
//    [self _addLimit:theLimit lessThenDate:theLessThenDate toQuery:userFPQ];
//    [userFPQ findObjectsInBackgroundWithBlock:resultBlock];

    __block typeof (self) bself = self;
    [thePhoto fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        AVQuery *photoUFQ = [[object relationforKey:@"faviconUsers"] query];
        [bself _includeKeyWithUser:photoUFQ];
        [bself _addLimit:theLimit lessThenDate:theLessThenDate toQuery:photoUFQ];
        [photoUFQ findObjectsInBackgroundWithBlock:resultBlock];
    }];
    
}

//查看照片的收藏者数
- (void)searchFaviconUsersCountFromPhoto:(Photo *)thePhoto
                                   block:(AVIntegerResultBlock)resultBlock
{
    if (!thePhoto) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 11000, @"参数不能为空"));
        }
        return;
    }
    
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    [params setValue:thePhoto forKey:@"photo"];
    //    [AVCloud callFunctionInBackground:@"search_photo_favicon_users_count" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    [thePhoto fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        [[[object relationforKey:@"faviconUsers"] query] countObjectsInBackgroundWithBlock:resultBlock];
        
    }];
}

//查看我收藏的照片
- (void)getMyFaviconPhotosWithLimit:(int)theLimit                        //返回条数 0默认返回20
                       lessThenDate:(NSDate *)theLessThenDate         //时间点
                              block:(AVArrayResultBlock)resultBlock
{
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //
    //    [self _addLimit:theLimit lessThenDate:theLessThenDate toParams:params];
    //
    //    [AVCloud callFunctionInBackground:@"get_my_favicon_photos" withParameters:params block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    
    AVQuery *userFPQ = [self.user.faviconPhotos query];
    [self _includeKeyWithPhoto:userFPQ];
    [self _addLimit:theLimit lessThenDate:theLessThenDate toQuery:userFPQ];
    [userFPQ findObjectsInBackgroundWithBlock:resultBlock];
 
}

//查看我收藏的照片数
- (void)getMyFaviconPhotosCountWithBlock:(AVIntegerResultBlock)resultBlock
{
    //    [AVCloud callFunctionInBackground:@"get_my_favicon_photos_count" withParameters:@{} block:^(id object, NSError *error) {
    //        if (resultBlock) {
    //            resultBlock(object,error);
    //        }
    //    }];
    AVQuery *userFP = [self.user.faviconPhotos query];
    [userFP countObjectsInBackgroundWithBlock:resultBlock];
}

#pragma mark - 打标
- (void)getOfficialPhotoWithSkip:(int)theSkip
                           block:(AVObjectResultBlock)resultBlcok
{
    AVQuery *photoQ = [Photo query];
    [photoQ whereKey:@"isOfficial" equalTo:@YES];
//    if (isNotTag)
//    {
//        [photoQ whereKey:@"isNotTag" notEqualTo:@YES];
//    }
//    else
//    {
//        [photoQ whereKey:@"isNotTag" equalTo:@YES];
//    }

    [photoQ orderByDescending:@"createdAt"];
    [self _includeKeyWithPhoto:photoQ];
//    photoQ.limit = 1;
    photoQ.skip = theSkip;
    
    [photoQ getFirstObjectInBackgroundWithBlock:resultBlcok];
}

- (void)getOfficialPhotoCountWithBlock:(AVIntegerResultBlock)resultBlcok
{
    AVQuery *photoQ = [Photo query];
    [photoQ whereKey:@"isOfficial" equalTo:@YES];
    [photoQ countObjectsInBackgroundWithBlock:resultBlcok];
}

//- (void)getTemperature:(AVArrayResultBlock)resultBlock
//{
//    [[Temperature query] findObjectsInBackgroundWithBlock:resultBlock];
//}
//
//- (void)getWeatherType:(AVArrayResultBlock)resultBlock
//{
//    [[WeatherType query] findObjectsInBackgroundWithBlock:resultBlock];
//}

- (void)updatePhoto:(Photo *)thePhoto
        temperature:(Temperature *)theTemperature
        weatherType:(WeatherType *)theWeatherType
              style:(NSString *)theStyle
        collocation:(NSArray *)theCollocation
              block:(AVBooleanResultBlock)resultBlock
{
    if (!(thePhoto && theTemperature && theWeatherType && theStyle && theCollocation)) {
        if (resultBlock) {
            resultBlock(NO,ALERROR(ALDOMAIN, 11000, @"参数不能为空"));
        }
        return;
    }
    
    thePhoto.temperature = theTemperature;
    thePhoto.weatherType = theWeatherType;
    thePhoto.style = theStyle;
    thePhoto.collocation = theCollocation;
    [thePhoto saveInBackgroundWithBlock:resultBlock];
}

@end
