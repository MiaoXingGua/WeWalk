//
//  LoginViewController.h
//  BazaarMan
//
//  Created by superhomeliu on 13-12-14.
//  Copyright (c) 2013年 liujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcoViewController : UIViewController<UIScrollViewDelegate,UIDynamicAnimatorDelegate>
{
    UIImageView *loginView;
    UIDynamicAnimator *animator;
    
    CGPoint sPoint;
    
    UIScrollView *_scrollView;
    
    BOOL isClose;
    BOOL userPanGesture;
    BOOL isFirst;
    
    int _lastPosition;
    int _version;
    
    UIButton *btn;
    
    float _beginY,_moveY;
    
    UIPanGestureRecognizer *panges;
}

@property (nonatomic, retain)UIDynamicItemBehavior *square1PropertiesBehavior;

@end
