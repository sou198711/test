//
//  ListViewController.m
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/07.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import "ListViewController.h"
#import "CustomTableViewCell.h"

@interface ListViewController () {
    NSMutableArray *list;
    //DetailViewController *detailVc;
}
@property (nonatomic) BOOL scrollingToTop;
@property (nonatomic) DetailViewController *detailVc;
@end

@implementation ListViewController

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
    NSLog(@"ListViewController");
    
    self.navigationItem.title = @"一覧";
    self.navigationItem.backBarButtonItem.title = @"戻る";
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    /*
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
     */
    [self getJSON];
    
    // カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil];
    [self.listTableView registerNib:nib forCellReuseIdentifier:@"CustomTableViewCell"];
    //    [self.listTableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];
    
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
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/jp/rss/topfreeapplications/limit=30/json"];
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
    NSLog(@"cellForRowAtIndexPath");
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomTableViewCell"];
    NSMutableDictionary *celData = [list objectAtIndex:indexPath.row];
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    cell.imageView.image = nil;
    dispatch_async(q_global, ^{
        NSString *imageURL = [[celData objectForKey:@"im:image"][0] objectForKey:@"label"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]]];
        
        dispatch_async(q_main, ^{
            cell.imageThumb.image = image;
            //[cell layoutSubviews];
        });
    });
    
    
    
    cell.labelSubjectName.text = [[[celData objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
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
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
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
    NSNumber *app_id = [[[celData objectForKey:@"id"] objectForKey:@"attributes"] objectForKey:@"im:id"];
    NSInteger *param = [app_id integerValue];
    
    self.detailVc =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    self.detailVc.view;
    [self.detailVc setViewData:param callView:(UIViewController *)self];
    //[self.navigationController pushViewController:detailVc animated:YES];
}

-(void)forwardDatail {
    NSLog(@"遷移");
    //[self presentViewController:]
    [self.navigationController pushViewController:self.detailVc animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
