//
//  NewsModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/13.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
/**
    评论数
 */
@property (copy, nonatomic) NSString * comment_count;
/**
 图片
 */
@property (copy, nonatomic) NSString * icon;
/**
 图片id
 */
@property (copy, nonatomic) NSString * iconId;
/**
 短标题
 */
@property (copy, nonatomic) NSString * shortTitle;
/**
 资源
 */
@property (copy, nonatomic) NSString * source;
/**
 标题
 */
@property (copy, nonatomic) NSString * title;

@end
