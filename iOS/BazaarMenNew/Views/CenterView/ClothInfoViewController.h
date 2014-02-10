//
//  ClothInfoViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "AsyncImageView.h"
#import "ALBazaarSDK.h"
#import "JSMessageInputView.h"
#import "EGORefreshTableHeaderView.h"

@interface ClothInfoViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, JSMessageInputViewDelegate,JSDismissiveTextViewDelegate,UIActionSheetDelegate,EGORefreshTableHeaderDelegate>
{
    AsyncImageView *clothesView;
    AsyncImageView *userHeadView;
    
    UILabel *nameLabel,*addressLabel,*dateLabel;
    
    NSMutableArray *_datalist;
    
    UITableView *_tableView;
    
    Photo *_photo;
    
    JSMessageInputView *_inputToolBarView;
    
    UIButton *sendBtn;
    
    int num;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property(nonatomic,strong)Photo *photo;
@property(nonatomic,strong)NSMutableArray *datalist;
@property (assign, nonatomic)CGFloat previousTextViewContentHeight;
@property (strong, nonatomic)JSMessageInputView *inputToolBarView;
@property(nonatomic,assign)BOOL isCollecting;
@property(nonatomic,strong)UIButton *collectBtn;
@property(nonatomic,strong)UILabel *collectNumLabel;
@property(nonatomic,strong)UILabel *chatNumLabel;
@property(nonatomic,strong)UIImageView *collectUserView;
@property(nonatomic,strong)NSMutableArray *collectUserArray;
@property(nonatomic,strong)UIView *moveView1;
@property(nonatomic,strong)UIView *moveView2;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,strong)UIView *headView;

- (id)initWithPhoto:(Photo *)photo;

@end
