//
//  CompleteInfoViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AsyncImageView.h"

@interface CompleteInfoViewController : SuperViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    UITextField *_textfield_name;
    
    UIImageView *imageview;
    UIButton *selectBtn;
    
    AsyncImageView *headView;
}

@property(nonatomic,strong)UIImage *userImage;

@end
