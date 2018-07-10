//
//  SGAssetUtilizationExpCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetUtilizationExpCell.h"

@implementation SGAssetUtilizationExpCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)setData:(SGAssetUtilizationData *)data
{
    _data = data;
    
    if ([data.asset isEqualToString:@""]) {
        self.titleLabel.text = data.group;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@, %@", data.subGroup, data.type];
    } else {
        self.titleLabel.text = data.asset;
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@, %@, %@", data.group, data.subGroup, data.type];
    }
    
    self.avgLabel.text = data.avg;
    
    self.numberOfAssetsInGroupLabel.text = data.numberOfAssetsInGroup;
    self.numberOfMovesLabel.text = data.numberOfMoves;
    self.numberOfDaysLabel.text = data.numberOfDays;
    self.minLabel.text = data.min;
    self.maxLabel.text = data.max;
    self.avgLabel.text = data.avg;
}

- (void)swipe:(id)sender
{
    [self.delegate showAssetInfo:self.data.asset];
}

@end
