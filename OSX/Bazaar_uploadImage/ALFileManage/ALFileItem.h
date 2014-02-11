//
//  FileListItem.h
//  BAZAAR_UPLOAD
//
//  Created by Albert on 14-1-23.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ALFileType) {
    
    //异常
    ALFileTypeUnknown = 0,
    ALFileTypeImage,
    ALFileTypeAudio,
    ALFileTypeVideo,
    ALFileTypeText,
    ALFileTypeLrc,
    ALFileTypeFolder
    
};

@interface ALFileItem : NSObject

@property (nonatomic ,strong)   NSString *name;         //文件名
@property (nonatomic ,strong)   NSString *path;         //文件路径
@property (nonatomic)           ALFileType mediaType;   //文件类型
@property (nonatomic ,strong)   NSString *suffix;       //文件后缀

//图片所在上一级目录名
@property (nonatomic ,strong) NSString *brand;  //品牌

@end
