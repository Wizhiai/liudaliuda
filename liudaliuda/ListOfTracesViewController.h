//
//  ListOfTracesViewController.h
//  liudaliuda
//
//  Created by iMac OS on 16/8/5.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfTracesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *listData;
}
@property (nonatomic,strong) NSManagedObjectContext *managedContext;


@end
