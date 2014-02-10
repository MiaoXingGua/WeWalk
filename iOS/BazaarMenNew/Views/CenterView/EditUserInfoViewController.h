//
//  EditUserInfoViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-16.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALBazaarSDK.h"
#import "SuperViewController.h"
#import "AsyncImageView.h"

@interface EditUserInfoViewController : SuperViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    AVUser *_user;
    
    AsyncImageView *userImageView;
    AsyncImageView *coverImageView;
    
    UIImage *_userImage;
    UIImage *_coverImage;
    
    int imageState;
    
    int gender;
    
    UITextField *textfield_name;
    
    UIView *_coverView;
}
@property(nonatomic,strong)AVUser *user;
@property(nonatomic,strong)UIImage *userImage;
@property(nonatomic,strong)UIImage *coverImage;

- (id)initWithUser:(AVUser *)user;
@end
