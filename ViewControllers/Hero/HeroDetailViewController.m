//
//  HeroDetailViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroDetailViewController.h"

@interface HeroDetailViewController ()

@end

@implementation HeroDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationRefer]; //设置导航栏
    [self loadData]; //加载数据
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:35 / 255.0 green:43 / 255.0 blue:60 / 255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.tabBarController.tabBar.hidden = NO;
}


//导航栏设置
- (void)setNavigationRefer {
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
}

- (void)loadData {
    //加载框
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"加载中..."];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:kHeroDetailInfoUrlString,self.heroId] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonObj);
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);  //图片尺寸
    UIGraphicsBeginImageContext(rect.size); //填充画笔
    CGContextRef context = UIGraphicsGetCurrentContext(); //根据所传颜色绘制
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect); //联系显示区域
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext(); // 得到图片信息
    UIGraphicsEndImageContext(); //消除画笔
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
