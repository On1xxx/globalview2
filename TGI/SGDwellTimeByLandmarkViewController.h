//
//  SGDwellTimeByLandmarkViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ios/CorePlot-CocoaTouch.h"
#import "SGDwellTimeByLandmarkData.h"

@interface SGDwellTimeByLandmarkViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (weak, nonatomic) NSArray *array;

- (SGDwellTimeByLandmarkData *)dataForIndex:(NSUInteger)index;

@end
