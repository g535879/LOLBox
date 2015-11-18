//
//  HeroDetailViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14./Users/guyubin/Documents/developer/Project/LOLBox/LOLBox.xcodeproj
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroDetailViewController.h"
#import "SkillModel.h"
#import "HeroSkillViewCell.h"
#import "HeroInfoCell.h"
#import "HeroInfoModel.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HeroDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ReloadCell> {
    UIScrollView * _scrollview; //滚动视图
    UIImageView * _heroBigImageView; //英雄图片
    UITableView * _heroTableView;   //父表格视图
    UIView * _headView;  //4个按钮容器
    UITableView * _currentTableView; //当前活动的子视图
    NSMutableArray * _dataArray; //所有数据源
    NSMutableArray * _currentDataArray; //当前数据源
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
    
    //4个子tableview
    for ( int i = 0; i < 4; i++) {
        //作为子tableview 的容器
        UIView * v = [[UIView alloc] initWithFrame:CGRectMake(MAX_WIDTH * i, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50)];
        [v setBackgroundColor:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1]];
        [_scrollview addSubview:v];
        
        //子tableview
        UITableView  *_skillTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        
        _skillTableView.delegate = self;
        _skillTableView.dataSource = self;
        _skillTableView.scrollEnabled = NO;
        _skillTableView.showsVerticalScrollIndicator = NO;
        //隐藏中间横线
        _skillTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //注册cell
        [_skillTableView registerNib:[UINib nibWithNibName:@"HeroSkillViewCell" bundle:nil] forCellReuseIdentifier:@"heroReuseCell"];
        
        //注册cell
        [_skillTableView registerNib:[UINib nibWithNibName:@"HeroInfoCell" bundle:nil] forCellReuseIdentifier:@"heroInfoReuseCell"];
        
        if (!i) { //第0个
            //当前表格视图
            _currentTableView = _skillTableView;
        }
        //默认第一个视图
        [v addSubview:_skillTableView];
    }
    //顶部图片
    //headImageView
    _heroBigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -MAX_HEIGHT / 3, MAX_WIDTH, MAX_HEIGHT / 3)];
    _heroBigImageView.image = [UIImage imageNamed:@"bindLogo"];
    
    
    _heroTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, MAX_WIDTH, MAX_HEIGHT+64) style:UITableViewStylePlain];
    _heroTableView.delegate = self;
    _heroTableView.dataSource = self;
    _heroTableView.showsVerticalScrollIndicator = NO;
    [_heroTableView addSubview:_heroBigImageView];
    _heroTableView.contentInset = UIEdgeInsetsMake(MAX_HEIGHT / 3, 0, 0, 0);
    [self.view addSubview:_heroTableView];
    
    //中间4个按钮
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, 50)];
    NSArray * titleArray = @[@"技能",@"出装加点",@"故事",@"天赋"];
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

//加载数据
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
            //顶部图片
            [_heroBigImageView setImageWithURL:[NSURL URLWithString:heroImageStrUrl] placeholderImage:[UIImage imageNamed:@"bindLogo"]];
            
//=================================================第一页数据开始===============================================/
            //解析技能
            NSArray * skillArray = resultDic[@"skill"];
            //技能相关模型数组
            NSMutableArray * skillModelArray = [@[] mutableCopy];
            for (NSDictionary * dic in skillArray) {
                SkillModel * model = [[SkillModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [skillModelArray addObject:model];
            }
            
            //多重数组。提高可扩展性
            NSArray * heroTitleArray = @[@[@"操作技巧"],@[@"符文穿戴"],@[@"背景故事"],@[@"天赋"]];
            NSArray * dataKeys = @[@[@"analyse"],@[@"rune_desc"],@[@"background"],@[@"talent_desc"]];
            for (int i = 0; i < heroTitleArray.count; i++) {
                //当前页容器
                NSMutableArray * currentDataArray = [@[] mutableCopy];
                if (i == 0) {
                    //技能数据加入到第一组中
                    [currentDataArray addObject:skillModelArray];
                }
                [heroTitleArray[i] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    HeroInfoModel * infoModel = [[HeroInfoModel alloc] init];
                    infoModel.title = obj;
                    infoModel.desc = resultDic[dataKeys[i][idx]];
                    [currentDataArray addObject:infoModel];
                }];
                
                if (!_dataArray) {
                    
                    _dataArray = [@[] mutableCopy];
                }
                
                [_dataArray addObject:currentDataArray];//存入数据源
            }
            //操作技巧解析
           
            
//=================================================第一页数据结束===============================================/
            
//=================================================第二页数据开始===============================================/
//            //第二页数据容器
//            NSMutableArray * equipArray = [@[] mutableCopy];
//            
//            //符文穿戴
//            HeroInfoModel * traceModel = [[HeroInfoModel alloc] init];
//            traceModel.title = ;
//            traceModel.desc = resultDic[];
//            [equipArray addObject:traceModel];
//            [_dataArray addObject:equipArray];
//=================================================第二页数据结束===============================================/
//=================================================第三页数据开始===============================================/
            //第三页数据容器
            NSMutableArray * storyArray = [@[] mutableCopy];
            //背景故事
            
//=================================================第三页数据结束===============================================/
//=================================================第四页数据开始===============================================/
//=================================================第四页数据结束===============================================/
            //默认显示第一页数据
            _currentDataArray = _dataArray[0];
            //刷新数据
            [_currentTableView reloadData];
        }
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}

