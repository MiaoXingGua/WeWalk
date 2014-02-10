//
//  AttentionListViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "AttentionListViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "AttentionCell.h"
#import "ALBazaarSDK.h"
#import "UserInfoViewController.h"

@interface AttentionListViewController ()

@end

@implementation AttentionListViewController
@synthesize datalist;
@synthesize tableView;


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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAttentionList:) name:REFRESHATTENTIONUSERLIST object:nil];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    titleLabel.text = @"关注";
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.backgroundView addSubview:self.tableView];
    
    
    [self requestAttentionList];
}

#pragma mark - 刷新关注
- (void)refreshAttentionList:(NSNotification *)info
{
    User *temp = [info object];
    
    for (int i=0; i<self.datalist.count; i++)
    {
        User *_user = [self.datalist objectAtIndex:i];
        
        if ([_user.objectId isEqualToString:temp.objectId])
        {
            [self.datalist removeObjectAtIndex:i];
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 请求关注用户
- (void)requestAttentionList
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    [ProgressHUD show:@"加载中"];
    
    [[ALBazaarEngine defauleEngine] getFriendListWithBlock:^(NSArray *objects, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            if (objects.count==0)
            {
                [ProgressHUD showSuccess:@"没有关注"];
            }
            else
            {
                NSLog(@"%@",objects);
                
                [bself.datalist removeAllObjects];

                [bself.datalist addObjectsFromArray:objects];
                
                [bself.tableView reloadData];
                
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
        userview.fromCenter = YES;
        userview.fromAttentionList=YES;
        [self.navigationController pushViewController:userview animated:YES];
    }
}


#pragma mark - addHeader&addFooter
- (void)addRefreshHeaderView
{
    if (_refreshHeaderView == nil)
    {
        _reloading = NO;
        
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height) arrowImageName:@"blackArrow.png" textColor:[UIColor blackColor]];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        _refreshHeaderView.delegate = self;
        [self.tableView addSubview:_refreshHeaderView];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

#pragma mark UIScrollViewDelegate Methods
//手指屏幕上不断拖动调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadFooterView egoLoadScrollViewDidScroll:scrollView];
}

//拖动停止时出发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadFooterView egoLoadScrollViewDidEndDragging:scrollView];

}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestAttentionList];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

//是否正在刷新中（返回值判断）
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

//下拉完，收回时执行（载入日期）
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}


#pragma mark - footerView Delegate
- (void)egoLoadTableFooterDidTriggerLoad:(EGOLoadTableFooterView *)view
{
    //[self loadMore];
}

- (BOOL)egoLoadTableFooterDataSourceIsLoading:(EGOLoadTableFooterView *)view
{
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoLoadTableFooterDataSourceLastUpdated:(EGOLoadTableFooterView *)view
{
    return [NSDate date]; // should return date data source was last change
}

- (void)doneLoadingMorTableViewData
{
    _reloading = NO;
    [_loadFooterView egoLoadScrollViewDataSourceDidFinishedLoading:self.tableView];
}


- (void)back
{
    [ProgressHUD dismiss];
    
    self.isBack=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHATTENTIONUSERLIST object:nil];
    
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
