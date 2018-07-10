//
//  SGDwellTimeByLandmarkData.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeByLandmarkData.h"

@implementation SGDwellTimeByLandmarkData
{
    int numberOfUnits;
    int numberOfOffenders;
//    
//    NSNumberFormatter *f;
}

- (id)init
{
    self = [super init];
    if (self) {
        numberOfUnits = 0;
        numberOfOffenders = 0;
        
//        f = [[NSNumberFormatter alloc] init];
//        f.maximumFractionDigits = 0;
//        f.roundingMode = NSNumberFormatterRoundHalfUp;

    }
    return self;
}

- (void)add:(SGDwellTime *)row
{
    numberOfUnits += 1;
    if (row.days.intValue > 0) {
        numberOfOffenders += 1;
    }
}

- (NSNumber *)percentage
{
    NSNumber *off = [NSNumber numberWithInt:numberOfOffenders];
    NSNumber *unt = [NSNumber numberWithInt:numberOfUnits];
    
    double x = [off doubleValue] * 100.0f;
    double y = x / [unt doubleValue];

    return [NSNumber numberWithDouble:y];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"DwellTimeByLandmark = %@, %d, %d, %@", self.landmark, numberOfUnits, numberOfOffenders, [self percentage]];
}

@end
