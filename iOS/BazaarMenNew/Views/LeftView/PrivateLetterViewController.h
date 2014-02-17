//
//  privateLetterViewController.h
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "ALBazaarSDK.h"
#import "JSMessageInputView.h"
#import "EGORefreshTableHeaderView.h"

@interface PrivateLetterViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate, JSMessageInputViewDelegate,JSDismissiveTextViewDelegate,EGORefreshTableHeaderDelegate>
{
    UITableView *_tableView;
    
    UIButton *sendBtn;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSDate *_nextTime;
    NSDate *_historyDate;
}

@property(nonatomic,strong)User *chatUser;
@property(nonatomic,assign)BOOL fromcenter;
@property(nonatomic,assign)BOOL isBack;
@property(nonatomic,assign)BOOL isRequest;
@property(nonatomic,assign)BOOL isHistroy;

@property(nonatomic,strong)NSMutableArray *datalist;
@property(nonatomic,strong)NSMutableArray *messagelist;

@property(nonatomic,assign)CGFloat previousTextViewContentHeight;
@property(nonatomic,strong)JSMessageInputView *inputToolBarView;
@property(nonatomic, strong)NSDate *lastTime;

- (id)initWithUser:(User *)user FromCenter:(BOOL)center;

@end
