    //
//  SerialLocationViewController.m
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "SerialLocationViewController.h"
#import "GPSPoints.h"
#import <AVFoundation/AVFoundation.h>                           //拍照头文件导入
#import <MobileCoreServices/MobileCoreServices.h>               //拍照头文件导入
#import <MediaPlayer/MediaPlayer.h>                             //拍照头文件导入
#import "HandlePhotoViewController.h"                            //心情书写编辑按钮
@interface SerialLocationViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation SerialLocationViewController{
    NSMutableArray *locationArray;
    MAMultiPolyline * _polyline;
    MAPolyline *commonPlolyline ;
    UIButton *tPBtn ;
    UIButton *writeBtn ;
    UIImagePickerController *_imagePickerController;
    UIImage *imageAnonation;
    NSMutableArray *imageArray;
    UIButton *submit;
    NSMutableArray *textArray;
    
}

#pragma mark - Action Handle

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];

    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    self.locationManager.distanceFilter = 1.0f;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex)
    {
        [self.locationManager stopUpdatingLocation];
        
        //Remove annotation & annotationView
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.pointAnnotaiton = nil;
        NSLog(@"插入数据");
        //创建模型数据模型
        GPSPoints *gps = [NSEntityDescription insertNewObjectForEntityForName:@"GPSPoints" inManagedObjectContext:self.managedContext];
//        gps.time = location.timestamp;
//        gps.longitude =[NSString stringWithFormat:@"%f", location.coordinate.longitude];
//        gps.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        gps.location = locationArray;
        gps.image = imageArray;
        gps.text = textArray;
        //    NSData *data = [NSData d]
        //    NSLog(@"%@",gps.time);
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
        
        //保存,用 save 方法
        NSError *error = nil;
        BOOL success = [self.managedContext save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
        }
        
        
        [self readData];
        
        
        //test
        NSData *travelsData = [NSKeyedArchiver archivedDataWithRootObject:locationArray];
        NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:travelsData];
        Byte *byte = (Byte *)[travelsData bytes];
        
    }
    else
    {
        [self.locationManager startUpdatingLocation];
        [locationArray removeAllObjects];
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
    
    //测试
    if ([locationArray count]>0) {
////        [self.locationManager stopUpdatingLocation];
//        [self readData];
//        
//    }else{
        CLLocationCoordinate2D commonPolyLineCords[[locationArray count]];
        NSMutableArray *index = [[NSMutableArray alloc]init];
        for (int i = 0; i < [locationArray count]; i++) {
            CLLocation *l =[locationArray objectAtIndex:i];
            commonPolyLineCords[i].latitude = l.coordinate.latitude;
               commonPolyLineCords[i].longitude = l.coordinate.longitude;
            [index addObject:@(i)];
        }
      commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
//        commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] dra];
            commonPlolyline = [MAMultiPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] drawStyleIndexes:index];
//        _polyline= [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
        [self.mapView addOverlay:commonPlolyline];
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
        
        
//    }else{
//        [self.mapView setZoomLevel:15.1 animated:NO];

     
    }

    
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
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"开始", @"结束", nil]];
    self.showSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationArray = [[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    textArray = [[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initToolBar];
    
    [self initMapView];
    
    [self configLocationManager];
    [self createCoreDataContent];


//    [self deleteCoreData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.translucent   = YES;
    self.navigationController.toolbarHidden         = NO;
    
    //记录文字按钮
    //规定按钮的位置
        writeBtn = [[UIButton alloc]initWithFrame:CGRectMake(235.0f, 7.0f, 35.0f, 35.0f)];
    //更改按钮的图片
    [writeBtn setImage:[UIImage imageNamed:@"creative-writing.png"] forState:UIControlStateNormal];
//    writeBtn.backgroundColor = [UIColor blackColor];
    writeBtn.contentMode = UIViewContentModeScaleAspectFit;
    //设置按钮按下的动作和响应方式
    [writeBtn addTarget:self action:@selector(write) forControlEvents:UIControlEventTouchUpInside];
    //最后就是把创建的按钮添加到navigationbar上
    [self.navigationController.navigationBar addSubview:writeBtn];
    
    //拍照按钮
    //规定按钮的位置
    tPBtn = [[UIButton alloc]initWithFrame:CGRectMake(135.0f, 7.0f, 35.0f, 35.0f)];
    //更改按钮的图片
    [tPBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
//    tPBtn.backgroundColor = [UIColor blueColor];
    //设置按钮按下的动作和响应方式
    [tPBtn addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    //最后就是把创建的按钮添加到navigationbar上
    [self.navigationController.navigationBar addSubview:tPBtn];
    
    [self initTextView];
    [self cameraSet];
}
-(void)viewWillDisappear:(BOOL)animated{
    [tPBtn removeFromSuperview];
    [writeBtn removeFromSuperview];
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
        
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.layer.cornerRadius = annotationView.frame.size.width/2;
        annotationView.contentMode = UIViewContentModeScaleToFill;
              if (imageAnonation!=nil) {
                  annotationView.image         = imageAnonation;
              }else{
                  annotationView.image            = [UIImage imageNamed:@"icon_location.png"];

              }
//        annotationView.frame.size = CGSizeMake(23, 23);
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
        for (GPSPoints *gps in objs) {
//            Book *book = stu.book;
            NSLog(@"%lu",[gps.location count]);
            NSLog(@"%lu",[gps.image count]);

           
//            NSLog(@"%@")
            NSArray *array = gps.location;

            for (CLLocation *loc in array) {
                
//                NSLog(@"%@",loc.coordinate);
                NSLog( @"%f",loc.coordinate.longitude);
            }
          
        }
        
    });
}
-(void)deleteCoreData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GPSPoints"]; //查到到你要删除的数据库中的对象
//    NSPredicate *predic = [NSPredicate predicateWithFormat:@"name = %@",@"张三2"];
//    request.predicate = predic;
    //请求数据
    NSArray *objs = [self.managedContext executeFetchRequest:request error:nil];
    for (GPSPoints *gps in objs) {
    [self.managedContext deleteObject:gps];
}

[self.managedContext save:nil];
}
-(void)write{
    NSLog(@"take a photo");
//    [UIView animateWithDuration:2 animations:^{
//        self.textView.frame =CGRectMake(20, 100, self.view.frame.size.width - 40,  100) ;
//        
//          submit.frame = CGRectMake(self.view.frame.size.width - 160, self.textView.frame.origin.y+self.textView.frame.size.height, 80, 80);
//    }];
    HandlePhotoViewController *hvc = [[HandlePhotoViewController alloc]init];
    [self presentViewController:hvc animated:YES completion:nil];
    
  
}
-(void)takePhoto{
    NSLog(@"take a photo");
//    [UIView animateWithDuration:2 animations:^{
//        self.textView.frame =CGRectMake(20, 100, self.view.frame.size.width - 40,  100) ;
//    }];
    [self submitText];
    [self selectImageFromCamera];
    
}

//关闭收起UITextView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.textView resignFirstResponder];
    
    
    
}


