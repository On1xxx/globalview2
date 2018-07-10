//
//  SGBarChartViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGBarChartViewController.h"
#import "SGFooFormatter.h"

#define HORIZONTAL 1

@implementation SGBarChartViewController
{
    CPTGraph *graph;
    CPTXYPlotSpace *barPlotSpace;
    NSNumberFormatter *f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}

- (void)addLegend:(CPTMutableLineStyle *)barLineStyle whiteTextStyle:(CPTMutableTextStyle *)whiteTextStyle
{
	// Add legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
	theLegend.numberOfRows	  = 2;
	theLegend.fill			  = [CPTFill fillWithColor:[CPTColor colorWithGenericGray:0.15]];
	theLegend.borderLineStyle = barLineStyle;
	theLegend.cornerRadius	  = 10.0;
	theLegend.swatchSize	  = CGSizeMake(20.0, 20.0);
	whiteTextStyle.fontSize	  = 16.0;
	theLegend.textStyle		  = whiteTextStyle;
	theLegend.rowMargin		  = 10.0;
	theLegend.paddingLeft	  = 12.0;
	theLegend.paddingTop	  = 12.0;
	theLegend.paddingRight	  = 12.0;
	theLegend.paddingBottom	  = 12.0;
    
#if HORIZONTAL
	NSArray *plotPoint = [NSArray arrayWithObjects:[NSNumber numberWithInteger:95], [NSNumber numberWithInteger:0], nil];
#else
	NSArray *plotPoint = [NSArray arrayWithObjects:[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:95], nil];
#endif
	CPTPlotSpaceAnnotation *legendAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:barPlotSpace anchorPlotPoint:plotPoint];
	legendAnnotation.contentLayer = theLegend;
    
#if HORIZONTAL
	legendAnnotation.contentAnchorPoint = CGPointMake(1.0, 0.0);
#else
	legendAnnotation.contentAnchorPoint = CGPointMake(0.0, 1.0);
#endif
	[graph.plotAreaFrame.plotArea addAnnotation:legendAnnotation];
}

- (void)viewDidAppear:(BOOL)animated
{
    CPTGraphHostingView *layerHostingView = (CPTGraphHostingView *)self.view;
    
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
	CGRect bounds = layerHostingView.bounds;
#else
	CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
#endif
    
	graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:bounds];
    layerHostingView.hostedGraph = graph;
    
//    graph.plotAreaFrame.paddingTop    = 20.0;
    graph.plotAreaFrame.paddingBottom = 50.0;
    graph.plotAreaFrame.paddingLeft   = 50.0;
    graph.plotAreaFrame.paddingRight  = 10.0;
    
//#if HORIZONTAL
//	graph.plotAreaFrame.paddingBottom += 30.0;
//#else
//	graph.plotAreaFrame.paddingLeft += 30.0;
//#endif
    
	// Add plot space for bar charts
	barPlotSpace = [[CPTXYPlotSpace alloc] init];
#if HORIZONTAL
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(120.0f)];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(11.0f)];
#else
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(11.0f)];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(120.0f)];
#endif
	[graph addPlotSpace:barPlotSpace];
    
	// Create grid line styles
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 1.0f;
	majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
	CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
	minorGridLineStyle.lineWidth = 1.0f;
	minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];
    
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color   = [CPTColor whiteColor];
    
	// Create axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	{
#if HORIZONTAL
		x.majorIntervalLength		  = CPTDecimalFromInteger(25);
		x.minorTicksPerInterval		  = 5;
		x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0);
#else
		x.majorIntervalLength		  = CPTDecimalFromInteger(1);
		x.minorTicksPerInterval		  = 0;
		x.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
#endif
		x.majorGridLineStyle = majorGridLineStyle;
//		x.minorGridLineStyle = minorGridLineStyle;
		x.axisLineStyle		 = nil;
		x.majorTickLineStyle = nil;
		x.minorTickLineStyle = nil;
		x.labelOffset		 = 10.0;
        x.labelTextStyle = whiteTextStyle;
        x.labelFormatter = f;
#if HORIZONTAL
		x.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
#else
		x.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
		x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
#endif
        
//		x.title		  = @"X Axis";
//		x.titleOffset = 30.0f;
//#if HORIZONTAL
//		x.titleLocation = CPTDecimalFromInteger(55);
//#else
//		x.titleLocation = CPTDecimalFromInteger(5);
//#endif
        
		x.plotSpace = barPlotSpace;
	}
    
	CPTXYAxis *y = axisSet.yAxis;
	{
#if HORIZONTAL
		y.majorIntervalLength		  = CPTDecimalFromInteger(1);
		y.minorTicksPerInterval		  = 0;
		y.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
#else
		y.majorIntervalLength		  = CPTDecimalFromInteger(10);
		y.minorTicksPerInterval		  = 9;
		y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(-0.5);
#endif
		y.preferredNumberOfMajorTicks = 8;
//		y.majorGridLineStyle		  = majorGridLineStyle;
//		y.minorGridLineStyle		  = minorGridLineStyle;
		y.axisLineStyle				  = nil;
		y.majorTickLineStyle		  = nil;
		y.minorTickLineStyle		  = nil;
		y.labelOffset				  = 10.0;
//		y.labelRotation				  = M_PI / 2;
        y.labelTextStyle = whiteTextStyle;
#if HORIZONTAL
		y.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
		y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
#else
		y.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
#endif
        
//		y.title		  = @"Y Axis";
//		y.titleOffset = 30.0f;
//#if HORIZONTAL
//		y.titleLocation = CPTDecimalFromInteger(5);
//#else
//		y.titleLocation = CPTDecimalFromInteger(55);
//#endif
        
		y.plotSpace = barPlotSpace;
	}
    
	// Set axes
	graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
	// Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor whiteColor];
    
	// Create first bar plot
	CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
	barPlot.lineStyle		= barLineStyle;
	barPlot.fill			= [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.5f alpha:0.5f]];
//	barPlot.barBasesVary	= YES;
//	barPlot.barWidth		= CPTDecimalFromFloat(0.5f); // bar is 50% of the available space
//	barPlot.barCornerRadius = 10.0f;
#if HORIZONTAL
	barPlot.barsAreHorizontal = YES;
#else
	barPlot.barsAreHorizontal = NO;
#endif
    
//	barPlot.labelTextStyle = whiteTextStyle;
    
	barPlot.delegate   = self;
	barPlot.dataSource = self;
	barPlot.identifier = @"Bar Plot 1";
    
	[graph addPlot:barPlot toPlotSpace:barPlotSpace];
        
//    [self addLegend:barLineStyle whiteTextStyle:whiteTextStyle];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return 10;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;

	if (fieldEnum == CPTBarPlotFieldBarLocation) {
		// location
        num = [NSDecimalNumber numberWithInt:index];
	} else if (fieldEnum == CPTBarPlotFieldBarTip) {
		// length
        num = [NSDecimalNumber numberWithInt:index + 2];
	} else {
        num = [NSDecimalNumber numberWithInt:index];
    }
    
	return num;
}

//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"FOO %d", index]];
//    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
//    textStyle.color = [CPTColor redColor];
//    label.textStyle = textStyle;
//    
//    return label;
//}

@end
