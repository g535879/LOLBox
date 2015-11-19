//
//  SummonerCellModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "SummonerCellModel.h"
#import "SummonerSkillModel.h"

@implementation SummonerCellModel

- (instancetype)initWithArray:(NSArray *)array AndTitle:(NSString *)title{
    if (self = [super init]) {
        if (array.count) {
//            SummonerSkillModel * model1 = array[0];
//            SummonerSkillModel * model2 = array[1];
//            SummonerSkillModel * model3 = array[2];
//            SummonerSkillModel * model4 = array[3];
//            

//            self.firstIcon = model1.icon;
//            self.firstDesc = model1.desc;
//            
//            self.secIcon = model2.icon;
//            self.secDesc = model2.desc;
//            
//            self.thirdIcon = model3.icon;
//            self.thireDesc = model3.desc;
//            
//            self.fourthDesc = model4.desc;
//            self.fourthIcon = model4.icon;
//
            self.title = title;
            NSArray * iconArray = @[@"firstIcon",@"secIcon",@"thirdIcon",@"fourthIcon"];
            NSArray * descArray =@[@"firstDesc",@"secDesc",@"thireDesc",@"fourthDesc"];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SummonerSkillModel * model = obj;
                [self setValue:model.icon forKey:iconArray[idx]];
                [self setValue:model.desc forKey:descArray[idx]];
            }];
        }
    }
    return self;
}
@end
