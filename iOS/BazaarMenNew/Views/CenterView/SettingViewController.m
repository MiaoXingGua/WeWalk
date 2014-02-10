//
//  SettingViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-11.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "SettingViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "ALBazaarSDK.h"
#import "SettingCell.h"
#import "AddCityViewController.h"
#import "ScheduleRequestManager.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize datalist = _datalist;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCity) name:REFRESHCITY object:nil];

    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    backImageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:backImageview];
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"设置";
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
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.backgroundView addSubview:_tableView];
    
    NSString *doc2 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.ImageCachePath = [doc2 stringByAppendingPathComponent:@"/ImageCache"];
    self.cacheDBPath = [doc2 stringByAppendingPathComponent:@"/com.stattek.dev"];
    
    NSString *_cacheSize = [self fileSizeAtPath];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"myCity"]];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"添加默认城市" forKey:@"title"];
    [dic setValue:array forKey:@"content"];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"阅读设置" forKey:@"title"];
    [dic2 setValue:_cacheSize forKey:@"content"];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"其他设置" forKey:@"title"];
    [dic3 setValue:[NSArray arrayWithObjects:@"意见反馈",@"给我评分",@"关于我们",@"注销", nil] forKey:@"content"];
    
    [self.datalist addObject:dic];
    [self.datalist addObject:dic2];
    [self.datalist addObject:dic3];
}

-(NSString *)fileSizeAtPath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    float imageCacheSize=0,webUrlCacheSize=0,cacheDBSize=0;
    
    if(self.ImageCachePath)
    {
        NSArray *imageCacheArray = [fileManager contentsOfDirectoryAtPath:self.ImageCachePath error:nil];
        
        for(int i = 0; i<imageCacheArray.count; i++)
            
        {
            
            NSString *fullPath = [self.ImageCachePath stringByAppendingPathComponent:[imageCacheArray objectAtIndex:i]];
            
            
            
            BOOL isDir;
            
            if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
                
            {
                
                NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
                
                imageCacheSize+= fileAttributeDic.fileSize/ 1024.0/1024.0;
                
            }
        }
    }
    
    if(self.cacheDBPath)
    {
        NSArray *cacheDBArray = [fileManager contentsOfDirectoryAtPath:self.cacheDBPath error:nil];
        
        for(int i = 0; i<cacheDBArray.count; i++)
            
        {
            
            NSString *fullPath = [self.cacheDBPath stringByAppendingPathComponent:[cacheDBArray objectAtIndex:i]];
            
            
            BOOL isDir;
            
            if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
                
            {
                
                NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
                
                cacheDBSize+= fileAttributeDic.fileSize/ 1024.0/1024.0;
                
            }
        }
    }
    
    
    float totalSize = imageCacheSize+webUrlCacheSize+cacheDBSize;

    NSString *str = [NSString stringWithFormat:@"%.2f",totalSize];
    if ([str isEqualToString:@"0.00"])
    {
        return @"0";
    }
    
    return str;
    
}

