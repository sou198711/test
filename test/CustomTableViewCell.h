//
//  Cell.h
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/06.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageThumb;
@property (weak, nonatomic) IBOutlet UILabel *labelSubjectName;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (CGFloat)rowHeight;

@end
