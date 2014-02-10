//
//  ScheduleView.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-23.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ScheduleView.h"
#import "WeatherRequestManager.h"

@implementation ScheduleView
@synthesize schedule;
@synthesize schedulePhoto;
@synthesize scheduleStateView;
@synthesize scheduleTypeView;

- (id)initWithFrame:(CGRect)frame Schedule:(Schedule *)sch
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.schedule = sch;
        
        [self creatScheduleView];
    }
    
    return self;
}


- (void)creatScheduleView
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkWeather) name:COMPLETEREQUESTSCHEDULEWEATHER object:nil];
    
    UIView *_schView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
    _schView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [self addSubview:_schView];
    
    self.scheduleStateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rectangle_haveweather.png"]];
    self.scheduleStateView.frame = CGRectMake(0, 0, 3, 43);
    [_schView addSubview:self.scheduleStateView];
    
    self.scheduleTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huiyi_large_color.png"]];
    self.scheduleTypeView.frame = CGRectMake(15, 8, 29, 29);
    [_schView addSubview:self.scheduleTypeView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = kCFDateFormatterShortStyle;
    [formatter setDateFormat:@"HH:mm"];
    NSString *timerStr = [formatter stringFromDate:self.schedule.date];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 150, 20)];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.text = timerStr;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_schView addSubview:timeLabel];
    
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 3, 120, 20)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.text = self.schedule.place;
    cityLabel.font = [UIFont systemFontOfSize:12];
    [cityLabel setTextAlignment:NSTextAlignmentLeft];
    [_schView addSubview:cityLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 22, 223, 20)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = self.schedule.content.text;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [contentLabel setTextAlignment:NSTextAlignmentLeft];
    [_schView addSubview:contentLabel];
    
    weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 40, 40)];
    weatherLabel.backgroundColor = [UIColor clearColor];
    weatherLabel.textColor = [UIColor blackColor];
    weatherLabel.font = [UIFont systemFontOfSize:22];
    [weatherLabel setTextAlignment:NSTextAlignmentCenter];
    [_schView addSubview:weatherLabel];
    
    UIImageView *weatherImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qing.png"]];
    weatherImage.frame = CGRectMake(280, 5, 35, 35);
    [_schView addSubview:weatherImage];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activity.frame = CGRectMake(260, 15, 20, 20);
    [_schView addSubview:_activity];
    [_activity startAnimating];
    
    for (NSMutableDictionary *dic in [WeatherRequestManager defaultManager].scheduleCityWeatherArray)
    {
        if ([self.schedule.place isEqualToString:[dic objectForKey:@"schCity"]])
        {
            self.weatherinfo = [dic objectForKey:@"weather"];
            
            Weather *tempwea = [self.weatherinfo.weathers objectAtIndex:0];
            
            int temperature = tempwea.temperature;
            
            weatherLabel.text = [NSString stringWithFormat:@"%d˚",temperature];
            
            int _type = self.schedule.type;
            
            if (_type==0)
            {
                self.scheduleTypeView.image = [UIImage imageNamed:@"huiyi_large_color.png"];
            }
            if (_type==1)
            {
                self.scheduleTypeView.image = [UIImage imageNamed:@"juhui_large_color.png"];
            }
            if (_type==2)
            {
                self.scheduleTypeView.image = [UIImage imageNamed:@"yundong_large_color.png"];
            }
            if (_type==3)
            {
                self.scheduleTypeView.image = [UIImage imageNamed:@"lifu_large_color.png"];
            }
            
            [_activity stopAnimating];
            _activity.hidden=YES;
            
            [self requestRecommendWith:self.weatherinfo];
        }
    }
    
    AVQuery *query = [WeatherType query];
    [query whereKey:@"weatherCode" equalTo:[NSNumber numberWithInt:[self.weatherinfo.weathers[0] weatherCode]]];
    [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        NSString *str = [object objectForKey:@"name"];
        
        if ([str isEqualToString:@"风"])
        {
            weatherImage.image = [UIImage imageNamed:@"feng.png"];
        }
        if ([str isEqualToString:@"雨"])
        {
            weatherImage.image = [UIImage imageNamed:@"yu.png"];
        }
        if ([str isEqualToString:@"雪"])
        {
            weatherImage.image = [UIImage imageNamed:@"xue.png"];
        }
        if ([str isEqualToString:@"晴"])
        {
            weatherImage.image = [UIImage imageNamed:@"qing.png"];
        }
        if ([str isEqualToString:@"雾"])
        {
            weatherImage.image = [UIImage imageNamed:@"wu.png"];
        }
        
    }];
    
    CGRect _frame;
    
    NSLog(@"%f",self.frame.size.height);
    
    if (self.frame.size.height>480)
    {
        self.h=0;
        _frame = CGRectMake(50, 55, 220, 340);
    }
    else
    {
        self.h=100;
        _frame = CGRectMake(40, 55, 250, 340);
    }
    
    self.personView = [[AsyncImageView alloc] initWithFrame:_frame ImageState:1];
    self.personView.backgroundColor = [UIColor clearColor];
    self.personView.scaleState = 1;
    [self.personView addTarget:self action:@selector(didSelectScheduleCloth) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.personView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-320+self.h, 100, 20)];
    label1.text = @"穿搭建议";
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentLeft;
    [self addSubview:label1];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(20, self.frame.size.height-298+self.h, 60, 1)];
    lineview.backgroundColor = [UIColor blackColor];
    [self addSubview:lineview];
    
    self.suggestinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-290+self.h, 90, 60)];
    self.suggestinfoLabel.textColor = [UIColor blackColor];
    self.suggestinfoLabel.numberOfLines=0;
    self.suggestinfoLabel.text = @"暂无推荐";
    self.suggestinfoLabel.font = [UIFont systemFontOfSize:14];
    self.suggestinfoLabel.backgroundColor = [UIColor clearColor];
    self.suggestinfoLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.suggestinfoLabel];
    
    self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.frame.size.height-230+self.h, 100, 60)];
    self.brandLabel.textColor = [UIColor blackColor];
    self.brandLabel.backgroundColor = [UIColor clearColor];
    [self.brandLabel setTextAlignment:NSTextAlignmentLeft];
    self.brandLabel.font = [UIFont systemFontOfSize:20];
    self.brandLabel.adjustsFontSizeToFitWidth = YES;
    self.brandLabel.numberOfLines=0;
    self.brandLabel.lineBreakMode = NSLineBreakByClipping;
    [self addSubview:self.brandLabel];
}

