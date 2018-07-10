//
//  SGInspectionSerializer.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGInspection.h"

@interface SGInspectionSerializer : NSObject

- (instancetype)initWithAssetId:(NSString *)assetId inspection:(SGInspection *)inspection;

@property (readonly, nonatomic) NSString *xml;

@end