-(void)initTextView{
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, -360, self.view.frame.size.width - 40,  100) ];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = NO;
    self.textView.delegate = self;
    self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.dataDetectorTypes = UIDataDetectorTypeAll;//显示数据类型的连接模式
    self.textView.textColor = [UIColor blackColor];
    self.textView.text = @"请在此处输入心情";
    [self.view addSubview:self.textView];
    submit = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, self.textView.frame.origin.y+self.textView.frame.size.height, 80, 80)];
    [submit setTitle:@"确定" forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(submitText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit];
}
#pragma mark - 提交心情文字
-(void) submitText{
    [UIView animateWithDuration:2.0 animations:^(void){
        self.textView.frame =  CGRectMake(20, -360, self.view.frame.size.width - 40,  100) ;
        submit.frame =CGRectMake(self.view.frame.size.width - 160, self.textView.frame.origin.y+self.textView.frame.size.height, 80, 80);
         CLLocation *l =[locationArray objectAtIndex:[locationArray count] - 1];
        NSDictionary *dic =[NSDictionary dictionaryWithObject:l forKey:self.textView.text];
        [textArray addObject:dic];
    }];
}
#pragma mark - 拍照
-(void)cameraSet{
    
    _imagePickerController = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
}
#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //录制视频时长，默认10s
    _imagePickerController.videoMaximumDuration = 15;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    
    //视频上传质量
    //UIImagePickerControllerQualityTypeHigh高清
    //UIImagePickerControllerQualityTypeMedium中等质量
    //UIImagePickerControllerQualityTypeLow低质量
    //UIImagePickerControllerQualityType640x480
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置摄像头模式（拍照，录制视频）为录像模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}
#pragma mark 拍照返回调用函数，处理图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    
    
    
    
    
    
    
    NSString *mdeiaTye = [info objectForKey:UIImagePickerControllerMediaType]; //获取媒体类型
    if ([mdeiaTye isEqualToString:(NSString*)kUTTypeImage]) {  //判断媒体类型是图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSString *iamgeStrBase64 = [data base64Encoding];
//        NSLog(@"%@,%lu",iamgeStrBase64,iamgeStrBase64.length/1024);
        
//        _photoLab.text = @"照片已选择";
//        _photoImageShoew.image = image;
        
        
        //添加大头针图片
        CLLocation *l =[locationArray objectAtIndex:[locationArray count] - 1];

        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = l.coordinate;
        pointAnnotation.title = @"方恒国际";
        pointAnnotation.subtitle = @"阜通东大街6号";
        
        NSString *iNameCor = [NSString stringWithFormat:@"image%f%f",l.coordinate.latitude,l.coordinate.longitude];
        imageAnonation = [self image:image byScalingToSize:CGSizeMake(30, 30)];
        
//        imageAnonation = image;
        NSLog(@"%@",image);
         [_mapView addAnnotation:pointAnnotation];
        
        //将图片先保存到document
        int imageNameI = 0;
        for (; ;) {
            NSString *hexStr = [self ToHex:imageNameI];
            NSString *iName = [NSString stringWithFormat:@"%@%@.png",iNameCor,hexStr];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:
                              iName ];
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            if (image==nil) {

                [data writeToFile:path atomically:YES];                                                        //到document
//                NSArray *arr = @[l.coordinate.latitude];
                NSDictionary *dic = [NSDictionary dictionaryWithObject:l forKey:iName];
                [imageArray addObject:dic];
                break;
            }
            imageNameI++;
            
        }
      
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}


