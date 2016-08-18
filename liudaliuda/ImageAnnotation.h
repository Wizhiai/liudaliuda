//
//  ImageAnnotation.h
//  liudaliuda
//
//  Created by iMac OS on 16/8/9.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MAMapKit/MAMapKit.h>
@interface ImageAnnotation : NSObject <MAAnnotation>
//该模型是大头针模型 所以必须实现协议MKAnnotation协议 和CLLocationCoordinate2D中的属性coordinate


@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,retain) NSNumber *type;
@property (nonatomic,assign) int  i;
@property (nonatomic,strong) UIImage  *image;
- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict;
@end
