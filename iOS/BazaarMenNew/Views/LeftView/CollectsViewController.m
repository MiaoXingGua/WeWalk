//
//  CollectsViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "CollectsViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "ClothInfoViewController.h"
#import "SystemConfigManager.h"

@interface CollectsViewController ()

@end

@implementation CollectsViewController
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
    titleLabel.text = @"收藏";
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
    
    waterFlow = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44)];
    waterFlow.waterFlowViewDelegate = self;
    waterFlow.waterFlowViewDatasource = self;
    waterFlow.delegate = self;
    waterFlow.haveHeadView = NO;
    waterFlow.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:waterFlow];
    
    [self addRefreshHeaderView];
    
    [self requestCollectPhotos];
}

- (void)requestCollectPhotos
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    [ProgressHUD show:@"加载中"];
    
    __block typeof(self) bself = self;
    
    __block WaterFlowView *__water = waterFlow;
    
    [[ALBazaarEngine defauleEngine] getMyFaviconPhotosWithLimit:50 lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            [bself.datalist removeAllObjects];
            
            for (int i=0; i<objects.count; i++)
            {
                Photo *temp = [objects objectAtIndex:i];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:temp.thumbnailURL forKey:@"url"];
                [dic setValue:temp forKey:@"photo"];
                
                if (temp.width>0 && temp.height>0)
                {
                    [dic setValue:[temp.user objectForKey:@"nickname"] forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:temp.width] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:temp.height] forKey:@"height"];
                }
                else
                {
                    [dic setValue:@"官方发布" forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:316] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:661.5] forKey:@"height"];
                }
                
                if (temp.content.text.length==0)
                {
                    [dic setValue:@"" forKey:@"content"];
                }
                else
                {
                    [dic setValue:temp.content.text forKey:@"content"];
                }
                
                
                [bself.datalist addObject:dic];

            }
            
            [__water reloadData];
            
            
            if (bself.datalist.count>20)
            {
                [bself addfootView];
            }
            
            __water.contentSize = CGSizeMake(320, waterFlow.contentSize.height+50);

            
            if (objects.count==0)
            {
                [ProgressHUD showSuccess:@"没有内容"];
            }
            else
            {
                [ProgressHUD showSuccess:@"成功"];
            }
        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
        [bself doneLoadingTableViewData];
        NSLog(@"%@",objects);
        
    }];
}


- (void)loadMore
{
    if (self.isLoadMore==YES)
    {
        return;
    }
    
    self.isLoadMore=YES;
    
    __block typeof(self) bself = self;
    
    __block WaterFlowView *__water = waterFlow;
    
    Photo *temp = [[self.datalist objectAtIndex:0] objectForKey:@"photo"];
    
    [[ALBazaarEngine defauleEngine] getMyFaviconPhotosWithLimit:30 lessThenDate:temp.createdAt block:^(NSArray *objects, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            if (objects.count==0)
            {
                [ProgressHUD showSuccess:@"没有更多"];
                bself.isLoadMore=NO;
                [bself doneLoadingMorTableViewData];
                
                return;
            }
            
            for (int i=0; i<objects.count; i++)
            {
                Photo *temp = [objects objectAtIndex:i];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:temp.thumbnailURL forKey:@"url"];
                [dic setValue:temp forKey:@"photo"];
                
                if (temp.width>0 && temp.height>0)
                {
                    [dic setValue:[temp.user objectForKey:@"nickname"] forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:temp.width] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:temp.height] forKey:@"height"];
                }
                else
                {
                    [dic setValue:@"官方发布" forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:316] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:661.5] forKey:@"height"];
                }
                
                if (temp.content.text.length==0)
                {
                    [dic setValue:@"" forKey:@"content"];
                }
                else
                {
                    [dic setValue:temp.content.text forKey:@"content"];
                }
                
                
                [bself.datalist addObject:dic];
                
            }
            
            [__water reloadData];
            
            [bself doneLoadingMorTableViewData];
            
            [bself addfootView];
            
            __water.contentSize = CGSizeMake(320, waterFlow.contentSize.height+50);

        }
        else
        {
            [bself doneLoadingMorTableViewData];
        }
        
        bself.isLoadMore=NO;
        
    }];
}

