//
//  privateLetterViewController.m
//  BazaarMenNew
//
//  Created by superhomeliu on 14-1-22.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "PrivateLetterViewController.h"
#import "ALBazaarSDK.h"
#import "PrivateLetterCell.h"
#import "UserInfoViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"

#define TOOLBARTAG		200
#define TABLEVIEWTAG	300
#define BEGIN_FLAG @"["
#define END_FLAG @"]"


@interface PrivateLetterViewController ()

@end

@implementation PrivateLetterViewController
@synthesize chatUser;
@synthesize datalist;
@synthesize messagelist;
@synthesize inputToolBarView;

- (id)initWithUser:(User *)user FromCenter:(BOOL)center
{
    if (self = [super init])
    {
        self.chatUser = user;
        self.fromcenter = center;
    }
    
    return self;
}

- (void)updateUnReadState
{
    [[ALBazaarEngine defauleEngine] updateUnreadStateOfUser:self.chatUser block:^(BOOL succeeded, NSError *error) {
        
        
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    self.datalist = [NSMutableArray arrayWithCapacity:0];
    self.messagelist = [NSMutableArray arrayWithCapacity:0];
    
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    naviView.backgroundColor = NAVIGATIONBARCOLOR;
    [self.backgroundView addSubview:naviView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    titleLabel.text = [self.chatUser objectForKey:@"nickname"];
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.center = CGPointMake(naviView.frame.size.width/2, naviView.frame.size.height/2);
    [naviView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(12, 8, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_image_001.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:backBtn];
    
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headview.backgroundColor = [UIColor clearColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, self.backgroundView.frame.size.height-44-INPUT_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = headview;
    [self.backgroundView addSubview:_tableView];
    
    
    CGRect inputFrame = CGRectMake(0.0f, self.backgroundView.frame.size.height - INPUT_HEIGHT, SCREEN_WIDTH, INPUT_HEIGHT);
    
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputToolBarView.layer.borderWidth = 1;
    self.inputToolBarView.textView.returnKeyType = UIReturnKeySend;
    self.inputToolBarView.textView.placeHolder = @"说点什么呢？";
    self.inputToolBarView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.inputToolBarView];
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"sendimage_0001.png"] forState:UIControlStateNormal];
    sendBtn.frame = CGRectMake(self.inputToolBarView.frame.size.width - 68.0f+10, 10.0f, 96/2, 57/2);
    [sendBtn addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView addSubview:sendBtn];

    
    [self addRefreshHeaderView];
    
    [self requestUnReadMessage];
   // [self beginPulldownAnimation];
    
    
}

- (void)beginPulldownAnimation
{
    [_tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [_refreshHeaderView performSelector:@selector(egoRefreshScrollViewDidEndDragging:) withObject:_tableView afterDelay:0.5];
}

#pragma mark - 发送私信
- (void)sendComment:(UIButton *)sender
{
    [self.inputToolBarView.textView resignFirstResponder];
    
    if (self.inputToolBarView.textView.text.length==0)
    {
        return;
    }
    
    self.isHistroy=NO;
    
    [self sendMassage:self.inputToolBarView.textView.text from:YES isHistroy:NO SendUser:[ALBazaarEngine defauleEngine].user];
    
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.datalist count]-1 inSection:0]
                      atScrollPosition: UITableViewScrollPositionBottom
                              animated:NO];
    
  //  __block typeof(self) bself = self;
    
    [[ALBazaarEngine defauleEngine] postMessageWithText:self.inputToolBarView.textView.text voice:nil URL:nil toUser:self.chatUser block:^(BOOL succeeded, NSError *error) {
        
        if (succeeded)                              
        {
            NSLog(@"成功");
        }
        else
        {
            NSLog(@"error=%@",error);
        }
        
    }];
    
    self.inputToolBarView.textView.text = @"";
    [self textViewDidChange:self.inputToolBarView.textView];

}

