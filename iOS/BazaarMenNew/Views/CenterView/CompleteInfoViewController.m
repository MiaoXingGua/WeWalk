//
//  CompleteInfoViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "CompleteInfoViewController.h"

@interface CompleteInfoViewController ()

@end

@implementation CompleteInfoViewController
@synthesize userImage;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0001_背景.png"]];
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    back.userInteractionEnabled = YES;
    [self.backgroundView addSubview:back];
    
    float _height;
    if (self.view.frame.size.height>480)
    {
        _height=0;
    }
    else
    {
        _height=20;
    }
    
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
    titleLabel.text = @"填 写 名 字";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.center = CGPointMake(SCREEN_WIDTH/2, naviImageView.frame.size.height/2);
    titleLabel.font = [UIFont systemFontOfSize:19];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [naviImageView addSubview:titleLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(257, 8, 60, 30);
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [naviImageView addSubview:nextBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.center = CGPointMake(SCREEN_WIDTH/2, 85-_height);
    label.text = @"请设置头像、昵称方便朋友认出你";
    label.font = [UIFont systemFontOfSize:16];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.backgroundView addSubview:label];
    
    imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"_0000_paizhao.png"]];
    imageview.frame = CGRectMake(0, 0, 80, 80);
    imageview.center = CGPointMake(SCREEN_WIDTH/2, 162-_height*2);
    imageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:imageview];
    
    headView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75) ImageState:0];
    headView.center = CGPointMake(imageview.frame.size.width/2, imageview.frame.size.height/2);
    headView.image=nil;
    [headView addTarget:self action:@selector(beginSelectImage) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:headView];
    
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 220-_height*2.2, 50, 20)];
    nickLabel.text = @"昵称";
    nickLabel.backgroundColor = [UIColor clearColor];
    nickLabel.font = [UIFont systemFontOfSize:13];
    [nickLabel setTextAlignment:NSTextAlignmentLeft];
    [self.backgroundView addSubview:nickLabel];
    
    
    _textfield_name = [[UITextField alloc] initWithFrame:CGRectMake(135, 220-_height*2.2, 70, 20)];
    _textfield_name.autocorrectionType = UITextAutocorrectionTypeNo;
    _textfield_name.placeholder = @"张三";
    _textfield_name.delegate = self;
    _textfield_name.keyboardType = UIKeyboardTypeDefault;
    _textfield_name.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfield_name.returnKeyType = UIReturnKeyDone;
    _textfield_name.font = [UIFont systemFontOfSize:13];
    _textfield_name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfield_name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _textfield_name.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:_textfield_name];
    
    [_textfield_name becomeFirstResponder];

    
    UIView *_lineview = [[UIView alloc] initWithFrame:CGRectMake(100, 240-_height*2.2, 120, 0.5)];
    _lineview.backgroundColor = [UIColor grayColor];
    [self.backgroundView addSubview:_lineview];
    
}

- (void)beginSelectImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    [sheet showInView:self.view];
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        UIImagePickerController *imagPickerC = [[UIImagePickerController alloc] init];//图像选取器
        imagPickerC.delegate = self;
        imagPickerC.allowsEditing = YES;
        imagPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagPickerC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        [self presentViewController:imagPickerC animated:YES completion:nil];
    }
    
    if (buttonIndex == 1)
    {        
        UIImagePickerController *imagePiker = [[UIImagePickerController alloc] init];
        imagePiker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePiker.delegate = self;
        imagePiker.allowsEditing = YES;
        [self presentViewController:imagePiker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    self.userImage = image;
    
    headView.image = image;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [_textfield_name becomeFirstResponder];

}

- (void)next
{
    if (_textfield_name.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写昵称" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.userImage==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择头像" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self next];
    
    return YES;
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
