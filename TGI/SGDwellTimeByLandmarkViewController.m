//
//  SGDwellTimeByLandmarkViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeByLandmarkViewController.h"
#import "SGDwellTime.h"
#import "SGDwellTimeByLandmarkData.h"
#import "SGDwellTimeByLandmarkYAxisLabelProvider.h"

@implementation SGDwellTimeByLandmarkViewController
{
    NSArray *data;
    
    CPTGraph *graph;
    CPTXYPlotSpace *barPlotSpace;
    NSNumberFormatter *f;
    SGDwellTimeByLandmarkYAxisLabelProvider *labelProvider;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        labelProvider = [[SGDwellTimeByLandmarkYAxisLabelProvider alloc] init];
        labelProvider.dataSource = self;
    }
    return self;
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    for (SGDwellTime *row in array) {
        SGDwellTimeByLandmarkData *entry = [tmp objectForKey:row.landmark];
        if (!entry) {
            entry = [[SGDwellTimeByLandmarkData alloc] init];
            entry.landmark = row.landmark;
        }
        [entry add:row];
        [tmp setObject:entry forKey:row.landmark];
    }
    
    data = tmp.allValues;

    data = [data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SGDwellTimeByLandmarkData *d1 = obj1;
        SGDwellTimeByLandmarkData *d2 = obj2;
        return [d2.landmark compare:d1.landmark];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    CPTGraphHostingView *layerHostingView = (CPTGraphHostingView *)self.view;
	CGRect bounds = layerHostingView.bounds;
    
	graph = [(CPTXYGraph *)[CPTXYGraph alloc] initWithFrame:bounds];
    layerHostingView.hostedGraph = graph;
    
    graph.plotAreaFrame.paddingBottom = 50.0;
    graph.plotAreaFrame.paddingLeft   = 50.0;
    graph.plotAreaFrame.paddingRight  = 10.0;
    
	barPlotSpace = [[CPTXYPlotSpace alloc] init];
    
	barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(120.0f)];
	barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(11.0f)];
	[graph addPlotSpace:barPlotSpace];
    
	CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
	majorGridLineStyle.lineWidth = 1.0f;
	majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];
    
    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
	whiteTextStyle.color   = [CPTColor whiteColor];
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
	CPTXYAxis *x		  = axisSet.xAxis;
	{
		x.majorIntervalLength		  = CPTDecimalFromInteger(25);
		x.minorTicksPerInterval		  = 5;
		x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0);

		x.majorGridLineStyle = majorGridLineStyle;
        //		x.minorGridLineStyle = minorGridLineStyle;
		x.axisLineStyle		 = nil;
		x.majorTickLineStyle = nil;
		x.minorTickLineStyle = nil;
		x.labelOffset		 = 10.0;
        x.labelTextStyle = whiteTextStyle;
        x.labelFormatter = f;

		x.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
        
		x.plotSpace = barPlotSpace;
	}
    
	CPTXYAxis *y = axisSet.yAxis;
	{
		y.majorIntervalLength		  = CPTDecimalFromInteger(1);
		y.minorTicksPerInterval		  = 0;
		y.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
        
//		y.preferredNumberOfMajorTicks = data.count - 1;
        //		y.majorGridLineStyle		  = majorGridLineStyle;
        //		y.minorGridLineStyle		  = minorGridLineStyle;
		y.axisLineStyle				  = nil;
		y.majorTickLineStyle		  = nil;
		y.minorTickLineStyle		  = nil;
		y.labelOffset				  = 10.0;
        //		y.labelRotation				  = M_PI / 2;
        y.labelTextStyle = whiteTextStyle;
        y.labelFormatter = labelProvider;
        
		y.visibleRange	 = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
		y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
        
		y.plotSpace = barPlotSpace;
	}
    
	graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];
    
	CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor whiteColor];
    
	CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
	barPlot.lineStyle		= barLineStyle;
	barPlot.fill			= [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.5f alpha:0.5f]];
	barPlot.barsAreHorizontal = YES;
    
	barPlot.delegate   = self;
	barPlot.dataSource = self;
    
	[graph addPlot:barPlot toPlotSpace:barPlotSpace];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	return data.count;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num = nil;
    
	if (fieldEnum == CPTBarPlotFieldBarLocation) {
		// location
        num = [NSDecimalNumber numberWithInt:index];
	} else if (fieldEnum == CPTBarPlotFieldBarTip) {
		// length
        SGDwellTimeByLandmarkData *row = [data objectAtIndex:index];
        num = [row percentage];
    }
    
	return num;
}

- (SGDwellTimeByLandmarkData *)dataForIndex:(NSUInteger)index
{
    if (index < data.count) {
        return [data objectAtIndex:index];
    } else {
        return nil;
    }
}

@end
