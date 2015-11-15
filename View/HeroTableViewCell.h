//
//  HeroTableViewCell.h
//  LOLBox
//
//  Created by 古玉彬 on 15/11/14.
//  Copyright © 2015年 guyubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *tags;

@end
