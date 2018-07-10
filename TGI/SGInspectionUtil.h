//
//  SGInspectionUtil.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGInspectionSerializer.h"
#import "SGPendingInspection.h"
#import "SGInspectionPhoto.h"

@interface SGInspectionUtil : NSObject

+ (NSString *)saveInspectionInDocumentsFolderForAssetId:(NSString *)assetId inspection:(SGInspection *)inspection serializer:(SGInspectionSerializer *)serializer;

+ (NSArray *)findPendingInspections;

+ (NSString *)findPendingInspectionXml:(NSString *)directoryPath;

+ (void)deletePendingInspection:(NSString *)directoryPath;

+ (void)savePhoto:(UIImage *)image uuid:(NSString *)uuid;

+ (NSString *)base64EncodedString:(SGInspectionPhoto *)photo;

+ (NSData *)dataWithBase64EncodedString:(NSString *)str;

+ (NSArray *)findInspectionPhotos:(NSString *)uuid;

@end
