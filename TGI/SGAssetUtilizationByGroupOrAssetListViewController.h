//
//  SGAssetUtilizationByGroupOrAssetListViewController.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSortOptionsViewController.h"

@interface SGAssetUtilizationByGroupOrAssetListViewController : UITableViewController <SGSortOptionsDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sortButton;

@property (weak, nonatomic) NSDate *fromDate;
@property (weak, nonatomic) NSDate *toDate;
@property (weak, nonatomic) NSString *range;
@property (weak, nonatomic) NSString *type;

- (void)showAssetInfo:(NSString *)asset;

@end
