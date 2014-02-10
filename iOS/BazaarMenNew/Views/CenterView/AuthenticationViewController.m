//
//  RignUpViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "SecurityCodeViewController.h"

@interface AuthenticationViewController ()

@end

@implementation AuthenticationViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_textfield_phone becomeFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [_textfield_phone resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    back.userInteractionEnabled = YES;
    [self.backgroundView addSubview:back];
    
    UIImageView *naviImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0004_矩形-2.png"]];
    naviImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    naviImageView.userInteractionEnabled = YES;
    [self.backgroundView addSubview:naviImageView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 13, 46/2, 40/2);
    [backBtn setImage:[UIImage imageNamed:@"_0003_返回.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.text = @"手 机 号 注 册";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.center = CGPointMake(SCREEN_WIDTH/2, naviImageView.frame.size.height/2);
    titleLabel.font = [UIFont systemFontOfSize:19];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [naviImageView addSubview:titleLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(250, 8, 60, 30);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:nextBtn];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 150, 30)];
    label1.text = @"请输入您的手机号";
    [label1 setTextAlignment:NSTextAlignmentLeft];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:17];
    [self.backgroundView addSubview:label1];
    
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_——.png"]];
    lineView.frame = CGRectMake(0, 104, SCREEN_WIDTH, 1);
    [self.backgroundView addSubview:lineView];
    
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0000_手机号bg.png"]];
    image1.frame = CGRectMake(0, 0, 552/2, 74/2);
    image1.center = CGPointMake(SCREEN_WIDTH/2, 148);
    image1.userInteractionEnabled = YES;
    [self.backgroundView addSubview:image1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 50, 30)];
    label2.text = @"+86";
    [label2 setTextAlignment:NSTextAlignmentLeft];
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:22];
    label2.font = [UIFont boldSystemFontOfSize:22];
    label2.backgroundColor = [UIColor clearColor];
    [image1 addSubview:label2];
    
    _textfield_phone = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, 160, 74/2)];
    _textfield_phone.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfield_phone.delegate = self;
    _textfield_phone.placeholder = @"输入手机号码";
    _textfield_phone.keyboardType = UIKeyboardTypePhonePad;
    _textfield_phone.returnKeyType = UIReturnKeyDone;
    _textfield_phone.font = [UIFont systemFontOfSize:22];
    _textfield_phone.font = [UIFont boldSystemFontOfSize:22];
    _textfield_phone.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_phone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _textfield_phone.backgroundColor = [UIColor clearColor];
    [image1 addSubview:_textfield_phone];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_选择.png"]];
    image2.frame = CGRectMake(22, 184, 25/2, 25/2);
    [self.backgroundView addSubview:image2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 100, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"已阅读并同意";
    label3.font = [UIFont systemFontOfSize:12];
    [self.backgroundView addSubview:label3];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(113, 180, 200, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = @"Bazaar软件许可及服务协议";
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:12];
    [self.backgroundView addSubview:label4];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(113, 197, 147, 1)];
    line2.backgroundColor = [UIColor grayColor];
    [self.backgroundView addSubview:line2];
    
}


- (void)next
{
    if (_textfield_phone.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if ([self isMobileNumber:_textfield_phone.text]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"手机号格式不正确，请重新输入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认手机号码" message:[NSString stringWithFormat:@"我们将发送验证码短信到这个号码:\n+86 %@",[self editPhoneNumber]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    [alert show];
}

- (NSString *)editPhoneNumber
{
    NSMutableString *str = [NSMutableString string];
    
    for (int i=0; i<11; i++)
    {
        NSRange _range = NSMakeRange(i, 1);
        
        if (i==3)
        {
            [str appendString:@" "];
        }
        
        if (i==7)
        {
            [str appendString:@" "];
        }
        
        
        [str appendString:[_textfield_phone.text substringWithRange:_range]];
    }
    
    return str;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        SecurityCodeViewController *code = [[SecurityCodeViewController alloc] init];
        code.phoneNumber = _textfield_phone.text;
        [self.navigationController pushViewController:code animated:YES];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 检测手机号
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
