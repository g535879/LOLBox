//
//  SummonerSkillModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummonerSkillModel : NSObject

/**
 技能描述
 */
@property (copy, nonatomic) NSString *desc;
/**
 技能id
 */
@property (copy, nonatomic) NSString *hid;
/**
 技能图标
 */
@property (copy, nonatomic) NSString *icon;
/**
 id
 */
@property (copy, nonatomic) NSString *ids;
/**
 技能名
 */
@property (copy, nonatomic) NSString *name;
/**
 技能类型
 */
@property (copy, nonatomic) NSString *type;
@end
