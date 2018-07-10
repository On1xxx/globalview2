//
//  SGDwellTimeViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSortOptionsViewController.h"

@interface SGDwellTimeViewController : UITableViewController <SGSortOptionsDelegate>

@property (nonatomic) NSArray *array;

- (void)willSort;

@end