- (void)refreshCity
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"myCity"]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"添加默认城市" forKey:@"title"];
    [dic setValue:array forKey:@"content"];
    
    [self.datalist removeObjectAtIndex:0];
    
    [self.datalist insertObject:dic atIndex:0];
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0)
    {
        NSMutableArray *array = [[self.datalist objectAtIndex:0] objectForKey:@"content"];
        
        return array.count;
    }
    
    if (section==1)
    {
        return 1;
    }
    
    
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor blackColor];
    [headView addSubview:line];
    
    if (section==0)
    {
        titleLabel.text = [[self.datalist objectAtIndex:0] objectForKey:@"title"];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"+_image0001.png"]];
        imageview.frame = CGRectMake(285, 15, 15, 15);
        [headView addSubview:imageview];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        [btn addTarget:self action:@selector(addCity) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    
    if (section==1)
    {
        titleLabel.text = [[self.datalist objectAtIndex:1] objectForKey:@"title"];
    }
    
    if (section==2)
    {
        titleLabel.text = [[self.datalist objectAtIndex:2] objectForKey:@"title"];
    }
    
    return headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndifier = @"cell";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndifier];
    
    if (cell==nil)
    {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section==0)
    {
        cell.contentLabel.hidden=YES;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"useCity"]];
        
        NSString *city = [dic objectForKey:@"cityname"];
        NSString *district = [dic objectForKey:@"districtname"];
        
        NSMutableArray *array = [[self.datalist objectAtIndex:0] objectForKey:@"content"];

        NSString *name = [[array objectAtIndex:indexPath.row] objectForKey:@"cityname"];
        
        if (district.length==0)
        {
            if ([name isEqualToString:city])
            {
                cell.iconView.hidden=NO;
                cell.iconView.frame = CGRectMake(25, 13, 32/2, 29/2);
                cell.iconView.image = [UIImage imageNamed:@"select_image0001.png"];
            }
            else
            {
                cell.iconView.hidden=YES;
                cell.iconView.image = nil;
            }
        }
        else
        {
            if ([name isEqualToString:district])
            {
                cell.iconView.hidden=NO;
                cell.iconView.frame = CGRectMake(25, 13, 32/2, 29/2);
                cell.iconView.image = [UIImage imageNamed:@"select_image0001.png"];
            }
            else
            {
                cell.iconView.hidden=YES;
                cell.iconView.image = nil;
            }
        }
        
        cell.titleLable.frame = CGRectMake(50, 0, 200, 40);
        cell.titleLable.text = name;
        
    }
    
    if (indexPath.section==1)
    {
        cell.titleLable.frame = CGRectMake(65, 2, 150, 40);
        cell.titleLable.text = @"清除缓存";
        
        cell.contentLabel.hidden=NO;
        cell.contentLabel.textAlignment = NSTextAlignmentRight;
        cell.contentLabel.frame = CGRectMake(200, 0, 100, 40);
        NSString *str = [[self.datalist objectAtIndex:1] objectForKey:@"content"];
        
        if ([str isEqualToString:@"0"])
        {
            cell.contentLabel.text = @"";
        }
        else
        {
            cell.contentLabel.text = [NSString stringWithFormat:@"%@M",[[self.datalist objectAtIndex:1] objectForKey:@"content"]];;
        }
        
        
        cell.iconView.hidden=NO;
        cell.iconView.frame = CGRectMake(40, 15, 27/2, 28/2);
        cell.iconView.image = [UIImage imageNamed:@"refresh_image.png"];
    }
    
    if (indexPath.section==2)
    {
        cell.iconView.hidden=NO;
        cell.contentLabel.hidden=YES;
        
        cell.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"set_image000%d.png",indexPath.row+1]];
        
        cell.titleLable.text = [[[self.datalist objectAtIndex:2] objectForKey:@"content"] objectAtIndex:indexPath.row];
        
        if (indexPath.row==0)
        {
            cell.iconView.frame = CGRectMake(40, 13, 25, 25);
            cell.titleLable.frame = CGRectMake(70, 3, 100, 40);
        }
        if (indexPath.row==1)
        {
            cell.iconView.frame = CGRectMake(40, 7, 25, 25);
            cell.titleLable.frame = CGRectMake(70, 0, 100, 40);
        }
        if (indexPath.row==2)
        {
            cell.iconView.frame = CGRectMake(40, 8, 25, 25);
            cell.titleLable.frame = CGRectMake(70, 0, 100, 40);
        }
        if (indexPath.row==3)
        {
            cell.iconView.frame = CGRectMake(40, 8, 25, 25);
            cell.titleLable.frame = CGRectMake(70, 0, 100, 40);
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        NSMutableArray *array = [[self.datalist objectAtIndex:0] objectForKey:@"content"];
        
        NSMutableDictionary *dic = [array objectAtIndex:indexPath.row];
        
        NSString *city = [dic objectForKey:@"cityname"];
        NSString *belong = [dic objectForKey:@"belong"];
        
        NSLog(@"%@,%@",city,belong);
        
        NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
        [dic2 setValue:belong forKey:@"cityname"];
        [dic2 setValue:city forKey:@"districtname"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"useCity"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHCITY object:nil];
        
        
        [_tableView reloadData];
    }
    
    if (indexPath.section==1)
    {
        if ([[[self.datalist objectAtIndex:1] objectForKey:@"content"] isEqualToString:@"0"])
        {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要清除图片缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
        [alert show];
    }
    
    if (indexPath.section==2)
    {
        if (indexPath.row==3)
        {
            [self logOut];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datalist.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BOOL deleteSelectCity=NO;
        
        NSMutableArray *array = [[self.datalist objectAtIndex:0] objectForKey:@"content"];
        
        NSString *_deleCityname = [[array objectAtIndex:indexPath.row] objectForKey:@"cityname"];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"useCity"]];
        
        NSString *city = [dic objectForKey:@"cityname"];
        NSString *district = [dic objectForKey:@"districtname"];
        
        if (district.length==0)
        {
            if ([city isEqualToString:_deleCityname])
            {
                deleteSelectCity=YES;
            }
        }
        else
        {
            if ([district isEqualToString:_deleCityname])
            {
                deleteSelectCity=YES;
            }
        }
        
        [array removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
        
        //删除选中城市
        if (deleteSelectCity==YES)
        {
            if (array.count==0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myCity"];
                
                [self addCity];
                
                return;
            }
            else
            {
                NSMutableDictionary *dic = [array objectAtIndex:0];
                NSString *city = [dic objectForKey:@"cityname"];
                NSString *belong = [dic objectForKey:@"belong"];
                
                NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
                [dic2 setValue:belong forKey:@"cityname"];
                [dic2 setValue:city forKey:@"districtname"];
                [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"useCity"];
            }
        }
        else
        {
            if (array.count==0)
            {
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"myCity"];
                
                [self addCity];
                
                return;
            }
        }

        
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"myCity"];

        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHCITY object:nil];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self removeImageCache];
    }
}

#pragma mark - 清除缓存
- (void)removeImageCache
{
    [ProgressHUD show:@"清除中"];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    //根据文件地址删除沙盒内文件
    [fileManage removeItemAtPath:self.ImageCachePath error:nil];
    [fileManage removeItemAtPath:self.cacheDBPath error:nil];
    
    NSMutableDictionary *dic = [self.datalist objectAtIndex:1];
    [dic setValue:@"0" forKey:@"content"];
    
    [_tableView reloadData];
    
    [self performSelector:@selector(completeRemoveCache) withObject:nil afterDelay:0.5];
}

- (void)completeRemoveCache
{
    [ProgressHUD showSuccess:@"完成"];
}

#pragma mark - 添加城市
- (void)addCity
{
    AddCityViewController *cityview = [[AddCityViewController alloc] init];
    [self presentViewController:cityview animated:YES completion:nil];
}

#pragma mark - 登出
- (void)logOut
{
    [[ScheduleRequestManager defaultManager].scheduleArray removeAllObjects];
    
    [[ALBazaarEngine defauleEngine] logOut];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTUSER object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHCITY object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
