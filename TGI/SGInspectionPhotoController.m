//
//  SGInspectionPhotoController.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionPhotoController.h"
#import "SGInspectionUtil.h"

#import <dispatch/dispatch.h>

@implementation SGInspectionPhotoController {
    dispatch_queue_t queue;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        queue = dispatch_queue_create("com.sophia.tgi.inspections.photos", NULL);
    }
    return self;
}

- (void)viewDidLoad {
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.allowsEditing = NO;
    self.delegate = self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(queue, ^{
        UIImage *scaledImage = [self scaleImage:image];
        [SGInspectionUtil savePhoto:scaledImage uuid:self.uuid];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.photosDelegate photoAdded];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (UIImage *)scaleImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(1024, 768);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
