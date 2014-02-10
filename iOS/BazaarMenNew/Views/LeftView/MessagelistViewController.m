//
//  MessagelistViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "MessagelistViewController.h"
#import "MessageCell.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "PrivateLetterViewController.h"

@interface MessagelistViewController ()

@end

@implementation MessagelistViewController
@synthesize datalist = _datalist;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self beginPulldownAnimation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [ProgressHUD dismiss];
}

- (void)beginPulldownAnimation
{
    [_tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:_tableView afterDelay:0.5];
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
    titleLabel.text = @"消息";
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
    
    [self addRefreshHeaderView];
}

#pragma mark - 请求联系人列表
- (void)requestlinkmanList
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    [self.datalist removeAllObjects];
    
    __block typeof(self) bself = self;
    
    __block UITableView *__tabelview = _tableView;
    
    [[ALBazaarEngine defauleEngine] getContactsWithblock:^(NSArray *likers, NSError *error) {
        
        if (!error)
        {
            if (likers.count==0)
            {
                [ProgressHUD showSuccess:@"没有内容"];
                
                bself.isRequest=NO;
                
                [bself performSelector:@selector(closeRefresh) withObject:nil afterDelay:0.5];
                

            }
            else
            {
                [[ALBazaarEngine defauleEngine] getALLUnreadMessageCountAboutUserWithBlock:^(NSArray *messagesCount, NSError *error) {
                    
                    if (!error)
                    {
                        for (int i=0; i<likers.count; i++)
                        {
                            NSMutableDictionary *tempdic = [NSMutableDictionary dictionary];
                            
                            User *temp1 = [likers objectAtIndex:i];
                            
                            [tempdic setValue:temp1 forKey:@"user"];
                            
                            for (NSDictionary *dic in messagesCount)
                            {
                                User *temp2 = [dic objectForKey:@"user"];
                                
                                if ([temp1.objectId isEqualToString:temp2.objectId])
                                {
                                    [tempdic setValue:[dic objectForKey:@"count"] forKey:@"count"];
                                }
                               
                            }
                            
                            [bself.datalist addObject:tempdic];
                        }
                        
                        [__tabelview reloadData];
                        
                        
                        bself.isRequest=NO;
                        
                        [bself performSelector:@selector(closeRefresh) withObject:nil afterDelay:0.5];

                    }
                    else
                    {
                        [ProgressHUD showError:@"失败"];
                        
                        bself.isRequest=NO;
                        
                        [bself performSelector:@selector(closeRefresh) withObject:nil afterDelay:0.5];
                    }
                }];
                
            }
        }
        else
        {
            [ProgressHUD showError:@"失败"];
            
            bself.isRequest=NO;
            
            [bself performSelector:@selector(closeRefresh) withObject:nil afterDelay:0.5];

        }
        
    }];
}

- (void)closeRefresh
{
    [self doneLoadingTableViewData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellindifiter = @"cell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter];
    
    if (cell==nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    User *temp = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"user"];
    
    cell.nameLabel.text = [temp objectForKey:@"nickname"];
    cell.headView.urlString = [temp objectForKey:@"smallHeadViewURL"];


    CGSize _nameSize = [cell.nameLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, 1000) lineBreakMode:0];
    
    int num = [[[self.datalist objectAtIndex:indexPath.row] objectForKey:@"count"] intValue];
    NSString *unReadStr = [NSString stringWithFormat:@"%d",num];

    
    if (unReadStr.length>2)
    {
        cell.unReadLabel.text = @"99+";
    }
    else
    {
        cell.unReadLabel.text = unReadStr;
    }
 
    cell.unreadbackground.image = [UIImage imageNamed:@"unread_background.png"];
    cell.unreadbackground.frame = CGRectMake(_nameSize.width+60+20, 16, 92/2, 48/2);
    
    if (num==0)
    {
        cell.unreadbackground.hidden=YES;
    }
    
    cell.unReadLabel.text = unReadStr;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    User *temp = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"user"];
    
    if (temp!=nil)
    {
        PrivateLetterViewController *privateview = [[PrivateLetterViewController alloc] initWithUser:temp FromCenter:NO];
        [self.navigationController pushViewController:privateview animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
        User *user = [self.datalist objectAtIndex:indexPath.row];
        
        if (user!=nil)
        {
            __block typeof(self) bself = self;
            
            __block UITableView *__tabelview = _tableView;
            
            [ProgressHUD show:@"删除中"];

            [[ALBazaarEngine defauleEngine] deleteContactsWithUser:user block:^(BOOL succeeded, NSError *error) {
                
                if (succeeded)
                {
                    [bself.datalist removeObjectAtIndex:indexPath.row];
                    [__tabelview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [ProgressHUD showSuccess:@"成功"];
                }
                else
                {
                    [ProgressHUD showError:@"失败"];
                }
            }];
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - addHeader&addFooter
- (void)addRefreshHeaderView
{
    if (_refreshHeaderView == nil)
    {
        _reloading = NO;
        
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height) arrowImageName:@"blackArrow.png" textColor:[UIColor blackColor]];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        _refreshHeaderView.delegate = self;
        [_tableView addSubview:_refreshHeaderView];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

#pragma mark UIScrollViewDelegate Methods
//手指屏幕上不断拖动调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//拖动停止时出发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestlinkmanList];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
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



- (void)back
{
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
