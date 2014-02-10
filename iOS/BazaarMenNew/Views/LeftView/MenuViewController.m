//
//  MenuViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-7.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "MenuViewController.h"
#import "UserInfoViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "SendPhotosViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "ALBazaarSDK.h"
#import "AttentionListViewController.h"
#import "FansViewController.h"
#import "CollectsViewController.h"
#import "MessagelistViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)logoutUser
{
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    [self performSelector:@selector(addLoginView) withObject:nil afterDelay:0.3];
}

- (void)addLoginView
{
    LoginViewController *loginview = [[LoginViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:loginview];
    [n setNavigationBarHidden:YES];
    
    self.sidePanelController.leftPanel = n;
}

- (void)getAllUnReadMessageNum
{
    __block typeof(self) bself = self;

    [[ALBazaarEngine defauleEngine] getALLUnreadMessageCountWithBlock:^(NSInteger messagesCount, NSError *error) {
        
      //  bself.unReadNum = messagesCount;
        
        if (messagesCount>0)
        {
            bself.unreadView.hidden=NO;
        }
        else
        {
            bself.unreadView.hidden=YES;
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self getAllUnReadMessageNum];
}

- (void)leftViewWillAppear
{
    [self getAllUnReadMessageNum];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutUser) name:LOGOUTUSER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfo:) name:REFRESHUSERINFO object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewWillAppear) name:NOTIFICATION_JASIDE_LOAD_LEFT_PANEL object:nil];

    
    

    UIImageView *backImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    backImageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:backImageview];
    
    operationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, SCREEN_HEIGHT)];
    operationView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:operationView];

    
    UIImageView *headborderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0000_头像边框.png"]];
    headborderImage.frame = CGRectMake(0, 0, 80, 80);
    headborderImage.center = CGPointMake(210/2, 55);
    headborderImage.userInteractionEnabled = YES;
    [self.backgroundView addSubview:headborderImage];
    
    
    headView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75) ImageState:0];
    headView.defaultImage = 0;
    headView.center = CGPointMake(headborderImage.frame.size.width/2, headborderImage.frame.size.height/2);
    [headView addTarget:self action:@selector(showUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [headborderImage addSubview:headView];
    
    [self refreshUserInfo:nil];
    
    vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0031_V.png"]];
    vImageView.frame = CGRectMake(63, 62, 34/2, 34/2);
    [headborderImage addSubview:vImageView];
    vImageView.alpha = 0;
    
    
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 30)];
    usernameLabel.center = CGPointMake(210/2, 130);
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    usernameLabel.backgroundColor = [UIColor clearColor];
    usernameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    usernameLabel.text = [[ALBazaarEngine defauleEngine].user objectForKey:@"nickname"];
    usernameLabel.font = [UIFont systemFontOfSize:19];
    [self.backgroundView addSubview:usernameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 0.5)];
    lineView.center = CGPointMake(210/2, 145);
    lineView.backgroundColor = [UIColor grayColor];
    [self.backgroundView addSubview:lineView];
    
    float _h=0;
    if (self.view.frame.size.height>480)
    {
        _h = 0;
    }
    else
    {
        _h = 10;
    }
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraBtn setImage:[UIImage imageNamed:@"camera_image.png"] forState:UIControlStateNormal];
    cameraBtn.frame = CGRectMake(0, 0, 94/2, 94/2);
    cameraBtn.center = CGPointMake(210/2, 190-_h);
    [cameraBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:cameraBtn];
    
