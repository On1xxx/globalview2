//
//  SGInspectionUtil.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionUtil.h"
#import "SGPendingInspection.h"
#import "SGInspection.h"
#import "SGInspectionPhoto.h"

@implementation SGInspectionUtil

+ (NSString *)createDirectoryIfMissing:(NSString *)uuid {
    NSLog(@"Create directory if missing, uuid: %@", uuid);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths.count > 0 ? paths[0] : nil;
    
    NSString *inspectionDirectoryPath = [NSString pathWithComponents:@[documentsPath,
                                                                       [NSString stringWithFormat:@"INSPECTION_%@", uuid]]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:inspectionDirectoryPath]) {
        NSLog(@"Creating directory: %@", inspectionDirectoryPath);
        
        NSError *error;
        if (![fileManager createDirectoryAtPath:inspectionDirectoryPath
                    withIntermediateDirectories:NO
                                     attributes:nil
                                          error:&error]) {
            NSLog(@"Directory error: %@", error);
        }
    }
    
    return inspectionDirectoryPath;
}

+ (NSString *)saveInspectionInDocumentsFolderForAssetId:(NSString *)assetId inspection:(SGInspection *)inspection serializer:(SGInspectionSerializer *)serializer {
    NSLog(@"UUID: %@", inspection.uuid);
    
    NSString *inspectionDirectoryPath = [self createDirectoryIfMissing:inspection.uuid];
    
    NSLog(@"Saving info");
    
    NSDictionary *info = @{@"assetId": assetId,
                           @"dateUtc": inspection.dateUtc,
                           @"dateTz": inspection.dateTz};
    
    if (![info writeToFile:[inspectionDirectoryPath stringByAppendingPathComponent:@"inspection.plist"]
                atomically:YES]) {
        NSLog(@"Info error");
    }
    
    NSLog(@"Saving XML");
    
    NSError *error;
    if (![serializer.xml writeToFile:[inspectionDirectoryPath stringByAppendingPathComponent:@"inspection.xml"]
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error]) {
        NSLog(@"XML error: %@", error);
    }
    
    NSLog(@"Done");
    
    return inspectionDirectoryPath;
}

+ (NSArray *)findPendingInspections {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = paths.count > 0 ? paths[0] : nil;
    NSError *error;
    
    NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    if (!filenames) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    NSMutableArray *inspections = [[NSMutableArray alloc] init];
    for (NSString *filename in filenames) {
        NSLog(@"File: %@", filename);
        if ([filename hasPrefix:@"INSPECTION_"]) {
            NSString *directoryPath = [documentsPath stringByAppendingPathComponent:filename];
            NSString *infoPath = [directoryPath stringByAppendingPathComponent:@"inspection.plist"];
            NSLog(@"Info path: %@", infoPath);
            NSDictionary *info = [[NSDictionary alloc] initWithContentsOfFile:infoPath];
            NSLog(@"Info: %@", info);
            if (!info) {
                continue;
            }
            SGPendingInspection *inspection = [[SGPendingInspection alloc] init];
            inspection.assetId = info[@"assetId"];
            inspection.dateUtc = info[@"dateUtc"];
            inspection.dateTz = info[@"dateTz"];
            inspection.directoryPath = directoryPath;
            [inspections addObject:inspection];
        }
    }
    return inspections;
}

+ (NSString *)findPendingInspectionXml:(NSString *)directoryPath {
    NSString *xmlPath = [directoryPath stringByAppendingPathComponent:@"inspection.xml"];
    NSError *error;
    NSString *xml = [NSString stringWithContentsOfFile:xmlPath encoding:NSUTF8StringEncoding error:&error];
    if (!xml) {
        NSLog(@"XML error: %@", error);
    }
    return xml;
}

+ (void)deletePendingInspection:(NSString *)directoryPath {
    NSLog(@"Deleting, path: %@", directoryPath);
    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error]) {
        NSLog(@"Delete failed, error: %@", error);
    } else {
        NSLog(@"Delete success");
    }
}

+ (void)savePhoto:(UIImage *)image uuid:(NSString *)uuid {
    NSString *directoryPath = [self createDirectoryIfMissing:uuid];
    NSString *name = [NSString stringWithFormat:@"PHOTO_%@", [[NSUUID UUID] UUIDString]];
    NSString *path = [directoryPath stringByAppendingPathComponent:name];
    
    NSLog(@"Saving photo to %@", path);
    
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [data writeToFile:path atomically:YES];
    
    NSLog(@"Photo saved, %@", name);
}

+ (NSString *)base64EncodedString:(SGInspectionPhoto *)photo {
    UIImage *image = [UIImage imageWithContentsOfFile:photo.filepath];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    return [data base64EncodedStringWithOptions:0];
}

+ (NSData *)dataWithBase64EncodedString:(NSString *)str {
    return [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

+ (NSArray *)findInspectionPhotos:(NSString *)uuid {
    NSString *directoryPath = [self createDirectoryIfMissing:uuid];
    
    NSError *error;
    NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
    if (!filenames) {
        NSLog(@"Cannot find photos: %@", error);
        return nil;
    }
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (NSString *filename in filenames) {
        NSLog(@"File: %@", filename);
        if ([filename hasPrefix:@"PHOTO_"]) {
            SGInspectionPhoto *photo = [[SGInspectionPhoto alloc] init];
            photo.filename = filename;
            photo.filepath = [directoryPath stringByAppendingPathComponent:filename];
            [items addObject:photo];
        }
    }
    NSLog(@"Found photos, count: %lu", (unsigned long)items.count);
    return items;
}

@end
