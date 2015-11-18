//
//  HeroSkillViewCell.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/17.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroSkillViewCell.h"
#import "SkillModel.h"

@interface HeroSkillViewCell ()
@property (assign, nonatomic) NSInteger currentPic; //当前选中的图片
@end
@implementation HeroSkillViewCell

- (void)awakeFromNib {
    
    //绑定图片tap事件
    for (int i = 0; i < 5; i++) {
        //技能图片
        UIImageView * imageView = (UIImageView *)[self viewWithTag:10 + i];
        //手势可点击
        imageView.userInteractionEnabled  = YES;
        imageView.layer.borderWidth = 3;
        [imageView.layer setBorderColor:[UIColor clearColor].CGColor];
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouch:)]];
    }
}

//技能图片点击
- (void)tapTouch:(UITapGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
    }SkillModel * model = self.dataArray[gesture.view.tag - 10];
    if (model) {
        self.skillName.text = model.name;
        self.skillDesc.text = model.desc;
        
        //保存当前点击图片
        self.currentPic = gesture.view.tag - 10;
        
        if ([self.delegate respondsToSelector:@selector(reloadCellByCell:)]) {
            
            //调用代理刷新表格
            [self.delegate reloadCellByCell:self];
        }
    }
    
}

//设置选中view边框。颜色
- (void)setPicState:(UIImageView *)view {
    for (int i = 0; i < 5; i++) {
        //技能图片
        UIImageView * imageView = (UIImageView *)[self viewWithTag:10 + i];
        if (view == imageView) {
            imageView.layer.borderColor = [UIColor blueColor].CGColor;
        }else{
            imageView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//赋值
- (void)setDataArray:(NSArray *)dataArray {
    if (_dataArray) {
        _dataArray = nil;
    }
    
    if (!dataArray.count) {
        return;
    }
    
    //交换第一个和最后一个数据(默认技能放在在后。但需要在最前面显示)
    NSMutableArray * tempArray = [dataArray mutableCopy];
    [tempArray insertObject:tempArray.lastObject atIndex:0];
    [tempArray removeObjectAtIndex:tempArray.count - 1];
    _dataArray = tempArray;
    
    //赋值数据
    for (int i = 0; i < self.dataArray.count; i++) {
        SkillModel * model = self.dataArray[i];
        if (model) {
            if (i == 0) {
                self.currentPic = model.currentSelectedPicIndex; //当前选中行
            }
            if (i == self.currentPic) { //第一个数据
                self.skillName.text = model.name;
                self.skillDesc.text = model.desc;
            }
            //技能图片
            UIImageView * imageView = (UIImageView *)[self viewWithTag:10 + i];
            [imageView setImageWithURL:[NSURL URLWithString:model.img]];
        }
        
    }
    
}

- (void)setCurrentPic:(NSInteger)currentPic {
    _currentPic = currentPic;
    //设置选中颜色
    [self setPicState:(UIImageView *)[self viewWithTag:10 + _currentPic]];
}

//单元格高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    CGSize size = [self.skillDesc.text boundingRectWithSize:CGSizeMake(width - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.skillDesc.font} context:nil].size;
    return size.height + CGRectGetMaxY(self.skillName.frame)+ 28;
}

@end
