//
//  HeroDetailViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroDetailViewController.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HeroDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    UIScrollView * _scrollview; //滚动视图
    UIImageView * _heroBigImageView; //英雄图片
    UITableView * _heroTableView;
    UIView * _headView;
    UITableView * _skillTableView; //技能相关表格布局
    
}
@end

@implementation HeroDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationRefer]; //设置导航栏
    [self loadData]; //加载数据
    [self createLayout]; //布局

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:35 / 255.0 green:43 / 255.0 blue:60 / 255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}


//导航栏设置
- (void)setNavigationRefer {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor orangeColor]];
    self.title = self.heroName;
    
}

#pragma mark - createLayout 
- (void)createLayout {
    
    
    //scrollView
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50)];
    _scrollview.delegate = self;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.contentOffset = CGPointMake(0, 0);
    _scrollview.pagingEnabled = YES;
    _scrollview.contentSize = CGSizeMake(MAX_WIDTH * 4, 2 * MAX_HEIGHT / 3);
//    [self.view addSubview:_scrollview];
    
    //teset
    for ( int i = 0; i < 4; i++) {
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(MAX_WIDTH * i, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50)];
        [v setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1]];
        [_scrollview addSubview:v];
        if (!i) {
//            [v addSubview:_skillTableView];
//            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.frame = CGRectMake(0, 0, 150, 150);
//            [btn setTitle:@"hello" forState:UIControlStateNormal];
            
            //skillView
            _skillTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50) style:UITableViewStylePlain];
            _skillTableView.delegate = self;
            _skillTableView.dataSource = self;
//            _skillTableView.bounces = NO;
            _skillTableView.scrollEnabled = NO;
            [_skillTableView setBackgroundColor:[UIColor yellowColor]];
            
            [v addSubview:_skillTableView];
        }
    }
    
    //headImageView
    _heroBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -MAX_HEIGHT / 3, MAX_WIDTH, MAX_HEIGHT / 3)];
    _heroBigImageView.image = [UIImage imageNamed:@"bindLogo"];
    
    
    _heroTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, MAX_WIDTH, MAX_HEIGHT+64) style:UITableViewStylePlain];
    _heroTableView.delegate = self;
    _heroTableView.dataSource = self;
    _heroTableView.showsVerticalScrollIndicator = NO;
    [_heroTableView addSubview:_heroBigImageView];
    _heroTableView.contentInset = UIEdgeInsetsMake(MAX_HEIGHT / 3, 0, 0, 0);
    [_heroTableView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_heroTableView];
    
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, 50)];
    NSArray * titleArray = @[@"技能",@"出装加点",@"故事",@"攻略"];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(MAX_WIDTH / 4 * idx, 0, MAX_WIDTH / 4, 50);
        [btn setTitle:titleArray[idx] forState:UIControlStateNormal];
        btn.tag = 100 + idx;
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:36 / 255.0 green:119/ 255.0 blue:255/ 255.0 alpha:1] forState:UIControlStateSelected];
        if (!idx) {//第一个默认选中
            [btn setSelected:YES];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        }
        [_headView addSubview:btn];
    }];
    
    [_headView setBackgroundColor:[UIColor lightGrayColor]];
    _heroTableView.tableHeaderView  = _headView;

}

- (void)loadData {
    //加载框
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"加载中..."];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:kHeroDetailInfoUrlString,self.heroId] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        id error_code = jsonObj[@"error_code"];
        if (![error_code integerValue]) {
            NSDictionary * resultDic = jsonObj[@"result"];
            NSString * heroImageStrUrl = resultDic[@"img_top"];
            [_heroBigImageView setImageWithURL:[NSURL URLWithString:heroImageStrUrl] placeholderImage:[UIImage imageNamed:@"bindLogo"]];
        }
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



#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _heroTableView) {
        return 1;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _heroTableView) {
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:_scrollview];
        return cell;
    }
    
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据%ld",indexPath.row];
//    [cell.contentView addSubview:_skillTableView];
    return cell;
    
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _heroTableView) {
        return MAX_HEIGHT - 64 - 50 + 200;
    }
    return 40;
}


#pragma mark -  srcollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat  y = scrollView.contentOffset.y;
   
    
    //父表格移动
    if (scrollView == _heroTableView) {
         NSLog(@"%f",y);
        if (y > -65) { //滑动到顶端。固定位置
            //固定位置-65
            scrollView.contentOffset = CGPointMake(0, -65);
            CGFloat offsetY = _skillTableView.contentOffset.y;
            //子表格联动
            //控制偏移量
            if (_skillTableView.contentOffset.y < (_skillTableView.contentSize.height - 64 -250)) {
                _skillTableView.contentOffset = CGPointMake(0, offsetY + y + 65);
            }
            _skillTableView.scrollEnabled = YES;
        }
        //往下滑动。
        if (y < -65) {
            
            //判断子表格偏移量
            if (_skillTableView.contentOffset.y > 0) {
                
                //固定位置-65
                _heroTableView.contentOffset = CGPointMake(0, -65);
                
                CGFloat offsetY = _skillTableView.contentOffset.y;
                //子表格联动
                _skillTableView.contentOffset = CGPointMake(0, offsetY + y + 65);

            }
        }
        //顶部图片偏移量
        if (y < - MAX_HEIGHT / 3) {
            CGRect frame = _heroBigImageView.frame;
            frame.size.height =  - y ;
            frame.origin.y = y;
            _heroBigImageView.frame = frame;
        }
    }
    
    //技能栏相关，子表格
    else if (scrollView == _skillTableView) {
        
        //内部表格偏移量小于0.固定位置
         if (_skillTableView.contentOffset.y <= 0) {
            _skillTableView.contentOffset = CGPointMake(0, 0);
            _skillTableView.scrollEnabled = NO;
        }

    }
    //标题栏滚动视图联动
   else if (scrollView == _scrollview) { //滚动视图
        CGFloat  x = scrollView.contentOffset.x;
        [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton * b = (UIButton *)obj;
                CGFloat offSet = x / MAX_WIDTH * 1.0;
//                NSLog(@"%f",fabs(b.tag - 100 - offSet));
                if (fabs(b.tag - 100 - offSet) < 1) {
                    b.selected  = YES;
                    [b.titleLabel setFont:[UIFont systemFontOfSize:16]];
                    
                    if (b.tag - 100 == offSet) {
                        [b.titleLabel setFont:[UIFont systemFontOfSize:18]];
                    }
                }
                else{
                    b.selected = NO;
                    [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
                }
            }
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != _scrollview) {
        return;
    }
    //取消其他按钮选中状态
    [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * b = (UIButton *)obj;
            if (b.selected) {
                b.selected = NO;
                [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }
            if (idx == scrollView.contentOffset.x / MAX_WIDTH) {
                b.selected = YES;
                [b.titleLabel setFont:[UIFont systemFontOfSize:18]];
            }
        }
    }];
    
}
#pragma mark - titleBtnClick 
- (void)titleBtnClick:(UIButton *)btn {
    //取消其他按钮选中状态
    [_headView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * b = (UIButton *)obj;
            if (b.selected) {
                b.selected = NO;
                [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            }
        }
    }];
    btn.selected = !btn.selected;
    
    [UIView animateWithDuration:0.5f animations:^{
        //设置滚动视图偏移量
        _scrollview.contentOffset = CGPointMake(MAX_WIDTH * (btn.tag - 100), 0);
        //字体变大
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    }];
    
    
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
