//
//  SGDwellTimeAssetInfoViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGDwellTime.h"

@interface SGDwellTimeAssetInfoViewController : UITableViewController

@property (weak, nonatomic) SGDwellTime *dwellTime;

- (void)addField:(NSString *)key value:(NSString *)value;

@end
