//
//  SGDwellTimeAssetShortInfoViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeAssetShortInfoViewController.h"
#import "SGDwellTimeAssetFullInfoViewController.h"

@implementation SGDwellTimeAssetShortInfoViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}

- (void)setDwellTime:(SGDwellTime *)dwellTime
{
    [super setDwellTime:dwellTime];
    
    [self addField:@"Status" value:dwellTime.status];
    [self addField:@"Landmark" value:dwellTime.landmark];
    [self addField:@"Group" value:dwellTime.group];
    [self addField:@"Sub group" value:dwellTime.subGroup];
    [self addField:@"Type" value:dwellTime.type];
    [self addField:@"Last Loc" value:dwellTime.location];
    [self addField:@"Revenue" value:dwellTime.revenue];
    [self addField:@"Cost" value:dwellTime.cost];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SGDwellTimeAssetFullInfoViewController *viewController = segue.destinationViewController;
    viewController.title = self.title;
    viewController.dwellTime = self.dwellTime;
}

@end
