//
//  HeroDetailCellModel.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroDetailCellModel.h"

@implementation HeroDetailCellModel


- (instancetype)initWitthFirstHero:(HeroDetailModel *)firstHero andSecHero:(HeroDetailModel *)secHero {
    if (self = [super init]) {
        
        self.firstHeroImg  = firstHero.img;
        self.secondHeroImg = secHero.img;
        self.firstHeroDesc = firstHero.desc;
        self.secondHeroDesc = secHero.desc;
    }
    return self;
}


- (instancetype)initWithArray:(NSArray *)array {
    
    self.firstModel = [array firstObject];
    self.secondModel = [array lastObject];
    
    return [self initWitthFirstHero:self.firstModel andSecHero:self.secondModel];
}
@end
