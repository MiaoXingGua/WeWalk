//
//  ALFileManage.m
//  BAZAAR_UPLOAD
//
//  Created by Albert on 14-1-23.
//  Copyright (c) 2014年 Albert. All rights reserved.
//

#import "ALFileManage.h"

ALFileManage *defaultManage = nil;

@interface ALFileManage ()
@property (nonatomic) BOOL firstScanDir;
@end

@implementation ALFileManage

+ (instancetype) defaultManage
{
    if (!defaultManage)
    {
        defaultManage = [[ALFileManage alloc] init];
    }
    
    return defaultManage;
}



- (NSArray *)scanDirectory:(NSString *)rootDir hasSuffix:(NSString *)aString recurse:(BOOL)isr
{
//    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
//    NSString *docDir = [documentPaths objectAtIndex:0];
    
    NSFileManager * fm = [NSFileManager defaultManager];

    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    
    NSArray *files = [fm subpathsOfDirectoryAtPath:rootDir error:nil];

    for (NSString *nodePath in files)
    {
        BOOL isdir = NO;
        NSString * truePath = [NSString stringWithFormat:@"%@/%@",rootDir,nodePath];
        BOOL isExist = [fm fileExistsAtPath:truePath isDirectory:&isdir];
        
        if (!isdir && isExist)
        {
//            [filePathArray addObject:truePath];
            ALFileItem * curItem = [[ALFileItem alloc] init];
            
            curItem.path = truePath;
            curItem.name = [[truePath lastPathComponent]stringByDeletingPathExtension];
            curItem.suffix = [[truePath lastPathComponent] pathExtension];
            curItem.mediaType = [self getmediaType:truePath];
//            curItem.brand = [truePath pathComponents][[truePath pathComponents].count-2];
            NSArray *pathComponents = [truePath pathComponents];
            int i = pathComponents.count-1;
            do {
                curItem.brand = [pathComponents objectAtIndex:--i];
                
            } while ([@"jpgpngpsd" rangeOfString:curItem.brand].location != NSNotFound);
            
            [fileArray addObject:curItem];
            
            curItem = nil;
        }
    }
    
    NSMutableArray *targetFileArray = [[NSMutableArray alloc] init];
    
    for (ALFileItem *item in fileArray)
    {
        if ([aString rangeOfString:item.suffix].location != NSNotFound)
        {
            [targetFileArray addObject:item];
        }
    }

    return targetFileArray;
}

- (ALFileType) getmediaType:(NSString *)name
{
    int type = ALFileTypeUnknown;

    if ([self nameCompare:name :@"png"]||[self nameCompare:name :@"jpg"] || [self nameCompare:name :@"bmp"] || [self nameCompare:name :@"jpeg"] || [self nameCompare:name :@"gif"])
    {
        type = ALFileTypeImage;
    }
    else if ([self nameCompare:name :@"mp3"] || [self nameCompare:name :@"wav"]|| [self nameCompare:name :@"aac"] || [self nameCompare:name :@"m4a"]|| [self nameCompare:name :@"mid"] || [self nameCompare:name :@"mid"])
    {
        type = ALFileTypeAudio;
    }
    else if ([self nameCompare:name :@"mov"] ||[self nameCompare:name :@"mp4"] || [self nameCompare:name :@"m4v"] || [self nameCompare:name :@"mpv"])
    {
        type = ALFileTypeVideo;
    }
    else if([self nameCompare:name :@"pdf"] || [self nameCompare:name :@"rtf"] || [self nameCompare:name :@"txt"] || [self nameCompare:name :@"html"] || [self nameCompare:name :@"htm"] || [self nameCompare:name :@"xml"] || [self nameCompare:name :@"doc"] || [self nameCompare:name :@"xls"] )
    {
        type = ALFileTypeText;
    }
    else if([self nameCompare:name :@"lrc"])
    {
        type = ALFileTypeLrc;
    }
    else if ([name hasPrefix:@"."])
    {
        type = ALFileTypeUnknown;
    }
    else if (![name hasPrefix:@"."])
    {
        type = ALFileTypeFolder;
    }
    
    return type;
}

-(BOOL)nameCompare:(NSString *)name :(NSString *)extension
{
    return [[name pathExtension] compare:extension options:NSCaseInsensitiveSearch]==NSOrderedSame;
}


//写入文件
- (BOOL)writeToPlist:(NSDictionary *)plistInfo ToPath:(NSString *)plistPath
{
    return [plistInfo writeToFile:plistPath atomically:YES];
}

//上传
- (void)uploadWithPlistPath:(NSString *)plistPath finsh:(AVBooleanResultBlock)finshBlock
{
    
}

@end
