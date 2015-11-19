//
//  SummonerCellModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummonerCellModel : NSObject
/**
 标题
 */
@property (copy, nonatomic) NSString *title;
/**
 第一个技能图片
 */
@property (copy, nonatomic) NSString *firstIcon;
/**
 第二个技能图片
 */
@property (copy, nonatomic) NSString *secIcon;
/**
  第三个技能图片
 */
@property (copy, nonatomic) NSString *thirdIcon;
/**
  第四个技能图片
 */
@property (copy, nonatomic) NSString *fourthIcon;
/**
  第一个技能描述
 */
@property (copy, nonatomic) NSString *firstDesc;
/**
  第二个技能描述
 */
@property (copy, nonatomic) NSString *secDesc;
/**
  第三个技能描述
 */
@property (copy, nonatomic) NSString *thireDesc;
/**
  第四个技能描述
 */
@property (copy, nonatomic) NSString *fourthDesc;

//初始化方法
- (instancetype)initWithArray:(NSArray *)array AndTitle:(NSString *)title;






@end
