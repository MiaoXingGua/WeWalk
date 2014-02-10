//
//  SettingCell.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-13.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell
{
    UIImageView *_iconView;
    UILabel *_titleLable;
    UILabel *_contentLabel;
}

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLable,*contentLabel;
@end
