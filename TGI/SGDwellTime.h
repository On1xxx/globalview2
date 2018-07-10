//
//  SGDwellTime.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGDwellTimeDate.h"

@interface SGDwellTime : NSObject

@property (nonatomic, strong) NSString *assetId;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *days;
@property (nonatomic, strong) NSString *assetDescription;
@property (nonatomic, strong) NSString *esn;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *landmark;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *revenue;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *subGroup;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *vin;

- (NSString *)location;

- (NSArray *)locationDates;
- (NSArray *)landmarkDates;

- (void)addLocationDate:(SGDwellTimeDate *)date;
- (void)addLandmarkDate:(SGDwellTimeDate *)date;

@end
