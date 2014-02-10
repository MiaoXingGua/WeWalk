//
//  ImageViewCell.m
//  WaterFlowViewDemo
//
//  Created by Smallsmall on 12-6-12.
//  Copyright (c) 2012年 activation group. All rights reserved.
//

#import "ImageViewCell.h"


#define TOPMARGIN 8.0f
#define LEFTMARGIN 8.0f

#define IMAGEVIEWBG [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]

@implementation ImageViewCell
@synthesize titleLabel = _titleLabel,contentLabel = _contentLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithIdentifier:(NSString *)indentifier
{
	if(self = [super initWithIdentifier:indentifier])
	{
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] CGColor];
        
        imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = IMAGEVIEWBG;
        [self addSubview:imageView];
    
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        self.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];
	}
	
	return self;
}

-(void)setImageWithURL:(NSURL *)imageUrl
{

    [imageView setImageWithURL:imageUrl];
    
}

-(void)setImage:(UIImage *)image
{

    imageView.image = image;
}

//保持图片上下左右有固定间距
-(void)relayoutViews
{
    float originX = 0.0f;
    float originY = 0.0f;
    float width = 0.0f;
    float height = 0.0f;
    
    originY = TOPMARGIN;
  //  height = CGRectGetHeight(self.frame) - TOPMARGIN;
    
    originX = LEFTMARGIN/2+2;
    width = CGRectGetWidth(self.frame) - LEFTMARGIN*1.5;

    
//    if (self.indexPath.column == 0) {
//        
//        originX = LEFTMARGIN;
//        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
//    }else if (self.indexPath.column < self.columnCount - 1){
//    
//        originX = LEFTMARGIN/2.0;
//        width = CGRectGetWidth(self.frame) - LEFTMARGIN;
//    }else{
//    
//        originX = LEFTMARGIN/2.0;
//        width = CGRectGetWidth(self.frame) - LEFTMARGIN - 1/2.0*LEFTMARGIN;
//    }
    
    // Image
    CGFloat objectWidth = [[self.dic objectForKey:@"width"] floatValue];
    CGFloat objectHeight = [[self.dic objectForKey:@"height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    
    float _h=0;
    
    if (scaledHeight<40)
    {
        _h=40-scaledHeight;
    }
    
    imageView.frame = CGRectMake(originX, originY-1+_h/2,width, scaledHeight);
    
    self.titleLabel.frame = CGRectMake(originX+2, originY+scaledHeight+_h, width, 20);
    self.titleLabel.text = [self.dic objectForKey:@"title"];
    
    CGSize labelSize = CGSizeZero;
    
    
    if (self.columnCount==3)
    {
         labelSize = [[self.dic objectForKey:@"content"] sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:0];
    }
    if (self.columnCount==2)
    {
         labelSize = [[self.dic objectForKey:@"content"] sizeWithFont:self.contentLabel.font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:0];
    }
   
//    if (labelSize.height>=80)
//    {
//        labelSize = CGSizeMake(labelSize.width, 80);
//    }
//    
//    if ([[self.dic objectForKey:@"content"] length]==0)
//    {
//        labelSize = CGSizeMake(labelSize.width, 0);
//    }
    
    self.contentLabel.frame = CGRectMake(originX+2, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5, width, labelSize.height);
    self.contentLabel.text = [self.dic objectForKey:@"content"];
    
    
    [super relayoutViews];

}

@end
