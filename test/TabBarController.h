//
//  FirstViewController.h
//  test
//
//  Created by 佐藤宗一郎 on 2015/05/26.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController


@property (weak, nonatomic) IBOutlet UILabel *loading;
// 切り替えるコンテンツを表示させる領域
@property (weak, nonatomic) IBOutlet UIView *contentView;

// 現在のViewControllerを保持しておく変数
@property (nonatomic) UIViewController *currentViewController;


@property (retain, nonatomic) IBOutlet UINavigationBar *naviBar;

@end

