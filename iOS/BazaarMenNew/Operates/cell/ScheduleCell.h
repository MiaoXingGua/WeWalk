//
//  ScheduleCell.h
//  BazaarMan
//
//  Created by superhomeliu on 14-1-3.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLongPress.h"

@interface ScheduleCell : UITableViewCell
{
    UIView *_backView;
    UIImageView *_stateView;
    UIImageView *_stateColorView;
    UIImageView *_lineView;
    
    UIImageView *_imgicon;
    
    UILabel *_timeLabel,*_contentLabel;
    
    CustomLongPress *_longpress;
}

@property(nonatomic,strong)UIImageView *stateView;
@property(nonatomic,strong)UIImageView *stateColorView;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIImageView *imgicon;
@property(nonatomic,strong)CustomLongPress *longpress;
@property(nonatomic,strong)UILabel *timeLabel,*contentLabel;

@end
