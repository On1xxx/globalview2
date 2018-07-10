//
//  SGDwellTime.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTime.h"

@implementation SGDwellTime
{
    NSMutableArray *locationDates;
    NSMutableArray *landmarkDates;
}

- (id)init
{
    self = [super init];
    if (self) {
        locationDates = [[NSMutableArray alloc] init];
        landmarkDates = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)location
{
    return [NSString stringWithFormat:@"%@, %@, %@", self.city, self.province, self.country];
}

- (NSArray *)locationDates
{
    return locationDates;
}

- (NSArray *)landmarkDates
{
    return landmarkDates;
}

- (void)addLocationDate:(SGDwellTimeDate *)date
{
    [locationDates addObject:date];
}

- (void)addLandmarkDate:(SGDwellTimeDate *)date
{
    [landmarkDates addObject:date];
}

@end
