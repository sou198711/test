//
//  ViewController.m
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/06.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"DetailViewController");
    
    //self.navigationItem.title = @"detail";
}

- (void)setViewData:(NSInteger *)id {
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"detail %ld", (long)id);
    
    self.navigationItem.title = [NSString stringWithFormat:@"detail %ld", (long)id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end