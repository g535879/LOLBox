//
//  BaseViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/9.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "BaseViewController.h"
#import "ScroModel.h"
#import "NewsModel.h"
#import "DesignPicScrollView.h"
#import "InfoDetialViewController.h"
#import "NewsViewCell.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface BaseViewController () <returnBaseVCDelegate,UITableViewDataSource,UITableViewDelegate>
@property (copy, nonatomic) NSMutableArray * adPicArray; //滚动广告图片数组
@property (copy, nonatomic) NSMutableArray * dataArry; //新闻数据源
@property (strong, nonatomic) DesignPicScrollView *adScrollView; //广告滚动视图
@property (strong, nonatomic) UITableView * newsTableView; //新闻表格视图
@property (assign, nonatomic) NSInteger currentPage; //当前页
@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLayout]; //布局

}

//布局
- (void)setLayout {
    
    
    //表格视图
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, MAX_WIDTH, MAX_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    [self.view addSubview:self.newsTableView];
    
    //广告滚动视图
    self.adScrollView = [[DesignPicScrollView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, (MAX_HEIGHT - 64 - 49) / 3)];
    [self.adScrollView setBackgroundColor:[UIColor blackColor]];
    self.adScrollView.returnDelegate = self;
    //表格头视图
    self.newsTableView.tableHeaderView = self.adScrollView;
    
    //下拉刷新控件
    [self setHeaderRefresh];
    
    //下拉加载更多
    [self setFooterRefresh];
    
    //加载框
    //注册cell
    [self.newsTableView registerNib:[UINib nibWithNibName:@"NewsViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
}

//获取数据
- (void)setDataUrl:(NSString *)dataUrl {
    _dataUrl = dataUrl;
    self.currentPage = 1;
    //获取数据
    [self loadData:dataUrl];
}

//下拉刷新
- (void)setHeaderRefresh {
    MJRefreshGifHeader * header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self loadData:self.dataUrl];
    }];
    
    //设置不同状态下的图片
    NSArray * imageArr = @[[UIImage imageNamed:@"common_loading_anne_0"],[UIImage imageNamed:@"common_loading_anne_1"]];
    [header setImages:imageArr duration:1.0f forState:MJRefreshStateRefreshing];
    [header setImages:@[[UIImage imageNamed:@"common_loading_anne_0"]] forState:MJRefreshStateIdle];
    self.newsTableView.header = header;
}

//上拉加载更多
- (void)setFooterRefresh {
    
    MJRefreshAutoGifFooter * footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self loadData:self.dataUrl];
    }];
    
    NSArray * imageArr = @[[UIImage imageNamed:@"common_loading_anne_0"],[UIImage imageNamed:@"common_loading_anne_1"]];
    
    [footer setImages:imageArr duration:1 forState:MJRefreshStateRefreshing];
    
    self.newsTableView.footer = footer;

}

#pragma mark - loadData
- (void)loadData:(NSString *)urlStr {
    
    //设置加载栏的动画效果
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    
    //加载栏显示
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"正在加载"];
    
    
    if (self.currentPage == 1) { //第一页刷新数据
        //清空数据
        [self.adPicArray removeAllObjects];
        [self.dataArry removeAllObjects];
    }
    
    urlStr = [NSString stringWithFormat:urlStr,self.currentPage];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        id adObj = jsonObj[@"recomm"];
        if ([adObj isKindOfClass:[NSArray class]]) {
            //解析广告
            [adObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ScroModel * model = [[ScroModel alloc] init];
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [model setValuesForKeysWithDictionary:obj];
                    [self.adPicArray addObject:model];
                }
                
            }];
        }
        //判断广告源数组中元素
        if (self.adPicArray.count) {
            //数据源赋值
            self.adScrollView.imageModelArray = self.adPicArray;
        }
        //解析新闻内容数据
        
        //判断数据是否正确
        NSString *errorCode = jsonObj[@"error_code"];
        if ([errorCode isKindOfClass:[NSString class]] && [errorCode isEqualToString:@"0"]) {  //正确数据
            
            id newsObj = jsonObj[@"result"];
            if ([newsObj isKindOfClass:[NSArray class]]) {
                [newsObj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NewsModel * model = [[NewsModel alloc] init];
                        [model setValuesForKeysWithDictionary:obj];
                        [self.dataArry addObject:model];
                    }
                }];
            }
            
            //刷新数据
            [self.newsTableView reloadData];
        }
        
        //关闭MJ刷新状态
        [self.newsTableView.header endRefreshing];
        
        [self.newsTableView.footer endRefreshing];
        
        //关闭加载栏
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        //关闭MJ刷新状态
        [self.newsTableView.header endRefreshing];
        
        [self.newsTableView.footer endRefreshing];
        
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}


#pragma mark - 初始化/get数组相关操作
- (NSMutableArray *)adPicArray {
    if (!_adPicArray) {
        _adPicArray = [@[] mutableCopy];
    }
    return _adPicArray;
}

-  (NSMutableArray *)dataArry {
    if (!_dataArry) {
        _dataArry = [@[] mutableCopy];
    }
    return _dataArry;
}

#pragma mark - 点击新闻代理事件
- (void)tapPicIndexID:(NSString *)artID {
    
    InfoDetialViewController * ivc = [[InfoDetialViewController alloc] init];
    ivc.newsId = artID;
    [self.navigationController pushViewController:ivc animated:YES];
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdntifier = @"cellIdentifier";
    NewsViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdntifier];
    NewsModel * model = self.dataArry[indexPath.row];
    [cell.newsImageView setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"1111icon.png"]];
    cell.newsTitle.text = model.title;
    cell.newsShortTitle.text = model.shortTitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsModel * model = self.dataArry[indexPath.row];
    [self tapPicIndexID:model.iconId];
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
