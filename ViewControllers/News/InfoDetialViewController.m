//
//  InfoDetialViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "InfoDetialViewController.h"
#import "UMSocial.h"

@interface InfoDetialViewController ()
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation InfoDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayout];
}


- (void)setLayout {
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"资讯详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick)];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    //显示加载框
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"加载中"];
    
    //开启线程加载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //建立请求
        NSString * url = [NSString stringWithFormat:kNewsDetailUrlString,self.newsId];
        NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadRequest:request];
            
            [MMProgressHUD dismissWithSuccess:@"加载完成"];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//分享按钮点击
- (void)shareBtnClick {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:SHARE_KEY
                                      shareText:@"来自吊炸天的LOLBoxAPP分享"
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,nil]
                                       delegate:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
