//
//  ClothInfoViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "ClothInfoViewController.h"
#import "ClothesCell.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "ALGPSHelper.h"
#import "UserInfoViewController.h"
#import "CollectUserViewController.h"

@interface ClothInfoViewController ()

@end

@implementation ClothInfoViewController
@synthesize photo = _photo;
@synthesize datalist = _datalist;
@synthesize collectUserView;
@synthesize collectBtn;
@synthesize collectNumLabel;
@synthesize collectUserArray;
@synthesize chatNumLabel;
@synthesize moveView1;
@synthesize moveView2;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
  

}

- (id)initWithPhoto:(Photo *)photo
{
    if (self = [super init])
    {
        self.photo = photo;
    }
    
    return self;
}

- (void)longPressPhoto
{
    if (clothesView.completeDownload==YES)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到相册" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIImageWriteToSavedPhotosAlbum(clothesView.imageView.image, nil, nil,nil);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];
    
    self.collectUserArray = [NSMutableArray arrayWithCapacity:5];
    
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
    [backBtn addTarget:self action:@selector(clothinfoback) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    
    float _w = self.photo.width;
    float _h = self.photo.height;
    
    if (_w==0 && _h==0)
    {
        _w = 316;
        _h = 661.5;
    }
    else
    {
        if (self.photo.width>=316)
        {
            _w = 316;
            _h = _h/(self.photo.width/316);
            
        }
        else
        {
            _w = 316;
            _h = _h*(316/self.photo.width);
        }
    }
    
  
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _h+90)];
    self.headView.backgroundColor = [UIColor clearColor];
    
    UIView *coverview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _h)];
    coverview.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.headView addSubview:coverview];
    
    clothesView = [[AsyncImageView alloc] initWithFrame:CGRectMake(2, 0, _w, _h) ImageState:1];
    clothesView.scaleState=2;
    clothesView.urlString = self.photo.originalURL;
    clothesView.userInteractionEnabled=YES;
    clothesView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [coverview addSubview:clothesView];
    
    UITapGestureRecognizer *longpress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPhoto)];
    [clothesView addGestureRecognizer:longpress];
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collectBtn.frame = CGRectMake(180, _h-28, 26, 26);
    self.collectBtn.userInteractionEnabled=NO;
    [self.collectBtn setImage:[UIImage imageNamed:@"likeimage_0002.png"] forState:UIControlStateNormal];
    self.collectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.collectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.collectBtn addTarget:self action:@selector(collectCloth) forControlEvents:UIControlEventTouchUpInside];
    [coverview addSubview:self.collectBtn];
    
    self.collectNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, _h-26, 45, 20)];
    self.collectNumLabel.text = @"0";
    self.collectNumLabel.textColor = [UIColor grayColor];
    self.collectNumLabel.backgroundColor = [UIColor clearColor];
    self.collectNumLabel.font = [UIFont systemFontOfSize:12];
    self.collectNumLabel.textAlignment = NSTextAlignmentLeft;
    [coverview addSubview:self.collectNumLabel];
    
    UIImageView *chatView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_chat.png"]];
    chatView.frame = CGRectMake(245, _h-28, 26, 26);
    [coverview addSubview:chatView];
    
    self.chatNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(270, _h-26, 45, 20)];
    self.chatNumLabel.text = @"0";
    self.chatNumLabel.textColor = [UIColor grayColor];
    self.chatNumLabel.backgroundColor = [UIColor clearColor];
    self.chatNumLabel.font = [UIFont systemFontOfSize:12];
    self.chatNumLabel.textAlignment = NSTextAlignmentLeft;
    [coverview addSubview:self.chatNumLabel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44-INPUT_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.backgroundView addSubview:_tableView];
    
    UIImageView *coverView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxing.png"]];
    coverView.userInteractionEnabled = YES;
    coverView.frame = CGRectMake(15, clothesView.frame.size.height-28, 55, 55);
    [self.headView addSubview:coverView];
    
    userHeadView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 49, 49) ImageState:0];
    userHeadView.center = CGPointMake(coverView.frame.size.width/2, coverView.frame.size.height/2);
    [userHeadView addTarget:self action:@selector(showOwnerView) forControlEvents:UIControlEventTouchUpInside];
    userHeadView.backgroundColor = [UIColor clearColor];
    [coverView addSubview:userHeadView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, clothesView.frame.size.height, 180, 30)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    nameLabel.text = [self.photo.user objectForKey:@"nickname"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:18];
    [self.headView addSubview:nameLabel];
    
    
    CGSize _adsize = [self.photo.place sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:0];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, clothesView.frame.size.height+32, 280, _adsize.height)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.numberOfLines=0;
    addressLabel.text = self.photo.place;
    addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = [UIFont systemFontOfSize:16];
    [self.headView addSubview:addressLabel];
    
    if (self.photo.place.length==0)
    {
        addressLabel.text = @"位置暂无";
        addressLabel.frame = CGRectMake(17, clothesView.frame.size.height+32, 100, 20);
        _adsize  = CGSizeMake(100, 20);
    }
    
    if (self.photo.isOfficial==YES)
    {
        userHeadView.image = [UIImage imageNamed:@"guanfang.jpg"];
        addressLabel.text = @"官方发布";
    }
    else
    {
        userHeadView.urlString = [self.photo.user objectForKey:@"smallHeadViewURL"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:self.photo.createdAt];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, addressLabel.frame.size.height+addressLabel.frame.origin.y+2, 200, 20)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = [UIColor lightGrayColor];
    dateLabel.text = dateStr;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:dateLabel];
    
  
    
    CGSize contentSize = [self.photo.content.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 10000) lineBreakMode:0];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, _h+_adsize.height+60, 280, contentSize.height)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.text = self.photo.content.text;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [self.headView addSubview:contentLabel];
    
    if (self.photo.content.text.length==0)
    {
        contentSize = CGSizeMake(100, 0);
    }
    
    num=1;
    
    self.collectUserView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, _h+addressLabel.frame.size.height+contentSize.height+65, 384/2, 35)];
    self.collectUserView.image = [UIImage imageNamed:@"collectuserimage.png"];
    self.collectUserView.userInteractionEnabled=YES;
    [self.headView addSubview:self.collectUserView];
    
    self.moveView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35*num, 35)];
    self.moveView1.backgroundColor = [UIColor clearColor];
    self.moveView1.clipsToBounds=YES;
    [self.collectUserView addSubview:self.moveView1];
    
    self.moveView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35*num, 35)];
    self.moveView2.backgroundColor = [UIColor clearColor];
    self.moveView2.clipsToBounds=YES;
    [self.moveView1 addSubview:self.moveView2];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(33*num, 0, 35, 35);
    [self.moreBtn setTitle:@"•••" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.moreBtn addTarget:self action:@selector(showMoreCollectUser) forControlEvents:UIControlEventTouchUpInside];
    [self.collectUserView addSubview:self.moreBtn];
    

    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _h+addressLabel.frame.size.height+contentSize.height+90+20);
    _tableView.tableHeaderView = self.headView;
    
    CGRect inputFrame = CGRectMake(0.0f, self.backgroundView.frame.size.height - INPUT_HEIGHT, SCREEN_WIDTH, INPUT_HEIGHT);
    
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputToolBarView.layer.borderWidth = 1;
    self.inputToolBarView.textView.returnKeyType = UIReturnKeyDone;
    self.inputToolBarView.textView.placeHolder = @"说点什么呢？";
    self.inputToolBarView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.inputToolBarView];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"sendimage_0001.png"] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(self.inputToolBarView.frame.size.width - 68.0f+10, 10.0f, 96/2, 57/2);
    [sendBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView addSubview:sendBtn];
    
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==YES)
    {
        [self isCollect];
    }
    
    [self addRefreshHeaderView];
    [self requestComments];
    
    [self requestCollectNum];
    [self requestCommentNum];
