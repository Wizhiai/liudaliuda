//
//  HandlePhotoViewController.h
//  liudaliuda
//
//  Created by lijiehu on 16/8/16.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandlePhotoViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
