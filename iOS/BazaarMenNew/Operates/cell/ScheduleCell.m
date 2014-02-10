//
//  ScheduleCell.m
//  BazaarMan
//
//  Created by superhomeliu on 14-1-3.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "ScheduleCell.h"

@implementation ScheduleCell
@synthesize stateView = _stateView;
@synthesize timeLabel = _timeLabel;
@synthesize contentLabel = _contentLabel;
@synthesize stateColorView = _stateColorView;
@synthesize lineView = _lineView;
@synthesize backView = _backView;
@synthesize imgicon = _imgicon;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 46)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.stateColorView = [[UIImageView alloc] init];
        self.stateColorView.frame = CGRectMake(0, 0, 3, 43);
        self.stateColorView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.stateColorView];
        
        self.stateView = [[UIImageView alloc] init];
        self.stateView.frame = CGRectMake(10, 8, 29, 29);
        self.stateView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.stateView];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 150, 20)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.timeLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 22, 223, 20)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.contentLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(45, 45, 320-45, 1)];
        self.lineView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self.contentView addSubview:self.lineView];
        
        self.imgicon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"schedule_image0001.png"]];
        self.imgicon.frame = CGRectMake(295, 17, 8, 25/2);
        self.imgicon.userInteractionEnabled = YES;
        [self.contentView addSubview:self.imgicon];
        
        self.longpress = [[CustomLongPress alloc] init];
        [self.contentView addGestureRecognizer:self.longpress];
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
