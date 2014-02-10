//
//  LoginViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-7.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface LoginViewController : SuperViewController<UITextFieldDelegate>
{
    UITextField *textfield_username,*textfield_password;
    
    UIView *otherView;
}
@property(nonatomic,assign)BOOL isRequest;

@end
