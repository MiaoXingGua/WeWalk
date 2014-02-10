//
//  LoginViewController.m
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import "WelcoViewController.h"
#import "SystemConfigManager.h"
#import "AuthenticationViewController.h"
#import "HomeViewController.h"

@interface WelcoViewController ()

@end

@implementation WelcoViewController



- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator
{
    NSLog(@"1111111111");
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator
{
    NSLog(@"2222222222");
    
    userPanGesture=YES;
    panges.enabled=YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    if (isFirst==YES)
    {
        return;
    }
    
    isFirst=YES;
    
    if (_version>=7)
    {
        [self creatDynamicAnimato];
    }
    else
    {
        [self animation];
    }
}

- (void)creatDynamicAnimato
{
    animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    animator.delegate = self;
    
    //重力行为
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[loginView]];
    
    //碰撞行为
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[loginView]];
    
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    UIEdgeInsets v;
    v.top = 1000;
    
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:v];
    self.square1PropertiesBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[loginView]];
    self.square1PropertiesBehavior.elasticity = 0.6;
    
    [animator addBehavior:self.square1PropertiesBehavior];
    [animator addBehavior:gravityBeahvior];
    [animator addBehavior:collisionBehavior];
    }

- (void)animation
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        loginView.center = CGPointMake(160, self.view.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            loginView.frame = CGRectMake(0, -40, 320, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                loginView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);

            } completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    loginView.frame = CGRectMake(0, -20, 320, self.view.frame.size.height);

                } completion:^(BOOL finished) {
                    
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        loginView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);

                    } completion:^(BOOL finished) {
                        
                        userPanGesture=YES;
                    }];
                }];
            }];
        }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _version = [SystemConfigManager defaultManager].systemVersion;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
    img.frame = CGRectMake(0, self.view.frame.size.height-80, 320, 80);
    img.userInteractionEnabled = YES;
    [self.view addSubview:img];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(10, 10, 90, 70);
    [img addSubview:loginBtn];
    
    
    UIButton *signUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpBtn.frame = CGRectMake(113, 10, 90, 70);
    [signUpBtn addTarget:self action:@selector(signup) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:signUpBtn];
    
    
    UIButton *guestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    guestBtn.frame = CGRectMake(213, 10, 90, 70);
    [guestBtn addTarget:self action:@selector(guest) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:guestBtn];
    
    loginView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"欢迎画面1.jpg"]];
    loginView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    loginView.center = CGPointMake(160, 100);
    loginView.userInteractionEnabled = YES;
    [self.view addSubview:loginView];
    
    
    panges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [loginView addGestureRecognizer:panges];
    
}



- (void)signup
{
  
}

- (void)guest
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:INTOHOMEVIEWCONTROLLER object:nil];
}

- (void)panView:(UIGestureRecognizer *)sender
{
    if (userPanGesture==NO)
    {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        _beginY = [sender locationInView:self.view].y;
        
        sPoint = [sender locationInView:loginView];//

    }
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        _moveY = [sender locationInView:self.view].y;
        
    //    CGPoint currentPoint = [sender locationInView:loginView];

      //  float disY = currentPoint.y - sPoint.y;
        
      //  loginView.center = CGPointMake(loginView.center.x, loginView.center.y+disY);
        
        userPanGesture=NO;
        
        if (_beginY-_moveY>=5)
        {
            NSLog(@"up");
            
            [self open];
        }
        else
        {
            NSLog(@"down");
            
            if (_version>=7)
            {
                [self beginWithPoint];
            }
            else
            {
                [self close];
            }
        }
    }

}

- (void)open
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        loginView.frame = CGRectMake(0, -100, 320, self.view.frame.size.height);

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            loginView.frame = CGRectMake(0, -90, 320, self.view.frame.size.height);

        } completion:^(BOOL finished) {
            isClose=NO;
            userPanGesture=YES;
        }];
    }];
}

- (void)close
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        loginView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);

    } completion:^(BOOL finished) {
        
        isClose=YES;
        userPanGesture=YES;

    }];
}




- (void)beginWithPoint
{
    [self.square1PropertiesBehavior addLinearVelocity:CGPointMake(0, -1 * [self.square1PropertiesBehavior linearVelocityForItem:loginView].y) forItem:loginView];
//    loginView.center = CGPointMake(160, 100);
    [animator updateItemUsingCurrentState:loginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
