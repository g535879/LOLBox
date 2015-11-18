//
//  HeroPorAViewCell.m
//  LOLBox
//
//  Created by 古玉彬 on 15/11/18.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "HeroPorAViewCell.h"

#define MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HeroPorAViewCell()

@property (strong, nonatomic) HeroDetailCellModel * myModel;
@end
@implementation HeroPorAViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createLayout];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setModel:(HeroDetailCellModel *)model {
    
    self.myModel = model;
    
    [self.firstImg setImageWithURL:[NSURL URLWithString:model.firstHeroImg]];
    [self.secImg setImageWithURL:[NSURL URLWithString:model.secondHeroImg]];
    [self.firstDesc setText:model.firstHeroDesc];
    [self.secDesc setText:model.secondHeroDesc];
    self.title.text = model.title;
    
    [self setPositon];
}

- (void)createLayout {
    
    UIImageView * logoImageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 15, 15)];
    logoImageview.image = [UIImage imageNamed:@"hero_blue_icon.png"];
    [self.contentView addSubview:logoImageview];
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 200, 21)];
    [self.title setFont:[UIFont systemFontOfSize:17]];
    
    [self.contentView addSubview:self.title];
    
    
    self.firstImg = [[UIImageView alloc] init];
    self.firstImg.frame = CGRectMake(25, 31, 40, 40);
    self.firstImg.userInteractionEnabled = YES;
    //添加手势
    [self.firstImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
    [self.contentView addSubview:self.firstImg];
    
    self.firstDesc = [[UILabel alloc] init];
    self.firstDesc.numberOfLines = 0;
    [self.firstDesc setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.firstDesc];
    
    self.secImg = [[UIImageView alloc] init];
    self.secImg.userInteractionEnabled = YES;
    //添加手势
    [self.secImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTouch:)]];
    [self.contentView addSubview:self.secImg];
    
    
    self.secDesc = [[UILabel alloc] init];
    [self.secDesc setNumberOfLines:0];
    [self.secDesc setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:self.secDesc];
    
}

- (void)setPositon {

    CGRect firstImgFrame = self.firstImg.frame;
    
    CGFloat width = MAX_WIDTH - firstImgFrame.size.width - 50;
    
    CGRect firstDexc = CGRectMake(CGRectGetMaxX(firstImgFrame)+ 5, firstImgFrame.origin.y, width,[self sizeofLabel:width WithText:self.firstDesc.text andFont:self.firstDesc.font]);
        self.firstDesc.frame = firstDexc;
    
    
    CGRect secondImgFrame = CGRectMake(firstImgFrame.origin.x, CGRectGetMaxY(firstDexc)+10, firstImgFrame.size.width, firstImgFrame.size.height);
    
    self.secImg.frame = secondImgFrame;
    
    CGRect secondDescFrame = CGRectMake(firstDexc.origin.x, CGRectGetMaxY(firstDexc)+10, width, [self sizeofLabel:width WithText:self.secDesc.text andFont:self.secDesc.font]);
    
    self.secDesc.frame = secondDescFrame;
}


- (CGFloat)heightOfCellWithWidth:(CGFloat)width {
    
   
    
    return CGRectGetMaxY(self.secDesc.frame) +20;
}

//手势点击
- (void)imgTouch:(UITapGestureRecognizer *)gesture {
    NSString * hId;
    NSString * heroTitle;
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //判断点击图片是img1还是2
        if (gesture.view == self.firstImg) {
            hId = self.myModel.firstModel.heroId;
            heroTitle = self.myModel.firstModel.title;
            
        }else if (gesture.view == self.secImg){
            hId = self.myModel.secondModel.heroId;
            heroTitle = self.myModel.secondModel.title;
        }
        //执行代理方法
        if ([self.delegate respondsToSelector:@selector(pushHeroPageByHeroId:andTitle:)]) {
            [self.delegate pushHeroPageByHeroId:hId andTitle:heroTitle];
        }
    }
}

//动态获取高度
- (CGFloat)sizeofLabel:(CGFloat)width WithText:(NSString *)text andFont:(UIFont *)font{
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
