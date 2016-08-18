//
//  ImageAnnotation.m
//  liudaliuda
//
//  Created by iMac OS on 16/8/9.
//  Copyright © 2016年 iMac OS. All rights reserved.
//

#import "ImageAnnotation.h"

@implementation ImageAnnotation
- (instancetype)initWithAnnotationModelWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        
        self.coordinate = CLLocationCoordinate2DMake([dict[@"coordinate"][@"latitute"] doubleValue], [dict[@"coordinate"][@"longitude"] doubleValue]);
//        self.coordinate = dict[@"coordinate"].la;
        self.title = dict[@"detail"];
        self.name = dict[@"name"];
        self.type = dict[@"type"];
    }
    return self;
}
@end
