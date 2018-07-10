//
//  SGAssignESNSelectionViewController.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAssignESN.h"

@interface SGAssignESNSelectionViewController : UITableViewController

@property (weak, nonatomic) SGAssignESN *obj;
@property (weak, nonatomic) NSArray *items;
@property (nonatomic) int target;

@end
