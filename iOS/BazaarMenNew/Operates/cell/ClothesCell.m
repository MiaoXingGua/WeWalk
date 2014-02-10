//
//  ClothesCell.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-9.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ClothesCell.h"

@implementation ClothesCell
@synthesize nameLabel = _nameLabel;
@synthesize contentLabel = _contentLabel;
@synthesize dateLabel = _dateLabel;
@synthesize userHeadCoverView = _userHeadCoverView;
@synthesize userHeadView = _userHeadView;
@synthesize backView = _backView;
@synthesize lineView = _lineView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        self.backView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        [self.contentView addSubview:self.backView];
        
        
        self.lineView2 = [[[UIView alloc] init] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        self.lineView2.backgroundColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1];
        [self.backView addSubview:self.lineView2];
        
        self.lineView = [[[UIView alloc] init] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1];
        [self.backView addSubview:self.lineView];
        
        self.userHeadCoverView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 55, 55)];
        self.userHeadCoverView.image = [UIImage imageNamed:@"touxing.png"];
        self.userHeadCoverView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.userHeadCoverView];
        
        self.userHeadView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 49, 49) ImageState:0];
        self.userHeadView.backgroundColor = [UIColor clearColor];
        self.userHeadView.center = CGPointMake(55/2+0.2, 55/2+0.2);
        [self.userHeadCoverView addSubview:self.userHeadView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 100, 25)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 150, 25)];
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont systemFontOfSize:15];
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.dateLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 150, 30)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLabel];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
