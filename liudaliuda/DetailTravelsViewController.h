//
//  DetailTravelsViewController.h
//  liudaliuda
//
//  Created by lijiehu on 16/8/15.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSPoints.h"
@interface DetailTravelsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) GPSPoints  *gps;
@end
