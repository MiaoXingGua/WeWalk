//
//  FinishUserDataViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-10.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "FinishUserDataViewController.h"
#import "IntoViewController.h"
#import "ALBazaarSDK.h"

@interface FinishUserDataViewController ()

@end

@implementation FinishUserDataViewController
@synthesize userImage = _userImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backview.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
    [self.backgroundView addSubview:backview];
    
    NSLog(@"%f",self.view.frame.size.height);
    
    float _h=0;
    if (self.view.frame.size.height>480)
    {
        _h=0;
    }
    else
    {
        _h = 20;
    }
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coverimage_0002.png"]];
    imageview.frame = CGRectMake(0, 0, 158/2, 158/2);
    imageview.center = CGPointMake(SCREEN_WIDTH/2, 130-_h);
    imageview.userInteractionEnabled = YES;
    [self.backgroundView addSubview:imageview];
    
    userHeadBtn = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 158/2-5, 158/2-5) ImageState:0];
    userHeadBtn.scaleState=2;
    userHeadBtn.center = CGPointMake(imageview.frame.size.width/2, imageview.frame.size.height/2);
    userHeadBtn.backgroundColor = [UIColor clearColor];
    [userHeadBtn addTarget:self action:@selector(selectUserHead) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:userHeadBtn];
    
    nick = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 140, 30)];;
    nick.backgroundColor = [UIColor clearColor];
    nick.delegate = self;
    nick.text = @"匿名";
    nick.center = CGPointMake(SCREEN_WIDTH/2, 205-_h);
    [nick setTextAlignment:NSTextAlignmentCenter];
    nick.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    nick.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nick.textColor = [UIColor blackColor];
    nick.returnKeyType = UIReturnKeyDone;
    [self.backgroundView addSubview:nick];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    line.center = CGPointMake(SCREEN_WIDTH/2, 220-_h);
    [self.backgroundView addSubview:line];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 295/2, 68/2);
    [completeBtn setBackgroundImage:[UIImage imageNamed:@"blackbtn_image.png"] forState:UIControlStateNormal];
    [completeBtn setTitle:@"完 成" forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completeBtn.center = CGPointMake(SCREEN_WIDTH/2, 330);
    [completeBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundView addSubview:completeBtn];
 
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.hidden=YES;
    _coverView.alpha = 0.4;
    _coverView.userInteractionEnabled = YES;
    [self.view addSubview:_coverView];
}

- (void)complete
{
    if (nick.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    if (nick.text.length>20)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称长度不能大于20个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    
    if (self.userImage==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择头像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    _coverView.hidden=NO;
    
    [ProgressHUD show:@"上传中"];
    
    __block typeof(self) bself = self;
    __block UIView *__coverview = _coverView;
    
    NSData *imageData = UIImageJPEGRepresentation(self.userImage, 0.5);
    AVFile *_imagefile = [AVFile fileWithName:@"userheadviewimage.jpg" data:imageData];
    
    [[ALBazaarEngine defauleEngine] updateUserInfoWithHeadView:_imagefile nickname:nick.text gender:1 backgroundView:nil city:nil block:^(BOOL succeeded, NSError *error) {
        
        __coverview.hidden=YES;
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            
            NSLog(@"成功");
            
            if (bself.isDismiss==NO)
            {
                [bself openIntoView];
            }
            else
            {
                [bself dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
        else
        {
            [ProgressHUD showError:@"上传用户资料失败，请重新尝试"];
        }
        
        bself.isRequest=NO;
        
    }];
}

- (void)openIntoView
{
    IntoViewController *intoview = [[IntoViewController alloc] init];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController pushViewController:intoview animated:NO];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
}

#pragma mark - 选择用户头像
- (void)selectUserHead
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
    
    self.userImage = image;
    
    userHeadBtn.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
