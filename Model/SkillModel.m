//
//  SkillModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/17.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "SkillModel.h"

@implementation SkillModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

//技能名
- (NSString *)name {
    return [NSString stringWithFormat:@"%@ (%@)",_name,_key];
}


//技能相关描述
- (NSString *)desc {
    NSMutableString * descStr = [@"" mutableCopy];
    
//    [descStr appendFormat:];
    [descStr appendFormat:@"%@\n\n%@%@%@",_desc,self.dist,self.cd,self.cost];
    return descStr;
}

- (NSString *)cd {
    return _cd.length ? [NSString stringWithFormat:@"冷却时间:%@\n",_cd] : @"";
}

- (NSString *)cost {
    return _cost.length ? [NSString stringWithFormat:@"消耗:%@\n",_cost] : @"";
}
- (NSString *)dist {
    return _dist.length ? [NSString stringWithFormat:@"施法距离:%@\n",_dist] : @"";
}

@end
