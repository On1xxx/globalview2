//
//  SGYardCheckAssetCell.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGYardCheckAsset.h"

@interface SGYardCheckAssetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *assetIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysNotMovedLabel;

- (void)setAsset:(SGYardCheckAsset *)asset;

@end
