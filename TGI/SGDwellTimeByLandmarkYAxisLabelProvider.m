//
//  SGDwellTimeByLandmarkYAxisLabelProvider.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeByLandmarkYAxisLabelProvider.h"

@implementation SGDwellTimeByLandmarkYAxisLabelProvider

- (NSString *)stringForObjectValue:(id)obj
{
    NSNumber *val = obj;
    NSUInteger index = [val intValue];
    SGDwellTimeByLandmarkData *data = [self.dataSource dataForIndex:index];
    return data.landmark;
}

@end
