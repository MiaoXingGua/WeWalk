//
//  StreetSnapViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 14-1-5.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "StreetSnapViewController.h"
#import "PSBroView.h"
#import "ALBazaarSDK.h"
#import "ALGPSHelper.h"
#import "SystemConfigManager.h"
#import "ClothInfoViewController.h"
#import "JASidePanelController.h"

@interface StreetSnapViewController ()

@end

@implementation StreetSnapViewController
@synthesize datalist = _datalist;



- (void)openStreetView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        coverView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
   // [waterFlow reloadData];
}

- (void)rightViewWillAppear
{
    [waterFlow setContentOffset:CGPointMake(0, 0) animated:NO];
    
    [self requestStreetImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightViewWillAppear) name:NOTIFICATION_JASIDE_LOAD_RIGHT_PANEL object:nil];
   
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];

    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"微行";
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_image_001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 130)];
    headview.backgroundColor = [UIColor lightGrayColor];
    headview.clipsToBounds=YES;
    [self.backgroundView addSubview:headview];
    
    waterHeadView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) ImageState:1];
    waterHeadView.image = [UIImage imageNamed:@"streetimage_0001.png"];
    waterHeadView.backgroundColor = [UIColor lightGrayColor];
    waterHeadView.clipsToBounds = YES;
    waterHeadView.userInteractionEnabled=NO;
    [headview addSubview:waterHeadView];
    
    self.selectedNum=1;
    
    newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.frame = CGRectMake(10, 10, 161/2, 161/2);
    newBtn.backgroundColor = [UIColor clearColor];
    [newBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0000_1选中.png"] forState:UIControlStateNormal];
    [newBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [newBtn setTitle:@"最新 " forState:UIControlStateNormal];
    newBtn.tag = 20000;
    newBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [newBtn addTarget:self action:@selector(didselected:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:newBtn];
    
    nearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nearBtn.frame = CGRectMake(110, 70, 161/2, 161/2);
    nearBtn.backgroundColor = [UIColor clearColor];
    [nearBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0005_2.png"] forState:UIControlStateNormal];
    [nearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nearBtn setTitle:@"附近" forState:UIControlStateNormal];
    nearBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    nearBtn.tag = 20001;
    [nearBtn addTarget:self action:@selector(didselected:) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:nearBtn];
    
    hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotBtn.frame = CGRectMake(210, 25, 161/2, 161/2);
    [hotBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0004_3.png"] forState:UIControlStateNormal];
    hotBtn.backgroundColor = [UIColor clearColor];
    hotBtn.tag = 20002;
    [hotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hotBtn setTitle:@"最热" forState:UIControlStateNormal];
    [hotBtn addTarget:self action:@selector(didselected:) forControlEvents:UIControlEventTouchUpInside];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [headview addSubview:hotBtn];
    
    waterFlow = [[WaterFlowView alloc] initWithFrame:CGRectMake(0, 44+130, SCREEN_WIDTH, self.backgroundView.frame.size.height-44-130)];
    waterFlow.waterFlowViewDelegate = self;
    waterFlow.waterFlowViewDatasource = self;
    waterFlow.delegate = self;
    waterFlow.haveHeadView=YES;
    waterFlow.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:waterFlow];
    
    [self addRefreshHeaderView];
    
    
//    waterFlow.contentSize = CGSizeMake(320, waterFlow.contentSize.height+50);
//    
//    footview = [[UIView alloc] initWithFrame:CGRectMake(0, waterFlow.contentSize.height-50, SCREEN_WIDTH, 50)];
//    footview.backgroundColor = [UIColor clearColor];
//    [waterFlow addSubview:footview];
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backto)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.backgroundView addGestureRecognizer:swipe];
    
    [self requestStreetImage];
}

- (void)didselected:(UIButton *)sender
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    if (sender.tag==20000)
    {
        [newBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0000_1选中.png"] forState:UIControlStateNormal];
        [nearBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0005_2.png"] forState:UIControlStateNormal];
        [hotBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0004_3.png"] forState:UIControlStateNormal];

        self.selectedNum=1;
        
    }
    if (sender.tag==20001)
    {
        [nearBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0001_3选中.png"] forState:UIControlStateNormal];

        [newBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0003_1.png"] forState:UIControlStateNormal];
        [hotBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0004_3.png"] forState:UIControlStateNormal];

        self.selectedNum=3;
    }
    if (sender.tag==20002)
    {
        [hotBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0002_2选中.png"] forState:UIControlStateNormal];

        [newBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0003_1.png"] forState:UIControlStateNormal];
        [nearBtn setBackgroundImage:[UIImage imageNamed:@"_0000s_0005_2.png"] forState:UIControlStateNormal];
         
        self.selectedNum=2;
    }
    
    [self requestStreetImage];
}
#pragma mark - 请求街拍图片
- (void)requestStreetImage
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    [ProgressHUD show:@"加载中"];
    
    __block typeof(self) bself = self;
    
    __block WaterFlowView *__water = waterFlow;
    
    //0.官方 1.最新街拍 2.最热街拍 3.附近街拍
    [[ALBazaarEngine defauleEngine] searchAllPhotoWithType:self.selectedNum limit:10 latitude:[ALGPSHelper OpenGPS].latitude longitude:[ALGPSHelper OpenGPS].longitude lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            [bself.datalist removeAllObjects];
            
            for (int i=0; i<objects.count; i++)
            {
                Photo *temp = [objects objectAtIndex:i];
                
                if (temp.width>0 && temp.height>0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:temp.thumbnailURL forKey:@"url"];
                    [dic setValue:temp forKey:@"photo"];
                    
                    [dic setValue:[temp.user objectForKey:@"nickname"] forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:temp.width] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:temp.height] forKey:@"height"];
                    
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
            }
            
            [ProgressHUD showSuccess:@"成功"];
            [__water reloadData];
            
            if (bself.datalist.count>5)
            {
                [bself addfootView];
            }
            
           // __water.contentSize = CGSizeMake(320, waterFlow.contentSize.height+50);
        }
        else
        {
            NSLog(@"%@",error);
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
        [bself doneLoadingTableViewData];
        
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
    
    Photo *temp = [[self.datalist lastObject] objectForKey:@"photo"];
    
    //0.官方 1.最新街拍 2.最热街拍 3.附近街拍
    [[ALBazaarEngine defauleEngine] searchAllPhotoWithType:self.selectedNum limit:30 latitude:[ALGPSHelper OpenGPS].latitude longitude:[ALGPSHelper OpenGPS].longitude lessThenDate:temp.createdAt block:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            if (objects.count==0)
            {
                [ProgressHUD showSuccess:@"没有更多"];
                [bself doneLoadingMorTableViewData];
                bself.isLoadMore=NO;
                
                return;
            }
            
            for (int i=0; i<objects.count; i++)
            {
                Photo *temp = [objects objectAtIndex:i];
                
                if (temp.width>0 && temp.height>0)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setObject:temp.thumbnailURL forKey:@"url"];
                    [dic setValue:temp forKey:@"photo"];
                    
                    [dic setValue:[temp.user objectForKey:@"nickname"] forKey:@"title"];
                    [dic setValue:[NSNumber numberWithFloat:temp.width] forKey:@"width"];
                    [dic setValue:[NSNumber numberWithFloat:temp.height] forKey:@"height"];
                    
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
                
            }
            
            [__water reloadData];
            [bself doneLoadingMorTableViewData];
            
            
            [bself addfootView];

           // __water.contentSize = CGSizeMake(320, waterFlow.contentSize.height+50);

           
        }
        else
        {
            NSLog(@"%@",error);
            [bself doneLoadingMorTableViewData];
        }
        
        bself.isLoadMore=NO;
    }];
}


#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 3;
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
    
    NSString *contenttext = [dict objectForKey:@"content"];

    if (dict)
    {
        width = [[dict objectForKey:@"width"] floatValue];
        height = [[dict objectForKey:@"height"] floatValue];
        
        
        labelSize = [contenttext sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(88, 10000) lineBreakMode:0];
    }
    
    NSLog(@"w=%f,h=%f",width,height);
    
    if (width==0 || height==0)
    {
        return 0;
    }
    
    CGFloat scaledHeight = floorf(height / (width / 88));
    
    if (scaledHeight<40)
    {
        scaledHeight=40;
    }
    
    if (contenttext.length==0)
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
    
    _loadFooterView = [[EGOLoadTableFooterView alloc] initWithFrame:CGRectMake(0, waterFlow.contentSize.height, self.view.frame.size.width, waterFlow.bounds.size.height) arrowImageName:@"" textColor:[UIColor grayColor]];
    _loadFooterView.backgroundColor = [UIColor clearColor];
    _loadFooterView.delegate = self;
    [waterFlow addSubview:_loadFooterView];
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
    float _y = scrollView.contentOffset.y;
    
    if (_y>waterFlow.contentSize.height*0.6)
    {
        NSLog(@"加载更多");
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadFooterView egoLoadScrollViewDidEndDragging:scrollView];

}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestStreetImage];
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


- (void)backto
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWHOMEVIEWCONTROLLER object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
