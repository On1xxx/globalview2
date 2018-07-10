//
//  SGInspectionTabBarController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SGInspectionPhotoControllerDelegate.h"
#import "SGInspection.h"

@interface SGInspectionTabBarController : UITabBarController <UIAlertViewDelegate, SGInspectionPhotoControllerDelegate>

@property (assign, nonatomic) NSString *assetId;
@property (assign, nonatomic) NSString *inspectionId;

@end