-(void)sendMassage:(NSString *)message from:(BOOL)fromSelf isHistroy:(BOOL)histroy SendUser:(User *)user
{
    NSDate *nowTime = [NSDate date];
    
	
	if ([self.datalist lastObject] == nil)
    {
		self.lastTime = nowTime;
        
        if (histroy==NO && self.isHistroy==NO)
        {
            [self.datalist addObject:nowTime];
        }
	}
	
    //设置显示时间间隔2分钟
	if ([[NSDate date] timeIntervalSince1970]-[self.lastTime timeIntervalSince1970]>120)
    {
		self.lastTime = [NSDate date];
        
        if (histroy==NO && self.isHistroy==NO)
        {
            [self.datalist addObject:[NSDate date]];
        }
	}
    
    UIView *chatView = [self bubbleView:message from:fromSelf SendUser:user];
    
    
    if(fromSelf==YES)
    {
        if (histroy==YES)
        {
            [self.datalist insertObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"self", @"speaker", chatView, @"view",user,@"user", [NSDate date],@"senddate", nil] atIndex:0];
        }
        else
        {
            [self.datalist addObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"self", @"speaker", chatView, @"view",user,@"user", [NSDate date],@"senddate",nil]];
        }
     
    }
    else
    {
        if (histroy==YES)
        {
            [self.datalist insertObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"other", @"speaker", chatView, @"view",user,@"user", [NSDate date],@"senddate",nil] atIndex:0];
        }
        else
        {
            [self.datalist addObject:[NSDictionary dictionaryWithObjectsAndKeys:message, @"text", @"other", @"speaker", chatView, @"view",user,@"user", [NSDate date],@"senddate", nil]];
        }
    }
}


#pragma mark - 请求私信
- (void)requestLetter
{
    if (self.isRequest==YES)
    {
        return;
    }
    
    self.isRequest=YES;
    
    __block typeof(self) bself = self;
    
    __block UITableView *__tabelview = _tableView;
    
    
    NSDate *_date=nil;
    
    if (self.datalist.count>0)
    {
        NSDictionary *dic = [self.datalist lastObject];
        _date = [dic objectForKey:@"senddate"];
        NSLog(@"%@",_date);
    }

    [[ALBazaarEngine defauleEngine] getUserMessageWithUser:self.chatUser limit:20 lessThanDate:_date block:^(NSArray *messages, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }

        if (!error)
        {
            if (messages.count==0)
            {
                [ProgressHUD showSuccess:@"没有内容"];
            }
            else
            {
                NSLog(@"%@",messages);
                
                for (int i=0; i<messages.count; i++)
                {
                    Message *_message = [messages objectAtIndex:i];
                    
                    BOOL fromSelf=NO;
                    
                    if ([[ALBazaarEngine defauleEngine].user.objectId isEqualToString:_message.fromUser.objectId])
                    {
                        fromSelf=YES;
                    }

                    if (_message.content.text.length>0)
                    {
                        [bself sendMassage:_message.content.text from:fromSelf isHistroy:YES SendUser:_message.fromUser];
                        
                        
                        _nextTime = _message.createdAt;
                        
                        
                        if (i==0)
                        {
                            _historyDate = _message.createdAt;
                            [bself.datalist insertObject:_nextTime atIndex:0];
                        }
                        
                        int t1 = [_nextTime timeIntervalSince1970];
                        int t2 = [_historyDate timeIntervalSince1970];
                        
                        NSLog(@"%d",t1-t2);
                        
                        if ([_historyDate timeIntervalSince1970]-[_nextTime timeIntervalSince1970]>120)
                        {
                            _historyDate = _nextTime;
                            
                            [bself.datalist insertObject:_historyDate atIndex:0];
                        }
                    }
                }
                
                [__tabelview reloadData];
                
                if (self.datalist.count>0)
                {
                    [__tabelview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bself.datalist.count-1 inSection:0]
                                       atScrollPosition: UITableViewScrollPositionBottom
                                               animated:NO];
                }
                
            }
            

        }
        else
        {
            [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
        
        [bself doneLoadingTableViewData];
        
    }];
}

