//
//  SGSortOptionsViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSortOrder.h"

@protocol SGSortOptionsDelegate <NSObject>

- (void)didSelectOption:(NSString *)option;

@end

@interface SGSortOptionsViewController : UITableViewController

@property (nonatomic) NSArray *options;
@property (nonatomic) NSString *currentOption;
@property (nonatomic) SGSortOrder currentOrder;
@property (weak, nonatomic) NSObject <SGSortOptionsDelegate> *delegate;

@end
