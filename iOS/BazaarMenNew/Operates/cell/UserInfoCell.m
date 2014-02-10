//
//  UserInfoCell.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "UserInfoCell.h"

@implementation UserInfoCell
@synthesize dayLabel = _dayLabel;
@synthesize monthLabel = _monthLabel;
@synthesize weekLabel = _weekLabel;
@synthesize photoView = _photoView;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 35)];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:self.dayLabel];
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 13, 40, 20)];
        self.monthLabel.backgroundColor = [UIColor clearColor];
        self.monthLabel.textAlignment = NSTextAlignmentRight;
        self.monthLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.monthLabel];
        
        self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 35, 60, 20)];
        self.weekLabel.textColor = [UIColor grayColor];
        self.weekLabel.backgroundColor = [UIColor clearColor];
        self.weekLabel.textAlignment = NSTextAlignmentLeft;
        self.weekLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.weekLabel];
        
        self.photoView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 210, 100)];
        self.photoView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.photoView];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