//    
    [self requestLikeList];
}

#pragma mark - 显示所有喜欢用户
- (void)showMoreCollectUser
{
    CollectUserViewController *collview = [[CollectUserViewController alloc] init];
    collview.photo = self.photo;
    [self.navigationController pushViewController:collview animated:YES];
}

#pragma mark - 请求喜欢列表
- (void)requestLikeList
{
    __block typeof(self) bself = self;
    

    [[ALBazaarEngine defauleEngine] searchFaviconUsersFromPhoto:self.photo limit:5 lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            NSLog(@"%d",objects.count);
            
            if (objects.count>0)
            {
                int _nums = objects.count;

                
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:5];
                
                for (int i=_nums; i>0; i--)
                {
                    User *_user = [objects objectAtIndex:i-1];

                    [temp addObject:_user];
                }
                
                for (int i=0; i<_nums; i++)
                {
                    User *_user = [temp objectAtIndex:i];
                    
                    AsyncImageView *userview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5+33*i, 2, 30, 30) ImageState:0];
                    userview.urlString = [_user objectForKey:@"smallHeadViewURL"];
                    userview.backgroundColor = [UIColor clearColor];
                    [userview addTarget:self action:@selector(didSelectCollectUser:) forControlEvents:UIControlEventTouchUpInside];
                    userview.tag = 40000+i;
                    [bself.moveView2 addSubview:userview];
                    
                    [bself.collectUserArray addObject:_user];
                }
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    bself.collectUserView.frame = CGRectMake(SCREEN_WIDTH-32*(_nums+1), bself.collectUserView.frame.origin.y, 384/2, 35);
                    bself.moveView1.frame = CGRectMake(0, 0, 35*_nums, 35);
                    bself.moveView2.frame = CGRectMake(0, 0, 35*_nums, 35);
                    bself.moreBtn.frame = CGRectMake(33*_nums, 0, 35, 35);

                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
