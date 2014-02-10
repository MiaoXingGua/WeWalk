//
//  SeacherCityCell.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-12.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeacherCityCell : UITableViewCell
{
    UILabel *_cityName;
    UILabel *_contentLabel;
}

@property(nonatomic,strong)UILabel *cityName;
@property(nonatomic,strong)UILabel *contentLabel;

@end