//根据颜色生成图片
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
    return _currentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //父tableview
    if (tableView == _heroTableView) {
        static NSString * cellIdentifier = @"cellIdentifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell.contentView addSubview:_scrollview];
        return cell;
    }
    //子视图刷新
    if (tableView == _currentTableView) {
        id obj= _currentDataArray[indexPath.row];
        
        //数组类型。说明为技能相关表格
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray * skillArray = (NSArray *)obj;
            static NSString * cellIdentifier = @"heroReuseCell";
            HeroSkillViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            //设置代理
            cell.delegate = self;
            
            cell.dataArray = skillArray; //相关数据
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone; //不可点击
            
            return cell;
        }
        
        //通用相关信息
        else if([obj isKindOfClass:[HeroInfoModel class]]){
            HeroInfoModel * model = (HeroInfoModel *)obj;
            static NSString * cellIdentifier = @"heroInfoReuseCell";
            HeroInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cell.title.text = model.title;
            cell.desc.text = model.desc;
            return cell;
        }
    }

    return nil;
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _heroTableView) {
        return MAX_HEIGHT - 64 - 50 + 200;
    }
    
    
    UITableViewCell * cell;
    id obj= _currentDataArray[indexPath.row];
    //数组类型。说明为技能相关表格
    if ([obj isKindOfClass:[NSArray class]]) {
        //子视图
        static NSString * cellIdentifier = @"heroReuseCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [(id)cell setDataArray:obj]; //相关数据
    }
    
    //通用相关信息
    else if([obj isKindOfClass:[HeroInfoModel class]]){
        HeroInfoModel * model = (HeroInfoModel *)obj;
        static NSString * cellIdentifier = @"heroInfoReuseCell";
        HeroInfoCell * infoCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        infoCell.title.text = model.title;
        infoCell.desc.text = model.desc;
        
        cell = infoCell;
    }

    return [(id)cell heightOfCellWithWidth:MAX_WIDTH];
}


#pragma mark -  srcollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //获取当前活动的tableview
    UITableView * _skillTableView = _currentTableView;
    CGFloat  y = scrollView.contentOffset.y;
   
    
    //父表格移动
    if (scrollView == _heroTableView) {
        
        if (y > -65) { //滑动到顶端。固定位置
            //固定位置-65
            scrollView.contentOffset = CGPointMake(0, -65);
            CGFloat offsetY = _skillTableView.contentOffset.y;
            //子表格联动
            //控制偏移量
            if (_skillTableView.contentOffset.y < (_skillTableView.contentSize.height - 64 -500)) {
                _skillTableView.contentOffset = CGPointMake(0, offsetY + y + 65);
            }
            _skillTableView.scrollEnabled = YES;
        }
        //往下滑动。判断自表格是否移动到0.如到0 移动父表格。否则。移动子表格
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
                //当前表格视图
                _currentTableView = [[_scrollview.subviews[idx] subviews]firstObject];
                //当前数据源赋值
//                if (_currentDataArray) {
//                    //清空数据
//                    [_currentDataArray removeAllObjects];
//                }
                if (_dataArray.count > idx) {
                    _currentDataArray = _dataArray[idx];
                    //刷新表格
                    [_currentTableView reloadData];
                }
                
                

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
        //字体变大
        [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        
        //设置滚动视图偏移量
        _scrollview.contentOffset = CGPointMake(MAX_WIDTH * (btn.tag - 100), 0);

       
    }];
    
    //当前表格视图
   _currentTableView = [[_scrollview.subviews[btn.tag - 100] subviews]firstObject];
    
    //当前数据源赋值
    if (_dataArray.count > btn.tag - 100) {
        _currentDataArray = _dataArray[btn.tag - 100];
        //刷新表格
        [_currentTableView reloadData];
    }

    
}

#pragma mark -  reloadCell delegate
- (void)reloadCellByCell:(UITableViewCell *)cell {
    //保存当前选中图片下标
    if ([cell isKindOfClass:[HeroSkillViewCell class]]) {
        NSInteger currentPicIndex = [(HeroSkillViewCell *)cell currentPic];
        //保存到模型中
        [(SkillModel *)[[_currentDataArray firstObject] lastObject] setCurrentSelectedPicIndex:currentPicIndex];
    }
    //刷新数据
    [_currentTableView reloadRowsAtIndexPaths:@[[_currentTableView indexPathForCell:cell]] withRowAnimation:NO];
}
@end
