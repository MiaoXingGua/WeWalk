//
//  RecommendView.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-15.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "RecommendView.h"
#import "ALBazaarSDK.h"
#import "ALGPSHelper.h"

@implementation RecommendView
@synthesize recommendDelegate;
@synthesize clothStr;
@synthesize streetPhoto;
@synthesize examplePhoto;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect _frame;
        float _height;
        BOOL isphone5;
        
        NSLog(@"%f",self.frame.size.height);
        if (self.frame.size.height>450)
        {
            _frame = CGRectMake(25, 30, 200, 380);
            _height=0;
            isphone5=YES;
        }
        else
        {
            _frame = CGRectMake(15, 30, 230, 360);
            _height = 15;
            isphone5=NO;
        }
        
        isShowExample = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCity) name:REFRESHCITY object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPM25) name:REFRESHPM25 object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeather) name:COMPLETEREFRESHWEATHER object:nil];
        
        self.clothStr = [NSMutableString stringWithCapacity:0];
        
        UIView *personview1 = [[UIView alloc] initWithFrame:CGRectZero];
        personview1.clipsToBounds = YES;
        personview1.backgroundColor = [UIColor whiteColor];
        
        if (isphone5==YES)
        {
            personview1.frame = CGRectMake(25, 30, 190, 380);
        }
        else
        {
            personview1.frame = CGRectMake(15, 30, 200, 350);
        }
        [self addSubview:personview1];
        
        
        self.personView = [[AsyncImageView alloc] initWithFrame:_frame ImageState:1];
        self.personView.scaleState = 1;
        self.personView.backgroundColor = [UIColor clearColor];
        [self.personView addTarget:self action:@selector(didSelectExampleClother) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.personView];
        
        self.personView_street = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, personview1.frame.size.width, personview1.frame.size.height) ImageState:1];
        self.personView_street.scaleState = 1;
        self.personView_street.backgroundColor = [UIColor whiteColor];
        [self.personView_street addTarget:self action:@selector(didSelectStreetClother) forControlEvents:UIControlEventTouchUpInside];
        self.personView_street.alpha = 0;
        self.personView_street.hidden=YES;
        [personview1 addSubview:self.personView_street];
        
        
        exampleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        exampleBtn.frame = CGRectMake(10, 10, 40, 30);
        [exampleBtn setTitle:@"示范" forState:UIControlStateNormal];
        [exampleBtn addTarget:self action:@selector(selectExample) forControlEvents:UIControlEventTouchUpInside];
        [exampleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        exampleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:exampleBtn];
        
        UIView *lineview =[[UIView alloc] initWithFrame:CGRectMake(53, 15, 1, 20)];
        lineview.backgroundColor = [UIColor blackColor];
        [self addSubview:lineview];
        
        streetSnapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        streetSnapBtn.frame = CGRectMake(55, 10, 40, 30);
        [streetSnapBtn setTitle:@"街拍" forState:UIControlStateNormal];
        [streetSnapBtn addTarget:self action:@selector(selectStreetSnap) forControlEvents:UIControlEventTouchUpInside];
        [streetSnapBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        streetSnapBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:streetSnapBtn];
        
        
        self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 37, 80, 40)];
        self.brandLabel.textColor = [UIColor blackColor];
        self.brandLabel.backgroundColor = [UIColor clearColor];
        [self.brandLabel setTextAlignment:NSTextAlignmentLeft];
        self.brandLabel.font = [UIFont systemFontOfSize:15];
        self.brandLabel.adjustsFontSizeToFitWidth = YES;
        self.brandLabel.numberOfLines=0;
        self.brandLabel.lineBreakMode = NSLineBreakByClipping;
        [self addSubview:self.brandLabel];
        
        weatherImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qing.png"]];
        weatherImage.frame = CGRectMake(275, 7, 35, 35);
        [self addSubview:weatherImage];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"useCity"]];
        
        NSString *city = [dic objectForKey:@"cityname"];
        NSString *district = [dic objectForKey:@"districtname"];
        
        cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(143, 15, 125, 30)];
        cityLabel.textColor = [UIColor blackColor];
        cityLabel.backgroundColor = [UIColor clearColor];
        [cityLabel setTextAlignment:NSTextAlignmentRight];
        cityLabel.font = [UIFont systemFontOfSize:18];
        cityLabel.font = [UIFont boldSystemFontOfSize:18];
        cityLabel.adjustsFontSizeToFitWidth = YES;
        cityLabel.lineBreakMode = NSLineBreakByClipping;
        [self addSubview:cityLabel];
        
        if (district.length==0)
        {
            cityLabel.text = city;
        }
        else
        {
            cityLabel.text = district;
        }
        
        temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 30, 90, 80)];
        temperatureLabel.text = @"--";
        temperatureLabel.backgroundColor = [UIColor clearColor];
        temperatureLabel.font = [UIFont systemFontOfSize:50];
        //temperatureLabel.font =[UIFont fontWithName:@"Garamond" size:30];
        [temperatureLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:temperatureLabel];
        
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.frame = CGRectMake(298, 68, 10, 10);
        _activity.hidden=YES;
        [self addSubview:_activity];
      
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 98, 90, 20)];
        dateLabel.backgroundColor = [UIColor clearColor];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        dateLabel.font = [UIFont systemFontOfSize:15];
        dateLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        dateLabel.text = @"--/--/--";
        [self addSubview:dateLabel];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(222, 118, 86, 0.5)];
        line1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:line1];
        
        pollutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 120, 90, 20)];
        pollutionLabel.backgroundColor = [UIColor clearColor];
        [pollutionLabel setTextAlignment:NSTextAlignmentCenter];
        pollutionLabel.font = [UIFont systemFontOfSize:15];
        pollutionLabel.adjustsFontSizeToFitWidth = YES;
        pollutionLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1];
        pollutionLabel.text = @"污染指数:--";
        [self addSubview:pollutionLabel];
        
        hightlowLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 138, 90, 20)];
        hightlowLabel.text = @"最高--/最低--";
        hightlowLabel.backgroundColor = [UIColor clearColor];
        [hightlowLabel setTextAlignment:NSTextAlignmentCenter];
        hightlowLabel.font = [UIFont systemFontOfSize:11];
        hightlowLabel.textColor = [UIColor blackColor];
        [self addSubview:hightlowLabel];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(222, 160, 86, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self addSubview:line2];

        UIButton *scheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scheduleBtn.frame = CGRectMake(240, 175-_height/2, 118/2, 118/2);
        [scheduleBtn setImage:[UIImage imageNamed:@"首页_0006_图层-13.png"] forState:UIControlStateNormal];
        [scheduleBtn addTarget:self action:@selector(didSelectedAllSchedule) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:scheduleBtn];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(239, scheduleBtn.frame.origin.y+60, 60, 20)];
        label1.text = @"全部日程";
        label1.font = [UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.backgroundColor =[UIColor clearColor];
        [self addSubview:label1];
        
        UIButton *addScheduleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addScheduleBtn.frame = CGRectMake(240, scheduleBtn.frame.origin.y+scheduleBtn.frame.size.height+28-_height/5, 118/2, 118/2);
        [addScheduleBtn setImage:[UIImage imageNamed:@"首页_0007_图层-12.png"] forState:UIControlStateNormal];
        [addScheduleBtn addTarget:self action:@selector(didSelectedAddSchedule) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addScheduleBtn];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(239, addScheduleBtn.frame.origin.y+60, 60, 20)];
        label2.text = @"添加日程";
        label2.font = [UIFont systemFontOfSize:13];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.backgroundColor =[UIColor clearColor];
        [self addSubview:label2];
        
        UIButton *fortuneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fortuneBtn.frame = CGRectMake(240, addScheduleBtn.frame.origin.y+addScheduleBtn.frame.size.height+28-_height/5, 118/2, 118/2);
        [fortuneBtn setImage:[UIImage imageNamed:@"首页_0008_图层-11.png"] forState:UIControlStateNormal];
        [fortuneBtn addTarget:self action:@selector(didSelectedFortune) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fortuneBtn];

        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(239, fortuneBtn.frame.origin.y+60, 60, 20)];
        label3.text = @"职场运势";
        label3.textColor = [UIColor colorWithRed:0.32 green:0.76 blue:0.96 alpha:1];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textAlignment = NSTextAlignmentCenter;
        label3.backgroundColor =[UIColor clearColor];
        [self addSubview:label3];

        UILabel *suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 390-_height*1.2, 100, 20)];
        suggestLabel.backgroundColor = [UIColor clearColor];
        suggestLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        suggestLabel.textAlignment = NSTextAlignmentLeft;
        suggestLabel.text = @"穿搭建议";
        suggestLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:suggestLabel];
        
        self.suggestinfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 406-_height*1.2, 220, 20)];
        self.suggestinfoLabel.backgroundColor = [UIColor clearColor];
        self.suggestinfoLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        self.suggestinfoLabel.textAlignment = NSTextAlignmentLeft;
        self.suggestinfoLabel.adjustsFontSizeToFitWidth=YES;
        self.suggestinfoLabel.text = @"暂无推荐"; 
        self.suggestinfoLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:self.suggestinfoLabel];
        
    }
    
    return self;
}

