//
//  SGInspectionPhotoController.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SGInspectionPhotoControllerDelegate.h"

@interface SGInspectionPhotoController : UIImagePickerController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) NSString *uuid;
@property (weak, nonatomic) id <SGInspectionPhotoControllerDelegate> photosDelegate;

@end
