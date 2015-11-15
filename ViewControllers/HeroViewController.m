//
//  HeroViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/9.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroViewController.h"
#import "PinYinForObjc.h"
#import "HeroModel.h"
#import "HeroTableViewCell.h"
#import "HeroDetailViewController.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HeroViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView * _tableView;// 表格布局
}
@property (copy, nonatomic) NSString * heroRange; //免费or全部
@property (strong, nonatomic) NSMutableArray * dataArray; //数据源
@property (strong, nonatomic) NSMutableDictionary * heroDic; //英雄字典
@end

@implementation HeroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData]; // 加载数据
    [self createLayout];
}


//加载数据
- (void)loadData{
    
    //加载框
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"正在加载..."];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://lol.data.shiwan.com/lolHeros/?filter=&type=%@",self.heroRange] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MMProgressHUD dismissWithSuccess:@"加载完成"];
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //解析数据
        [self analyseResponseData:obj];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MMProgressHUD dismissWithError:@"加载失败"];
    }];
}

//布局
- (void)createLayout {
//    segement
    UISegmentedControl * seg = [[UISegmentedControl alloc] initWithItems:@[@"免费",@"全部"]];
    [seg setSelectedSegmentIndex:0];
    seg.frame = CGRectMake(0, 0, 150, 30);
    //点击事件
    [seg addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, MAX_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"HeroTableViewCell" bundle:nil] forCellReuseIdentifier:@"heroCell"];
}

//解析数据
- (void)analyseResponseData:(NSDictionary *)responseDic {
    if ([[responseDic[@"error_code"] stringValue] isEqualToString:@"0"]) { //成功返回0
        
        //解析数组
        for (NSDictionary * dic in responseDic[@"result"]) {
            HeroModel * model = [[HeroModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            //获取英雄名字首字母
            NSString * name = [[NSString stringWithFormat:@"%c",[[PinYinForObjc chineseConvertToPinYinHead:model.name_c] characterAtIndex:0]] uppercaseString];
            if (self.heroDic[name]) { //有数据
                id obj = self.heroDic[name];
                if ([obj isKindOfClass:[NSArray class]]) {
                    [obj addObject:model];
                }
            }else{
                [self.heroDic setObject:[@[] mutableCopy] forKey:name];
                [[self.heroDic objectForKey:name] addObject:model];
            }
        }
        
        //解析self.heroDic 。存入 数据源
        for ( int i = 'A'; i < 'Z'; i++) {
            id heroData = self.heroDic[[NSString stringWithFormat:@"%c",i]];
            if (heroData) { //有数据
                [self.dataArray addObject:@{[NSString stringWithFormat:@"%c",i]:heroData}];
            }
        }
        [_tableView reloadData];
    }
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

//分组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.dataArray[section] allObjects] firstObject] count];
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"heroCell";
    HeroTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HeroModel * model = [[self.dataArray[indexPath.section] allObjects] firstObject][indexPath.row];
    [cell.icon setImageWithURL:[NSURL URLWithString:model.img]];
    cell.title.text = model.title;
    cell.name.text = model.name_c;
    cell.tags.text = model.tags;
    return cell;
    
}
//分组标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.dataArray[section] allKeys] firstObject];
}

//index title
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * titleArray = [@[] mutableCopy];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titleArray addObject:[[obj allKeys] firstObject]];
    }];
    return titleArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [@[] mutableCopy];
    }
    return _dataArray;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeroModel * model = [[self.dataArray[indexPath.section] allObjects] firstObject][indexPath.row];
    HeroDetailViewController * hvc = [[HeroDetailViewController alloc] init];
    hvc.heroId = model.heroId;
    hvc.heroName = model.title;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:hvc animated:YES];
}

- (NSString *)heroRange {
    if (!_heroRange) {
        _heroRange = @"free";
    }
    return _heroRange;
}

- (NSMutableDictionary *)heroDic {
    if (!_heroDic) {
        _heroDic = [@{} mutableCopy];
    }
    return _heroDic;
}
//seg点击事件
- (void)segClick:(UISegmentedControl *)seg {
    if (seg.selectedSegmentIndex) { //1
        self.heroRange = @"all";
    }else{
        self.heroRange = @"free";
    }
    //清空以前数据
    [self.dataArray removeAllObjects];
    
    [self.heroDic removeAllObjects];
    //重新加载数据
    [self loadData];
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