- (void)requestUnReadMessage
{
   // [ProgressHUD show:@"加载中"];
    
    __block typeof(self) bself = self;
    
    __block UITableView *__tabelview = _tableView;

    [[ALBazaarEngine defauleEngine] getUserUnreadMessageWithUser:self.chatUser limit:1000 lessThanDate:nil block:^(NSArray *messages, NSError *error) {
        
        if (bself.isBack==YES)
        {
            return;
        }
        
        if (!error)
        {
            if (messages.count==0)
            {
                [ProgressHUD showSuccess:@"没有内容"];
            }
            else
            {
                for (int i=0; i<messages.count; i++)
                {
                    Message *_message = [messages objectAtIndex:i];
                    
                    BOOL fromSelf=NO;
                    
                    if ([[ALBazaarEngine defauleEngine].user.objectId isEqualToString:_message.fromUser.objectId])
                    {
                        fromSelf=YES;
                    }
                    
                    _nextTime = _message.createdAt;
                    
                    
                    if (i==0)
                    {
                        _historyDate = _message.createdAt;
                        [bself.datalist addObject:_nextTime];
                    }
                    
                    int t1 = [_nextTime timeIntervalSince1970];
                    int t2 = [_historyDate timeIntervalSince1970];
                    
                    NSLog(@"%d",t1-t2);
                    
                    if ([_nextTime timeIntervalSince1970]-[_historyDate timeIntervalSince1970]>120)
                    {
                        _historyDate = _nextTime;
                        
                        [bself.datalist addObject:_nextTime];
                    }

                    
                    if (_message.content.text.length>0)
                    {
                        bself.isHistroy=YES;
                        
                        [bself sendMassage:_message.content.text from:fromSelf isHistroy:NO SendUser:_message.fromUser];
                    }
                }
                
                [__tabelview reloadData];
                
                if (self.datalist.count>0)
                {
                    [__tabelview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:bself.datalist.count-1 inSection:0]
                                       atScrollPosition: UITableViewScrollPositionBottom
                                               animated:NO];
                }
                
            }
            
          //  [ProgressHUD showSuccess:@"成功"];
            
        }
        else
        {
          //  [ProgressHUD showError:@"失败"];
        }
        
        bself.isRequest=NO;
        
        [bself updateUnReadState];
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Cellindifiter1 = @"cell1";
    static NSString *Cellindifiter2 = @"cell2";
    static NSString *Cellindifiter3 = @"cell3";

    
    //显示消息时间
    if([[self.datalist objectAtIndex:indexPath.row] isKindOfClass:[NSDate class]])
    {
        PrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter1];
        
        if(cell==nil)
        {
            cell = [[PrivateLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter1];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *destDateString = [formatter stringFromDate:[self.datalist objectAtIndex:indexPath.row]];
        
        cell.dateLabel.hidden=NO;
        cell.dateLabel.center = CGPointMake(160, 22);
        [cell.dateLabel setTextAlignment:NSTextAlignmentCenter];
        cell.dateLabel.textColor = [UIColor whiteColor];
		[cell.dateLabel setText:destDateString];
        
        
        return cell;
        
    }
    else
    {
        NSDictionary *dic = [self.datalist objectAtIndex:indexPath.row];
        
        //发送消息
        if([[dic objectForKey:@"speaker"] isEqualToString:@"self"])
        {
            PrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter2];
            
            if(cell==nil)
            {
                cell = [[PrivateLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter2];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            
            NSDictionary *chatInfo = [self.datalist objectAtIndex:[indexPath row]];
            UIView *chatView = [chatInfo objectForKey:@"view"];
            
            UIView *tempview = [[cell.popView subviews] lastObject];
            
            if(tempview!=nil)
            {
                [tempview removeFromSuperview];
            }
            
            [cell.popView addSubview:chatView];
            cell.popView.frame = chatView.frame;
            
            
            return cell;
            
        }
        //接收消息
        if([[dic objectForKey:@"speaker"] isEqualToString:@"other"])
        {
            PrivateLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellindifiter3];
            
            if(cell==nil)
            {
                cell = [[PrivateLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cellindifiter3];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
            }
            
            NSDictionary *chatInfo = [self.datalist objectAtIndex:[indexPath row]];
            UIView *chatView = [chatInfo objectForKey:@"view"];
            
            UIView *tempview = [[cell.popView subviews] lastObject];
            
            if(tempview!=nil)
            {
                [tempview removeFromSuperview];
            }
            
            [cell.popView addSubview:chatView];
            cell.popView.frame = chatView.frame;
            
            
            return cell;
            
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.datalist objectAtIndex:indexPath.row] isKindOfClass:[NSDate class]])
    {
		return 40;
	}
    else
    {
		UIView *chatView = [[self.datalist objectAtIndex:indexPath.row] objectForKey:@"view"];
        
		return chatView.frame.size.height;
	}
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 显示用户主页
- (void)showUserInfo:(AsyncImageView *)sender
{
    
}


#pragma mark - 生成气泡
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf SendUser:(User *)user
{
    UIView *returnView =  [self assembleMessageAtIndex:text from:fromSelf];
    returnView.backgroundColor = [UIColor clearColor];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectZero];
    cellView.backgroundColor = [UIColor clearColor];
    
	UIImage *arrowsImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"arrowsImageSelf":@"arrowsImageOthers" ofType:@"png"]];
    
    UIImageView *arrowsImageView = [[UIImageView alloc] initWithImage:arrowsImage];
    
    
    UIImage *bubble = [UIImage imageNamed:@"chatviewimage.png"];
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 伸缩后重新赋值
    
    bubble = [bubble resizableImageWithCapInsets:insets];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubble];
    
    UIImageView *touxiang = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxing.png"]];
    touxiang.userInteractionEnabled = YES;
    
    UILabel *userName = [[UILabel alloc] init];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont systemFontOfSize:12];
    userName.textColor = [UIColor whiteColor];
    
    if(fromSelf==YES)
    {
        
        arrowsImageView.frame = CGRectMake(230, 21+5, 4, 7);
        
        bubbleImageView.frame = CGRectMake(210-returnView.frame.size.width, 10.0f+10, returnView.frame.size.width+20.0f, returnView.frame.size.height+30.0f );
        
        returnView.frame= CGRectMake(bubbleImageView.frame.origin.x+5, 16.0f+10, returnView.frame.size.width, returnView.frame.size.height);
        
        cellView.frame = CGRectMake(10, 0.0f, 300, bubbleImageView.frame.size.height+30.0f+5);
        
        touxiang.frame = CGRectMake(300-60, 0, 46, 46);
        
        userName.frame = CGRectMake(10, 0, 220, 15);
        userName.text = [[ALBazaarEngine defauleEngine].user objectForKey:@"nickname"];
        [userName setTextAlignment:NSTextAlignmentRight];
        
        AsyncImageView *headimage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42) ImageState:0];
        headimage.center = CGPointMake(touxiang.frame.size.width/2, touxiang.frame.size.height/2);
        headimage.urlString = [[ALBazaarEngine defauleEngine].user objectForKey:@"smallHeadViewURL"];
        [headimage addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        headimage.tag = self.datalist.count;
        
        [touxiang addSubview:headimage];
    }
	else
    {
        
        arrowsImageView.frame = CGRectMake(68, 21+5, 4, 7);
        
        touxiang.frame = CGRectMake(15, 0, 46, 46);
        
        userName.frame = CGRectMake(72, 0, 200, 15);
        userName.text = [self.chatUser objectForKey:@"nickname"];
        [userName setTextAlignment:NSTextAlignmentLeft];
        
        AsyncImageView *link = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 42, 42) ImageState:0];
        link.center = CGPointMake(touxiang.frame.size.width/2, touxiang.frame.size.height/2);
        link.urlString = [self.chatUser objectForKey:@"smallHeadViewURL"];
        [link addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        link.tag = self.datalist.count;
        
        returnView.frame= CGRectMake(79.0f, 16.0f+10, returnView.frame.size.width, returnView.frame.size.height);
        
        bubbleImageView.frame = CGRectMake(72, 10.0f+10, returnView.frame.size.width+20.0f, returnView.frame.size.height+30.0f);
        
		cellView.frame = CGRectMake(0.0f, 0.0f, bubbleImageView.frame.size.width+30.0f,bubbleImageView.frame.size.height+30.0f+5);
        
        [touxiang addSubview:link];
    }
        
    [cellView addSubview:bubbleImageView];
    [cellView addSubview:returnView];
    [cellView addSubview:touxiang];
    
    [cellView addSubview:arrowsImageView];
    [cellView addSubview:userName];
    
    
	return cellView;
    
}

