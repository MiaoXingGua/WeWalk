//
//  SeacherCityCell.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-12.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "SeacherCityCell.h"

@implementation SeacherCityCell
@synthesize cityName = _cityName;
@synthesize contentLabel = _contentLabel;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.contentLabel];
        
        self.cityName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        self.cityName.textColor = [UIColor grayColor];
        self.cityName.textAlignment = NSTextAlignmentLeft;
        self.cityName.backgroundColor = [UIColor clearColor];
        self.cityName.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.cityName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
