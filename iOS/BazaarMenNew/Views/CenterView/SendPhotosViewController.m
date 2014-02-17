//
//  SendPhotosViewController.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-9.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "SendPhotosViewController.h"
#import "WeatherRequestManager.h"
#import "ALGPSHelper.h"
#import "ALBazaarSDK.h"
#import "UIImage+imageNamed_Hack.h"

@interface SendPhotosViewController ()

@end

@implementation SendPhotosViewController
@synthesize imageArray = _imageArray;
@synthesize viewArray = _viewArray;
@synthesize pointArray = _pointArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
   
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
  
}

- (id)initWithUserImage:(UIImage *)image
{
    if (self = [super init])
    {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
        self.viewArray = [NSMutableArray arrayWithCapacity:0];
        self.pointArray = [NSMutableArray arrayWithCapacity:0];
        
        if (image!=nil)
        {
            [self.imageArray addObject:image];
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSuccess) name:GPSLOCATIONSUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshError) name:GPSLOCATIONERROR object:nil];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"close_image0001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(273, 3, 50, 40);
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [sendBtn addTarget:self action:@selector(sendPhotos) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:sendBtn];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 530);
    [self.backgroundView addSubview:_scrollView];
    
    UIView *backtextView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, SCREEN_WIDTH-4, 185)];
    backtextView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    backtextView.layer.borderWidth = 1;
    backtextView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [_scrollView addSubview:backtextView];
    
    
    noteTextView = [[NoteView alloc] initWithFrame:CGRectMake(8, 38, SCREEN_WIDTH-20, 140)];
    noteTextView.font = [UIFont systemFontOfSize:20];
    noteTextView.delegate = self;
    noteTextView.keyboardType = UIKeyboardTypeDefault;
    noteTextView.textColor = [UIColor grayColor];
    noteTextView.backgroundColor = [UIColor clearColor];
    noteTextView.returnKeyType = UIReturnKeyDone;
    [backtextView addSubview:noteTextView];
    
    for (int i=0; i<4; i++)
    {
        CGRect frame = CGRectMake(10+100*i, 240-44, 98, 140);
        NSValue *v = [NSValue valueWithCGRect:frame];
        
        [self.pointArray addObject:v];
    }
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"sendphoto_image0001.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPhotos) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:addBtn];
    
    if (self.imageArray.count>0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 240-44, 98, 140)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor =[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
        view.layer.borderWidth = 1;
        [_scrollView addSubview:view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(3, 3, 92, 134);
        btn.tag = 9000;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn setImage:[self.imageArray objectAtIndex:0] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        [self.viewArray addObject:view];
        
        addBtn.frame = CGRectMake(10+100, 240-44, 98, 140);
    }
    else
    {
        addBtn.frame = CGRectMake(10, 240-44, 98, 140);
    }
    
    [self.viewArray addObject:addBtn];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",[ALGPSHelper OpenGPS].administrativeArea,[ALGPSHelper OpenGPS].subLocality,[ALGPSHelper OpenGPS].locationName];
    CGSize _size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 40) lineBreakMode:0];
    
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 342, _size.width, _size.height)];
    addressLabel.text = str;
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [_scrollView addSubview:addressLabel];
    
    refrshBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [refrshBtn setImage:[UIImage imageNamed:@"refreshaddress_image.png"] forState:UIControlStateNormal];
    refrshBtn.frame = CGRectMake(addressLabel.frame.size.width+10, 343, 20, 20);
    [refrshBtn addTarget:self action:@selector(refreshAddress) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:refrshBtn];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.frame = CGRectMake(addressLabel.frame.size.width+10, 343, 20, 20);
    _activity.hidden=YES;
    [_scrollView addSubview:_activity];
    
    UIView *shareView =[[UIView alloc] initWithFrame:CGRectMake(2, 385, SCREEN_WIDTH-4, 100)];
    shareView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
    shareView.layer.borderWidth = 1;
    shareView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [_scrollView addSubview:shareView];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    shareLabel.text = @"分享到···";
    shareLabel.font = [UIFont systemFontOfSize:14];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textColor = [UIColor grayColor];
    shareLabel.textAlignment = NSTextAlignmentLeft;
    [shareView addSubview:shareLabel];
    
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame = CGRectMake(10, 30, 112/2, 90/2);
    [sinaBtn setImage:[UIImage imageNamed:@"sina_image.png"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(shareToSinaWeibo) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:sinaBtn];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(10+45+25, 31, 112/2, 90/2);
    [weixinBtn setImage:[UIImage imageNamed:@"weixin_image.png"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(shareToWeixin) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:weixinBtn];
    
    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20)];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha=0.4;
    _coverView.hidden=YES;
    _coverView.userInteractionEnabled = YES;
    [self.view addSubview:_coverView];
    
}

#pragma mark - 分享
- (void)shareToSinaWeibo
{
    
}

- (void)shareToWeixin
{
    
}


#pragma mark - 刷新地址
- (void)refreshAddress
{
    if (self.isRefresh==YES)
    {
        return;
    }
    
    self.isRefresh=YES;
    refrshBtn.hidden = YES;
    _activity.hidden=NO;
    [_activity startAnimating];
    
    [[ALGPSHelper OpenGPS] refreshLocation];
}


