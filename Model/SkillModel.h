//
//  SkillModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/17.
//  Copyright © 2015年 guyubin. All rights reserved.
//英雄技能model QWER

#import <Foundation/Foundation.h>

@interface SkillModel : NSObject
/**
 cd
 */
@property (copy, nonatomic) NSString *cd;

/**
 消耗
 */
@property (copy, nonatomic) NSString * cost;

/**
 距离
 */
@property (copy, nonatomic) NSString *dist;
/**
 技能描述
 */
@property (copy, nonatomic) NSString *desc;
/**
 技能图片
 */
@property (copy, nonatomic) NSString *img;
/**
 key
 */
@property (copy, nonatomic) NSString *key;
/**
 技能名
 */
@property (copy, nonatomic) NSString *name;

//当前选中图片下标
@property (assign, nonatomic) NSInteger currentSelectedPicIndex;
@end
