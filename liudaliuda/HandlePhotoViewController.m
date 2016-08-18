//
//  HandlePhotoViewController.m
//  liudaliuda
//
//  Created by lijiehu on 16/8/16.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "HandlePhotoViewController.h"
#import "HandlePhotoTableViewCell.h"
@interface HandlePhotoViewController ()

@end

@implementation HandlePhotoViewController{
    UITextView *textView;
    UIButton *submit;
    UITableView *tableview;
    UIView *topView;
    int i;
//    NSMutableArray *self.dataArray;
    NSDictionary *dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSDictionary *
    dataDic =[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"textView",@"",@"image",@"0",@"isVisible", nil];
    self.dataArray = [[NSMutableArray alloc]init];
//    [dataDic setValue:@"" forKey:@"textView"];
//    [dataDic setValue:@"" forKey:@"image"];
    [self.dataArray addObject:dataDic];
//    [self.dataArray addobj]
    [self initTopBar];
    [self initTableView];
    [self initTextView];
    self.view.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:237/255.0 alpha:1];
      tableview.backgroundColor = [UIColor colorWithRed:251/255.0 green:247/255.0 blue:237/255.0 alpha:1];
    i = 1;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTableView{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, topView.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height - topView.frame.size.height)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}
#pragma mark 初始化自定义的顶部Bar
-(void)initTopBar{
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 67)];
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithRed:88/255.0 green:206/255.0 blue:238/255.0 alpha:1];
}
-(void)initTextView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
//    tableview.tableHeaderView = headView;
    textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40,  100) ];
    textView.backgroundColor = [UIColor whiteColor];
    textView.scrollEnabled = NO;
    textView.delegate = self;
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    textView.returnKeyType = UIReturnKeyDefault;
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.textAlignment = NSTextAlignmentLeft;
    textView.dataDetectorTypes = UIDataDetectorTypeAll;//显示数据类型的连接模式
    textView.textColor = [UIColor blackColor];
    textView.text = @"请在此处输入心情";
    [headView addSubview: textView];
//    [self.view addSubview:textView];
//    submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, textView.frame.origin.y+textView.frame.size.height, 80, 80)];
//    [submit setTitle:@"确定" forState:UIControlStateNormal];
//    [submit addTarget:self action:@selector(submitText) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:submit];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return i;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        HandlePhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];

        if (cell == nil) {
            
            cell = [[HandlePhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag withFrame:self.view.frame.size.width];

    
        }
          NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    if (![[dic valueForKey:@"image"] isEqualToString:@""]) {   //如果数据中有图片
         [cell.contentIMG setBackgroundImage:[UIImage imageNamed:[dic valueForKey:@"image"]] forState:UIControlStateNormal];
        [self resetCellHeight];

    }
    NSLog( @"%@",self.dataArray);
   
//    if (cell.imageView.image) {
//           }
    
    cell.content.delegate = self;
    cell.content.returnKeyType =UIReturnKeyDone;
    
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
 cell.content.tag = indexPath.row;
    NSLog(@"%ld",(long)cell.tag);//test
 cell.content.text = [dic valueForKey:@"textView"];
    NSLog(@"%@]%@",cell.content.text,[dic valueForKey:@"textView"]);
//    [cell.addButton addTarget:self action:@selector(insertCell) forControlEvents:UIControlEventTouchUpInside];
//    __block HandlePhotoTableViewCell *cellB = cell;
    cell.btnClick = ^(){
        i++;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"",@"textView",@"",@"image" ,false,@"isVisible",nil];
//        
//        if ((indexPath.row+1) == [_dataArray count]) {   //如果是最后一个cell则直接追加至末尾
//             [self.dataArray addObject:dic];
//        }
        
        [self.dataArray insertObject:dic atIndex:indexPath.row+1];

NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        for (int cellI = 0; cellI <= indexPath.row; cellI++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellI inSection:0];
            [indexPaths addObject: indexPath];
        }
        
        
        [tableview beginUpdates];
        [tableview insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationRight];
        [tableview endUpdates];
        [tableView reloadData];
    };
    if ([[dic valueForKey:@"isVisible"] isEqualToString:@"1"]) {
        cell.addButton.alpha = 1;
    }else{
          cell.addButton.alpha = 0;
    }
    
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, [cell getHeight]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}
-(void)insertCell{
    
}


//-(IBAction)addRows:(id)sender{
//    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//    for (int i=0; i<3; i++) {
//        NSString *s = [[NSString alloc] initWithFormat:@”hello %d”,i];
//        [datas addObject:s];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//        [indexPaths addObject: indexPath];
//    }
//    [tableview beginUpdates];
//    [tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewScrollPositionNone];
//    [tableview endUpdates];
//}
////关闭收起UITextView
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//
//{
//    
//    [self.content resignFirstResponder];
//    
-(void)textViewDidChange:(UITextView *)textView
{
//    self.ViewStr=textView.text;
    
}
-(void)textViewDidEndEditing:(UITextView *)textView1{
    HandlePhotoTableViewCell *cell = (HandlePhotoTableViewCell *)textView1.superview;
//    cell.addButton.backgroundColor = [UIColor blueColor];
 
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:[self.dataArray objectAtIndex:textView1.tag]];
    [dic setValue:textView1.text forKey:@"textView"];
    
    
    if (![textView1.text isEqualToString:@""]) {
        cell.addButton.alpha = 1;

         [dic setValue: @"1" forKey:@"isVisible"];
    }
    
    
    
    NSDictionary *dicT = [[NSDictionary alloc]initWithDictionary:dic];
    
    
    
    
    [self.dataArray replaceObjectAtIndex:textView1.tag withObject:dicT];
//    if (self.dataArray.count <= (textView.tag +1)) {
//        [self.dataArray addObject:dic];
//    }

    NSLog(@"%@%ld--%ld",cell.content.text,(long)textView.tag,textView1.tag);
}

- (BOOL)textView:(UITextView *)textViewMy shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textViewMy resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)resetCellHeight{
    
}

@end