#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 2;
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView
{
    return self.datalist.count;
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath
{
    
    ImageViewCell *view = [[ImageViewCell alloc] initWithIdentifier:nil];
    
    return view;
}


-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath
{
    
    //arrIndex是某个数据在总数组中的索引
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    
    NSDictionary *object = [self.datalist objectAtIndex:arrIndex];
    
    NSURL *URL = [NSURL URLWithString:[object objectForKey:@"url"]];
    
    ImageViewCell *imageViewCell = (ImageViewCell *)view;
    imageViewCell.indexPath = indexPath;
    imageViewCell.columnCount = waterFlowView.columnCount;
    imageViewCell.dic = object;
    [imageViewCell relayoutViews];
    [(ImageViewCell *)view setImageWithURL:URL];
}


#pragma mark WaterFlowViewDelegate
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath
{
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSDictionary *dict = [self.datalist objectAtIndex:arrIndex];
    
    float width = 0.0f;
    float height = 0.0f;
    
    CGSize labelSize = CGSizeZero;
    
    if (dict)
    {
        width = [[dict objectForKey:@"width"] floatValue];
        height = [[dict objectForKey:@"height"] floatValue];
        
        labelSize = [[dict objectForKey:@"content"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(142, 10000) lineBreakMode:0];
    }
    
    CGFloat scaledHeight = floorf(height / (width / 142));
    
    if ([[dict objectForKey:@"content"] length]==0)
    {
        if([SystemConfigManager defaultManager].systemVersion>=7)
        {
            return scaledHeight+labelSize.height+20;
        }
        
        return scaledHeight+labelSize.height+35;
    }
    
    return scaledHeight+labelSize.height+20+20;
}

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath
{
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSLog(@"index=%d",arrIndex);
    
    Photo *_photo = nil;
    _photo = [[self.datalist objectAtIndex:arrIndex] objectForKey:@"photo"];
    
    if (_photo!=nil)
    {
        ClothInfoViewController *clothView = [[ClothInfoViewController alloc] initWithPhoto:_photo];
        [self.navigationController pushViewController:clothView animated:YES];
    }
    
}

#pragma mark - addHeader&addFooter
- (void)addRefreshHeaderView
{
    if (_refreshHeaderView == nil)
    {
        _reloading = NO;
        
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - waterFlow.bounds.size.height, self.view.frame.size.width, waterFlow.bounds.size.height) arrowImageName:@"blackArrow.png" textColor:[UIColor blackColor]];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        _refreshHeaderView.delegate = self;
        [waterFlow addSubview:_refreshHeaderView];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

- (void)addfootView
{
    if (_loadFooterView!=nil)
    {
        [_loadFooterView removeFromSuperview];
        _loadFooterView=nil;
    }
    
    _loadFooterView = [[EGOLoadTableFooterView alloc] initWithFrame:CGRectMake(0, waterFlow.contentSize.height-10, self.view.frame.size.width, waterFlow.bounds.size.height) arrowImageName:@"" textColor:[UIColor grayColor]];
    _loadFooterView.backgroundColor = [UIColor clearColor];
    _loadFooterView.delegate = self;
    [waterFlow addSubview:_loadFooterView];
}

#pragma mark - footerView Delegate
- (void)egoLoadTableFooterDidTriggerLoad:(EGOLoadTableFooterView *)view
{
    [self loadMore];
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
    [_loadFooterView egoLoadScrollViewDataSourceDidFinishedLoading:waterFlow];
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
    float _y = scrollView.contentOffset.y;
    NSLog(@"%f",_y);
    
    if (_y>waterFlow.contentSize.height*0.6)
    {
        NSLog(@"加载更多");
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestCollectPhotos];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:waterFlow];
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

#pragma mark - back
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
