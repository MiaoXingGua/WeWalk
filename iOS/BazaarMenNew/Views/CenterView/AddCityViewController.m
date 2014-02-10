//
//  AddCityViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-12.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "AddCityViewController.h"
#import "CityButton.h"
#import "SeacherCityCell.h"
#import "ALWeatherEngine.h"

@interface AddCityViewController ()

@end

@implementation AddCityViewController
@synthesize cityArray = _cityArray;
@synthesize myCityArray = _myCityArray;
@synthesize searchCityArray = _searchCityArray;


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
   
}

#pragma mark - 城市定位
- (BOOL)GPSstate
{
    if([CLLocationManager locationServicesEnabled]== YES)
    {
        if ([ALGPSHelper OpenGPS].canGPS==YES)
        {
            isAllowGPS = YES;
            
            [ProgressHUD show:@"定位中..."];
        }
        else
        {
            isAllowGPS = NO;
            
            [ProgressHUD showError:@"请在设置打开定位服务"];
        }
        
    }
    else
    {
        isAllowGPS = NO;
        [ProgressHUD showError:@"请在设置打开定位服务"];
    }
    
    
    if (isAllowGPS==NO)
    {
        [self performSelector:@selector(closeGPSView) withObject:nil afterDelay:2];
    }
    
    return isAllowGPS;
}

- (void)closeGPSView
{
    [ProgressHUD dismiss];
}

- (void)locationSuccess
{
    [ProgressHUD showSuccess:@"定位成功"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        __block typeof(self) bself = self;
        
        
        NSLog(@"city%@",[ALGPSHelper OpenGPS].administrativeArea);
        NSLog(@"qu%@",[ALGPSHelper OpenGPS].subLocality);
        
//        for (int i=0; i<[ALGPSHelper OpenGPS].administrativeArea.length; i++)
//        {
//            
//        }

//        [[ALWeatherEngine defauleEngine] getCityNameWithQueryCondition:[ALGPSHelper OpenGPS].administrativeArea block:^(NSArray *objects, NSError *error) {
//            
//            NSLog(@"%@",objects);
//            
//        }];
    }
}