#pragma mark - 请求今日推荐
- (void)requestStreetImage
{
    __block typeof(self) bself = self;
    
    NSLog(@"%f,%f",[ALGPSHelper OpenGPS].latitude,[ALGPSHelper OpenGPS].longitude);
  
    [[ALBazaarEngine defauleEngine] getPhototWithTemperature:temperature weatherCode:weaCode isOfficial:NO latitude:[ALGPSHelper OpenGPS].latitude longitude:[ALGPSHelper OpenGPS].longitude block:^(AVObject *object, NSError *error) {
        
        if (object!=nil)
        {
            Photo *temp = (Photo *)object;
            
            if (temp.originalURL.length>0)
            {
                bself.streetPhoto = temp;
            }
            bself.personView_street.urlString = temp.originalURL;
        }
    }];
}
- (void)requestModelImage
{
    __block typeof(self) bself = self;

    [[ALBazaarEngine defauleEngine] getPhototWithTemperature:temperature weatherCode:weaCode isOfficial:YES latitude:0 longitude:0 block:^(AVObject *object, NSError *error) {
        
        if (object!=nil)
        {
            Photo *temp = (Photo *)object;
            
            if (temp.originalURL.length>0)
            {
                bself.examplePhoto = temp;
            }
            
            bself.personView.urlString = temp.originalURL;
            
            
            NSString *string = @"";

            for (int i=0; i<4; i++)
            {                
                NSString *str = [temp.collocation[i] allValues][0];
                
                if (str.length)
                {
                    if (string.length)
                    {
                        string = [string stringByAppendingString:@"+"];
                    }
                    
                    string = [string stringByAppendingString:str];
                }
            }
            
            //            NSString *str4 = [dic objectForKey:@"内衣"];
            //            NSString *str5 = [dic objectForKey:@"毛衣"];
            //            NSString *str6 = [[dic objectForKey:@"配饰"] objectAtIndex:0];
            //            NSString *str7 = [[dic objectForKey:@"配饰"] objectAtIndex:1];
            //            NSString *str8 = [[dic objectForKey:@"配饰"] objectAtIndex:2];
            
            
            if (temp.collocation.count==0)
            {
                bself.brandLabel.text = @"";
            }
            else
            {
                NSString *b = temp.brand.name;
                CGSize _brandSize = [b sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(80, 40) lineBreakMode:0];
                
                bself.brandLabel.frame = CGRectMake(15, 37, _brandSize.width, _brandSize.height);
                bself.brandLabel.text = b;
                
                if (string.length>0)
                {
                    bself.suggestinfoLabel.text = string;
                }
                else
                {
                    bself.suggestinfoLabel.text = @"暂无推荐";
                }
            }
            
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"今日推荐加载错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
//            [alert show];
        }
    }];

  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self requestModelImage];
    }
}

