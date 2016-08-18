//
//  ListOfTracesCell.h
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfTracesCell : UITableViewCell
@property (nonatomic,strong) UIButton *userIcon;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *content;
@property (nonatomic,strong) UILabel *location;
@property (nonatomic,strong) UILabel *userName;
@property (nonatomic,strong) UIImageView *contentIMG;
@property NSDictionary *dic;
-(void)setdata:(NSDictionary *)dic;
- (void)setFrame:(CGRect)frame;
@end
