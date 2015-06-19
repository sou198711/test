//
//  ViewController.h
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/06.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *lbllTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
//@property (weak, nonatomic) UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)setViewData:(NSInteger *)id callView:(UIViewController *)viewCon;
@end