#pragma mark - 刷新城市
- (void)refreshCity
{
    [[WeatherRequestManager defaultManager] requestWeather];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"useCity"]];
    
    NSString *city = [dic objectForKey:@"cityname"];
    NSString *district = [dic objectForKey:@"districtname"];
    

    if (district.length==0)
    {
        cityLabel.text = city;
    }
    else
    {
        cityLabel.text = district;
    }
    
    temperatureLabel.text = @"--";
    pollutionLabel.text = @"污染指数:--";
    hightlowLabel.text = @"最高--/最低--";

}

#pragma mark - 刷新天气
- (void)refreshWeather
{
    WeatherInfo *tempweatherInfo = [WeatherRequestManager defaultManager].weatherinfo;
    
    Weather *tempweather = [tempweatherInfo.weathers objectAtIndex:0];
    
    weaCode = tempweather.weatherCode;
    
    temperature = tempweather.temperature;
    
    int high = [[tempweatherInfo.weathers objectAtIndex:1] high];
    int low = [[tempweatherInfo.weathers objectAtIndex:1] low];
    
    NSLog(@"温度：%f,最高：%f,最低：%f",tempweather.temperature,tempweather.high,tempweather.low);
    
    __block typeof(self) bself = self;

    __block UILabel *__datelabel = dateLabel;
    
    [[ALWeatherEngine defauleEngine] currentDateWithBlock:^(NSDate *date) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        __datelabel.text = destDateString;
        
        [bself showTextAnimation:__datelabel];
        
    }];
    
    if ([[WeatherRequestManager defaultManager].weatherState isEqualToString:@"风"])
    {
        weatherImage.image = [UIImage imageNamed:@"feng.png"];
    }
    if ([[WeatherRequestManager defaultManager].weatherState isEqualToString:@"雨"])
    {
        weatherImage.image = [UIImage imageNamed:@"yu.png"];
    }
    if ([[WeatherRequestManager defaultManager].weatherState isEqualToString:@"雪"])
    {
        weatherImage.image = [UIImage imageNamed:@"xue.png"];
    }
    if ([[WeatherRequestManager defaultManager].weatherState isEqualToString:@"晴"])
    {
        weatherImage.image = [UIImage imageNamed:@"qing.png"];
    }
    if ([[WeatherRequestManager defaultManager].weatherState isEqualToString:@"雾"])
    {
        weatherImage.image = [UIImage imageNamed:@"wu.png"];
    }
    
    temperatureLabel.text = [NSString stringWithFormat:@"%d˚",temperature];
    hightlowLabel.text = [NSString stringWithFormat:@"最高%d˚/最低%d˚",high,low];
    
    [self showTextAnimation:temperatureLabel];
    
    [self requestModelImage];
    [self requestStreetImage];
}

