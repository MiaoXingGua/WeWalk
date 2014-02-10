//
//  SecurityCodeViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "SecurityCodeViewController.h"
#import "CompleteInfoViewController.h"
#import "AttributedLabel.h"

@interface SecurityCodeViewController ()

@end

@implementation SecurityCodeViewController
@synthesize phoneNumber;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [_textfield_code becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [_textfield_code resignFirstResponder];
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
    titleLabel.text = @"填 写 验 证 码";
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
    
    float _height;
    if (self.view.frame.size.height>480)
    {
        _height=0;
    }
    else
    {
        _height=20;
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(41, 60-_height*0.3, 100, 30)];
    label1.text = @"我们已发送";
    label1.font = [UIFont systemFontOfSize:16];
    label1.textColor = [UIColor blackColor];
    label1.backgroundColor = [UIColor clearColor];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [self.backgroundView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(122, 60-_height*0.3, 100, 30)];
    label2.text = @"登录码短信";
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor grayColor];
    label2.backgroundColor = [UIColor clearColor];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [self.backgroundView addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(203, 60-_height*0.3, 100, 30)];
    label3.text = @"到这个号码";
    label3.font = [UIFont systemFontOfSize:16];
    label3.textColor = [UIColor blackColor];
    label3.backgroundColor = [UIColor clearColor];
    [label3 setTextAlignment:NSTextAlignmentLeft];
    [self.backgroundView addSubview:label3];
    

    
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
        
        
        [str appendString:[self.phoneNumber substringWithRange:_range]];
        
       
    }
    
    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    numberLabel.text = [NSString stringWithFormat:@"+86  %@",str];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    numberLabel.center = CGPointMake(SCREEN_WIDTH/2, 115-_height*0.8);
    numberLabel.font = [UIFont systemFontOfSize:21];
    numberLabel.font = [UIFont boldSystemFontOfSize:21];
    numberLabel.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:numberLabel];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 48)];
    codeView.center = CGPointMake(SCREEN_WIDTH/2, 180-_height*1.7);
    codeView.backgroundColor = [UIColor clearColor];
    codeView.layer.borderColor = [UIColor blackColor].CGColor;
    codeView.layer.borderWidth = 1;
    [self.backgroundView addSubview:codeView];
    
    _textfield_code = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 48)];
    _textfield_code.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfield_code.keyboardType = UIKeyboardTypePhonePad;
    _textfield_code.returnKeyType = UIReturnKeyDone;
    _textfield_code.font = [UIFont systemFontOfSize:25];
    _textfield_code.font = [UIFont boldSystemFontOfSize:25];
    [_textfield_code setTextAlignment:NSTextAlignmentCenter];
    _textfield_code.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _textfield_code.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _textfield_code.backgroundColor = [UIColor clearColor];
    [codeView addSubview:_textfield_code];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _timeLabel.text = @"接收短信大约需要30秒";
    [_timeLabel setTextAlignment:NSTextAlignmentCenter];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.center = CGPointMake(SCREEN_WIDTH/2, 220-_height*1.5);
    [self.backgroundView addSubview:_timeLabel];
    
    againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    againBtn.frame = CGRectMake(0, 0, 90, 30);
    againBtn.center = CGPointMake(SCREEN_WIDTH/2, 260-_height*1.9);
    [againBtn setBackgroundImage:[UIImage imageNamed:@"_0000_denglu-bg.png"] forState:UIControlStateNormal];
    [againBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    againBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [againBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:againBtn];
    againBtn.userInteractionEnabled = NO;
    

    _second=30;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTime) userInfo:nil repeats:YES];
}

- (void)sendCode
{
    againBtn.userInteractionEnabled = NO;
    
    _timeLabel.text = @"接收短信大约需要30秒";

    _second=30;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginTime) userInfo:nil repeats:YES];
}

- (void)beginTime
{
    if (_second==0)
    {
        [_timer invalidate];
        _timer=nil;
        
        againBtn.userInteractionEnabled = YES;
        
        return;
    }
    
    _second -= 1;
    
    _timeLabel.text = [NSString stringWithFormat:@"接收短信大约需要%d秒",_second];
}

- (void)next
{
    if (_textfield_code.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请填写短信验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    CompleteInfoViewController *com = [[CompleteInfoViewController alloc] init];
    [self.navigationController pushViewController:com animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
