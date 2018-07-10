//
//  SGYardCheckListCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckListCell.h"

@implementation SGYardCheckListCell

- (void)setYardCheck:(SGYardCheck *)yardCheck
{
    self.landmarkLabel.text = yardCheck.landmark;
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@, %@, %@", 	yardCheck.group, yardCheck.subGroup, yardCheck.type];
    self.countLabel.text = yardCheck.count;
}

@end
