//
//  HeroDetailViewController.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "RootViewController.h"

@interface HeroDetailViewController : RootViewController
@property (copy, nonatomic) NSString * heroId;   //英雄id
@property (copy, nonatomic) NSString * heroName;  //英雄名
@end
