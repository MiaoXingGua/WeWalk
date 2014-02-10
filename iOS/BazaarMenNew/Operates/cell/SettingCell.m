//
//  SettingCell.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-13.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell
@synthesize iconView = _iconView;
@synthesize titleLable = _titleLable;
@synthesize contentLabel = _contentLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.iconView = [[UIImageView alloc] init];
        self.iconView.userInteractionEnabled = YES;
        self.iconView.hidden=YES;
        [self.contentView addSubview:self.iconView];
        
        self.titleLable = [[UILabel alloc] init];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.font = [UIFont systemFontOfSize:15];
        self.titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLable];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.hidden=YES;
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
