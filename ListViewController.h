//
//  ListViewController.h
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/07.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface ListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>{
    DetailViewController * detailView;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic) NSMutableArray *arrayOfRows;
@property (nonatomic, strong) NSMutableArray *selectedCellIndexPaths;
@end