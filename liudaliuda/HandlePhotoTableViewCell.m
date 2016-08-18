//
//  HandlePhotoTableViewCell.m
//  liudaliuda
//
//  Created by lijiehu on 16/8/17.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "HandlePhotoTableViewCell.h"

@implementation HandlePhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withFrame:(float)width{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:237/255.0 alpha:1];
//        textView
        self.content = [[UITextView alloc]initWithFrame:CGRectMake(5, 15, width -10, 300)];
        self.content.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:237/255.0 alpha:1];
        
        [self addSubview:self.content];

        self.content.delegate = self;
     
        
        //        图片
        self.contentIMG = [[UIButton alloc]initWithFrame:CGRectMake((width-30)/2, self.content.frame.size.height+self.content.frame.origin.y + 20,30, 30)];
        [_contentIMG setBackgroundImage:[UIImage imageNamed:@"camera.png"]  forState:UIControlStateNormal] ;
//        CGSize imgSize =   _contentIMG.image.size;
//        self.contentIMG.frame = CGRectMake(5, self.content.frame.size.height+self.content.frame.origin.y + 10, width - 10, imgSize.height*width/imgSize.width);
        self.contentIMG.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.contentIMG];
        
        //时间标签
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width - 200, self.contentIMG.frame.size.height + self.contentIMG.frame.origin.y + 16, 180, 14)];
        self.timeLabel.text = @"记于 2016.2.2 16：40";
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:14];
        [self.timeLabel setFont:font];
        [self.timeLabel setTextColor:[UIColor colorWithRed:193.0/255.0 green:192/255.0 blue:188/255.0 alpha:1.0]];
        CGSize size = CGSizeMake(320,14); //设置一个行高上限
        
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.timeLabel.font, NSFontAttributeName,nil];
        size =[self.timeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        
        self.timeLabel.numberOfLines = 0;//表示label可以多行显示
        
        self.timeLabel.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
        
        self.timeLabel.frame = CGRectMake(width - size.width-10, self.contentIMG.frame.size.height + self.contentIMG.frame.origin.y + 16, size.width, size.height);
        
        
        [self addSubview:self.timeLabel];
        //添加按钮
        self.addButton = [[UIButton alloc]initWithFrame:CGRectMake(width/2 - 40, self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + 20, 80, 80)];
        self.addButton.alpha = 0;
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addCell:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
//        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(5, self.addButton.frame.size.height+self.addButton.frame.origin.y+5, self.bounds.size.width - 10, self.frame.size.height - 50)];
        
    }
    return self;
}
//关闭收起UITextView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.content resignFirstResponder];
    
    
    
}
//点击事件
-(void)addCell:(UIButton *)sender{
    if (self.btnClick) {
        self.btnClick();
    }
}
-(CGFloat)getHeight{
    CGFloat h = self.addButton.frame.origin.y + self.addButton.frame.size.height + 10 ;
    return h;
}
@end
