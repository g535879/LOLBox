//
//  HeroModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroModel : NSObject
/**
     英雄id
 */
@property (copy, nonatomic) NSString *heroId;
/**
    英雄图片
 */
@property (copy, nonatomic) NSString *img;
/**
    英雄名
 */
@property (copy, nonatomic) NSString *name_c;
/**
    标签
 */
@property (copy, nonatomic) NSString *tags;
/**
    英雄称号
 */
@property (copy, nonatomic) NSString *title;
@end
