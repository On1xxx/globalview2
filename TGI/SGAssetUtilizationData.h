//
//  SGAssetUtilizationData.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAssetUtilizationData : NSObject

@property (nonatomic) NSString *numberOfAssetsInGroup;
@property (nonatomic) NSString *numberOfDays;
@property (nonatomic) NSString *numberOfMoves;
@property (nonatomic) NSString *avg;
@property (nonatomic) NSNumber *avgValue;
@property (nonatomic) NSString *max;
@property (nonatomic) NSString *min;
@property (nonatomic) NSString *group;
@property (nonatomic) NSString *subGroup;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *asset;

@end
