//
//  Brand.h
//  BAZAAR-PUSH
//
//  Created by Albert on 14-1-3.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

@interface Brand : AVObject <AVSubclassing>
//名字
@property (nonatomic, retain) NSString *name;
//类型
//@property (nonatomic, assign) int type;//单品/化妆品

@end
