//
//  ListOfTracesViewController.m
//  liudaliuda
//
//  Created by iMac OS on 16/8/5.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "ListOfTracesViewController.h"
#import "GPSPoints.h"
#import "MainViewController.h"
#import "ListOfTracesCell.h"
#import "DetailTravelsViewController.h"
@interface ListOfTracesViewController (){
    UITableView *tableview ;
}

@end

@implementation ListOfTracesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    listData = [[NSMutableArray alloc]init];

    [self createCoreDataContent];
    [self readData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return [listData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.width/1.875 + 16;
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//   }
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tag = @"tag";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tag];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
//        
//    }
      GPSPoints *gps = [listData objectAtIndex:indexPath.row];
    ////
    NSDictionary *dic = @{@"userIcon":@"8.pic.jpg",@"contentIMG":@"1.pic.jpg",@"title":@"南京一日游"};
    ListOfTracesCell *cell = [[ListOfTracesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
  //    [cell setFrame:cell.frame];
//    cell.textLabel.text = @"I love 泰迪";
    [self setFrame:cell.frame];
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width, 260)];
    [cell setdata:dic];

     NSLog(@"%f",self.view.frame.size.width);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    int x = indexPath.row;
    NSLog(@"%ld",(long)indexPath.row);
    GPSPoints *gps = [listData objectAtIndex:indexPath.row];
    MainViewController *mvc = [[MainViewController alloc]init];
    mvc.gps = gps;
    
//    [self.navigationController pushViewController:mvc animated:YES];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailTravelsViewController *dvc = [[DetailTravelsViewController alloc]init];
    [self.navigationController pushViewController:dvc animated:YES];
    
}

//CoreData相关操作

-(void)createCoreDataContent{
    //创建数据库文件的路径
    //        NSString *path = [NSHomeDirectory() stringByAppendingString:@"Doucments/ImortData"];
    //        NSFileManager *manager = [NSFileManager defaultManager];
    //        if (![manager fileExistsAtPath:path]) {
    //            [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //        }
    //
    
    //documet目录下
    NSString *doc  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"/GPSPoints"];//注意不是:stringByAppendingString
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"-----------------------------------");
    NSLog(@"data : %@",path);
    
    //创建文件,并且打开数据库文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //给存储器指定存储的类型
    NSError *error;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) {
        [NSException raise:@"添加数据库错误" format:@"%@",[error localizedDescription]];
    }
    
    //创建图形上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;
    self.managedContext = context;
}

//读取数据库文件
- (void)readData{
    NSLog(@"读取数据");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 初始化一个查询请求
        //  NSFetchRequest *request = [[NSFetchRequest alloc] init];
        // 设置要查询的实体
        // request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedContext];
        
        //以上代码简写成下边
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GPSPoints"];
        
        // 设置排序（按照age降序）
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
        request.sortDescriptors = [NSArray arrayWithObject:sort];
        // 设置条件过滤(搜索name中包含字符串"zhang"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*zhang*)
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*zhang*"];
        // request.predicate = predicate;
        
        // 执行请求
        NSError *error = nil;
        NSArray *objs = [self.managedContext executeFetchRequest:request error:&error];
        [listData addObjectsFromArray:objs];
        [tableview reloadData];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        
        NSLog(@"-----------------------------------");
        // 遍历数据
        for (NSManagedObject *obj in objs) {
            NSLog(@"---name=%@", [obj valueForKey:@"latitude"]);
        }
//        NSLog(@"%d----------------------------------------------------------|||||||||||",index);
        for (GPSPoints *gps in objs) {
            //            Book *book = stu.book;
            NSLog(@"%lu",[gps.location count]);
            
            //            NSLog(@"%@")
            NSArray *array = gps.location;
            
//            for (CLLocation *loc in array) {
//                
//                //                NSLog(@"%@",loc.coordinate);
//                NSLog(@"%f",loc.coordinate.longitude);
//            }
            //
        }
        
        
    });
}


- (void)setFrame:(CGRect)frame {
    
    frame.size.width = self.view.frame.size.width;
//    [super setFrame:frame];
    
}

@end
