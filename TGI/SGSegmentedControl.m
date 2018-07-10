//
//  SGSegmentedControl.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGSegmentedControl.h"

@implementation SGSegmentedControl

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (selectedSegmentIndex == self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    [super setSelectedSegmentIndex:selectedSegmentIndex];
}

@end
