//
//  SendPhotosViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-9.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "NoteView.h"

@interface SendPhotosViewController : SuperViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    NoteView *noteTextView;
    
    NSMutableArray *_imageArray;
    NSMutableArray *_viewArray;
    NSMutableArray *_pointArray;
    
    UIScrollView *_scrollView;
    
    UILabel *addressLabel;
    UIButton *refrshBtn;
    
    int _phototag;
    
    NSTimer *_timer;
    
    UIView *_coverView;
    
    UIActivityIndicatorView *_activity;
}

@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *viewArray;
@property(nonatomic,strong)NSMutableArray *pointArray;

@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isPost;

- (id)initWithUserImage:(UIImage *)image;

@end
