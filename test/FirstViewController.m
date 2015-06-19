//
//  FirstViewController.m
//  test
//
//  Created by 佐藤宗一郎 on 2015/05/26.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import "FirstViewController.h"
#import "ListViewController.h"
#import "CustomTableViewCell.h"

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *list;
}
@property (nonatomic) BOOL scrollingToTop;
@end

@implementation FirstViewController

/**
  * イニシャライザ
  */
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"トップ";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"FirstViewController");
    /*
    //self.navigationController.delegate = [[UINavigationController alloc] initWithRootViewController:self];
    
    // SegmentedControlの値により異なるControllerを取得する
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    // UIViewController *vc = [[ListViewController alloc] init];
    //self.currentId = SUMMARY_LIST;
    
    // 取得したコントローラを子コントローラとして追加する
    [self addChildViewController:vc];
    
    // 子コントローラのViewを親コントローラのContent表示領域のサイズにする
    vc.view.frame = self.contentView.bounds;
    
    NSLog(@"DestinationController viewDidLoad y = %f", self.contentView.bounds.origin.y);
    NSLog(@"DestinationController viewDidLoad height = %f", self.contentView.bounds.size.height);
    
    // 子ViewControllerのviewを、自身のview階層に追加
    [self.contentView addSubview:vc.view];
    
    // 子ViewControllerに追加されたことを通知
    [vc didMoveToParentViewController:self];
    
    self.currentViewController = vc;
    self.currentViewController.view.frame = self.contentView.bounds;
    */
    /*
    UIViewController *secondVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //[self presentViewController:]
    [self.navigationController pushViewController:secondVC animated:YES];
    */
    
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    
    NSMutableDictionary *celData = NULL;
    list = [NSMutableArray array];
    for (int i=1; i<=20; i++) {
        NSString *subject = [@"subject" stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
        NSString *title = [@"title"stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
        
        celData = [NSMutableDictionary dictionary];
        [celData setObject:[NSNumber numberWithUnsignedInt:i] forKey:@"id"];
        [celData setObject:subject forKey:@"subject"];
        [celData setObject:title forKey:@"title"];
        
        [list addObject:celData];
    }
    [self getJSON];
    
    // カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil];
    [self.listTableView registerNib:nib forCellReuseIdentifier:@"CustomTableViewCell"];

    NSLog(@"FirstViewController end");
    
    [self.contentView addSubview:self.listTableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [list count];
}

- (void)getJSON
{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/jp/rss/topfreeapplications/limit=10/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // アプリデータの配列をプロパティに保持
        list = [[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"];
        
        // TableView をリロード
        [self.listTableView reloadData];
    }];
}

/**
 *  テーブルに表示するセルを返します。（実装必須）
 *
 *  @param tableView テーブルビュー
 *  @param indexPath セクション番号・行番号の組み合わせ
 *
 *  @return セル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    cell.imageView.image = nil;
    dispatch_async(q_global, ^{
        NSString *imageURL = @"http://blog-imgs-58.fc2.com/t/o/t/totalmatomedia/2013072601.png";
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]]];
        
        dispatch_async(q_main, ^{
            cell.imageThumb.image = image;
            //[cell layoutSubviews];
        });
    });
    
    NSMutableDictionary *celData = [list objectAtIndex:indexPath.row];
    
    cell.labelSubjectName.text = [celData objectForKey:@"subject"];
    cell.labelTitle.text = [[celData objectForKey:@"im:name"] objectForKey:@"label"];
    /*
    NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://blog-imgs-58.fc2.com/t/o/t/totalmatomedia/2013072601.png"]];
    UIImage *image = [UIImage imageWithData:image_data];
    cell.imageThumb.image = image;
     */
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //一番下までスクロールしたかどうか
    if (scrollView.dragging || self.scrollingToTop)
    {
        //まだ表示するコンテンツが存在するか判定し存在するなら○件分を取得して表示更新する
        NSLog(@"下までいったよ!! ><");
    }
}

/**
 * セルが選択されたとき
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"リスト押下");
    NSMutableDictionary *celData = [list objectAtIndex:indexPath.row];
    
    UIViewController *secondVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //[self presentViewController:]
    UIViewController *parent = [self.navigationController.viewControllers objectAtIndex:0];
    [parent.navigationController pushViewController:secondVC animated:YES];
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    self.scrollingToTop = YES;
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.scrollingToTop = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
