//
//  HeroInfoCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
// 通用英雄描述

#import <UIKit/UIKit.h>

@interface HeroInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *desc;

//单元格高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width;
@end
