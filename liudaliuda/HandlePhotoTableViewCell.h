//
//  HandlePhotoTableViewCell.h
//  liudaliuda
//
//  Created by lijiehu on 16/8/17.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandlePhotoTableViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic,strong) UITextView *content;
@property (nonatomic,strong) UIButton *contentIMG;
@property (nonatomic,strong) UIButton *addButton;
@property(strong,nonatomic)void(^btnClick)();
@property (nonatomic,strong) UILabel *timeLabel;
@property bool isVisible;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(float)width;
-(CGFloat)getHeight;
@end
