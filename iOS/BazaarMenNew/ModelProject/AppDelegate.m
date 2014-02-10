//
//  AppDelegate.m
//  ModelProject
//
//  Created by superhomeliu on 14-1-20.
//  Copyright (c) 2014年 liujia. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "SystemConfigManager.h"
#import "TextViewController.h"
#import "StreetSnapViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "WeatherRequestManager.h"
#import "ScheduleRequestManager.h"
#import "ALGPSHelper.h"
#import "ALNotificationSDK.h"

#import <AVOSCloud/AVOSCloud.h>

//avos测试后台
//#define AVOS_APP_ID @"pljwkiridjjh98hum6dy1vs3eeq4uu00bgguuhrmt0lk4gtm"
//#define AVOS_APP_KEY @"z021ffbim9aq6jmef6lbs1q1d2ckbocr26ewcvcphrrrkxo6"

//avo正式后台
#define AVOS_APP_ID @"sy9s3xqtcdi3nsogyu1gnojg0wxslws0kl28lgd02hgsddff"
#define AVOS_APP_KEY @"bc0cullpfyceroe12164i8evoi5cw4zpbszssgtqp0k78xyh"

#import "ALBazaarSDK.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [SystemConfigManager defaultManager].systemVersion = [[[UIDevice currentDevice] systemVersion] intValue];
    
    [ALWeatherSDK registerLKSDK];
    [ALBazaarSDK registerLKSDK];
    [ALNotificationSDK registerLKSDK];
    [AVOSCloud setApplicationId:AVOS_APP_ID clientKey:AVOS_APP_KEY];
    [AVOSCloud useAVCloudCN];
    
//    NSLog(@"%@",[[ALBazaarEngine defauleEngine].user class]);
    
//    [User currentUser];
    
//    NSLog(@"%@",[[ALBazaarEngine defauleEngine].user class]);

    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    //PUSH进入程序
    if (application.applicationIconBadgeNumber != 0)
    {
        application.applicationIconBadgeNumber = 0;
        //存储在当前安装deviceToken解析并保存它
        [[AVInstallation currentInstallation] saveInBackground];
    }
    
    //导入数据库
    [self loadDatabaseIfNeeded];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor blackColor];
    
    self.panelViewController = [[JASidePanelController alloc] init];
    self.panelViewController.shouldDelegateAutorotateToVisiblePanel = NO;
    [self.panelViewController setLeftFixedWidth:210];
    [self.panelViewController setRightFixedWidth:340];
    self.panelViewController.recognizesPanGesture = YES;
    
    HomeViewController *home = [[HomeViewController alloc] init];
    UINavigationController *n1 = [[UINavigationController alloc] initWithRootViewController:home];
    [n1 setNavigationBarHidden:YES];
    self.panelViewController.centerPanel = n1;
    
    
    if ([[ALBazaarEngine defauleEngine] isLoggedIn]==YES)
    {
        MenuViewController *menuView = [[MenuViewController alloc] init];
        UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:menuView];
        [n setNavigationBarHidden:YES];
        self.panelViewController.leftPanel = n;
        
        [[ScheduleRequestManager defaultManager] requestAllSchedule];
    }
    else
    {
        LoginViewController *loginview = [[LoginViewController alloc] init];
        UINavigationController *n2 = [[UINavigationController alloc] initWithRootViewController:loginview];
        [n2 setNavigationBarHidden:YES];
        self.panelViewController.leftPanel = n2;
    }
    
    
    StreetSnapViewController *streetview = [[StreetSnapViewController alloc] init];
    UINavigationController *n3 = [[UINavigationController alloc] initWithRootViewController:streetview];
    [n3 setNavigationBarHidden:YES];
    self.panelViewController.rightPanel = n3;
    
    self.window.rootViewController = self.panelViewController;
        
    [ALGPSHelper OpenGPS];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadDatabaseIfNeeded
{
    //Using NSFileManager we can perform file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    //find file path
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [path stringByAppendingPathComponent:@"citylist.db"];
    
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success)
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"citylist.db"];
        
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[WeatherRequestManager defaultManager] stopTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[WeatherRequestManager defaultManager] openRefreshWeatherTimer];
    [[WeatherRequestManager defaultManager] refreshDate];
}

//通知来时应用程序已经打开了
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"receviedPushOfUserInfo = %@", userInfo);
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"" delegate:nil cancelButtonTitle:@"" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
