//
//  MynavigationController.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/9.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "MynavigationController.h"


#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MynavigationController ()

@end

@implementation MynavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    
    if (self = [super initWithRootViewController:rootViewController]) {
        
        self.navigationBar.barTintColor = [UIColor colorWithRed:35 / 255.0 green:43 / 255.0 blue:60 / 255.0 alpha:0.5];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [self.navigationBar setTintColor:[UIColor whiteColor]];
        
    }
    return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
