//
//  HeroDetailModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroDetailModel.h"

@implementation HeroDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key hasPrefix:@"skill_desc"]) {
        [self setValue:value forKey:@"desc"];
    }
    
    if ([key isEqualToString:@"hid"]) {
        [self setValue:value forKey:@"heroId"];
    }
}

- (void)setDesc:(NSString *)desc {
    if (desc.length > 0) { 
        _desc == nil ? (_desc = desc) : (_desc = [_desc stringByAppendingFormat:@"\n%@",desc]);
    }
}
@end
