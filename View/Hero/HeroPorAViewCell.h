//
//  HeroPorAViewCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
// 

#import <UIKit/UIKit.h>

#import "HeroDetailCellModel.h"

@protocol PushHeroPage <NSObject>

//跳转
- (void)pushHeroPageByHeroId:(NSString *)hId andTitle:(NSString *)title;

@end
@interface HeroPorAViewCell : UITableViewCell

@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UIImageView *firstImg;
@property (strong, nonatomic)  UIImageView *secImg;
@property (strong, nonatomic)  UILabel *firstDesc;
@property (strong, nonatomic)  UILabel *secDesc;

@property (assign, nonatomic) id<PushHeroPage> delegate;

//设置模型
- (void)setModel:(id)idModel;

//布局
- (void)createLayout;

//设置控件位置
- (void)setPositon;

//单元格高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width;

@end
