//
//  ScroModel.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/13.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScroModel : NSObject
/**
 id
 */
@property (copy, nonatomic) NSString * article_id;
/**
 图片
 */
@property (copy, nonatomic) NSString * ban_img;
/**
 评论数
 */
@property (copy, nonatomic) NSString * comment_count;
/**
 图片名
 */
@property (copy, nonatomic) NSString * name;
@end
