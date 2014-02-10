//
//  AttentionCell.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AttentionCell : UITableViewCell
{
    AsyncImageView *_headView;
    UIImageView *_coverView;
    
    UILabel *_nameLabel;
    
    UIView *_lineView;
}

@property(nonatomic,strong)AsyncImageView *headView;
@property(nonatomic,strong)UIImageView *coverView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIView *lineView;

@end
