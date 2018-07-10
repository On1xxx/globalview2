//
//  SGPieChartViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGPieChartViewController.h"

@implementation SGPieChartViewController
{
    CPTXYGraph *pieChart;
}

- (void)viewDidAppear:(BOOL)animated
{
    pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    //	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //	[pieChart applyTheme:theme];
    
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.hostedGraph = pieChart;
    
    //	pieChart.paddingLeft   = 20.0;
    //	pieChart.paddingTop	   = 20.0;
    //	pieChart.paddingRight  = 20.0;
    //	pieChart.paddingBottom = 20.0;
    //
    //	pieChart.axisSet = nil;
    
    //	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
    //	whiteText.color = [CPTColor whiteColor];
    //
    //	pieChart.titleTextStyle = whiteText;
    //	pieChart.title			= @"Graph Title";
    
	CPTPieChart *piePlot = [[CPTPieChart alloc] init];
	piePlot.dataSource = self;
	piePlot.pieRadius = 131.0;
    //	piePlot.identifier		= @"Pie Chart 1";
    //	piePlot.startAngle		= M_PI_4;
    //	piePlot.sliceDirection	= CPTPieDirectionCounterClockwise;
    //	piePlot.centerAnchor	= CGPointMake(0.5, 0.38);
    //	piePlot.borderLineStyle = [CPTLineStyle lineStyle];
	piePlot.delegate = self;
    
	[pieChart addPlot:piePlot];
    
 	CPTLegend *legend = [CPTLegend legendWithGraph:pieChart];
	legend.numberOfColumns = 1;
	legend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
	legend.borderLineStyle = [CPTLineStyle lineStyle];
	legend.cornerRadius = 5.0;
    
	pieChart.legend = legend;
	pieChart.legendAnchor = CPTRectAnchorBottom;
//	pieChart.legendDisplacement = CGPointMake(-boundsPadding - 10.0, 0.0);
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 3;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSLog(@"field: %d, index: %d", fieldEnum, index);
    return [NSNumber numberWithInt:index + 1];
}

- (NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    NSLog(@"legend for index: %u", index);
    return [NSString stringWithFormat:@"%u %%", index];
}

@end