//                bself.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bself.headView.frame.size.height-35);
//                __tableview.tableHeaderView = bself.headView;
            }
        }
    }];
}

- (void)moveCollectUserView
{
    num = self.collectUserArray.count;
    
    if (num>=5)
    {
        self.moveView1.frame = CGRectMake(0, 0, 170, 35);
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.moveView2.frame = CGRectMake(33, 0, self.moveView2.frame.size.width, self.moveView2.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            AsyncImageView *userview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 2, 30, 30) ImageState:0];
            userview.urlString = [[ALBazaarEngine defauleEngine].user objectForKey:@"smallHeadViewURL"];
            userview.backgroundColor = [UIColor clearColor];
            [self.collectUserView addSubview:userview];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.collectUserView.frame = CGRectMake(SCREEN_WIDTH-32*(num+2), self.collectUserView.frame.origin.y, 384/2, 35);
            
            self.moveView1.frame = CGRectMake(0, 0, 35*(num+1), 35);
            self.moveView2.frame = CGRectMake(34, 0, self.moveView2.frame.size.width, self.moveView2.frame.size.height);
            self.moreBtn.frame = CGRectMake(33*(num+1), 0, 35, 35);
            
            
        } completion:^(BOOL finished) {
            
            AsyncImageView *userview = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 2, 30, 30) ImageState:0];
            userview.urlString = [[ALBazaarEngine defauleEngine].user objectForKey:@"smallHeadViewURL"];
            userview.backgroundColor = [UIColor clearColor];
            [self.collectUserView addSubview:userview];
            
        }];
    }
}

#pragma mark - 显示用户
- (void)didSelectCollectUser:(AsyncImageView *)sender
{
    User *temp = [self.collectUserArray objectAtIndex:sender.tag-40000];
    
    BOOL isSelf=NO;
    
    if ([temp.objectId isEqualToString:[ALBazaarEngine defauleEngine].user.objectId]==YES)
    {
        isSelf=YES;
    }
    else
    {
        isSelf=NO;
    }
    
    if (temp!=nil)
    {
        UserInfoViewController *userinfo = [[UserInfoViewController alloc] initWithSelf:isSelf User:temp];
        userinfo.fromCenter=YES;
        [self.navigationController pushViewController:userinfo animated:YES];
    }
    
}

