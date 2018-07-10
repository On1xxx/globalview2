//
//  SGDwellTimeByAssetViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeByAssetViewController.h"
#import "SGDwellTime.h"
#import "SGPair.h"

@implementation SGDwellTimeByAssetViewController
{
    CPTXYGraph *pieChart;
    NSMutableArray *stats;
}

- (void)setArray:(NSArray *)array
{
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    for (SGDwellTime *row in array) {
        NSNumber *entry = [tmp objectForKey:row.days];
        int value = 0;
        if (entry) {
            value = [entry intValue];
        }
        value += 1;
        [tmp setObject:[NSNumber numberWithInt:value] forKey:row.days];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.maximumFractionDigits = 0;
    f.roundingMode = NSNumberFormatterRoundHalfUp;
    
    int count = array.count;
    stats = [[NSMutableArray alloc] init];
    for (NSString *days in tmp) {
        NSNumber *value = [tmp objectForKey:days];
        double x = [value doubleValue] * 100.0f;
        double y = x / count;
        NSString *val = [f stringFromNumber:[NSNumber numberWithDouble:y]];
        SGPair *p = [SGPair pairWithKey:days value:val];
        [stats addObject:p];
    }
    
    [stats sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SGPair *p1 = obj1;
        SGPair *p2 = obj2;
        int a = [p1.key intValue];
        int b = [p2.key intValue];
        if (a > b) {
            return NSOrderedAscending;
        } else if (a < b) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGFloat margin = pieChart.plotAreaFrame.borderLineStyle.lineWidth + 5.0;
    
	CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CGRect plotBounds	 = pieChart.plotAreaFrame.bounds;
	CGFloat newRadius	 = MIN(plotBounds.size.width, plotBounds.size.height) / 2.0 - margin;
    
	CGFloat y = 0.0;
    
	if ( plotBounds.size.width > plotBounds.size.height ) {
		y = 0.5;
	} else {
		y = (newRadius + margin) / plotBounds.size.height;
	}
	CGPoint newAnchor = CGPointMake(0.5, y);
    
	// Animate the change
	[CATransaction begin];
	{
		[CATransaction setAnimationDuration:1.0];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"pieRadius"];
		animation.toValue  = [NSNumber numberWithDouble:newRadius];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"pieRadius"];
        
		animation		   = [CABasicAnimation animationWithKeyPath:@"centerAnchor"];
		animation.toValue  = [NSValue valueWithBytes:&newAnchor objCType:@encode(CGPoint)];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"centerAnchor"];
	}
	[CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	CPTPieChart *piePlot			 = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CABasicAnimation *basicAnimation = (CABasicAnimation *)theAnimation;
    
	[piePlot removeAnimationForKey:basicAnimation.keyPath];
	[piePlot setValue:basicAnimation.toValue forKey:basicAnimation.keyPath];
	[piePlot repositionAllLabelAnnotations];
}

- (void)viewDidAppear:(BOOL)animated
{
    pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    pieChart.defaultPlotSpace.allowsUserInteraction = YES;
    
    //	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //	[pieChart applyTheme:theme];
    
	self.hostingView.hostedGraph = pieChart;
    
    pieChart.axisSet = nil;
    
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
    whiteText.color = [CPTColor whiteColor];

//    pieChart.titleTextStyle = whiteText;
//    pieChart.title			= @"Graph Title";
    
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource = self;
    piePlot.delegate = self;
    piePlot.identifier = @"Pie Chart 1";
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        piePlot.pieRadius = 135.0;
    } else {
        piePlot.pieRadius = 84.5;
    }
//    piePlot.labelOffset = -10.0;

    //	piePlot.startAngle		= M_PI_4;
    //	piePlot.sliceDirection	= CPTPieDirectionCounterClockwise;
    //	piePlot.centerAnchor	= CGPointMake(0.5, 0.38);
    //	piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    
	[pieChart addPlot:piePlot];

 	CPTLegend *legend = [CPTLegend legendWithGraph:pieChart];
	legend.numberOfColumns = 1;
	legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	legend.borderLineStyle = [CPTLineStyle lineStyle];
	legend.cornerRadius = 5.0;
    
	pieChart.legend = legend;
	pieChart.legendAnchor = CPTRectAnchorBottomRight;
    //	pieChart.legendDisplacement = CGPointMake(-boundsPadding - 10.0, 0.0);
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return stats.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    SGPair *p = [stats objectAtIndex:index];
    return [NSNumber numberWithInt:[p.value intValue]];
}

//- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
//{
//    static CPTMutableTextStyle *style = nil;
//    if (!style) {
//        style = [[CPTMutableTextStyle alloc] init];
//        style.color = [CPTColor grayColor];
//        style.fontSize = 12;
//    }
//    SGPair *p = [stats objectAtIndex:index];
//    NSString *text = [NSString stringWithFormat:@"%@ Days (%@ %%)", p.key, p.value];
//    return [[CPTTextLayer alloc] initWithText:text style:style];
//}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
//    NSLog(@"legend for index: %u", index);
    SGPair *p = [stats objectAtIndex:index];
    return [NSString stringWithFormat:@"%@ Days (%@ %%)", p.key, p.value];
}

@end
