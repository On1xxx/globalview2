//
//  SGDwellTimeByAssetViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ios/CorePlot-CocoaTouch.h"

@interface SGDwellTimeByAssetViewController : UIViewController <CPTPieChartDataSource, CPTPieChartDelegate>

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostingView;

- (void)setArray:(NSArray *)array;

@end