#pragma mark - 请求收藏数
- (void)requestCollectNum
{
    __block typeof(self) bself = self;

    [[ALBazaarEngine defauleEngine] searchFaviconUsersCountFromPhoto:self.photo block:^(NSInteger number, NSError *error) {
        
        if (!error)
        {
            bself.collectNumLabel.text = [NSString stringWithFormat:@"%d",number];
        }
    }];
}
#pragma mark - 请求评论数
- (void)requestCommentNum
{
    __block typeof(self) bself = self;

    [[ALBazaarEngine defauleEngine] getCommentCountFromPhoto:self.photo block:^(NSInteger number, NSError *error) {
    
        if (!error)
        {
            bself.chatNumLabel.text = [NSString stringWithFormat:@"%d",number];
        }
    }];
}
#pragma mark - 显示楼主个人主页
- (void)showOwnerView
{
    if (self.photo.isOfficial==YES)
    {
        return;
    }
    
    BOOL isSelf=NO;
    
    if ([self.photo.user.objectId isEqualToString:[ALBazaarEngine defauleEngine].user.objectId]==YES)
    {
        isSelf=YES;
    }
    else
    {
        isSelf=NO;
    }
    
    UserInfoViewController *userinfo = [[UserInfoViewController alloc] initWithSelf:isSelf User:self.photo.user];
    userinfo.fromCenter=YES;
    [self.navigationController pushViewController:userinfo animated:YES];

}

#pragma mark - 显示用户个人主页
- (void)tapUserHeadView:(AsyncImageView *)sender
{
    Comment *tempcomment = [self.datalist objectAtIndex:sender.tag-8000];
    AVUser *tempuser = tempcomment.user;
    BOOL isSelf=NO;
    
    if ([tempuser.objectId isEqualToString:[ALBazaarEngine defauleEngine].user.objectId]==YES)
    {
        isSelf=YES;
    }
    else
    {
        isSelf=NO;
    }
    
    UserInfoViewController *userinfo = [[UserInfoViewController alloc] initWithSelf:isSelf User:tempuser];
    userinfo.fromCenter=YES;
    [self.navigationController pushViewController:userinfo animated:YES];
}

#pragma mark - 是否收藏
- (void)isCollect
{
    NSArray *array = [NSArray arrayWithObjects:self.photo, nil];
    
    __block typeof(self) bself = self;

    
    [[ALBazaarEngine defauleEngine] isMyFaviconPhotos:array block:^(NSArray *objects, NSError *error) {
        
        if (error)
        {
            return;
        }
        
        if ([objects containsObject:bself.photo])
        {
            [bself.collectBtn setImage:[UIImage imageNamed:@"likeimage_0001.png"] forState:UIControlStateNormal];
            bself.collectBtn.userInteractionEnabled=NO;
        }
        else
        {
            [bself.collectBtn setImage:[UIImage imageNamed:@"likeimage_0002.png"] forState:UIControlStateNormal];
            bself.collectBtn.userInteractionEnabled=YES;
        }
        
    }];
}

#pragma mark - 收藏
- (void)collectCloth
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.isCollecting==YES)
    {
        return;
    }
    
    self.isCollecting=YES;
    
 
    __block typeof(self) bself = self;

    
    [[ALBazaarEngine defauleEngine] faviconPhoto:self.photo block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)
        {
            [bself.collectBtn setImage:[UIImage imageNamed:@"likeimage_0001.png"] forState:UIControlStateNormal];
            bself.collectBtn.userInteractionEnabled=NO;
            
            [bself moveCollectUserView];
            [bself requestCollectNum];
        }
        else
        {
            [ProgressHUD showError:@"收藏失败"];
        }
        
        bself.isCollecting=NO;
    }];
}

//取消收藏
- (void)cancelCollectColth
{
    
}

