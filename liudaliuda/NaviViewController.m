//
//  NaviViewController.m
//  liudaliuda
//
//  Created by iMac OS on 16/8/3.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "NaviViewController.h"
#import "GPSPoints.h"



@interface NaviViewController ()<AMapNaviDriveViewDelegate,MAMapViewDelegate, AMapLocationManagerDelegate>
@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@property (nonatomic, strong)AMapNaviDriveView *naviDriveView;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@end

@implementation NaviViewController{
    NSMutableArray *locationArray;
    MAMultiPolyline * _polyline;
    MAPolyline *commonPlolyline ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    locationArray = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initToolBar];
    
    [self initMapView];
    
    [self configLocationManager];
    [self createCoreDataContent];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.translucent   = YES;
    self.navigationController.toolbarHidden         = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout   = NO;
        annotationView.animatesDrop     = NO;
        annotationView.draggable        = NO;
        annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
        
        return annotationView;
    }
    
    return nil;
}
//- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay{
//
//}


- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    NSMutableArray * _speedColors;
    [_speedColors addObject:[UIColor blueColor]];
    if (overlay == commonPlolyline)
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColors = _speedColors;
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
        
    }
    
    return nil;
}
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
//插入数据
- (IBAction)insertData{
    NSLog(@"插入数据");
    //    //创建模型数据模型
    //    GPSPoints *gps = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedContext];
    //    gps.time = @"张三2";
    //    student.id = @(11);
    //
    //    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedContext];
    //    book.bookID = @(121);
    //    book.bookName = @"<老人与海2>";
    //
    //    student.book = book;
    //
    //    Student *student2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedContext];
    //    student2.name = @"李四2";
    //    student2.id = @(23);
    //
    //    Book *book2 = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedContext];
    //    book2.bookID = @(242);
    //    book2.bookName = @"<飞鸟集2>";
    //
    //    student2.book = book2;
    //
    //    //保存,用 save 方法
    //    NSError *error = nil;
    //    BOOL success = [self.managedContext save:&error];
    //    if (!success) {
    //        [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
    //    }
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
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        
        NSLog(@"-----------------------------------");
        // 遍历数据
        int index = 0;
        //        for (NSManagedObject *obj in objs) {
        //            NSLog(@"%d---name=%@", index++,[obj valueForKey:@"time"]);
        //        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"%d---name=%@", index++,[obj valueForKey:@"latitude"]);
        }
        NSLog(@"%d----------------------------------------------------------|||||||||||",index);
        //        for (GPSPoints *gps in objs) {
        ////            Book *book = stu.book;
        //            NSLog(@"%@---name=", gps.time);
        //        }
        
        
        
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNaviDriveView{
    if (self.naviDriveView == nil) {
        self.naviDriveView = [[AMapNaviDriveView alloc]initWithFrame:self.view.bounds];
        self.naviDriveView.delegate = self;
    }
}

