//
//  NaviViewController.h
//  liudaliuda
//
//  Created by iMac OS on 16/8/3.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/AMapNaviDriveView.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAPolyline.h>
@interface NaviViewController : UIViewController

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic,strong) NSManagedObjectContext *managedContext;
@end
