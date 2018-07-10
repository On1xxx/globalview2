//
//  SGInspectionViewControllerDelegate.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGInspection.h"

@protocol SGInspectionViewControllerDelegate <NSObject>

- (void)setInspection:(SGInspection *)inspection readOnly:(BOOL)readOnly;

@optional

- (void)setAssetId:(NSString *)assetId;
- (void)setInspectionId:(NSString *)inspectionId;

@end
