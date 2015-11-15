//
//  DesignDisplayView.m
//  GuyubinUIExam
//
//  Created by 古玉彬 on 15/10/31.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import "DesignDisplayView.h"

@interface DesignDisplayView (){
    UILabel *_descpitionLabel; //描述label
    
}

@end

@implementation DesignDisplayView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-20)];
        [self addSubview:self.bgImageView];
        
        _descpitionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        _descpitionLabel.numberOfLines = 1;
        //透明度
//        _descpitionLabel.backgroundColor = [UIColor colorWithRed:0.33 green:0.33 blue:0.33 alpha:0.3];
        [_descpitionLabel setBackgroundColor:[UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f]];
        //字体颜色
//        [_descpitionLabel setTextColor:[UIColor whiteColor]];
        //字体大小
        [_descpitionLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_descpitionLabel];
    }
    return self;
}



- (void)setPicDesription:(NSString *)picDesription {
    _descpitionLabel.text =picDesription;
}
@end
