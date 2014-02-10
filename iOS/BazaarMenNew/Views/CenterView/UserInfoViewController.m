//
//  UserInfoViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "UserInfoViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "UserInfoCell.h"
#import "UserPhotoView.h"
#import "EditUserInfoViewController.h"
#import "ClothInfoViewController.h"
#import "PrivateLetterViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
@synthesize datalist = _datalist;
@synthesize countArray = _countArray;
@synthesize user = _user;
@synthesize attentionBtn;


- (id)initWithSelf:(BOOL)isSelf User:(AVUser *)user
{
    if (self = [super init])
    {
        self.isSelf = isSelf;
        self.user = user;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectPhotos:) name:DIDSELECTUSERPHOTO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:REFRESHUSERINFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverImageView:) name:REMOVECOVERIMAGEVIEW object:nil];
    
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];
    self.countArray = [NSMutableArray arrayWithCapacity:0];

    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    titleLabel.text = [self.user objectForKey:@"nickname"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_image_001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(userinfoback) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195)];
    view1.backgroundColor = [UIColor clearColor];
    
    headView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 282/2) ImageState:1];
    headView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    headView.scaleState=2;
    [headView addTarget:self action:@selector(tapCoverImage) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:headView];

    if (self.isSelf==NO)
    {
        UIButton *privateLetterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        privateLetterBtn.frame = CGRectMake(0, 0, 75, 75);
        privateLetterBtn.center = CGPointMake(55, headView.frame.size.height/2);
        [privateLetterBtn setImage:[UIImage imageNamed:@"_0001_私信.png"] forState:UIControlStateNormal];
        [privateLetterBtn addTarget:self action:@selector(sendLetter) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:privateLetterBtn];
        
        self.attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.attentionBtn.frame = CGRectMake(0, 0, 75, 75);
        self.attentionBtn.center = CGPointMake(265, headView.frame.size.height/2);
        [self.attentionBtn setBackgroundImage:[UIImage imageNamed:@"_0002_+关注.png"] forState:UIControlStateNormal];
        [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.attentionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.attentionBtn addTarget:self action:@selector(attentionOrRemoveUser) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:self.attentionBtn];
        
        if ([[ALBazaarEngine defauleEngine] isLoggedIn]==YES)
        {
            [self isHaveAttentionUser];
        }
        else
        {
            [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
       
    }
    
    
    UIImageView *headbackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxing.png"]];
    headbackView.userInteractionEnabled = YES;
    headbackView.frame = CGRectMake(0, 0, 82, 82);
    headbackView.center = CGPointMake(SCREEN_WIDTH/2, 140);
    [view1 addSubview:headbackView];
    
    NSLog(@"%@",[self.user objectForKey:@"smallHeadViewURL"]);
    
    userHeadView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 73, 73) ImageState:0];
    userHeadView.urlString = [self.user objectForKey:@"smallHeadViewURL"];
    [userHeadView addTarget:self action:@selector(editUserInfo) forControlEvents:UIControlEventTouchUpInside];
    userHeadView.center = CGPointMake(headbackView.frame.size.width/2, headbackView.frame.size.height/2);
    userHeadView.backgroundColor = [UIColor clearColor];
    [headbackView addSubview:userHeadView];
   
    float _h=0;
    if (self.view.frame.size.height>470)
    {
        _h = 20;
    }
    else
    {
        _h = 0;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44-_h) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = view1;
    [self.backgroundView addSubview:_tableView];
    
    [self refreshUserInfo:nil];
    [self requestUserPhotos];
}