#pragma mark - 刷新PM25
- (void)refreshPM25
{
    pollutionLabel.text = [NSString stringWithFormat:@"污染指数:%d",[WeatherRequestManager defaultManager].PM25Num];
   // [self showTextAnimation:pollutionLabel];
}


- (void)roteAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    
    //围绕Z轴旋转，垂直与屏幕
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1.0)];
    
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = 100000000;
    
   // [rotateView.layer addAnimation:animation forKey:nil];
}

#pragma mark - 示范/街拍
- (void)selectExample
{
    self.brandLabel.hidden=NO;
    
    [exampleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [streetSnapBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.personView.alpha = 1;
        self.personView_street.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        self.personView_street.hidden=YES;
        
    }];
}

- (void)selectStreetSnap
{
    self.personView_street.hidden=NO;
    self.brandLabel.hidden=YES;
    
    [exampleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [streetSnapBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.personView.alpha = 0;
        self.personView_street.alpha = 1;
        
    } completion:nil];
}

#pragma mark - 代理
- (void)didSelectExampleClother
{
    [recommendDelegate didSelectExampleClother:self.examplePhoto];
}

- (void)didSelectStreetClother
{
    [recommendDelegate didSelectStreetClother:self.streetPhoto];
}

- (void)didSelectedAllSchedule
{
    [recommendDelegate didSelectedAllSchedule:@""];
}

- (void)didSelectedAddSchedule
{
    [recommendDelegate didSelectedAddSchedule:@""];
}

- (void)didSelectedFortune
{
    [recommendDelegate didselectedFortune:@""];
}

- (void)tap:(UIGestureRecognizer *)sender
{
    if (isOpen==YES)
    {
        [self close];
    }
    else
    {
        [self open];
    }
}

- (void)pan:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _beginPoint = [sender locationInView:weatherView];
    }
    
    
    CGPoint currentPoint = [sender locationInView:weatherView];
    
    float disX = currentPoint.x - _beginPoint.x;
    
    weatherView.center = CGPointMake(weatherView.center.x+disX, 100);
    
    
    if (sender.state==UIGestureRecognizerStateChanged)
    {
        float _x = weatherView.center.x;
        
        if (_x<220)
        {
            weatherView.center = CGPointMake(220, 100);

            return;

        }
        
        if (_x>325)
        {
            weatherView.center = CGPointMake(325, 100);

            return;
        }
    }
    
    if (sender.state==UIGestureRecognizerStateEnded)
    {
        float _x = weatherView.center.x;
        
        if (_x<220)
        {
            isOpen=YES;
        }
        
        if (_x<220)
        {
            isOpen=YES;
            weatherView.center = CGPointMake(220, 100);
        }
        
        if (_x>325)
        {
            isOpen=NO;
            weatherView.center = CGPointMake(325, 100);
        }
    }
}

- (void)open
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        weatherView.center = CGPointMake(215, 100);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            weatherView.center = CGPointMake(220, 100);
        } completion:^(BOOL finished) {
            isOpen=YES;

        }];
    }];
}

- (void)close
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        weatherView.center = CGPointMake(330, 100);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            weatherView.center = CGPointMake(325, 100);

        } completion:^(BOOL finished) {
            
            isOpen=NO;

        }];
    }];
}

#pragma animation
- (void)showTextAnimation:(UILabel *)label
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [label.layer addAnimation: animation forKey: @"FadeIn"];
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
