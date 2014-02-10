//
//  FansViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "FansViewController.h"
#import "AttentionCell.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "ALBazaarSDK.h"
#import "UserInfoViewController.h"

@interface FansViewController ()

@end

@implementation FansViewController
@synthesize datalist = _datalist;


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [ProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    titleLabel.text = @"粉丝";
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
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.backgroundView addSubview:_tableView];
    
    [self requestFansList];
}

#pragma mark - 请求粉丝
- (void)requestFansList
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    __block UITableView *__tableview = _tableView;
    
    [ProgressHUD show:@"加载中"];
    
    [[ALBazaarEngine defauleEngine] getFollowListWithBlock:^(NSArray *objects, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            if (objects.count==0)
            {
                [ProgressHUD showSuccess:@"没有粉丝"];
            }
            else
            {
                [bself.datalist removeAllObjects];
                
                [bself.datalist addObjectsFromArray:objects];
                [__tableview reloadData];
                
                [ProgressHUD showSuccess:@"成功"];
                
            }
        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellindifiter = @"cell";
    
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter];
    
    if (cell==nil)
    {
        cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    User *temp = [self.datalist objectAtIndex:indexPath.row];
    
    cell.headView.urlString = [temp objectForKey:@"smallHeadViewURL"];
    cell.nameLabel.text = [temp objectForKey:@"nickname"];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *temp = [self.datalist objectAtIndex:indexPath.row];
    
    if (temp!=nil)
    {
        BOOL isSelf=NO;
        
        if ([temp.objectId isEqualToString:[ALBazaarEngine defauleEngine].user.objectId])
        {
            isSelf=YES;
        }
        
        UserInfoViewController *userview = [[UserInfoViewController alloc] initWithSelf:isSelf User:temp];
        userview.fromCenter=YES;
        [self.navigationController pushViewController:userview animated:YES];
    }
}

- (void)back
{
    [ProgressHUD dismiss];

    self.isBack=YES;
    
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