- (void)requestUserPhotos
{
    [ProgressHUD show:@"加载中"];
    
    __block typeof(self) bself = self;
    
    __block UITableView *__tableview = _tableView;

    [[ALBazaarEngine defauleEngine] searchPhotoWithUser:self.user limit:20 lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] init];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyyMMdd"];
            
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                Photo *photo = obj;
                NSString *key = [formatter stringFromDate:photo.createdAt];
                
                NSMutableArray *arr = [dic1 valueForKey:key];
                if (!arr) {
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObject:photo];
                    [dic1 setValue:arr forKey:key];
                }
                else
                {
                    [arr addObject:photo];
                }
                
            }];

            
            NSMutableArray * list = [NSMutableArray arrayWithArray:[dic1.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                int a = [obj1 intValue];
                int b = [obj2 intValue];
                if (a>b)
                {
                    return NSOrderedAscending;
                }
                else if (a<b)
                {
                    return NSOrderedDescending;
                }
                
                return NSOrderedSame;
  
            }]];
            
            
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               
                [bself.datalist addObject:dic1[obj]];
                
            }];
            
            if (bself.isBack==YES)
            {
                return;
            }
            
            [__tableview reloadData];
            
            [ProgressHUD showSuccess:@"成功"];
            
        }
        else
        {
            NSLog(@"error=%@",error);
            [ProgressHUD showError:@"失败"];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellindifiter = @"cell";
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter];
    
    if (cell==nil)
    {
        cell = [[UserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSMutableArray *array = [self.datalist objectAtIndex:indexPath.row];

    
    int linenum;
    
    if (array.count%3==0)
    {
        linenum = array.count/3;
    }
    else
    {
        linenum = array.count/3+1;
    }
    
    if (self.countArray.count==0)
    {
        for (UIView *view in cell.photoView.subviews)
        {
            [view removeFromSuperview];
        }
        
        cell.photoView.frame = CGRectMake(100, 0, 210, 70*linenum);
  
        UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, linenum*70)];
        bkview.backgroundColor = [UIColor clearColor];
        
        Photo *temp = [array objectAtIndex:0];
        
        NSDictionary *dic = [self handleDateWith:temp.createdAt];
        cell.monthLabel.text = [dic objectForKey:@"month"];
        cell.dayLabel.text = [dic objectForKey:@"day"];
        cell.weekLabel.text = [dic objectForKey:@"week"];
        
        int m=0;
        
        for(int i=0; i<linenum; i++)
        {
            for(int j=0; j<3; j++)
            {
                if (m < array.count)
                {
                    Photo *photo = [array objectAtIndex:m];
                    
                    UserPhotoView *_views = [[UserPhotoView alloc] initWithFrame:CGRectMake(70*j, 70*i, 67, 67)];
                    _views.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                    _views.imageUrl = photo.thumbnailURL;
                    _views.userphoto = photo;
                    [_views setImageViewUrl:photo.thumbnailURL];
                    [bkview addSubview:_views];
                    
                    m++;
                }
            }
        }
        
        [cell.photoView addSubview:bkview];
        
        [self.countArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
    else
    {
        if ([self.countArray containsObject:[NSNumber numberWithInteger:indexPath.row]]==NO)
        {
            for (UIView *view in cell.photoView.subviews)
            {
                [view removeFromSuperview];
            }
            
            cell.photoView.frame = CGRectMake(100, 0, 210, 70*linenum);
            
            UIView *bkview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, linenum*70)];
            bkview.backgroundColor = [UIColor clearColor];
            
            Photo *temp = [array objectAtIndex:0];
            
            NSDictionary *dic = [self handleDateWith:temp.createdAt];
            cell.monthLabel.text = [dic objectForKey:@"month"];
            cell.dayLabel.text = [dic objectForKey:@"day"];
            cell.weekLabel.text = [dic objectForKey:@"week"];
            
            int m=0;
            
            for(int i=0; i<linenum; i++)
            {
                for(int j=0; j<3; j++)
                {
                    if (m < array.count)
                    {
                        Photo *photo = [array objectAtIndex:m];

                        UserPhotoView *_views = [[UserPhotoView alloc] initWithFrame:CGRectMake(70*j, 70*i, 67, 67)];
                        _views.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                        _views.imageUrl = photo.thumbnailURL;
                        _views.userphoto = photo;
                        [_views setImageViewUrl:photo.thumbnailURL];
                        [bkview addSubview:_views];
                        
                        m++;
                    }
                }
            }
            
            [cell.photoView addSubview:bkview];
        }
    }
    
    return cell;
}

- (NSDictionary *)handleDateWith:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *_year = [formatter stringFromDate:date];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    int _m = [[formatter2 stringFromDate:date] intValue];
    NSString *_month = [NSString stringWithFormat:@"%d月",_m];
   
    
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"dd"];
    NSString *_day = [formatter3 stringFromDate:date];
    
    NSDateFormatter *formatter4 = [[NSDateFormatter alloc] init];
    [formatter4 setDateFormat:@"EEEE"];
    NSString *_week = [formatter4 stringFromDate:date];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_year,@"year",_month,@"month",_day,@"day",_week,@"week", nil];
    
    return dic;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [self.datalist objectAtIndex:indexPath.row];
    
    int linenum;
    
    if (array.count%3==0)
    {
        linenum = array.count/3;
    }
    else
    {
        linenum = array.count/3+1;
    }
    
    NSLog(@"lin=%d",linenum);
    
    return linenum*70+10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didSelectPhotos:(NSNotification *)into
{
    UserPhotoView *photo = (UserPhotoView *)[into object];
    
    if (photo!=nil)
    {
        ClothInfoViewController *clothview = [[ClothInfoViewController alloc] initWithPhoto:photo.userphoto];
        [self.navigationController pushViewController:clothview animated:YES];
    }
    
    NSLog(@"photo=%@",photo.userphoto);
    
    NSLog(@"small=%@,larger=%@",photo.smallUrl,photo.largerUrl);
}

