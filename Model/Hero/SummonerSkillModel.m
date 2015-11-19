//
//  SummonerSkillModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "SummonerSkillModel.h"

@implementation SummonerSkillModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ids"];
    }
}
@end
