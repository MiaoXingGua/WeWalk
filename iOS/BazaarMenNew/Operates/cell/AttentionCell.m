//
//  AttentionCell.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-17.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell
@synthesize coverView = _coverView;
@synthesize headView = _headView;
@synthesize nameLabel = _nameLabel;
@synthesize lineView = _lineView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.coverView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxing.png"]];
        self.coverView.frame = CGRectMake(10, 7, 40, 40);
        self.coverView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.coverView];
        
        self.headView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36) ImageState:0];
        self.headView.backgroundColor = [UIColor clearColor];
        self.headView.center = CGPointMake(20, 20);
        [self.coverView addSubview:self.headView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 17, 180, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(25, 54, 295, 1)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:self.lineView];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
