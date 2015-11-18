//
//  HeroInfoCell.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroInfoCell.h"

@implementation HeroInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//单元格高度
- (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    CGSize size = [self.desc.text boundingRectWithSize:CGSizeMake(width - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.desc.font} context:nil].size;
    return size.height + CGRectGetMaxY(self.title.frame) + 28;
}

@end