//图文混排
-(void)getImageRange:(NSString*)message : (NSMutableArray*)array
{
    NSRange range=[message rangeOfString: BEGIN_FLAG];
    NSRange range1=[message rangeOfString: END_FLAG];
    //判断当前字符串是否还有表情的标志。
    if (range.length>0 && range1.length>0)
    {
        if (range.location > 0)
        {
            [array addObject:[message substringToIndex:range.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)]];
            NSString *str=[message substringFromIndex:range1.location+1];
            [self getImageRange:str :array];
        }
        else
        {
            NSString *nextstr=[message substringWithRange:NSMakeRange(range.location, range1.location+1-range.location)];
            //排除文字是“”的
            if (![nextstr isEqualToString:@""])
            {
                [array addObject:nextstr];
                NSString *str=[message substringFromIndex:range1.location+1];
                [self getImageRange:str :array];
            }
            else
            {
                return;
            }
        }
        
    }
    else if (message != nil)
    {
        [array addObject:message];
    }
}

#define KFacialSizeWidth  20
#define KFacialSizeHeight 20
#define MAX_WIDTH 190
-(UIView *)assembleMessageAtIndex : (NSString *) message from:(BOOL)fromself
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [self getImageRange:message :array];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];

    UIFont *fon = [UIFont systemFontOfSize:14.0f];
    CGFloat upX = 0;
    CGFloat upY = 0;
    CGFloat X = 0;
    CGFloat Y = 0;
    if (array)
    {
        for (int i=0;i < [array count];i++)
        {
            NSString *str=[array objectAtIndex:i];
            NSLog(@"str--->%@",str);
            
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                if (upX >= MAX_WIDTH)
                {
                    upY = upY + KFacialSizeHeight;
                    upX = 0;
                    X = 190;
                    Y = upY;
                }
                NSLog(@"str(image)---->%@",str);
            }
            else
            {
                for (int j = 0; j < [str length]; j++)
                {
                    NSString *temp = [str substringWithRange:NSMakeRange(j, 1)];
                    if (upX >= MAX_WIDTH)
                    {
                        upY = upY + KFacialSizeHeight;
                        upX = 0;
                        X = 190;
                        Y =upY;
                    }
                    
                    CGSize size=[temp sizeWithFont:fon constrainedToSize:CGSizeMake(190, 40)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,size.height)];
                    la.font = fon;
                    la.text = temp;
                    la.textColor = [UIColor whiteColor];
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    
                    upX=upX+size.width;
                    if (X<190)
                    {
                        X = upX;
                    }
                }
            }
        }
    }
    returnView.frame = CGRectMake(15.0f,1.0f, X, Y); //@ 需要将该view的尺寸记下，方便以后使用
    // NSLog(@"%.1f %.1f", X, Y);
    return returnView;
}

