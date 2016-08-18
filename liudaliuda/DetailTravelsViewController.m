//
//  DetailTravelsViewController.m
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "DetailTravelsViewController.h"
#import "detailTableViewCell.h"
@interface DetailTravelsViewController ()

@end

@implementation DetailTravelsViewController
   
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    
    
   
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    
    [self.tableView setDataSource:self];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark UItableViewDelegate method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSString *tag = @"tag";
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
        
        //    if (cell == nil) {
        //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
        //
        //    }
//        GPSPoints *gps = [listData objectAtIndex:indexPath.row];
        ////
        NSDictionary *dic = @{@"userIcon":@"8.pic.jpg",@"contentIMG":@"1.pic.jpg",@"title":@"南京一日游",@"time":@"2016-8-9 8:00"};
        detailTableViewCell *cell = [[detailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
        //    [cell setFrame:cell.frame];
        //    cell.textLabel.text = @"I love 泰迪";
        [self setFrame:cell.frame];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width, 260)];
        [cell setdata:dic];
        
        NSLog(@"%f",self.view.frame.size.width);
        return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setFrame:(CGRect)frame {
    
    frame.size.width = self.view.frame.size.width;
    //    [super setFrame:frame];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
