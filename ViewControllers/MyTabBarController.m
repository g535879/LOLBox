//
//  MyTabBarController.m
//  HomeworkWeekend
//
//  Created by 古玉彬 on 15/10/23.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "MyTabBarController.h"
#import "RootViewController.h"
#import "InfoViewController.h"
#import "HeroDataViewController.h"
#import "HeroViewController.h"
#import "SettingViewController.h"

#import "MynavigationController.h"


@interface MyTabBarController (){
    
    NSMutableArray *_viewControllers; //子视图数组
    NSArray *_classNameArray; //类名数组
    NSArray *_tabNameAndPicArray; //tab名称和图片
    
}


@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData]; //初始化数据
}

//初始化数据
- (void)setData {
    if (!_viewControllers) {
        
        _viewControllers = [[NSMutableArray alloc] init];
    }
    
    _classNameArray = @[@"InfoViewController",@"HeroViewController",@"HeroDataViewController",@"SettingViewController"];

    _tabNameAndPicArray = @[@[@"新闻",@"tab_icon_news_normal",@"tab_icon_news_press"],@[@"英雄",@"tab_icon_more_normal",@"tab_icon_more_press"],@[@"资料",@"tab_icon_quiz_normal",@"tab_icon_quiz_press"],@[@"设置",@"tab_icon_more_normal",@"tab_icon_more_press"]];
    
    [_classNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RootViewController *rvc = [[NSClassFromString(obj) alloc] init];
        MynavigationController *ngc = [[MynavigationController alloc] initWithRootViewController:rvc];
        [[ngc.viewControllers firstObject] setTitle:_tabNameAndPicArray[idx][0]];
        [ngc.tabBarItem setImage:[[UIImage imageNamed:_tabNameAndPicArray[idx][1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]]; //未选中图标
        [ngc.tabBarItem setSelectedImage:[[UIImage imageNamed:_tabNameAndPicArray[idx][2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]]; //选中图片
        [_viewControllers addObject:ngc];
        [self.tabBar setBarTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.00f]];
    }];
    
    self.viewControllers = _viewControllers;
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
