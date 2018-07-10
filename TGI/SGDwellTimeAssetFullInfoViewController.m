//
//  SGDwellTimeAssetFullInfoViewController.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeAssetFullInfoViewController.h"

@implementation SGDwellTimeAssetFullInfoViewController

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
    [self addField:@"Days" value:dwellTime.days];
    [self addField:@"ESN" value:dwellTime.esn];
    [self addField:@"Description" value:dwellTime.assetDescription];
    [self addField:@"VIN" value:dwellTime.vin];
    [self addField:@"Serial number" value:dwellTime.serialNumber];
    for (SGDwellTimeDate *date in dwellTime.locationDates) {
        NSString *str = [NSString stringWithFormat:@"Last Location Date %@", date.label];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self addField:str value:date.date];
    }
    for (SGDwellTimeDate *date in dwellTime.landmarkDates) {
        NSString *str = [NSString stringWithFormat:@"Last Landmark Date %@", date.label];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self addField:str value:date.date];
    }
}

@end
