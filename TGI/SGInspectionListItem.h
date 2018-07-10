//
//  SGInspectionListItem.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGInspectionListItem : NSObject

@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *inspectionId;
@property (strong, nonatomic) NSString *dateUtc;
@property (strong, nonatomic) NSString *dateTz;
@property (strong, nonatomic) NSString *tz;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *subGroup;
@property (strong, nonatomic) NSString *type;

@end
