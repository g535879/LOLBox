//
//  InfoViewController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/9.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "InfoViewController.h"
#import "NewsViewController.h"
#import "ActivityViewController.h"
#import "GameViewController.h"
#import "VideoViewController.h"
#import "FunViewController.h"
#import "OfficaialViewController.h"
#import "GirlViewController.h"
#import "RadiersViewController.h"
#import "SCNavTabBarController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewControllers]; //子视图
}


//子视图
- (void)createViewControllers {
    
    //隐藏导航栏
    self.navigationController.navigationBar.hidden = YES;

    NewsViewController * new = [[NewsViewController alloc]init];
    
    new.title = @"最新";
    
    ActivityViewController * activity = [[ActivityViewController alloc]init];
    
    activity.title = @"活动";
    
    GameViewController * game = [[GameViewController alloc]init];
    
    game.title = @"赛事";
    
    VideoViewController * video = [[VideoViewController alloc]init];
    
    video.title = @"视频";
    
    FunViewController * fun = [[FunViewController alloc]init];
    
    fun.title = @"娱乐";
    
    OfficaialViewController * official = [[OfficaialViewController alloc]init];
    
    official.title = @"官方";
    
    GirlViewController * girl = [[GirlViewController alloc]init];
    
    girl.title = @"美女";
    
    RadiersViewController * raiders = [[RadiersViewController alloc]init];
    
    raiders.title = @"攻略";
    
    SCNavTabBarController * stc = [[SCNavTabBarController alloc] init];
    //所需管理的视图控制器
    stc.subViewControllers = @[new,activity,game,video,fun,official,girl,raiders];

    //导航栏颜色
    [stc setNavTabBarColor:[UIColor colorWithRed:35 / 255.0 green:43 / 255.0 blue:60 / 255.0 alpha:0.5]];
    
    //更改背景颜色保持与导航条一致
    self.view.backgroundColor = [UIColor colorWithRed:55 / 255.0 green:63 / 255.0 blue:80 / 255.0 alpha:1];
    
    //显示效果
    [stc addParentController:self];
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
