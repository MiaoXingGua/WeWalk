//
//  CityCell.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-16.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UITableViewCell
{
    UIView *_coverView,*_coverView2;
    UILabel *_citynameLable;
    UIButton *_deleteBtn;
    
    UIButton *coverBtn;
    
    BOOL isOpen;
}

@property(nonatomic,strong)UILabel *citynameLable;
@property(nonatomic,strong)UIButton *deleteBtn;

@end
