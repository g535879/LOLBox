//
//  HeroSkillViewCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/17.
//  Copyright © 2015年 guyubin. All rights reserved.
//英雄技能cell


#import <UIKit/UIKit.h>


@protocol ReloadCell <NSObject>
/**
 刷新单元格
 */
- (void)reloadCellByCell:(UITableViewCell *)cell;

@end

@interface HeroSkillViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *skillDefault;
@property (weak, nonatomic) IBOutlet UIImageView *skillQ;
@property (weak, nonatomic) IBOutlet UIImageView *skillW;
@property (weak, nonatomic) IBOutlet UIImageView *skillE;
@property (weak, nonatomic) IBOutlet UIImageView *skillR;
@property (weak, nonatomic) IBOutlet UILabel *skillName;
@property (weak, nonatomic) IBOutlet UILabel *skillDesc;
@property (copy, nonatomic) NSArray * dataArray;//数据源

@property (assign, nonatomic, readonly) NSInteger currentPic; //当前选中的图片

@property (assign, nonatomic) id<ReloadCell> delegate; //代理。刷新表格

//单元格高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width;
@end





