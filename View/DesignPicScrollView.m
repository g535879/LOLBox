//
//  DesignPicScrollView.m
//  GuyubinUIExam
//
//  Created by 古玉彬 on 15/10/31.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "DesignPicScrollView.h"
#import "DesignDisplayView.h"
#import "ScroModel.h"
#import "SDWebImageCompat.h"
#import "NSString+URLEncoding.h"

@interface DesignPicScrollView ()<UIScrollViewDelegate> {
    
    DesignDisplayView *_leftImageView; //左侧视图
    DesignDisplayView *_centerImageView; //中间视图
    DesignDisplayView *_rightImageView; //右侧视图
    UIPageControl *_pageController; //小白点
    CGFloat _viewHeight; //容器宽度
    CGFloat _viewWidth; //容器宽度
    NSTimer *_autoRunTimer; //自动滚动计时器
}

@property (assign,nonatomic) BOOL AutoRun; //是否自动滚动
@end

@implementation DesignPicScrollView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _viewHeight = frame.size.height;
        _viewWidth = frame.size.width;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(_viewWidth * 3, _viewHeight-64);
        self.contentOffset = CGPointMake(_viewWidth, 0);
        self.pagingEnabled = YES;
        self.delegate = self;
        [self setDatailLayout]; //设置布局

    }
    return self;
}



//赋值数据
- (void)setImageModelArray:(NSArray *)imageModelArray {
    _imageModelArray = imageModelArray;
    _pageController.numberOfPages = imageModelArray.count;
    self.AutoRun = self.AutoScroll;
    [self initDisplay]; //初始化显示
}
//布局
- (void)setDatailLayout {
    
    //imageView
    _leftImageView = [[DesignDisplayView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight)];
    [_leftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)]];
    [self addSubview:_leftImageView];
    _centerImageView =[[DesignDisplayView alloc] initWithFrame:CGRectMake(_viewWidth, 0, _viewWidth, _viewHeight)];
    [_centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)]];
    [self addSubview:_centerImageView];
    //rightImageView
    _rightImageView = [[DesignDisplayView alloc]initWithFrame:CGRectMake(_viewWidth * 2, 0, _viewWidth, _viewHeight)];
    [_rightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)]];
    [self addSubview:_rightImageView];
    
    //pageControll
    _pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(_viewWidth, _viewHeight-32, _viewWidth, 32)];
    //[self addSubview:_pageController];
}

//初始化显示样式
- (void)initDisplay {
    [self updatePicByIndex:0];
    _pageController.currentPage = 0; //当前页
}

//修改当前显示的图片
-(void)updatePicByIndex:(NSInteger)picIndex {
    
    ScroModel *leftPicModel = self.imageModelArray[[self calIndex:picIndex - 1]];
    ScroModel *centerPicModel = self.imageModelArray[[self calIndex:picIndex]];
    ScroModel *rightPicModel = self.imageModelArray[[self calIndex:picIndex + 1]];
    
    //更新左侧视图
    [self updateImage:_leftImageView withScroModel:leftPicModel];
    //中间视图
    [self updateImage:_centerImageView withScroModel:centerPicModel];
    //右侧视图
    [self updateImage:_rightImageView withScroModel:rightPicModel];

}

//计算图片下标
- (NSInteger)calIndex:(NSInteger) picIndex {
    
    return (picIndex + self.imageModelArray.count) % self.imageModelArray.count;
}

//更新自定义视图图片和文字描述
- (void)updateImage:(DesignDisplayView *)view withScroModel:(ScroModel *)model {
    [view.bgImageView setImageWithURL:[NSURL URLWithString:[model.ban_img URLDecodedString]]];
    view.picDesription = model.name;
}


//是否自动滚动
- (void)setAutoRun:(BOOL)isAutoRun {
    if (isAutoRun) {
        if (!_autoRunTimer) {
            _autoRunTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(autoRunPic) userInfo:nil repeats:YES];
        }else{
            [_autoRunTimer setFireDate:[NSDate distantPast]]; //开启定时器
        }
    }else{
        if (_autoRunTimer) {
            [_autoRunTimer setFireDate:[NSDate distantFuture]]; //暂停
        }
    }
}

#pragma mark - 滚动视图协议代理
//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_autoRunTimer setFireDate:[NSDate distantFuture]]; //暂停
    CGPoint point = scrollView.contentOffset;
    //偏移量太小。不修改
    if (fabs(point.x - _viewWidth) < _viewWidth/2) {
        return;
    }
    if (point.x > _viewWidth) { //往右滑
        self.picIndex = [self calIndex:self.picIndex+1];
    }
    else{
        self.picIndex = [self calIndex:self.picIndex-1];
    }
    
    //更新UI
    [self updatePicByIndex:self.picIndex];
    
    //设置偏移量
    self.contentOffset = CGPointMake(_viewWidth, 0);
    
    //设置分页
    _pageController.currentPage = self.picIndex;
    
    if (self.AutoRun) {
        [_autoRunTimer setFireDate:[NSDate distantPast]]; //开启
    }
}


//自动滚动代码
- (void)autoRunPic {

    static float offsetX = 0;
    //设置偏移量
    [UIView animateWithDuration:0.01 animations:^{
        self.contentOffset = CGPointMake(_viewWidth+offsetX, 0);
    } completion:^(BOOL finished) {
        
        if (offsetX >= _viewWidth) {
            self.picIndex = [self calIndex:++self.picIndex];
            [self updatePicByIndex:self.picIndex];
            _pageController.currentPage = self.picIndex;
            self.contentOffset = CGPointMake(_viewWidth, 0);
            offsetX = 0;
            [_autoRunTimer setFireDate:[NSDate distantFuture]]; //暂停
            [_autoRunTimer performSelector:@selector(setFireDate:) withObject:[NSDate distantPast] afterDelay:3.0f];//开启定时器
        }
    }];
    offsetX+=10;
}


//图片点击事件
- (void)picTap:(UITapGestureRecognizer *)gesture {
    
    if ([self.returnDelegate respondsToSelector:@selector(tapPicIndexID:)]) {
        ScroModel * model = self.imageModelArray[self.picIndex];
        
        [self.returnDelegate tapPicIndexID:model.article_id];
    }
}

- (void)dealloc {
    
    //删除定时器
    if (_autoRunTimer) {
        [_autoRunTimer invalidate];
    }
}
@end
