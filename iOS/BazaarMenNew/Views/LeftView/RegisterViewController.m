//
//  RegisterViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-7.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "RegisterViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "LoginViewController.h"
#import "FinishUserDataViewController.h"
#import "MenuViewController.h"
#import "ALBazaarSDK.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeRegisterUser) name:SHOWCENTERVIEWCONTROLLER object:nil];
    
    UIImageView *backImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    backImageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:backImageview];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:backView];
    
    UIImageView *logview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixing.png"]];
    logview.frame = CGRectMake(0, 0, 349/2, 109/2);
    logview.center = CGPointMake(210/2, 100);
    [backView addSubview:logview];
    
    UIImageView *usernameimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username_image0001.png"]];
    usernameimage.frame = CGRectMake(17, 140, 44/2, 47/2);
    [backView addSubview:usernameimage];
    
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
    [backView addSubview:textfield_username];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(17, 170, 175, 1)];
    line1.backgroundColor =[UIColor lightGrayColor];
    [backView addSubview:line1];
    
    UIImageView *passwordimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image0002.png"]];
    passwordimage.frame = CGRectMake(17, 195, 51/2, 30/2);
    [backView addSubview:passwordimage];
    
    
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
    [backView addSubview:textfield_password];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(17, 220, 175, 1)];
    line2.backgroundColor =[UIColor lightGrayColor];
    [backView addSubview:line2];
    
    
    UIImageView *passwordimage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_image0002.png"]];
    passwordimage2.frame = CGRectMake(17, 195+50, 51/2, 30/2);
    [backView addSubview:passwordimage2];
    
    
    textfield_passwordagain = [[UITextField alloc] initWithFrame:CGRectMake(50, 190+50, 130, 30)];
    textfield_passwordagain.backgroundColor = [UIColor clearColor];
    textfield_passwordagain.delegate = self;
    textfield_passwordagain.tag = 123;
    [textfield_passwordagain setSecureTextEntry:YES];
    textfield_passwordagain.keyboardType = UIKeyboardTypeAlphabet;
    textfield_passwordagain.borderStyle = UITextBorderStyleNone;
    textfield_passwordagain.returnKeyType = UIReturnKeyDone;
    textfield_passwordagain.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfield_passwordagain.autocorrectionType = UITextAutocorrectionTypeNo;
    textfield_passwordagain.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield_passwordagain.placeholder = @"确认密码";
    textfield_passwordagain.textColor = [UIColor blackColor];
    [backView addSubview:textfield_passwordagain];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(17, 220+50, 175, 1)];
    line3.backgroundColor =[UIColor lightGrayColor];
    [backView addSubview:line3];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(0, 0, 294/2, 68/2);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"_0013_登　录.png"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"注 册" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.center = CGPointMake(210/2, 320);
    [loginBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:loginBtn];
    
    
    float _height=0;
    if (self.view.frame.size.height>460)
    {
        _height = 65;
    }
    else
    {
        _height = 45;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-_height, 210, _height)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [backView addSubview:bottomView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 14, 200, 20)];
    label2.text = @"返回登录页面";
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
    [pushBtn addTarget:self action:@selector(backtoLoginView) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:pushBtn];
}

#pragma makr - 完成注册
- (void)completeRegisterUser
{
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    [self performSelector:@selector(addMenuView) withObject:nil afterDelay:0.3];
}

- (void)addMenuView
{
    MenuViewController *menuView = [[MenuViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:menuView];
    [n setNavigationBarHidden:YES];
    
    self.sidePanelController.leftPanel = n;
}

#pragma mark - 注册
- (void)registerUser
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
    
    
    if (textfield_password.text.length>0 && textfield_password.text.length<6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码长度需要大于6位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }

    
    if (textfield_passwordagain.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (![textfield_password.text isEqualToString:textfield_passwordagain.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码必须一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    [ProgressHUD show:@"注册中"];
    
    __block typeof(self) bself = self;
    
    [[ALBazaarEngine defauleEngine] signUpWithUsername:textfield_username.text password:textfield_password.text block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            
            [bself openFinishUserDataView];
        }
        else
        {
            NSLog(@"%@",[[error userInfo] objectForKey:@"error"]);

            int _code = [[[error userInfo] objectForKey:@"code"] intValue];
            
            if (_code==202)
            {
                [ProgressHUD showError:@"用户名已注册"];
            }
            else
            {
                [ProgressHUD showError:@"注册失败，请重新尝试"];
            }
        }
        
        bself.isRequest=NO;
    }];
    
}

- (void)openFinishUserDataView
{
    FinishUserDataViewController *finishview = [[FinishUserDataViewController alloc] init];
    finishview.isDismiss=NO;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController pushViewController:finishview animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.sidePanelController setCenterPanelHidden:YES animated:YES duration:0.2];
}

#pragma mark - 返回登录
- (void)backtoLoginView
{
    [self.sidePanelController showCenterPanelAnimated:YES];
    
    [self performSelector:@selector(loginView) withObject:nil afterDelay:0.3];
}

- (void)loginView
{
    LoginViewController *loginview = [[LoginViewController alloc] init];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:loginview];
    [n setNavigationBarHidden:YES];
    
    self.sidePanelController.leftPanel = n;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOWLEFTVIEW object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==123)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            backView.frame = CGRectMake(0, -50, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        } completion:^(BOOL finished) {
            
        }];
    }
   
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (backView.frame.origin.y!=0)
    {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
