//
//  RecommendView.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-15.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "WeatherRequestManager.h"
#import "Photo.h"

@class didSelectRecommendDelegate;

@protocol didSelectRecommendDelegate <NSObject>

- (void)didSelectExampleClother:(Photo *)photo;
- (void)didSelectStreetClother:(Photo *)photo;

- (void)didSelectedAllSchedule:(NSString *)cityid;
- (void)didSelectedAddSchedule:(NSString *)cityid;
- (void)didselectedFortune:(NSString *)cityid;

@end

@interface RecommendView : UIView
{
    UIImageView *weatherView;
    
    CGPoint _beginPoint;
    
    BOOL isOpen;
    
    BOOL isShowExample;
    
    
    
    
    UIButton *exampleBtn;
    UIButton *streetSnapBtn;
 
    
    UILabel *cityLabel;
    UILabel *temperatureLabel;
    UILabel *hightlowLabel;
    UILabel *pollutionLabel;
    UILabel *dateLabel;
//    UIImageView *rotateView;
    UIActivityIndicatorView *_activity;
    
    int temperature;
    WeatherCode weaCode;
    
    UIImageView *weatherImage;
    
   
}

@property(nonatomic,assign)id<didSelectRecommendDelegate>recommendDelegate;
@property(nonatomic,strong)NSMutableString *clothStr;
@property(nonatomic,assign)BOOL animation;
@property(nonatomic,strong) Photo *examplePhoto;
@property(nonatomic,strong) Photo *streetPhoto;

@property(nonatomic,strong)AsyncImageView *personView;
@property(nonatomic,strong)AsyncImageView *personView_street;
@property(nonatomic,strong)UILabel *brandLabel;
@property(nonatomic,strong)UILabel *suggestinfoLabel;

@end

