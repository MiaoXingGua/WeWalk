//
//  UserInfoViewController.h
//  BazaarMen
//
//  Created by superhomeliu on 14-1-8.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AsyncImageView.h"
#import "ALBazaarSDK.h"
#import "ShowImageViewController.h"

@interface UserInfoViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    AsyncImageView *headView;
    
    NSMutableArray *_datalist;
    
    NSMutableArray *_countArray;
    
    NSMutableArray *_attentionUserArray;
    
    UITableView *_tableView;
    
    AVUser *_user;
    
    UILabel *titleLabel;
    AsyncImageView *userHeadView;
    
    ShowImageViewController *coverImageView;
    ShowImageViewController *userHeadImageView;
    
}
@property(nonatomic,strong)AVUser *user;
@property(nonatomic,strong)NSMutableArray *countArray;
@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)NSMutableArray *attentionUserArray;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isAttention;
@property(nonatomic,assign)BOOL fromCenter;
@property(nonatomic,assign)BOOL completerelation;
@property(nonatomic,strong)UIButton *attentionBtn;
@property(nonatomic,assign)BOOL fromAttentionList;

- (id)initWithSelf:(BOOL)isSelf User:(AVUser *)user;

@end
