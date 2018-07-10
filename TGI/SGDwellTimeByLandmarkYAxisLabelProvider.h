//
//  SGDwellTimeByLandmarkYAxisLabelProvider.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGDwellTimeByLandmarkViewController.h"

@interface SGDwellTimeByLandmarkYAxisLabelProvider : NSNumberFormatter

@property (weak, nonatomic) SGDwellTimeByLandmarkViewController *dataSource;

@end
