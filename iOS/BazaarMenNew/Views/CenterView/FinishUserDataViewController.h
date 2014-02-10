//
//  FinishUserDataViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-10.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AsyncImageView.h"

@interface FinishUserDataViewController : SuperViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AsyncImageView *userHeadBtn;
    UITextField *nick;
    
    UIImage *_userImage;
    
    UIView *_coverView;
}
@property(nonatomic,strong)UIImage *userImage;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isDismiss;
@end
