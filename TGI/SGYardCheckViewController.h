//
//  SGYardCheckViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGYardCheck.h"
#import "SGSortOptionsViewController.h"

@interface SGYardCheckViewController : UITableViewController <SGSortOptionsDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;

@property (weak, nonatomic) SGYardCheck *yardCheck;

@end
