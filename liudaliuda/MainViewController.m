//
//  MainViewController.m
//  liudaliuda
//
//  Created by iMac OS on 16/8/1.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "MainViewController.h"
#import "ImageAnnotation.h"

#define kRoutePlanInfoViewHeight    130.f
#define kRouteIndicatorViewHeight   64.f
#define kCollectionCellIdentifier   @"kCollectionCellIdentifier"

@interface MainViewController ()<MAMapViewDelegate, AMapNaviDriveManagerDelegate, DriveNaviViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    CLLocation *locationAll;
    AMapNaviDriveManager *_driveManager;
    MAPolyline *commonPlolyline ;
    UIImage *imageAn;
    NSMutableArray *imageAnArray;
    int aI;
}

@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) UICollectionView *routeIndicatorView;
@property (nonatomic, strong) NSMutableArray *routeIndicatorInfoArray;
@property (nonatomic, strong) PreferenceView *preferenceView;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;

@property (nonatomic, strong)AMapNaviDriveView *naviDriveView;

@end

@implementation MainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    imageAnArray  = [[NSMutableArray alloc]init];
    aI = 0;
      self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self configLocationManager];
    [self.locationManager startUpdatingLocation];
    
    [self initProperties];
    
    [self initMapView];
    
    [self initDriveManager];
    
    [self configSubViews];
    
    [self initRouteIndicatorView];
    [self getOverlay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initAnnotations];
}

- (void)initProperties
{
    //为了方便展示驾车多路径规划，选择了固定的起终点
//    self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    self.endPoint   = [AMapNaviPoint locationWithLatitude: 32.26847629 longitude:121.50841227];

    self.routeIndicatorInfoArray = [NSMutableArray array];
}

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, kRoutePlanInfoViewHeight,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - kRoutePlanInfoViewHeight)];
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initDriveManager
{
    if (self.driveManager == nil)
    {
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
    }
}

- (void)initRouteIndicatorView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _routeIndicatorView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - kRouteIndicatorViewHeight, CGRectGetWidth(self.view.bounds), kRouteIndicatorViewHeight) collectionViewLayout:layout];
    
    _routeIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _routeIndicatorView.backgroundColor = [UIColor clearColor];
    _routeIndicatorView.pagingEnabled = YES;
    _routeIndicatorView.showsVerticalScrollIndicator = NO;
    _routeIndicatorView.showsHorizontalScrollIndicator = NO;
    
    _routeIndicatorView.delegate = self;
    _routeIndicatorView.dataSource = self;
    
    [_routeIndicatorView registerClass:[RouteCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    
    [self.view addSubview:_routeIndicatorView];
}

- (void)initAnnotations
{
    NaviPointAnnotation *beginAnnotation = [[NaviPointAnnotation alloc] init];
    [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(self.startPoint.latitude, self.startPoint.longitude)];
    beginAnnotation.title = @"起始点";
    beginAnnotation.navPointType = NaviPointAnnotationStart;
    
    [self.mapView addAnnotation:beginAnnotation];
    
    NaviPointAnnotation *endAnnotation = [[NaviPointAnnotation alloc] init];
    [endAnnotation setCoordinate:CLLocationCoordinate2DMake(self.endPoint.latitude, self.endPoint.longitude)];
    endAnnotation.title = @"终点";
    endAnnotation.navPointType = NaviPointAnnotationEnd;
    
    [self.mapView addAnnotation:endAnnotation];
}

#pragma mark - SubViews

- (void)configSubViews
{
    UILabel *startPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.view.bounds), 20)];
    
    startPointLabel.textAlignment = NSTextAlignmentCenter;
    startPointLabel.font = [UIFont systemFontOfSize:14];
    startPointLabel.text = [NSString stringWithFormat:@"起 点：%f, %f", self.startPoint.latitude, self.startPoint.longitude];
    
    [self.view addSubview:startPointLabel];
    
    UILabel *endPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.view.bounds), 20)];
    
    endPointLabel.textAlignment = NSTextAlignmentCenter;
    endPointLabel.font = [UIFont systemFontOfSize:14];
    endPointLabel.text = [NSString stringWithFormat:@"终 点：%f, %f", self.endPoint.latitude, self.endPoint.longitude];
    
    [self.view addSubview:endPointLabel];
    
    self.preferenceView = [[PreferenceView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 30)];
    [self.view addSubview:self.preferenceView];
    
    UIButton *routeBtn = [self createToolButton];
    [routeBtn setFrame:CGRectMake((CGRectGetWidth(self.view.bounds)-80)/2.0, 95, 80, 30)];
    [routeBtn setTitle:@"路径规划" forState:UIControlStateNormal];
    [routeBtn addTarget:self action:@selector(routePlanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:routeBtn];
}

