//
//  MenuViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-7.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AsyncImageView.h"

@interface MenuViewController : SuperViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AsyncImageView *headView;
    
    UIView *operationView;
    UIView *authenticationView;
    
    UIImageView *vImageView;
    
    UILabel *usernameLabel;
}

@end
