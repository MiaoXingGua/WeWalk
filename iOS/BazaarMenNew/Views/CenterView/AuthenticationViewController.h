//
//  RignUpViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface AuthenticationViewController : SuperViewController<UITextFieldDelegate>
{
    UITextField *_textfield_phone;
}

@end
