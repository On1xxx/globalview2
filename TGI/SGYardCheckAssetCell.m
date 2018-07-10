//
//  SGYardCheckAssetCell.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckAssetCell.h"

@implementation SGYardCheckAssetCell

- (void)setAsset:(SGYardCheckAsset *)asset
{
    self.assetIdLabel.text = asset.assetId;
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@, %@, %@", 	asset.group, asset.subGroup, asset.type];
    self.daysNotMovedLabel.text = asset.daysNotMoved;
}

@end
