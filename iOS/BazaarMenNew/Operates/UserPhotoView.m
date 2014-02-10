//
//  UserPhotoView.m
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "UserPhotoView.h"
#import "UIImageView+WebCache.h"

@implementation UserPhotoView
@synthesize imageUrl = _imageUrl;
@synthesize smallUrl = _smallUrl;
@synthesize largerUrl = _largerUrl;
@synthesize userphoto = _userphoto;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
//        self.layer.cornerRadius = 3;
        
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageview];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [btn addTarget:self action:@selector(tapPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    return self;
}

- (void)tapPhoto
{
    NSLog(@"tap!!!");
    [[NSNotificationCenter defaultCenter] postNotificationName:DIDSELECTUSERPHOTO object:self];
}

- (void)setImageViewUrl:(NSString *)url
{
    [_imageview setImageWithURL:[NSURL URLWithString:url]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
