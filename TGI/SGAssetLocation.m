//
//  SGAssetLocation.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetLocation.h"

@implementation SGAssetLocation {
    CLLocationCoordinate2D _coord;
}

- (instancetype)initWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    self = [super init];
    if (self) {
        self->_coord.latitude = [latitude floatValue];
        self->_coord.longitude = [longitude floatValue];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _coord;
}

@end
