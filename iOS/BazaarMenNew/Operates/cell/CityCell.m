//
//  CityCell.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-16.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "CityCell.h"

@implementation CityCell
@synthesize citynameLable = _citynameLable;
@synthesize deleteBtn = _deleteBtn;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(celloperation) name:CELLDELETEOPERATION object:nil];
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.backgroundColor = [UIColor blackColor];
        self.deleteBtn.frame = CGRectMake(210-60, 0, 60, 40);
        [self.deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
        
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 40)];
        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.userInteractionEnabled = YES;
        [self.contentView addSubview:_coverView];
        
        self.citynameLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        self.citynameLable.backgroundColor = [UIColor clearColor];
        [self.citynameLable setTextAlignment:NSTextAlignmentLeft];
        self.citynameLable.font = [UIFont systemFontOfSize:14];
        self.citynameLable.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.citynameLable];
        
        _coverView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 40)];
        _coverView2.backgroundColor = [UIColor clearColor];
        _coverView2.userInteractionEnabled = YES;
        [self.contentView addSubview:_coverView2];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipgesture:)];
        swip.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        [_coverView2 addGestureRecognizer:swip];
        
        coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        coverBtn.frame = CGRectMake(0, 0, 210-60, 40);
        [coverBtn addTarget:self action:@selector(recoverCoverView) forControlEvents:UIControlEventTouchDown];
        coverBtn.hidden=YES;
        [self.contentView addSubview:coverBtn];
    }
    
    return self;
}

- (void)celloperation
{
    if (isOpen==YES)
    {
        [self recoverCoverView];
    }
}


- (void)recoverCoverView
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _coverView.frame = CGRectMake(0, 0, 210, 40);
        _coverView2.frame = CGRectMake(0, 0, 210, 40);

    } completion:^(BOOL finished) {
        coverBtn.hidden=YES;
        isOpen=NO;
    }];
}

- (void)swipgesture:(UIGestureRecognizer *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CELLDELETEOPERATION object:nil];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _coverView.frame = CGRectMake(-60, 0, 210, 40);
        _coverView2.frame = CGRectMake(-60, 0, 210, 40);

    } completion:^(BOOL finished) {
        coverBtn.hidden=NO;
        isOpen=YES;
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
