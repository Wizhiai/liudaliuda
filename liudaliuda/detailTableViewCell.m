//
//  detailTableViewCell.m
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "detailTableViewCell.h"

@implementation detailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

-(void)setdata:(NSDictionary *)dic{
    //    NSLog(@"%f",self.window.frame.size.width);
    UIView *contentView =[[UIView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width -10, self.frame.size.height - 5)];
    contentView.backgroundColor = [UIColor purpleColor];
//    [self.userIcon setImage:[UIImage imageNamed:[dic valueForKey:@"userIcon"]] forState:UIControlStateNormal];
    
    self.contentIMG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height) ];
    self.contentIMG.image =    [UIImage imageNamed:[dic valueForKey:@"contentIMG"]];
    //    self.contentIMG.frame = self.frame;
    
    self.contentIMG.contentMode = UIViewContentModeScaleAspectFit;
    self.contentIMG.clipsToBounds = YES;
    NSString *s =[dic valueForKey:@"title"];//test
    //
    self.time = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.frame.size.width - 20, 80)];
    self.time.backgroundColor = [UIColor whiteColor];
    self.time.text =[dic valueForKey:@"title"];
    
    NSString *content =[dic valueForKey:@"content"];//test
    //
    self.content = [[UILabel alloc]initWithFrame:CGRectMake(10, self.contentIMG.frame.size.height + self.contentIMG.frame.origin.y, self.frame.size.width - 20, 80)];
    self.content.backgroundColor = [UIColor blueColor];
    self.content.text =[dic valueForKey:@"content"];

    [contentView addSubview:self.contentIMG];
    [contentView addSubview:self.time];
    [contentView addSubview:self.content];
    [self addSubview:contentView];
    
    //       [self addSubview:self.title];
}

@end
