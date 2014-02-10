//
//  ClothesCell.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-9.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ClothesCell : UITableViewCell
{
    UIView *_backView;
    UILabel *_nameLabel,*_dateLabel,*_contentLabel;
    AsyncImageView *_userHeadView;
    UIImageView *_userHeadCoverView;
    
    UIView *_lineView;
    UIView *_lineView2;
}
@property(nonatomic,strong)UIView *lineView,*lineView2;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *nameLabel,*dateLabel,*contentLabel;
@property(nonatomic,strong)AsyncImageView *userHeadView;
@property(nonatomic,strong)UIImageView *userHeadCoverView;

@end