- (void)refreshSuccess
{
    refrshBtn.hidden = NO;
    _activity.hidden=YES;
    [_activity stopAnimating];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",[ALGPSHelper OpenGPS].administrativeArea,[ALGPSHelper OpenGPS].subLocality,[ALGPSHelper OpenGPS].locationName];
    CGSize _size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 40) lineBreakMode:0];
    addressLabel.frame = CGRectMake(10, 342, _size.width, _size.height);
    refrshBtn.frame = CGRectMake(addressLabel.frame.size.width+10, 343, 20, 20);
    _activity.frame = CGRectMake(addressLabel.frame.size.width+10, 343, 20, 20);

    self.isRefresh=NO;
}

- (void)refreshError
{
    refrshBtn.hidden = NO;
    _activity.hidden=YES;
    [_activity stopAnimating];
    
    self.isRefresh=NO;
}


#pragma mark - 发送自拍图片 文字
- (void)sendPhotos
{
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (self.imageArray.count==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择至少一张照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    if (noteTextView.text.length==0)
    {
        noteTextView.text = @"";
    }
    
    if (self.isPost==YES)
    {
        return;
    }
    
    self.isPost=YES;
    
    [noteTextView resignFirstResponder];
    
    _coverView.hidden=NO;
    
    [ProgressHUD show:@"发布中"];
   
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i=0; i<self.imageArray.count; i++)
    {
        UIImage *tempimg1 = [self.imageArray objectAtIndex:i];
        UIImage *tempimg2; //压缩图片
        
        NSLog(@"%f,%f",tempimg1.size.width,tempimg1.size.height);
        
        float resolution = tempimg1.size.width*tempimg1.size.height;
        float i = resolution/150000;
        
        NSLog(@"%f",resolution/150000);
        
        if (i>=8)
        {
            i=8;
        }
        else
        {
            i=1;
        }
        
        tempimg2 = [tempimg1 imageScaled:i];
        
        AVFile *imagefile = [AVFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(tempimg2, 1)];
        [temp addObject:imagefile];
    }
    
    __block typeof(self) bself = self;
    
    __block UIView *__coverview = _coverView;
    
    NSString *address = [NSString stringWithFormat:@"%@,%@,%@",[ALGPSHelper OpenGPS].administrativeArea,[ALGPSHelper OpenGPS].subLocality,[ALGPSHelper OpenGPS].locationName];

    Weather *tempweather = [[WeatherRequestManager defaultManager].weatherinfo.weathers objectAtIndex:0];
    int temperature = tempweather.temperature;
    
    NSLog(@"wendu:%d,code:%d",temperature,tempweather.weatherCode);
    
    [[ALBazaarEngine defauleEngine] postPhotoWithImage:temp temperature:temperature weatherCode:tempweather.weatherCode text:noteTextView.text voice:nil isShareToSinaWeibo:NO isShareToQQWeibo:NO latitude:[ALGPSHelper OpenGPS].latitude longitude:[ALGPSHelper OpenGPS].longitude place:address block:^(BOOL succeeded, NSError *error) {
        
        __coverview.hidden=YES;
        
        if (succeeded && !error)
        {
            [ProgressHUD showSuccess:@"成功"];
            NSLog(@"succeed");
            
            [bself back];
        }
        else
        {
            [ProgressHUD showError:@"失败,请重新尝试"];
            NSLog(@"%@",error);
        }
        
        bself.isPost=NO;
        
    }];
}


#pragma mark - 选择图片 删除图片
- (void)addPhotos
{
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"打开相册", nil];
    [_sheet showInView:self.view];
}

- (void)movePhoto
{
    for (int i=0; i<self.viewArray.count; i++)
    {
        UIView *view = (UIView *)[self.viewArray objectAtIndex:i];
        CGRect _fame = [[self.pointArray objectAtIndex:i] CGRectValue];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            view.frame = _fame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)removePhoto:(UIButton *)sender
{
    _phototag = sender.tag-9000;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否要删除照片？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self.imageArray removeObjectAtIndex:_phototag];
        
        UIView *view = (UIView *)[self.viewArray objectAtIndex:_phototag];
        [view removeFromSuperview];
        
        [self.viewArray removeObjectAtIndex:_phototag];
        
        
        int _tag = 9000;
        
        for (int i=0; i<self.viewArray.count-1; i++)
        {
            UIView *view = [self.viewArray objectAtIndex:i];
            UIButton *btn = [[view subviews] objectAtIndex:0];
            btn.tag = _tag;
            _tag++;
        }
        
        if (self.imageArray.count<3)
        {
            UIButton *btn = [self.viewArray lastObject];
            btn.hidden=NO;
        }
        
        [self movePhoto];
    }
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
    UIImage *image = (UIImage *)[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (image!=nil)
    {

        CGRect _fame = [[self.pointArray objectAtIndex:0] CGRectValue];
        
        
        UIView *view = [[UIView alloc] initWithFrame:_fame];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor =[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
        view.layer.borderWidth = 1;
        [_scrollView addSubview:view];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(3, 3, 92, 134);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(removePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        [self.viewArray insertObject:view atIndex:0];
        [self.imageArray addObject:image];

        int _tag = 9000;

        for (int i=0; i<self.viewArray.count-1; i++)
        {
            UIView *view = [self.viewArray objectAtIndex:i];
            UIButton *btn = [[view subviews] objectAtIndex:0];
            btn.tag = _tag;
            _tag++;
        }

        if (self.imageArray.count==3)
        {
            UIButton *btn = [self.viewArray lastObject];
            btn.hidden=YES;
        }
        
        [self movePhoto];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // to update NoteView
    [noteTextView setNeedsDisplay];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [noteTextView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GPSLOCATIONERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GPSLOCATIONSUCCESS object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
