//
//  UserInfoCell.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
{
    UILabel *_dayLabel,*_monthLabel,*_weekLabel;
    
    UIView *_photoView;
}
@property(nonatomic,strong)UILabel *dayLabel,*monthLabel,*weekLabel;
@property(nonatomic,strong)UIView *photoView;

@end
