//
//  SGDwellTimeCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeCell.h"

@implementation SGDwellTimeCell

- (void)setDwellTime:(SGDwellTime *)dwellTime
{
    _dwellTime = dwellTime;
    
    self.assetIdLabel.text = dwellTime.assetId;
    self.landmarkLabel.text = dwellTime.landmark;
    self.daysLabel.text = dwellTime.days;
}

@end
