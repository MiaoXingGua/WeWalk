//
//  Photo.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "ALWeatherConfig.h"
//@class Advertisement;
@class Brand;
@class Temperature;
@class WeatherType;
@class Content;

@interface Photo : AVObject <AVSubclassing>

//原图url
@property (nonatomic, retain) NSString *originalURL;

//缩略图url
@property (nonatomic, retain) NSString *thumbnailURL;

//原图大小
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

//内容
@property (nonatomic, retain) Content *content;

//品牌 brand (Brand)
@property (nonatomic, retain) Brand *brand;

//温度 temperature (Temperature)
@property (nonatomic, retain) Temperature *temperature;

//功能 style (NSString)
@property (nonatomic, retain) NSString *style;//正式商务、休闲商务、运动、礼服、休闲、时尚、非常时尚

//天气类型 weatherCode (WeatherType)
@property (nonatomic, assign) WeatherType *weatherType;

//天气类型 weatherCode (WeatherType)
@property (nonatomic, assign) NSString *weatherName;

//功能 正式商务、休闲商务、运动、礼服、休闲、时尚、非常时尚
//@property (nonatomic, assign) NSString *occasion;
//搭配
@property (nonatomic, retain) NSArray *collocation;

//图片种类 type (int) (T台/单品/个人)
//@property (nonatomic, assign) int type;

//是否是工作日装 isWorker（BOOL）
//@property (nonatomic, assign) BOOL isWorker;

//坐标 location (AVGeoPoint)
@property (nonatomic, retain) AVGeoPoint *location;

@property (nonatomic, retain) NSString *place;

//作者 user (_User)
@property (nonatomic, retain) AVUser *user;

//收藏人列表 faviconUsers (User_relation)
@property (nonatomic, retain) AVRelation *faviconUsers;

@property (nonatomic, assign) int hot;

@property (nonatomic, assign) BOOL isOfficial;

//搭配
/*
    外套 :
    羽绒服
    夹克
    大衣
    风衣
    西装
 */
@property (nonatomic, retain) NSString *coat;


/*
    最里面:
    衬衫
    T恤
    连帽衫
    打底衫
 */
@property (nonatomic, retain) NSString *underwear;

/*
    毛衣:
    高领毛衣
    圆领毛衣
    V领毛衣
    毛衣开衫
 */
@property (nonatomic, retain) NSString *sweater;

/*
    配饰:
    眼镜
    墨镜
    领带
    腰带
    腰封
    领节
    袖扣
    领针
    马甲
    丝巾
    围巾
    口袋巾
 */
@property (nonatomic, retain) NSString *accessory;


/*
    裤子:
    牛仔裤
    卡其裤
    西装裤
    工装裤
    连身裤
    礼服裤
 */
@property (nonatomic, retain) NSString *trousers;

/*
    鞋子:
    沙漠靴
    乐福鞋
    浅口便鞋
    牛津鞋
    横饰鞋
    运动鞋
    拖鞋/便鞋
    帆船鞋
    切尔西靴
    礼服鞋
    登山靴
    马丁靴
    凉鞋
    帆布鞋
    僧侣鞋
 */
@property (nonatomic, retain) NSString *shoe;

/*
 马甲:

 */
@property (nonatomic, retain) NSString *waistcoat;
/*
 卫衣:
 
 */
@property (nonatomic, retain) NSString *hoodies;
@end