- (void)searchCollectWithPhoto
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1111)
    {
        [self.inputToolBarView.textView resignFirstResponder];
    }
}

#pragma mark - 发送评论
- (void)sendComment:(UIButton *)sender
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1111;
        [alert show];
        
        return;
    }
    
    if (self.inputToolBarView.textView.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.photo==nil)
    {
        return;
    }
    
    __block typeof(self) bself = self;
    
    [ProgressHUD show:@"评论中"];
    
    [self.inputToolBarView.textView resignFirstResponder];
    
    [[ALBazaarEngine defauleEngine] commentPhoto:self.photo text:self.inputToolBarView.textView.text voice:nil block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            bself.inputToolBarView.textView.text = @"";
            
            [bself requestComments];
            [bself requestCommentNum];
        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
    }];
}

#pragma mark - 请求评论
- (void)requestComments
{
    __block typeof(self) bself = self;
    
    __block UITableView *__tabelview = _tableView;

    [[ALBazaarEngine defauleEngine] getCommentListFromPhoto:self.photo limit:20 lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        [bself.datalist removeAllObjects];
        [bself.datalist addObjectsFromArray:objects];
        
        [__tabelview reloadData];
        
        [bself doneLoadingTableViewData];
        
        NSLog(@"%@",objects);
        
    }];
}

//加载更多
- (void)requestMoreComments
{
    __block typeof(self) bself = self;
    
    __block UITableView *__tabelview = _tableView;
    
    [[ALBazaarEngine defauleEngine] getCommentListFromPhoto:self.photo limit:20 lessThenDate:nil block:^(NSArray *objects, NSError *error) {
        
        [bself.datalist removeAllObjects];
        [bself.datalist addObjectsFromArray:objects];
        
        [__tabelview reloadData];
        
        NSLog(@"%@",objects);
        
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
    
    ClothesCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter];
    
    if (cell==nil)
    {
        cell = [[ClothesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    Comment *_comment = [self.datalist objectAtIndex:indexPath.row];
    
    cell.userHeadView.urlString = [_comment.user objectForKey:@"smallHeadViewURL"];
    [cell.userHeadView addTarget:self action:@selector(tapUserHeadView:) forControlEvents:UIControlEventTouchUpInside];
    cell.userHeadView.tag = indexPath.row+8000;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ : ",[_comment.user objectForKey:@"nickname"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateStr = [formatter stringFromDate:self.photo.createdAt];
    
    cell.dateLabel.text = dateStr;
   

    CGSize contentSize = [_comment.content.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(220, 10000) lineBreakMode:0];
    
    cell.contentLabel.frame = CGRectMake(80, 35, 235, contentSize.height);
    cell.contentLabel.text = _comment.content.text;
    cell.contentLabel.textColor = [UIColor grayColor];
    cell.contentLabel.font = [UIFont systemFontOfSize:15];
    
    cell.backView.frame = CGRectMake(0, 0, 320, 35+contentSize.height+10);
    
    cell.lineView2.frame = CGRectMake(0, 0, 320, 0.5);
    cell.lineView.frame = CGRectMake(0, cell.backView.frame.size.height, 320, 0.5);
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *_comment = [self.datalist objectAtIndex:indexPath.row];
    
    CGSize contentSize = [_comment.content.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(235, 10000) lineBreakMode:0];
    
    return 35+contentSize.height+15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
   // [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                     
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             sendBtn.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f,inputViewFrame.size.height+changeInHeight- 8-28, 59.0f, 26.0f);

                             
                             if(!isShrinking)
                             {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
  //  self.inputToolBarView.sendButton.enabled = ([[textView.text trimWhitespace] length] > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.backgroundView convertRect:keyboardRect fromView:nil].origin.y;
                         
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.backgroundView convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.backgroundView.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
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
    [self.inputToolBarView.textView resignFirstResponder];

    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestComments];
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


- (void)clothinfoback
{
    [self.inputToolBarView.textView resignFirstResponder];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
