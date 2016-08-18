//
//  GPSPoints+CoreDataProperties.h
//  liudaliuda
//
//  Created by iMac OS on 16/8/9.
//  Copyright © 2016年 iMac OS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GPSPoints.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPSPoints (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSArray *location;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSDate *time;
@property (nullable, nonatomic, retain) NSArray *image;
@property (nullable, nonatomic, retain) NSArray *text;

@end

NS_ASSUME_NONNULL_END
