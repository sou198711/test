//
//  AppDelegate.h
//  test
//
//  Created by 佐藤宗一郎 on 2015/05/26.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;


@end