- (void)checkWeather
{
    for (NSMutableDictionary *dic in [WeatherRequestManager defaultManager].scheduleCityWeatherArray)
    {
        if ([self.schedule.place isEqualToString:[dic objectForKey:@"schCity"]])
        {
            self.weatherinfo = [dic objectForKey:@"weather"];
            
            Weather *tempwea = [self.weatherinfo.weathers objectAtIndex:0];
            
            int temperature = tempwea.temperature;
            
            weatherLabel.text = [NSString stringWithFormat:@"%d˚",temperature];
            
            [_activity stopAnimating];
            _activity.hidden=YES;
            
            [self requestRecommendWith:self.weatherinfo];
        }
    }
}

- (void)requestRecommendWith:(WeatherInfo *)info
{
    
    __block typeof(self) bself = self;
    
    Weather *tempwea = [info.weathers objectAtIndex:0];
    
    int temperature = tempwea.temperature;
    
    [[ALBazaarEngine defauleEngine] getPhototWithTemperature:temperature weatherCode:tempwea.weatherCode isOfficial:YES latitude:0 longitude:0 block:^(AVObject *object, NSError *error) {
        
        if (object!=nil && !error)
        {
            Photo *temp = (Photo *)object;
            
            if (temp.originalURL.length>0)
            {
                bself.schedulePhoto = temp;
            }
            
            bself.personView.urlString = temp.originalURL;
            
            NSMutableString *str = [NSMutableString string];
            
            for (int i=0; i<temp.collocation.count; i++)
            {
                NSDictionary *dic = [temp.collocation objectAtIndex:i];
                
                if (i==0)
                {
                    NSString *str1 = [dic objectForKey:@"裤子"];
                    
                    if (str1.length>0)
                    {
                        [str appendFormat:@"%@",str1];
                    }
                }
                if (i==1)
                {
                    NSString *str2 = [dic objectForKey:@"鞋子"];
                    
                    if (str2.length>0)
                    {
                        [str insertString:[NSString stringWithFormat:@"\n+%@",str2] atIndex:str.length];
                    }
                }
                if (i==2)
                {
                    NSString *str3 = [dic objectForKey:@"外套"];
                    
                    if (str3.length>0)
                    {
                        [str insertString:[NSString stringWithFormat:@"\n+%@",str3] atIndex:str.length];
                    }
                }
            }
            
            //NSString *str4 = [dic objectForKey:@"内衣"];
            //NSString *str5 = [dic objectForKey:@"毛衣"];
            //NSString *str6 = [[dic objectForKey:@"配饰"] objectAtIndex:0];
            //NSString *str7 = [[dic objectForKey:@"配饰"] objectAtIndex:1];
            //NSString *str8 = [[dic objectForKey:@"配饰"] objectAtIndex:2];
            
            if (str.length==0)
            {
                bself.suggestinfoLabel.text = @"暂无推荐";
                bself.suggestinfoLabel.frame = CGRectMake(20, self.frame.size.height-290+self.h-20, 90, 60);
            }
            
            if (temp.collocation.count==0)
            {
                
                bself.brandLabel.text = @"";
            }
            else
            {
                NSString *b = temp.brand.name;
                CGSize _brandSize = [b sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(100, 60) lineBreakMode:0];
                bself.brandLabel.frame = CGRectMake(20, self.frame.size.height-230+bself.h, _brandSize.width, _brandSize.height);
                bself.brandLabel.text = b;
            }
        }
        else
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
            //            [alert show];
        }
    }];
    
}

- (void)didSelectScheduleCloth
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDSELECTSCHEDULEPHOTO object:self.schedulePhoto];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self requestRecommendWith:self.weatherinfo];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
