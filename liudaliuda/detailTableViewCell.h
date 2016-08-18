//
//  detailTableViewCell.h
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *time;
@property (nonatomic,strong) UIImageView *contentIMG;
-(void)setFrame:(CGRect)frame;
-(void)setdata:(NSDictionary *)dic;
@end