- (UIButton *)createToolButton
{
    UIButton *toolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    toolBtn.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    toolBtn.layer.borderWidth  = 0.5;
    toolBtn.layer.cornerRadius = 5;
    
    [toolBtn setBounds:CGRectMake(0, 0, 80, 30)];
    [toolBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toolBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    return toolBtn;
}

#pragma mark - Button Action

- (void)routePlanAction:(id)sender
{
//    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint]
//                                                endPoints:@[self.endPoint]
//                                                wayPoints:nil
//                                          drivingStrategy:self.preferenceView.strategy];
    [self.driveManager calculateDriveRouteWithEndPoints:@[self.endPoint] wayPoints:nil drivingStrategy:self.preferenceView.strategy];
}

#pragma mark - Handle Navi Routes

- (void)showNaviRoutes
{
    if ([self.driveManager.naviRoutes count] <= 0)
    {
        return;
    }
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.routeIndicatorInfoArray removeAllObjects];
    
    for (NSNumber *aRouteID in [self.driveManager.naviRoutes allKeys])
    {
        AMapNaviRoute *aRoute = [[self.driveManager naviRoutes] objectForKey:aRouteID];
        int count = (int)[[aRoute routeCoordinates] count];
        
        //添加路径Polyline
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D *)malloc(count * sizeof(CLLocationCoordinate2D));
        for (int i = 0; i < count; i++)
        {
            AMapNaviPoint *coordinate = [[aRoute routeCoordinates] objectAtIndex:i];
            coords[i].latitude = [coordinate latitude];
            coords[i].longitude = [coordinate longitude];
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coords count:count];
        
        SelectableOverlay *selectablePolyline = [[SelectableOverlay alloc] initWithOverlay:polyline];
        [selectablePolyline setRouteID:[aRouteID integerValue]];
        
        [self.mapView addOverlay:selectablePolyline];
        free(coords);
        
        //更新CollectonView的信息
        RouteCollectionViewInfo *info = [[RouteCollectionViewInfo alloc] init];
        info.routeID = [aRouteID integerValue];
        info.title = [NSString stringWithFormat:@"路径ID:%ld | 路径计算策略:%ld", (long)[aRouteID integerValue], (long)self.preferenceView.strategy];
        info.subtitle = [NSString stringWithFormat:@"长度:%ld米 | 预估时间:%ld秒 | 分段数:%ld", (long)aRoute.routeLength, (long)aRoute.routeTime, (long)aRoute.routeSegments.count];
        
        [self.routeIndicatorInfoArray addObject:info];
    }
    
    [self.mapView showAnnotations:self.mapView.annotations animated:NO];
    [self.routeIndicatorView reloadData];
    
    [self selectNaviRouteWithID:[[self.routeIndicatorInfoArray firstObject] routeID]];
}

- (void)selectNaviRouteWithID:(NSInteger)routeID
{
    if ([self.driveManager selectNaviRouteWithRouteID:routeID])
    {
        [self selecteOverlayWithRouteID:routeID];
    }
    else
    {
        NSLog(@"路径选择失败!");
    }
}

- (void)selecteOverlayWithRouteID:(NSInteger)routeID
{
    [self.mapView.overlays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MAOverlay> overlay, NSUInteger idx, BOOL *stop)
     {
         if ([overlay isKindOfClass:[SelectableOverlay class]])
         {
             SelectableOverlay *selectableOverlay = overlay;
             
             /* 获取overlay对应的renderer. */
             MAPolylineRenderer * overlayRenderer = (MAPolylineRenderer *)[self.mapView rendererForOverlay:selectableOverlay];
             
             if (selectableOverlay.routeID == routeID)
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = YES;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.selectedColor;
                 overlayRenderer.strokeColor = selectableOverlay.selectedColor;
                 
                 /* 修改overlay覆盖的顺序. */
                 [self.mapView exchangeOverlayAtIndex:idx withOverlayAtIndex:self.mapView.overlays.count - 1];
             }
             else
             {
                 /* 设置选中状态. */
                 selectableOverlay.selected = NO;
                 
                 /* 修改renderer选中颜色. */
                 overlayRenderer.fillColor   = selectableOverlay.regularColor;
                 overlayRenderer.strokeColor = selectableOverlay.regularColor;
             }
             
             [overlayRenderer glRender];
         }
     }];
    
}

#pragma mark - AMapNaviDriveManager Delegate