#pragma mark - Text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendComment:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    // End of textView.contentSize replacement code
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             
                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             sendBtn.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f,inputViewFrame.size.height+changeInHeight- 8-28, 59.0f, 26.0f);
                             
                             
                             if(!isShrinking)
                             {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    
    //  self.inputToolBarView.sendButton.enabled = ([[textView.text trimWhitespace] length] > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.backgroundView convertRect:keyboardRect fromView:nil].origin.y;
                         
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.backgroundView convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.backgroundView.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

#pragma mark - addHeader&addFooter
- (void)addRefreshHeaderView
{
    if (_refreshHeaderView == nil)
    {
        _reloading = NO;
        
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.frame.size.width, _tableView.bounds.size.height) arrowImageName:@"blackArrow.png" textColor:[UIColor blackColor]];
        _refreshHeaderView.backgroundColor = [UIColor clearColor];
        
        _refreshHeaderView.delegate = self;
        [_tableView addSubview:_refreshHeaderView];
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
}

#pragma mark UIScrollViewDelegate Methods
//手指屏幕上不断拖动调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//拖动停止时出发
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float _y = scrollView.contentOffset.y;
    NSLog(@"%f",_y);
    
    if (_y>_tableView.contentSize.height*0.8)
    {
        NSLog(@"加载更多");
    }
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
   [self.inputToolBarView.textView resignFirstResponder];
}

#pragma mark - headerView Delegate
//拖拽到位松手触发（刷新）
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self requestLetter];
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

//是否正在刷新中（返回值判断）
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading
}

//下拉完，收回时执行（载入日期）
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	return [NSDate date]; // should return date data source was last changed
}

- (void)back
{
    self.isBack=YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
