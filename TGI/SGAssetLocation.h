//
//  SGAssetLocation.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SGAssetLocation : NSObject <MKAnnotation>

- (instancetype)initWithLatitude:(NSString *)latitude longitude:(NSString *)longitude;

@end
