//
//  MessageCell.h
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface MessageCell : UITableViewCell
{
    
}

@property(nonatomic,strong)AsyncImageView *headView;
@property(nonatomic,strong)UIImageView *coverView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *unReadLabel;
@property(nonatomic,strong)UIImageView *unreadbackground;

@end