#pragma mark - 刷新用户信息
- (void)refreshUserInfo:(NSNotification *)info
{
    __block AsyncImageView *__userheadview = userHeadView;
    __block AsyncImageView *__headview = headView;
    __block UILabel *__titlelabel = titleLabel;
    
    [self.user refreshInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        if ([object objectForKey:@"backgroundViewURL"]!=nil)
        {
            
            __headview.urlString = [object objectForKey:@"backgroundViewURL"];
        }
        else
        {
            __headview.image = [UIImage imageNamed:@"_0000_bg.png"];
            
        }
        
        __userheadview.urlString = [object objectForKey:@"smallHeadViewURL"];
        __titlelabel.text = [object objectForKey:@"nickname"];
        
    }];
}

#pragma mark - 封面图
- (void)tapCoverImage
{
//    if ([[ALBazaarEngine defauleEngine].user objectForKey:@"backgroundViewURL"]==nil)
//    {
//       // [ProgressHUD showError:@"还没有设置封面照片"];
//        
//        return;
//    }
    
    if(coverImageView==nil)
    {
        if (headView.imageView.image!=nil)
        {
            coverImageView = [[ShowImageViewController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ImageUrl:nil Image:headView.imageView.image];
            [self.backgroundView addSubview:coverImageView.view];
        }
    }
}

- (void)removeCoverImageView:(NSNotification *)info
{
    if (coverImageView!=nil)
    {
        coverImageView=nil;
    }
    
    if (userHeadImageView!=nil)
    {
        userHeadImageView=nil;
    }
}

#pragma mark - 编辑资料
- (void)editUserInfo
{
    if ([self.user.objectId isEqualToString:[ALBazaarEngine defauleEngine].user.objectId])
    {
        EditUserInfoViewController *editview = [[EditUserInfoViewController alloc] initWithUser:self.user];
        [self.navigationController pushViewController:editview animated:YES];
    }
    else
    {
        userHeadImageView = [[ShowImageViewController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ImageUrl:[self.user objectForKey:@"largeHeadViewURL"] Image:nil];
        [self.backgroundView addSubview:userHeadImageView.view];
    }
}

#pragma mark - 发私信
- (void)sendLetter
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    PrivateLetterViewController *privateview = [[PrivateLetterViewController alloc] initWithUser:self.user FromCenter:YES];
    [self.navigationController pushViewController:privateview animated:YES];
}



#pragma mark - 加关注
- (void)attentionOrRemoveUser
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.completerelation==NO)
    {
        [ProgressHUD showError:@"数据加载中"];
        
        return;
    }
    
    if (self.isAttention==YES)
    {
        [self cancelAttentin];
    }
    else
    {
        [self attentionUser];
    }
}

- (void)cancelAttentin
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    __block UIButton *__attentionbtn = attentionBtn;
    
    [ProgressHUD show:@"取消关注中"];
    
    [[ALBazaarEngine defauleEngine] removeFriendWithUser:self.user block:^(BOOL succeeded, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (succeeded)
        {
            [ProgressHUD showSuccess:@"成功"];
            
            if (bself.fromAttentionList==YES)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHATTENTIONUSERLIST object:bself.user];
            }
            
            bself.isAttention=NO;
            
            [__attentionbtn setTitle:@"+关注" forState:UIControlStateNormal];
        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
    }];
}

- (void)attentionUser
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    __block UIButton *__attentionbtn = attentionBtn;

    [ProgressHUD show:@"关注中"];
    
    [[ALBazaarEngine defauleEngine] addFriendWithUser:self.user block:^(BOOL succeeded, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        
        if (succeeded)
        {
            bself.isAttention=YES;
            [ProgressHUD showSuccess:@"成功"];
            [__attentionbtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
        
    }];
}

- (void)isHaveAttentionUser
{
    __block typeof(self) bself = self;
    

    [[ALBazaarEngine defauleEngine] getFriendListWithBlock:^(NSArray *objects, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            bself.isAttention=NO;
            
            for (int i=0; i<objects.count; i++)
            {
                User *temp = [objects objectAtIndex:i];
                
                if ([temp.objectId isEqualToString:bself.user.objectId])
                {
                    bself.isAttention=YES;
                }
            }
            
            if (bself.isAttention==YES)
            {
                [bself.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            else
            {
                [bself.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
            }
            
            bself.completerelation = YES;
        }
    }];
}


- (void)userinfoback
{
    self.isBack=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DIDSELECTUSERPHOTO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHUSERINFO object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REMOVECOVERIMAGEVIEW object:nil];
    
    [ProgressHUD dismiss];
    
    if (self.fromCenter==YES)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    [self.sidePanelController setCenterPanelHidden:NO animated:YES duration:0.4];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
