//
//  ImageViewCell.h
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-12.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WaterFlowViewCell.h"
#import "UIImageView+WebCache.h"

@interface ImageViewCell : WaterFlowViewCell
{
    UIImageView *imageView;
    
    UILabel *_titleLabel,*_contentLabel;
}

@property(nonatomic,strong)UILabel *titleLabel,*contentLabel;
@property(nonatomic,strong)NSDictionary *dic;

-(void)setImageWithURL:(NSURL *)imageUrl;
-(void)setImage:(UIImage *)image;
-(void)relayoutViews;

@end
