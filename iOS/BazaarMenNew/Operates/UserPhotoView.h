//
//  UserPhotoView.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface UserPhotoView : UIView
{
    UIImageView *_imageview;
    
    CGRect _frame;
    
    NSString *_imageUrl;
    
    NSString *_smallUrl,*_largerUrl;
    
    Photo *_userphoto;
}

@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,assign)int indexofrow;
@property(nonatomic,assign)int indexofnum;
@property(nonatomic,strong)NSString *smallUrl;
@property(nonatomic,strong)NSString *largerUrl;
@property(nonatomic,strong)Photo *userphoto;

- (void)setImageViewUrl:(NSString *)url;

@end
