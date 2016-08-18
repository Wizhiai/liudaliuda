//
//  MainViewController.h
//  liudaliuda
//
//  Created by iMac OS on 16/8/1.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <AMapLocationKit/AMapLocationManager.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "PreferenceView.h"
#import <MAMapKit/MAMapKit.h>
#import "GPSPoints.h"
#import "SpeechSynthesizer.h"
#import "NaviPointAnnotation.h"
#import "SelectableOverlay.h"
#import "RouteCollectionViewCell.h"
#import "DriveNaviViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import <AMapNaviKit/AMapNaviDriveView.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAPolyline.h>
@interface MainViewController : UIViewController<AMapLocationManagerDelegate>
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) GPSPoints  *gps;
@property (nonatomic,strong) NSManagedObjectContext *managedContext;
@end
