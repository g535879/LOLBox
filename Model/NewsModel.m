//
//  NewsModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/13.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"iconId"];
    }
    else if ([key isEqualToString:@"short"]){
        [self setValue:value forKey:@"shortTitle"];
    }
}
@end
