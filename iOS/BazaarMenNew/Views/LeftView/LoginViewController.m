//
//  LoginViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-7.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"
#import "ALBazaarSDK.h"
#import "ScheduleRequestManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    backImageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:backImageview];
    
    UIImageView *logview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixing.png"]];
    logview.frame = CGRectMake(0, 0, 349/2, 109/2);
    logview.center = CGPointMake(210/2, 100);
    [self.backgroundView addSubview:logview];
    
    UIImageView *usernameimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username_image0001.png"]];
    usernameimage.frame = CGRectMake(17, 140, 44/2, 47/2);
    [self.backgroundView addSubview:usernameimage];
    
    textfield_username = [[UITextField alloc] initWithFrame:CGRectMake(50, 140, 130, 30)];
    textfield_username.backgroundColor = [UIColor clearColor];
    textfield_username.borderStyle = UITextBorderStyleNone;
    textfield_username.delegate = self;
    textfield_username.returnKeyType = UIReturnKeyDone;
    textfield_username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield_username.placeholder = @"用户名";
    textfield_username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield_username.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield_username.textColor = [UIColor blackColor];
    [self.backgroundView addSubview:textfield_username];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(17, 170, 175, 1)];
    line1.backgroundColor =[UIColor lightGrayColor];
    [self.backgroundView addSubview:line1];
    
    UIImageView *passwordimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image0002.png"]];
    passwordimage.frame = CGRectMake(17, 195, 51/2, 30/2);
    [self.backgroundView addSubview:passwordimage];
    
    
    textfield_password = [[UITextField alloc] initWithFrame:CGRectMake(50, 190, 130, 30)];
    textfield_password.backgroundColor = [UIColor clearColor];
    textfield_password.delegate = self;
    [textfield_password setSecureTextEntry:YES];
    textfield_password.keyboardType = UIKeyboardTypeAlphabet;
    textfield_password.borderStyle = UITextBorderStyleNone;
    textfield_password.returnKeyType = UIReturnKeyDone;
    textfield_password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield_password.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield_password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield_password.placeholder = @"密码";
    textfield_password.textColor = [UIColor blackColor];
    [self.backgroundView addSubview:textfield_password];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(17, 220, 175, 1)];
    line2.backgroundColor =[UIColor lightGrayColor];
    [self.backgroundView addSubview:line2];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 294/2, 68/2);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"_0013_登　录.png"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.center = CGPointMake(210/2, 270);
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:loginBtn];
    
    
    otherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 80)];
    otherView.backgroundColor = [UIColor clearColor];
    otherView.center = CGPointMake(210/2, 390);
    [self.backgroundView addSubview:otherView];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0004_——第三方登录—.png"]];
    line.frame = CGRectMake(0, 0, 341/2, 1);
    line.center = CGPointMake(otherView.frame.size.width/2, 20);
    [otherView addSubview:line];
    
    UILabel *otherlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    otherlabel.textColor = [UIColor grayColor];
    otherlabel.text = @"第三方登录";
    otherlabel.center = CGPointMake(otherView.frame.size.width/2, 20);
    [otherlabel setTextAlignment:NSTextAlignmentCenter];
    otherlabel.backgroundColor = [UIColor clearColor];
    otherlabel.font = [UIFont systemFontOfSize:13];
    [otherView addSubview:otherlabel];
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.frame = CGRectMake(66, 40, 30, 30);
    [weiboBtn setImage:[UIImage imageNamed:@"_0007_sina.png"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];
    [otherView addSubview:weiboBtn];
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(114, 40, 30, 30);
    [qqBtn setImage:[UIImage imageNamed:@"_0005_qq.png"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [otherView addSubview:qqBtn];
    
    float _height=0;
    if (self.view.frame.size.height>460)
    {
        _height = 65;
    }
    else
    {
        _height = 45;
        otherView.center = CGPointMake(210/2, 370);
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-_height, 210, _height)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self.backgroundView addSubview:bottomView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 200, 20)];
    label2.text = @"还没账号？请点击这里注册";
    [label2 setTextAlignment:NSTextAlignmentLeft];
    label2.font = [UIFont systemFontOfSize:13];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor whiteColor];
    [bottomView addSubview:label2];
    
    UIImageView *arrowsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0006_注册.png"]];
    arrowsImage.frame = CGRectMake(182, 15, 35/2, 35/2);
    [bottomView addSubview:arrowsImage];
    arrowsImage.userInteractionEnabled = YES;
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(0, 0, 210, 50);
    [pushBtn addTarget:self action:@selector(showRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:pushBtn];
    
}

- (void)showRegisterView
{
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    [self performSelector:@selector(registerView) withObject:nil afterDelay:0.3];
}

- (void)registerView
{
    RegisterViewController *registerView = [[RegisterViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:registerView];
    [n setNavigationBarHidden:YES];
    
    self.sidePanelController.leftPanel = n;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLEFTVIEW object:nil];
}

#pragma mark - 登录
- (void)login
{
    if (textfield_username.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (textfield_password.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    [ProgressHUD show:@"登录中"];
    
    [[ALBazaarEngine defauleEngine] loginWithUsername:textfield_username.text password:textfield_password.text block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            
            [bself.sidePanelController showCenterPanelAnimated:YES];
            
            [[ScheduleRequestManager defaultManager] requestAllSchedule];
            
            [bself performSelector:@selector(addMenuView) withObject:nil afterDelay:0.3];
        }
        else
        {
            [ProgressHUD showError:@"登录失败，请重新尝试"];
        }
        
        bself.isRequest = NO;
        
    }];
    
    
}

- (void)addMenuView
{
    MenuViewController *menuView = [[MenuViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:menuView];
    [n setNavigationBarHidden:YES];
    
    self.sidePanelController.leftPanel = n;
}

#pragma mark - 第三方登录
- (void)weiboLogin
{
    
}

- (void)qqLogin
{
    
}

#pragma mark - UITextFieldDelegate
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