- (void)locationError
{
    [ProgressHUD showError:@"定位失败"];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:GPSLOCATIONSUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationError) name:GPSLOCATIONERROR object:nil];

    
    NSArray *array = [NSArray arrayWithObjects:@"定位",@"北京",@"上海",@"广州",@"深圳",@"武汉",@"南京",@"西安",@"成都",@"郑州",@"杭州",@"东莞",@"重庆",@"长沙",@"天津",@"苏州",@"沈阳",@"福州",@"无锡",@"哈尔滨",@"厦门",@"石家庄",@"合肥",@"南昌",@"济南",@"佛山",@"大连",@"常州",@"太原",@"青岛",@"南宁",@"长春",@"昆明",@"兰州",@"宁波",@"汕头", nil];
    
    self.searchCityArray = [NSMutableArray arrayWithCapacity:0];
    
    self.cityArray = [NSMutableArray arrayWithCapacity:0];
    
    self.myCityArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"myCity"]];
    
    for (int i=0; i<array.count; i++)
    {
        BOOL iscollect=NO;
        NSString *name = [array objectAtIndex:i];
        NSString *collectname;
        for (NSMutableDictionary *dic in self.myCityArray)
        {
            collectname = [dic objectForKey:@"cityname"];
            
            if ([name isEqualToString:collectname])
            {
                iscollect=YES;
            }
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:name forKey:@"cityname"];
        [dic setValue:[NSNumber numberWithBool:iscollect] forKey:@"iscollect"];
        [self.cityArray addObject:dic];
    }
    
 
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"添加城市";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"close_image0001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 90-44)];
    top.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.backgroundView addSubview:top];
    
    searchtextfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 52, 310, 30)];
    searchtextfield.textAlignment = NSTextAlignmentLeft;
    searchtextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchtextfield.backgroundColor = [UIColor clearColor];
    searchtextfield.returnKeyType = UIReturnKeySearch;
    searchtextfield.font = [UIFont systemFontOfSize:15];
    searchtextfield.delegate = self;
    searchtextfield.borderStyle = UITextBorderStyleRoundedRect;
    [self.backgroundView addSubview:searchtextfield];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(320, 52, 40, 30);
    cancelBtn.backgroundColor = [UIColor grayColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cancelBtn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT-90)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (self.cityArray.count/3+1)*30+90);
    [self.backgroundView addSubview:_scrollView];
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 90, SCREEN_WIDTH, SCREEN_HEIGHT-90) style:UITableViewStylePlain];
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.separatorColor = [UIColor lightGrayColor];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    _tabelView.alpha = 0;
    [self.backgroundView addSubview:_tabelView];
    [self addHotCityView];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchCityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndifier = @"cell";
    
    SeacherCityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndifier];
    
    if (cell==nil)
    {
        cell = [[SeacherCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [self.searchCityArray objectAtIndex:indexPath.row];
    
    NSString *content = [dic objectForKey:@"districtName"];
    NSString *city = [dic objectForKey:@"cityName"];
    
    CGSize _size = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(1000, 50) lineBreakMode:0];
    
    cell.contentLabel.frame = CGRectMake(15, 0, _size.width, 50);
    cell.contentLabel.text = content;
    
    cell.cityName.frame = CGRectMake(15+_size.width+10, 0, 100, 50);
    cell.cityName.text = [NSString stringWithFormat:@"-  %@",city];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *city = [[self.searchCityArray objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    
    NSString *districtName = [[self.searchCityArray objectAtIndex:indexPath.row] objectForKey:@"districtName"];

    if (self.setSchedle==YES)
    {
        [self.citydelegate didSelectedCity:districtName];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    [self addCollectCityWithName:city districtName:districtName];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)addCollectCityWithName:(NSString *)name districtName:(NSString *)district
{
    BOOL isCollect=NO;
    
    for (NSMutableDictionary *dic in self.myCityArray)
    {
        NSString *temp = [dic objectForKey:@"cityname"];
        
        if ([temp isEqualToString:district])
        {
            isCollect=YES;
        }
    }
    
    if (isCollect==YES)
    {
        [ProgressHUD showSuccess:@"城市已存在"];
        
        return;
    }
    else
    {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:district forKey:@"cityname"];
        [dic setValue:name forKey:@"belong"];
        [self.myCityArray addObject:dic];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.myCityArray forKey:@"myCity"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:name forKey:@"cityname"];
    [dic setValue:district forKey:@"districtname"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"useCity"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHCITY object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addHotCityView
{
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, (self.cityArray.count/3+1)*30+90)];
    cityView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:cityView];
    
    int linenum = self.cityArray.count/3+1;
    
    int m=0;
    
    for(int i=0; i<linenum; i++)
    {
        for(int j=0; j<3; j++)
        {
            if (m < self.cityArray.count)
            {
                NSString *name = [[self.cityArray objectAtIndex:m] objectForKey:@"cityname"];
                BOOL iscollect = [[[self.cityArray objectAtIndex:m] objectForKey:@"iscollect"] boolValue];
                
                CityButton *btn = [CityButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(20+100*j, 38*i, 80, 30);
                btn.isCollect = iscollect;
                btn.name = name;
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitle:name forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                btn.tag = 3000+m;
                [btn addTarget:self action:@selector(didselectCity:) forControlEvents:UIControlEventTouchUpInside];
                [cityView addSubview:btn];
                
                if (iscollect==YES)
                {
                    btn.titleLabel.font = [UIFont systemFontOfSize:18];
                    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                }
                
                m++;
            }
        }
    }

}


#pragma mark - 选择热门城市
- (void)didselectCity:(CityButton *)sender
{
    NSLog(@"cityname=%@",sender.name);
    
    if (self.setSchedle==YES)
    {
        [self.citydelegate didSelectedCity:sender.name];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
    
    if (sender.tag-3000==0)
    {
        if ([self GPSstate]==YES)
        {
            [[ALGPSHelper OpenGPS] refreshLocation];
        }
        
        return;
    }
    
    NSString *cityname = sender.name;
    
    if (sender.isCollect==YES)
    {
        [ProgressHUD showSuccess:@"城市已存在"];

        return;
    }
    else
    {
 
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:cityname forKey:@"cityname"];
        [dic setValue:cityname forKey:@"belong"];
        
        [self.myCityArray addObject:dic];
    }
  
    [[NSUserDefaults standardUserDefaults] setObject:self.myCityArray forKey:@"myCity"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:sender.name forKey:@"cityname"];
    [dic setValue:@"" forKey:@"districtname"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"useCity"];

    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHCITY object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)closeView
{
    if (self.setSchedle==NO)
    {
        NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"myCity"];
        if (array.count==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加一个城市" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GPSLOCATIONERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GPSLOCATIONSUCCESS object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSearchAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _tabelView.alpha = 1;
        searchtextfield.frame = CGRectMake(5, 52, 265, 30);
        cancelBtn.frame = CGRectMake(275, 52, 40, 30);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideSearchAnimation
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _tabelView.alpha = 0;
        searchtextfield.frame = CGRectMake(5, 52, 310, 30);
        cancelBtn.frame = CGRectMake(320, 52, 40, 30);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showSearchAnimation];
    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    __block typeof(self) bself = self;
    
    __block UITableView *__tableview = _tabelView;
    
    NSLog(@"%@",string);
    
    if (string.length==0)
    {
        return YES;
    }

    [[ALWeatherEngine defauleEngine] getCityNameWithQueryCondition:string block:^(NSArray *objects, NSError *error) {
        
        [bself.searchCityArray removeAllObjects];
        
        [bself.searchCityArray addObjectsFromArray:objects];
        
        [__tableview reloadData];
                
    }];
    
    return YES;
}


- (void)cancelSearch
{
    [searchtextfield resignFirstResponder];
    
    [self hideSearchAnimation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
