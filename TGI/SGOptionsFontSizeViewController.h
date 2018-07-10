//
//  SGOptionsFontSizeViewControllerViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGOptionsViewController.h"

@interface SGOptionsFontSizeViewController : UITableViewController

@property (weak, nonatomic) SGOptionsViewController *optionsController;
@property (nonatomic) NSInteger fontSize;

@end
