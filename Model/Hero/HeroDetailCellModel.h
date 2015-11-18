//
//  HeroDetailCellModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroDetailModel.h"

@interface HeroDetailCellModel : NSObject
/**
    分组名
 */
@property (copy, nonatomic) NSString * title;
/**
 第一个英雄头像
 */
@property (copy, nonatomic) NSString * firstHeroImg;

/**
 第二个英雄头像
 */
@property (copy, nonatomic) NSString * secondHeroImg;
/**
 第一个英雄描述
 */
@property (copy, nonatomic) NSString * firstHeroDesc;

/**
 第二个英雄描述
 */
@property (copy, nonatomic) NSString * secondHeroDesc;

//第一个model
@property (strong, nonatomic) HeroDetailModel * firstModel;
//第二个model
@property (strong, nonatomic) HeroDetailModel * secondModel;
//初始化方法
- (instancetype)initWitthFirstHero:(HeroDetailModel *)firstHero andSecHero:(HeroDetailModel *)secHero;


- (instancetype)initWithArray:(NSArray *)array;
@end
