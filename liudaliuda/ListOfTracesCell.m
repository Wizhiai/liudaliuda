//
//  ListOfTracesCell.m
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "ListOfTracesCell.h"

@implementation ListOfTracesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
     
        self.userIcon.layer.cornerRadius = 15;
        self.userIcon.contentMode= UIViewContentModeScaleAspectFit;
//                        [self addSubview:self.userIcon];
        
      
     

    }
    return self;
}

-(void)setdata:(NSDictionary *)dic{
//    NSLog(@"%f",self.window.frame.size.width);
    UIView *contentView =[[UIView alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width -16, self.frame.size.width/1.875)];
    contentView.backgroundColor = [UIColor purpleColor];
    
     self.userIcon = [[UIButton alloc]initWithFrame:CGRectMake(18, contentView.frame.size.height - 50, 30, 30)];
    self.userIcon.layer.cornerRadius = self.userIcon.frame.size.height/2;
    self.userIcon.clipsToBounds = YES;
       [self.userIcon setImage:[UIImage imageNamed:[dic valueForKey:@"userIcon"]] forState:UIControlStateNormal];
    
    self.contentIMG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height) ];
                self.contentIMG.image =    [UIImage imageNamed:[dic valueForKey:@"contentIMG"]];
//    self.contentIMG.frame = self.frame;
    
    self.contentIMG.contentMode = UIViewContentModeScaleToFill;
    self.contentIMG.clipsToBounds = YES;
    NSString *s =[dic valueForKey:@"title"];
    //
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, self.frame.size.width - 36, 30)];
    self.title.backgroundColor = [UIColor clearColor];
    [self.title setTextColor:[UIColor whiteColor]];
    self.title.text =[dic valueForKey:@"title"];
    
    NSString *labelString = [dic valueForKey:@"title"];
    
     UIFont *font = [UIFont fontWithName:@"Arial" size:21];//11 一定要跟label的显示字体大小一致
    
    [self.title setFont:font];
    //标题设置
//    1、UILabel内容自动换行
    
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.title.font, NSFontAttributeName,nil];
    size =[labelString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    self.title.numberOfLines = 0;//表示label可以多行显示
    
    self.title.lineBreakMode = NSLineBreakByCharWrapping;//换行模式，与上面的计算保持一致。
    
    self.title.frame = CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y, self.frame.size.width -36, size.height);//保持原来Label的位置和宽度，只是改变高度。
    

    //地点
    UILabel *locationLable = [[UILabel alloc]initWithFrame:CGRectMake(28, self.title.frame.origin.y+self.title.frame.size.height+8, self.frame.size.width - 20, 12)];
    locationLable.text = @"中国日本省";
    [locationLable setFont:[UIFont fontWithName:@"Arial" size:13]];
    [locationLable setTextColor:[UIColor whiteColor]];
    //距离
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(locationLable.frame.origin.x,locationLable.frame.origin.y + locationLable.frame.size.height+8,46, locationLable.frame.size.height)];
     [distanceLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    distanceLabel.text = @"89KM";
     CGSize sizeLinelabel = CGSizeMake(320,locationLable.frame.size.height);
    NSDictionary * tdicLineLabel = [NSDictionary dictionaryWithObjectsAndKeys:distanceLabel.font, NSFontAttributeName,nil];

     sizeLinelabel =[ distanceLabel.text boundingRectWithSize:sizeLinelabel options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdicLineLabel context:nil].size;
    [distanceLabel setFrame:CGRectMake(distanceLabel.frame.origin.x, distanceLabel.frame.origin.y, sizeLinelabel.width, sizeLinelabel.height)];
      [distanceLabel setTextColor:[UIColor whiteColor]];
    
    //时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(6+distanceLabel.frame.origin.x + distanceLabel.frame.size.width,distanceLabel.frame.origin.y ,self.frame.size.width - distanceLabel.frame.size.width - distanceLabel.frame.origin.x, distanceLabel.frame.size.height)];
    timeLabel.text = @"历时3天";
    [timeLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
  [timeLabel setTextColor:[UIColor whiteColor]];
    
    //竖线
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, self.title.frame.origin.y+self.title.frame.size.height + 6, 4, locationLable.frame.size.height +12 + distanceLabel.frame.size.height )];
    lineLabel.backgroundColor = [UIColor colorWithRed:88/255.0 green:206/255.0 blue:207/255.0 alpha:1];
    lineLabel.layer.cornerRadius = 2;
    lineLabel.clipsToBounds = YES;
    
    //用户名
    
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(self.userIcon.frame.origin.x + self.userIcon.frame.size.width + 6, self.userIcon.frame.origin.y + 7, 100, 14)];
     [self.userName setFont:[UIFont fontWithName:@"Arial" size:13]];
    self.userName.text = @"胡大侠云游四海是也";
    CGSize sizeUserNamelabel = CGSizeMake(320,   self.userName.frame.size.height);
    NSDictionary * tdicUserNameLabel = [NSDictionary dictionaryWithObjectsAndKeys:self.userName.font, NSFontAttributeName,nil];
    
    sizeUserNamelabel =[    self.userName.text boundingRectWithSize:sizeUserNamelabel options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdicUserNameLabel context:nil].size;
    [self.userName setFrame:CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y, sizeUserNamelabel.width, sizeUserNamelabel.height)];
    [self.userName setTextColor:[UIColor whiteColor]];
    
    [contentView addSubview:self.contentIMG];
      [contentView addSubview:self.title];
    [contentView addSubview:locationLable];
    [contentView addSubview:distanceLabel];
    [contentView addSubview:timeLabel];
     [contentView addSubview:self.userIcon];
    [contentView addSubview:self.userName];
    [contentView addSubview:lineLabel]; //竖线


    [self addSubview:contentView];
    contentView.layer.cornerRadius = 8;
    contentView.clipsToBounds = YES;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