- (void)driveManager:(AMapNaviDriveManager *)driveManager error:(NSError *)error
{
    NSLog(@"error:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    [self showNaviRoutes];
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onCalculateRouteFailure:(NSError *)error
{
    NSLog(@"onCalculateRouteFailure:{%ld - %@}", (long)error.code, error.localizedDescription);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager didStartNavi:(AMapNaviMode)naviMode
{
    NSLog(@"didStartNavi");
}

- (void)driveManagerNeedRecalculateRouteForYaw:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForYaw");
}

- (void)driveManagerNeedRecalculateRouteForTrafficJam:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"needRecalculateRouteForTrafficJam");
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager onArrivedWayPoint:(int)wayPointIndex
{
    NSLog(@"onArrivedWayPoint:%d", wayPointIndex);
}

- (void)driveManager:(AMapNaviDriveManager *)driveManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType
{
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:soundString];
}

- (void)driveManagerDidEndEmulatorNavi:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"didEndEmulatorNavi");
}

- (void)driveManagerOnArrivedDestination:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onArrivedDestination");
}

#pragma mark - DriveNaviView Delegate

- (void)driveNaviViewCloseButtonClicked
{
    //开始导航后不再允许选择路径，所以停止导航
    [self.driveManager stopNavi];
    
    //停止语音
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.routeIndicatorInfoArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.shouldShowPrevIndicator = (indexPath.row > 0 && indexPath.row < _routeIndicatorInfoArray.count);
    cell.shouldShowNextIndicator = (indexPath.row >= 0 && indexPath.row < _routeIndicatorInfoArray.count-1);
    cell.info = self.routeIndicatorInfoArray[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(collectionView.bounds) - 10, CGRectGetHeight(collectionView.bounds) - 5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DriveNaviViewController *driveVC = [[DriveNaviViewController alloc] init];
    [driveVC setDelegate:self];
    
    //将driveView添加到AMapNaviDriveManager中
    [self.driveManager addDataRepresentative:driveVC.driveView];
    
    [self.navigationController pushViewController:driveVC animated:NO];
    [self.driveManager startEmulatorNavi];
//    [self.driveManager startGPSNavi];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    RouteCollectionViewCell *cell = [[self.routeIndicatorView visibleCells] firstObject];
    
    if (cell.info)
    {
        [self selectNaviRouteWithID:cell.info.routeID];
    }
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NaviPointAnnotation class]])
    {
        static NSString *annotationIdentifier = @"NaviPointAnnotationIdentifier";
        
        MAPinAnnotationView *pointAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (pointAnnotationView == nil)
        {
            pointAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:annotationIdentifier];
        }
        
        pointAnnotationView.animatesDrop   = NO;
        pointAnnotationView.canShowCallout = YES;
        pointAnnotationView.draggable      = NO;
        
        NaviPointAnnotation *navAnnotation = (NaviPointAnnotation *)annotation;
        
        if (navAnnotation.navPointType == NaviPointAnnotationStart)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorGreen];
        }
        else if (navAnnotation.navPointType == NaviPointAnnotationEnd)
        {
            [pointAnnotationView setPinColor:MAPinAnnotationColorRed];
        }
        
        return pointAnnotationView;
    }else if ([annotation isKindOfClass:[MAPointAnnotation class]])
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
        if (imageAn!=nil) {
         
//            annotationView.image         = [imageAnArray objectAtIndex:aI];
            if (aI<[imageAnArray count]-1) {
                aI++;
            }
        }else{
            annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
            
        }
        //        annotationView.frame.size = CGSizeMake(23, 23);
        return annotationView;
    }else if([annotation isKindOfClass:[ImageAnnotation class]]){
        static NSString *pointReuseIndetifier = @"imageannotatione";
        
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
        
        ImageAnnotation *imaAnnotation = (ImageAnnotation *)annotation;
        
       
        if (imaAnnotation.image!=nil) {
            
            annotationView.image         = imaAnnotation.image;
            if (aI<[imageAnArray count]-1) {
                aI++;
            }
        }else{
//            annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
            
        }
        return annotationView;


    };

    return nil;
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[SelectableOverlay class]])
    {
        SelectableOverlay * selectableOverlay = (SelectableOverlay *)overlay;
        id<MAOverlay> actualOverlay = selectableOverlay.overlay;
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:actualOverlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = selectableOverlay.isSelected ? selectableOverlay.selectedColor : selectableOverlay.regularColor;
        
        return polylineRenderer;
    }else if([overlay isKindOfClass:[MAPolyline class]])
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

    }
    
    return nil;
}


- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
//    locationAll = location;
      self.startPoint = [AMapNaviPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
//    //    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
//    [locationArray addObject:location];
//    //    location.c
//    
//    //测试
//    if ([locationArray count]>0) {
//        ////        [self.locationManager stopUpdatingLocation];
//        //        [self readData];
//        //
//        //    }else{
//        CLLocationCoordinate2D commonPolyLineCords[[locationArray count]];
//        NSMutableArray *index = [[NSMutableArray alloc]init];
//        for (int i = 0; i < [locationArray count]; i++) {
//            CLLocation *l =[locationArray objectAtIndex:i];
//            commonPolyLineCords[i].latitude = l.coordinate.latitude;
//            commonPolyLineCords[i].longitude = l.coordinate.longitude;
//            [index addObject:@(i)];
//        }
//        commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
//        //        commonPlolyline = [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] dra];
//        commonPlolyline = [MAMultiPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count] drawStyleIndexes:index];
//        //        _polyline= [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
//        [self.mapView addOverlay:commonPlolyline];
//    }
//    if ([locationArray count]>0){
//        if (self.pointAnnotaiton == nil)
//        {
//            self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
//            [self.pointAnnotaiton setCoordinate:location.coordinate];
//            
//            [self.mapView addAnnotation:self.pointAnnotaiton];
//        }
//        
//        [self.pointAnnotaiton setCoordinate:location.coordinate];
//        [self.mapView setCenterCoordinate:location.coordinate];
//        
//        
//        //    }else{
//        //        [self.mapView setZoomLevel:15.1 animated:NO];
//        
//        
//    }
//    
    
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
    if (self.pointAnnotaiton == nil)
    {
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    [self.mapView setCenterCoordinate:location.coordinate];
    
    

    
}

//构建折线图数据
-(void)getOverlay{
    NSMutableArray *indexes = [[NSMutableArray alloc]init];
        CLLocationCoordinate2D commonPolyLineCords[[_gps.location count]];

                for (int i = 0; i < [_gps.location count]; i++) {
                    CLLocation *l =[_gps.location objectAtIndex:i];
                    commonPolyLineCords[i].latitude = l.coordinate.latitude;
                    commonPolyLineCords[i].longitude = l.coordinate.longitude;
                    [indexes addObject:@(i)];
                }

    //构建折线对象
    commonPlolyline = [MAMultiPolyline polylineWithCoordinates:commonPolyLineCords count:[_gps.location count] drawStyleIndexes:indexes];
    //        _polyline= [MAPolyline polylineWithCoordinates:commonPolyLineCords count:[locationArray count]];
    [self.mapView addOverlay:commonPlolyline];
//    在地图上添加折现对象
      for (int i = 0; i < [_gps.image count]; i++) {
          
          NSDictionary *dic = [_gps.image objectAtIndex:i];
          
          NSArray* arr = [dic allKeys];
          int  t = 0;
          for(NSString* str in arr)
          {
              NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES);
              NSString *documentsDirectory = [paths objectAtIndex:0];
              NSString* path = [documentsDirectory stringByAppendingPathComponent:
                                str ];
              UIImage* image = [UIImage imageWithContentsOfFile:path];
//                  UIImage* image = [UIImage imageWithContentsOfFile:@"/var/mobile/Containers/Data/Application/02D5460E-642D-47CA-A2A2-D00368E2A5BE/Documents/test.png"];
              //添加大头针图片
              CLLocation *l =[dic valueForKey:str];
              
//              NSData *data = [NSData dataWithContentsOfFile:str];
//              UIImage* image1 = [UIImage imageWithContentsOfFile:str];

              MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
              pointAnnotation.coordinate = l.coordinate;
              pointAnnotation.title =[NSString stringWithFormat:@"%d方恒国际",i];
              pointAnnotation.subtitle = @"阜通东大街6号";
              
              //          NSString *iNameCor = [NSString stringWithFormat:@"image%f%f",l.coordinate.latitude,l.coordinate.longitude];
              //          imageAnonation = [self image:image byScalingToSize:CGSizeMake(30, 30)];
              
              
              //        imageAnonation = image;
//              NSLog(@"%@",image);
              imageAn = [self image:image byScalingToSize:CGSizeMake(40, 40)];
           

              [imageAnArray addObject:imageAn];
//                [_mapView addAnnotation:pointAnnotation];
              
              
              ImageAnnotation *imageAnnotationT =[[ImageAnnotation alloc]init];
              imageAnnotationT.coordinate = l.coordinate;
              imageAnnotationT.title = @"hlj";
              imageAnnotationT.i = t;
//              ImageAnnotation.image = imageAn;
              imageAnnotationT.image = imageAn;
               [_mapView addAnnotation:imageAnnotationT];
              t++;
              
              NSLog(@"%@", [dic objectForKey:str]);
          }
          
          
            }
    

    
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

@end
