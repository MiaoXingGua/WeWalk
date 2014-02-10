//
//  MessageCell.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize contentLabel;
@synthesize coverView;
@synthesize headView;
@synthesize nameLabel;
@synthesize lineView;
@synthesize timeLabel;
@synthesize unreadbackground;

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
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 17, 200, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.nameLabel];
        
//        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 27, 210, 20)];
//        self.contentLabel.textAlignment = NSTextAlignmentLeft;
//        self.contentLabel.backgroundColor = [UIColor clearColor];
//        self.contentLabel.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:self.contentLabel];
//        
//        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 6, 100, 20)];
//        self.timeLabel.textAlignment = NSTextAlignmentRight;
//        self.timeLabel.backgroundColor = [UIColor clearColor];
//        self.timeLabel.font = [UIFont systemFontOfSize:14];
//        [self.contentView addSubview:self.timeLabel];
        
        self.unreadbackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unread_background.png"]];
        self.unreadbackground.frame = CGRectMake(0, 0, 92/2, 48/2);
        [self.contentView addSubview:self.unreadbackground];
        
        self.unReadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 92/2, 48/2)];
        self.unReadLabel.font = [UIFont systemFontOfSize:14];
        self.unReadLabel.textAlignment = NSTextAlignmentCenter;
        self.unReadLabel.backgroundColor = [UIColor clearColor];
        self.unReadLabel.textColor = [UIColor whiteColor];
        [self.unreadbackground addSubview:self.unReadLabel];
        
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
