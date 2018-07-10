//
//  SGAssetUtilizationExpCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGAssetUtilizationByGroupOrAssetListViewController.h"
#import "SGAssetUtilizationCell.h"
#import "SGAssetUtilizationData.h"

@interface SGAssetUtilizationExpCell : UITableViewCell

@property (weak, nonatomic) SGAssetUtilizationData *data;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *avgLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfAssetsInGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMovesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;

@property (weak, nonatomic) SGAssetUtilizationByGroupOrAssetListViewController *delegate;

@end
