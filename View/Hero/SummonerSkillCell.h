//
//  SummonerSkillCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
// 召唤师单元格

#import "HeroPorAViewCell.h"

@interface SummonerSkillCell : HeroPorAViewCell
/**
 第三个图片
 */
@property (strong, nonatomic) UIImageView *thirdImg;
/**
 第三个图片描述
 */
@property (strong, nonatomic) UILabel *thirdDesc;
/**
 第四个图片
 */
@property (strong, nonatomic) UIImageView *fourthImg;
/**
 第四个图片描述
 */
@property (strong, nonatomic) UILabel *fourthDesc;

//设置数据源
- (void)setDataArray:(NSArray *)arr;

//获取高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width;
@end
