//
//  SGAssetUtilizationCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAssetUtilizationData.h"
#import "SGAssetUtilizationByGroupOrAssetListViewController.h"

@interface SGAssetUtilizationCell : UITableViewCell

@property (weak, nonatomic) SGAssetUtilizationData *data;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgLabel;

@property (weak, nonatomic) SGAssetUtilizationByGroupOrAssetListViewController *delegate;

@end