//进制转换
-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }  
    return str;  
}

-(int)ToTen:(NSString*)tmpid
{
    
    int int_ch;
    
    
    unichar hex_char1 = [tmpid
                         characterAtIndex:0];
    ////两位16进制数中的第一位(高位*16)
    
    int int_ch1;
    
    if(hex_char1 >= '0'&& hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;
    //// 0 的Ascll - 48
    
    else if(hex_char1 >=
            'A'&& hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16;
    //// A 的Ascll - 65
    
    else
        int_ch1 = (hex_char1-87)*16;
    //// a 的Ascll - 97
    
    
    
    unichar hex_char2 = [tmpid
                         characterAtIndex:1];
    ///两位16进制数中的第二位(低位)
    
    int int_ch2;
    
    if(hex_char2 >= '0'&& hex_char2 <='9')
        int_ch2 = (hex_char2-48);
    //// 0 的Ascll - 48
    
    else if(hex_char1 >=
            'A'&& hex_char1 <='F')
        int_ch2 = hex_char2-55;
    //// A 的Ascll - 65
    
    else
        int_ch2 = hex_char2-87;
    //// a 的Ascll - 97
    
    int_ch = int_ch1+int_ch2;
    
    NSLog(@"int_ch=%d",int_ch);
    
    
    return int_ch;
}
//保存图片时更改annomation的信息
//更新数据
//- (void)modifyData{ // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库 //先从数据库中取出所有的数据,然后从其中选出要修改的那个,进行修改,然后保存
//NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"]; //设置过滤条件
//NSPredicate *pre = [NSPredicate predicateWithFormat:@"name = %@",@"李四2"];
//request.predicate = pre; NSError *error = nil; NSArray *objs = [self.managedContext executeFetchRequest:request error:&error]; if (error) {
//    [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
//} // 2.更新身高
//    for (Student *stu in objs) {
//stu.name = @"被修改的新名字";
//} //保存,用 save 方法
//    BOOL success = [self.managedContext save:&error];
//    if (!success) {
//[NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
//}

//}
@end