//    authenticationView = [[UIView alloc] initWithFrame:CGRectMake(0, 233-_h*1.8, 200, 30)];
//    authenticationView.backgroundColor = [UIColor clearColor];
//    [self.backgroundView addSubview:authenticationView];
//    
//    UIImageView *auimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"set_00000.png"]];
//    auimage.frame = CGRectMake(23, 0, 29/2, 51/2);
//    [authenticationView addSubview:auimage];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(55, 4, 150, 20);
//    btn.titleLabel.font = [UIFont systemFontOfSize:19];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(authentication) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"认证达人 VIP" forState:UIControlStateNormal];
//    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [authenticationView addSubview:btn];
    
    
    for (int i=0; i<5; i++)
    {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"set_0000%d.png",i+1]]];
        [operationView addSubview:img];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake(55, 275+i*40-_h*1.8, 150, 30);
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:19];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectoperation:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [operationView addSubview:btn];
        
        if (i==0)
        {
            img.frame = CGRectMake(20, 280+i*40-_h*1.8, 38/2, 37/2);
            [btn setTitle:@"喜欢 Collection" forState:UIControlStateNormal];
        }
        if (i==1)
        {
            img.frame = CGRectMake(20, 282+i*40-_h*1.8, 39/2, 30/2);
            [btn setTitle:@"消息 Message" forState:UIControlStateNormal];
        }
        if (i==2)
        {
            img.frame = CGRectMake(20, 280+i*40-_h*1.8, 41/2, 36/2);
            [btn setTitle:@"粉丝 Fans" forState:UIControlStateNormal];
        }
        if (i==3)
        {
            img.frame = CGRectMake(20, 280+i*40-_h*1.8, 33/2, 41/2);
            [btn setTitle:@"关注 Attention" forState:UIControlStateNormal];
        }
        if (i==4)
        {
            img.frame = CGRectMake(20, 280+i*40-_h*1.8, 36/2, 42/2);
            [btn setTitle:@"设置 Setting" forState:UIControlStateNormal];
        }
    }
    
    self.unreadView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unreadnum.png"]];
    self.unreadView.userInteractionEnabled = YES;
    [self.backgroundView addSubview:self.unreadView];
    self.unreadView.hidden=YES;
    
    if (_h==10)
    {
        self.unreadView.frame = CGRectMake(34, 300, 10, 10);
    }
    else
    {
        self.unreadView.frame = CGRectMake(34, 318, 10, 10);
    }
    
    
}

- (void)refreshUserInfo:(NSNotification *)info
{
    __block AsyncImageView *__headview = headView;
    __block UILabel *__usernamelabel = usernameLabel;

    
    [[ALBazaarEngine defauleEngine].user refreshInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        
        __headview.urlString = [object objectForKey:@"smallHeadViewURL"];
        __usernamelabel.text = [object objectForKey:@"nickname"];
        
    }];
}

- (void)selectoperation:(UIButton *)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    //喜欢
    if (sender.tag==1000)
    {
        CollectsViewController *collectview = [[CollectsViewController alloc] init];
        [self.navigationController pushViewController:collectview animated:NO];
    }
    //消息
    if (sender.tag==1001)
    {
        MessagelistViewController *messageview = [[MessagelistViewController alloc] init];
        [self.navigationController pushViewController:messageview animated:NO];
        
    }
    //粉丝
    if (sender.tag==1002)
    {
        FansViewController *fansview = [[FansViewController alloc] init];
        [self.navigationController pushViewController:fansview animated:NO];
    }
    //关注
    if (sender.tag==1003)
    {
        AttentionListViewController *attview = [[AttentionListViewController alloc] init];
        [self.navigationController pushViewController:attview animated:NO];
    }
    //设置
    if (sender.tag==1004)
    {
        SettingViewController *setview =[[SettingViewController alloc] init];
        [self presentViewController:setview animated:YES completion:nil];
        
        return;
    }
   
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.sidePanelController setCenterPanelHidden:YES animated:YES duration:0.3];
}

- (void)openCamera
{
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"打开相册", nil];
    [_sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UIImagePickerController *imagePiker = [[UIImagePickerController alloc] init];
        imagePiker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePiker.delegate = self;
        imagePiker.allowsEditing = NO;
        [self presentViewController:imagePiker
                           animated:YES
                         completion:nil];
    }
    
    if (buttonIndex == 1)
    {
        
        UIImagePickerController *imagPickerC = [[UIImagePickerController alloc] init];//图像选取器
        imagPickerC.delegate = self;
        imagPickerC.allowsEditing = NO;
        imagPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagPickerC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        [self presentViewController:imagPickerC animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self presentSendPhotosView:image];
        
    }];
}

- (void)presentSendPhotosView:(UIImage *)image
{
    SendPhotosViewController *sendphotos = [[SendPhotosViewController alloc] initWithUserImage:image];
    [self presentViewController:sendphotos animated:YES completion:nil];
}

#pragma mark - Push动画
- (void)pushAnimation
{
    
}

#pragma mark - 显示用户
- (void)showUserInfo
{
    UserInfoViewController *userview = [[UserInfoViewController alloc] initWithSelf:YES User:[ALBazaarEngine defauleEngine].user];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController pushViewController:userview animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.sidePanelController setCenterPanelHidden:YES animated:YES duration:0.4];
}

#pragma mark - 手机号认证
- (void)authentication
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        authenticationView.alpha = 0;
        vImageView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            operationView.frame = CGRectMake(0, -40, 210, SCREEN_HEIGHT);

        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
