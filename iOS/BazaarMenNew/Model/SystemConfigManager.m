//
//  SystemConfigManager.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "SystemConfigManager.h"
#import "ASIHTTPRequest.h"
#import <systemconfiguration/scnetworkreachability.h>
#include <netinet/in.h>
#import "TReachability.h"

static SystemConfigManager *systemconfig=nil;

@implementation SystemConfigManager
@synthesize systemVersion;

+ (SystemConfigManager *)defaultManager
{
    if (systemconfig==nil)
    {
        systemconfig = [[SystemConfigManager alloc] init];
    }
    
    return systemconfig;
}

- (BOOL)isOrNotNetWorking
{
    TReachability *internetReach = [TReachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus status = [internetReach currentReachabilityStatus];
    
    if (NotReachable == status)
    {
        
        //        [UIAlertView  alertViewWithInfo:@"无法连接网络"];
        return NO;
        
    }else return YES;
    return [self connectedToNetwork];
    
    TReachability *reach = [TReachability reachabilityWithHostName:@"www.baidu.com"];
    
    if ([reach currentReachabilityStatus] == NotReachable) {
        
        return NO;
        
    }else return YES;
}

- (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
    NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
    
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

@end
