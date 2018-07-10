//
//  SGPendingInspection.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGPendingInspection : NSObject

@property (strong, nonatomic) NSString *assetId;
@property (strong, nonatomic) NSString *dateUtc;
@property (strong, nonatomic) NSString *dateTz;
@property (strong, nonatomic) NSString *directoryPath;

@end
