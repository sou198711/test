//
//  ViewController.m
//  test
//
//  Created by 佐藤宗一郎 on 2015/06/06.
//  Copyright (c) 2015年 佐藤宗一郎. All rights reserved.
//

#import "DetailViewController.h"
#import "ListViewController.h"
#import "AFNetworking.h"

@interface DetailViewController () {
    NSDictionary *detail;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"DetailViewController viewDidLoad");
    
    /*
    self.lblDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 5000)];
    [self.lblDetail setLineBreakMode:NSLineBreakByWordWrapping];  // 改行設定
    [self.lblDetail setNumberOfLines:0];  // 行数指定。0で指定なし
    //[self.lblDetail setText:dummyText];   // sizeToFitより前にテキストをセットする
    //[self.lblDetail sizeToFit];   // テキストの量に応じて高さを変える
    
    [self.scrollView addSubview:self.lblDetail];
     */
    //self.navigationItem.title = @"detail";
}

- (void)setViewData:(NSInteger *)app_id callView:(UIViewController *)viewCon {
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"detail %ld", (long)app_id);
    
    ListViewController *listView = (ListViewController *)viewCon;
    
    NSString *url_str = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?country=jp&id=%ld", (long)app_id];
    
    // APIアクセス
    NSURL *url = [NSURL URLWithString:url_str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //取得したレスポンスをJSONパース
   // NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:nil error:&e];
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url_str
      parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"response: %@", responseObject);
          [self setDetailInfo:(NSDictionary *)responseObject];
          // 遷移実行
          [listView forwardDatail];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
    /*
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
    }];
    */
}

- (void)setDetailInfo:(NSDictionary *)jsonDictionary {
    
    // アプリデータの配列をプロパティに保持
    detail = [jsonDictionary objectForKey:@"results"][0];
    NSLog(@"%@", [detail objectForKey:@"trackName"]);
    
    // タイトル設定
    self.navigationItem.title = [detail objectForKey:@"trackName"];
    
    self.lbllTitle.text = [detail objectForKey:@"trackName"];
    self.lblCategory.text = [detail objectForKey:@"genres"][0];
    self.lblDetail.text = [detail objectForKey:@"description"];
    [self.lblDetail sizeToFit];
    NSLog(@"%@", self.lbllTitle.text);
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    dispatch_async(q_global, ^{
        NSString *imageURL = [detail objectForKey:@"artworkUrl512"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: imageURL]]];
        
        dispatch_async(q_main, ^{
            self.mainImage.image = image;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end