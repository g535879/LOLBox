//
//  NewsViewCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsShortTitle;

@end
