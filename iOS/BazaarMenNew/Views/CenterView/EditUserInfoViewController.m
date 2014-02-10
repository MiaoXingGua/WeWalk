//
//  EditUserInfoViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-16.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()

@end

@implementation EditUserInfoViewController
@synthesize user = _user;
@synthesize userImage = _userImage;
@synthesize coverImage = _coverImage;



- (id)initWithUser:(AVUser *)user
{
    if (self = [super init])
    {
        self.user = user;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"个人信息";
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
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 30+44, SCREEN_WIDTH, 120)];
    backview.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:backview];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40, 40, SCREEN_WIDTH-40, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [backview addSubview:line];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(40, 80, SCREEN_WIDTH-40, 1)];
    line2.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [backview addSubview:line2];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    label1.text = @"头像";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:15];
    [backview addSubview:label1];
    
    userImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(275, 5, 30, 30) ImageState:0];
    userImageView.urlString = [self.user objectForKey:@"smallHeadViewURL"];
    userImageView.defaultImage=0;
    userImageView.backgroundColor = [UIColor clearColor];
    [backview addSubview:userImageView];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 20)];
    label2.text = @"昵称";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:15];
    [backview addSubview:label2];
    
    textfield_name = [[UITextField alloc] initWithFrame:CGRectMake(123, 40, 180, 40)];
    textfield_name.backgroundColor = [UIColor clearColor];
    textfield_name.textAlignment = NSTextAlignmentRight;
    textfield_name.textColor = [UIColor blackColor];
    textfield_name.delegate = self;
    textfield_name.returnKeyType = UIReturnKeyDone;
    textfield_name.text = [self.user objectForKey:@"nickname"];
    textfield_name.font = [UIFont systemFontOfSize:15];
    textfield_name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backview addSubview:textfield_name];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 20)];
    label4.text = @"主页封面";
    label4.textColor = [UIColor blackColor];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.backgroundColor = [UIColor clearColor];
    label4.font = [UIFont systemFontOfSize:15];
    [backview addSubview:label4];
    
    coverImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(275, 85, 30, 30) ImageState:0];
    coverImageView.defaultImage = 0;
    coverImageView.backgroundColor = [UIColor clearColor];
    coverImageView.urlString = [self.user objectForKey:@"backgroundViewURL"];
    coverImageView.backgroundColor = [UIColor clearColor];
    [backview addSubview:coverImageView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 5, SCREEN_WIDTH, 30);
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(editUserHead) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 85, SCREEN_WIDTH, 30);
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(editCoverImage) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:btn2];
    
    UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.frame = CGRectMake(0, 0, 260, 35);
    [updateBtn setTitle:@"更新资料" forState:UIControlStateNormal];
    updateBtn.center = CGPointMake(SCREEN_WIDTH/2, 250);
    [updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal
     ];
    updateBtn.backgroundColor = [UIColor grayColor];
    [updateBtn addTarget:self action:@selector(updateUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:updateBtn];
    
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden=YES;
    _coverView.alpha = 0.4;
    _coverView.userInteractionEnabled = YES;
    [self.view addSubview:_coverView];
}

#pragma mark - 选择头像
- (void)editUserHead
{
    imageState = 0;
    
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"打开相册", nil];
    [_sheet showInView:self.view];
}

#pragma mark - 选择封面图
- (void)editCoverImage
{
    imageState = 1;
    
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
        imagePiker.allowsEditing = YES;
        [self presentViewController:imagePiker
                           animated:YES
                         completion:nil];
    }
    
    if (buttonIndex == 1)
    {
        
        UIImagePickerController *imagPickerC = [[UIImagePickerController alloc] init];//图像选取器
        imagPickerC.delegate = self;
        imagPickerC.allowsEditing = YES;
        imagPickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        imagPickerC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        
        [self presentViewController:imagPickerC animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    if (imageState==0)
    {
        self.userImage = image;
        
        userImageView.image = image;
    }
    else
    {
        self.coverImage = image;
        
        coverImageView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)updateUserInfo
{
    
    if (textfield_name.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (textfield_name.text.length>20)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称长度不能大于20个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }

        
    _coverView.hidden=NO;
    
    [ProgressHUD show:@"更新中"];
    

    AVFile *_userfile = nil;
    AVFile *_coverfile = nil;
    
    if (self.userImage!=nil)
    {
        _userfile = [AVFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(self.userImage, 0.5)];
    }
    
    if (self.coverImage!=nil)
    {
        _coverfile = [AVFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(self.coverImage, 0.5)];
    }

    __block typeof(self) bself = self;

    
    __block UIView *__coverview = _coverView;

    [[ALBazaarEngine defauleEngine] updateUserInfoWithHeadView:_userfile nickname:textfield_name.text gender:YES backgroundView:_coverfile city:nil block:^(BOOL succeeded, NSError *error) {
        
        __coverview.hidden=YES;
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESHUSERINFO object:nil];
            
            [bself.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [ProgressHUD showError:@"上传用户资料失败，请重新尝试"];
        }
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"资料还未更新，是否退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
