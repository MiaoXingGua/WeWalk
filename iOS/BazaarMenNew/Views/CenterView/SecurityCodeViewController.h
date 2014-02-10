//
//  SecurityCodeViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface SecurityCodeViewController : SuperViewController
{
    UILabel *_timeLabel;
    NSTimer *_timer;
    
    UITextField *_textfield_code;
    
    int _second;
    UIButton *againBtn;
}
@property(nonatomic,strong)NSString *phoneNumber;

@end
