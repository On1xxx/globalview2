//
//  SGDwellTimeByLandmarkData.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGDwellTime.h"

@interface SGDwellTimeByLandmarkData : NSObject

@property (nonatomic) NSString *landmark;

- (void)add:(SGDwellTime *)row;
- (NSNumber *)percentage;

@end
