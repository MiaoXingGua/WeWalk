//
//  PrivateLetterCell.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "PrivateLetterCell.h"

@implementation PrivateLetterCell
@synthesize popView;
@synthesize dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
        self.dateLabel.backgroundColor = [UIColor lightGrayColor];
        self.dateLabel.layer.cornerRadius = 6;
        self.dateLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.dateLabel];
        self.dateLabel.hidden=YES;
  
        self.popView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        self.popView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.popView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