-(void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager{
    //将naviDriveView添加到AMapNaviDriveManager中
    [self.driveManager addDataRepresentative:self.naviDriveView];
    
    //将导航试图添加到视图层级中
    [self.view addSubview:self.naviDriveView];
    
    //开始实时导航
    [self.driveManager startGPSNavi];
}

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex)
    {
        [self.locationManager stopUpdatingLocation];
        
        //Remove annotation & annotationView
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.pointAnnotaiton = nil;
    }
    else
    {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [locationArray addObject:location];
    //    location.c
    
    
    
    
    
    
    //读取数据
    
    
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
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }
        
        NSLog(@"-----------------------------------");
        // 遍历数据
        int index = 0;
        //        for (NSManagedObject *obj in objs) {
        //            NSLog(@"%d---name=%@", index++,[obj valueForKey:@"time"]);
        //        }
        for (NSManagedObject *obj in objs) {
            NSLog(@"%d---name=%@", index++,[obj valueForKey:@"latitude"]);
        }
        NSLog(@"%d----------------------------------------------------------|||||||||||",index);
        for (GPSPoints *gps in objs) {
            //            Book *book = stu.book;
            NSLog(@"%lu",[gps.location count]);
            
            //            NSLog(@"%@")
            NSArray *array = gps.location;
            
            for (CLLocation *loc in array) {
                
                //                NSLog(@"%@",loc.coordinate);
                NSLog(@"%f",loc.coordinate.longitude);
            }
                //
    
    
    
    //测试
    if ([array count]>0) {

        CLLocationCoordinate2D commonPolyLineCords[[objs count]];
        NSMutableArray *index = [[NSMutableArray alloc]init];
        for (int i = 0; i < [array count]; i++) {
            CLLocation *l =[array objectAtIndex:i];
            commonPolyLineCords[i].latitude = l.coordinate.latitude;
            commonPolyLineCords[i].longitude = l.coordinate.longitude;
            [index addObject:@(i)];
        }
        int i =0;
//        for (GPSPoints *gps in objs) {
////            CLLocation *l =[locationArray objectAtIndex:i];
//            CLLocationCoordinate2D clLocationCoordinate2D;
//            clLocationCoordinate2D.latitude = gps.latitude.floatValue;
//            clLocationCoordinate2D.longitude = gps.longitude.floatValue;
//            commonPolyLineCords[i].latitude =  clLocationCoordinate2D.latitude;
//            commonPolyLineCords[i].longitude =  clLocationCoordinate2D.longitude;
////
////            CLLocationCoordinate2D clLocationCoordinate2DTWO;
////            
////            clLocationCoordinate2DTWO = clLocationCoordinate2D;
////            commonPolyLineCords[i] =clLocationCoordinate2D;
//            [index addObject:@(i)];
//            i++;
//
////            NSLog(@"%d---name=%@", index++,[obj valueForKey:@"latitude"]);
//        }

             commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
        //        commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] dra];
        commonPlolyline = [MAMultiPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] drawStyleIndexes:index];
        //        _polyline= [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
        [self.mapView addOverlay:commonPlolyline];
    }
    
    
    
    
            
        }

    
    
    
    if ([locationArray count]>0){
        if (self.pointAnnotaiton == nil)
        {
            self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
            [self.pointAnnotaiton setCoordinate:location.coordinate];
            
            [self.mapView addAnnotation:self.pointAnnotaiton];
        }
        
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        [self.mapView setCenterCoordinate:location.coordinate];
        
        
         
    }
    });

    
    //
    //    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
    //
    //    _count = dataArray.count;
    
    //    --------
    //    _runningCoords = (CLLocationCoordinate2D *)malloc(_count * sizeof(CLLocationCoordinate2D));
    //
    //    for (int i = 0; i < _count; i++)
    //    {
    //        @autoreleasepool
    //        {
    //            NSDictionary * data = dataArray[i];
    //            _runningCoords[i].latitude = [data[@"latitude"] doubleValue];
    //            _runningCoords[i].longitude = [data[@"longtitude"] doubleValue];
    //
    //            UIColor * speedColor = [self getColorForSpeed:[data[@"speed"] floatValue]];
    //            [_speedColors addObject:[UIColor blueColor]];
    //
    //            [indexes addObject:@(i)];
    //        }
    //    }
    //}
    //
    //_polyline = [MAMultiPolyline polylineWithCoordinates:_runningCoords count:_count drawStyleIndexes:indexes];
    //    _polyline = [MAMultiPolyline polylineWithCoordinates:_runningCoords count:_count drawStyleIndexes:indexes];
    NSLog(@"插入数据");
//    //创建模型数据模型
//    GPSPoints *gps = [NSEntityDescription insertNewObjectForEntityForName:@"GPSPoints" inManagedObjectContext:self.managedContext];
//    gps.time = location.timestamp;
//    gps.longitude =[NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    gps.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
//    
//    //    NSData *data = [NSData d]
//    //    NSLog(@"%@",gps.time);
//    //    student.id = @(11);
//    //
//    //    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedContext];
//    //    book.bookID = @(121);
//    //    book.bookName = @"<老人与海2>";
//    //
//    //    student.book = book;
//    //
//    //    Student *student2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedContext];
//    //    student2.name = @"李四2";
//    //    student2.id = @(23);
//    //
//    //    Book *book2 = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedContext];
//    //    book2.bookID = @(242);
//    //    book2.bookName = @"<飞鸟集2>";
//    //
//    //    student2.book = book2;
//    
//    //保存,用 save 方法
//    NSError *error = nil;
//    BOOL success = [self.managedContext save:&error];
//    if (!success) {
//        [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
//    }
//    
//    
    
    
}

#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Start", @"Stop", nil]];
    self.showSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, nil];
}

@end
