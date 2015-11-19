//
//  SummonerSkillCell.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/19.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "SummonerSkillCell.h"
#import "SummonerSkillModel.h"
#import "SummonerCellModel.h"

@interface SummonerSkillCell()

//数据源
@property (copy, nonatomic) NSArray * dataArry;
@end

@implementation SummonerSkillCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //添加手势
        [self.firstImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
        [self.secImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
        [self.thirdImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
        [self.fourthImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createLayout{
    [super createLayout];
    
    self.thirdImg = [[UIImageView alloc] init];
    self.thirdImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.thirdImg];
    
    self.thirdDesc = [[UILabel alloc] init];
    self.thirdDesc.numberOfLines = 0;
    [self.thirdDesc setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.thirdDesc];
    
    self.fourthImg = [[UIImageView alloc] init];
    self.fourthImg.userInteractionEnabled = YES;
    [self.contentView addSubview:self.fourthImg];
    
    
    self.fourthDesc = [[UILabel alloc] init];
    [self.fourthDesc setNumberOfLines:0];
    [self.fourthDesc setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.fourthDesc];
    
    //设置tag
    self.firstImg.tag = 10 + 0;
    self.firstDesc.tag = 100 + 0;
    
    self.secImg.tag = 10 + 1;
    self.secDesc.tag = 100 + 1;
    
    self.thirdImg.tag = 10 + 2;
    self.thirdDesc.tag = 100 + 2;
    
    self.fourthImg.tag = 10 + 3;
    self.fourthDesc.tag = 100 + 3;
    
}

- (void)setModel:(id)idModel {
    
    SummonerCellModel * model = idModel;
    self.title.text = model.title;
    [self.firstImg setImageWithURL:[NSURL URLWithString:model.firstIcon]];
    self.firstDesc.text = model.firstDesc;
    
    self.secDesc.text = model.secDesc;
    [self.secImg setImageWithURL:[NSURL URLWithString:model.secIcon]];
    
    self.thirdDesc.text = model.thireDesc;
    [self.thirdImg setImageWithURL:[NSURL URLWithString:model.thirdIcon]];
    
    self.fourthDesc.text = model.fourthDesc;
    [self.fourthImg setImageWithURL:[NSURL URLWithString:model.fourthIcon]];
    
    //布局
    [self setPositon];
}

- (void)setDataArray:(NSArray *)arr{
    self.dataArry = arr;
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SummonerSkillModel * model = obj;
        UIImageView * view = (UIImageView *)[self.contentView viewWithTag:10 + idx];
        UILabel * label = (UILabel *)[self. contentView viewWithTag:100 + idx];
        [view setImageWithURL:[NSURL URLWithString:model.icon]];
        [label setText:model.desc];
    }];
    
    //布局
    [self setPositon];
}

- (void)setPositon {
    
    [super setPositon];
    
    CGFloat width = self.secDesc.frame.size.width;
    
    CGRect maxSecRect = [self maxHeight:self.secDesc.frame andRect:self.secImg.frame];
    
    CGRect thirdDescFrame = CGRectMake(self.secDesc.frame.origin.x, CGRectGetMaxY(maxSecRect) + 10 , width,[self sizeofLabel:width WithText:self.thirdDesc.text andFont:self.thirdDesc.font]);
    self.thirdDesc.frame = thirdDescFrame;
    
    CGRect thireImgFrame = CGRectMake(self.secImg.frame.origin.x, thirdDescFrame.origin.y, self.secImg.frame.size.width, self.secImg.frame.size.height);
    self.thirdImg.frame = thireImgFrame;
    
    
    CGRect maxThirdFrame = [self maxHeight:self.thirdDesc.frame andRect:self.thirdImg.frame];
    
    CGRect fourthDescFrame = CGRectMake(self.thirdDesc.frame.origin.x, CGRectGetMaxY(maxThirdFrame) + 10, width, [self sizeofLabel:width WithText:self.fourthDesc.text andFont:self.fourthDesc.font]);
    self.fourthDesc.frame = fourthDescFrame;
    
    CGRect fourthImgFrame = CGRectMake(self.secImg.frame.origin.x, self.fourthDesc.frame.origin.y, self.thirdImg.frame.size.width, self.thirdImg.frame.size.height);
    
    self.fourthImg.frame = fourthImgFrame;
}

- (void)imgTouch:(UITapGestureRecognizer *)gesuture {
    
}

- (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    
    NSArray * iconArray = @[@"firstImg",@"secImg",@"thirdImg",@"fourthImg"];
    NSArray * descArray = @[@"firstDesc",@"secDesc",@"thirdDesc",@"fourthDesc"];
    
    // 判断最后一个不为空的控件
    for (NSInteger i = iconArray.count - 1; i >= 0; i--) {
        if ([(UILabel *)[self valueForKey:descArray[i]] text].length) {
            return CGRectGetMaxY([self maxHeight:[[self valueForKey:descArray[i]] frame] andRect:[[self valueForKey:iconArray[i]] frame]]);
        }
    }
    
    return 0;
    
}

//控件最大宽度
- (CGRect)maxHeight:(CGRect)rect1 andRect:(CGRect)rect2 {
    
    
    return CGRectGetMaxY(rect1) > CGRectGetMaxY(rect2) ? rect1 : rect2;
}

//动态获取高度
- (CGFloat)sizeofLabel:(CGFloat)width WithText:(NSString *)text andFont:(UIFont *)font{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.height;
}
@end
