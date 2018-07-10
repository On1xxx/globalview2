//
//  SGAttachmentParser.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionAttachmentParser.h"

@implementation SGInspectionAttachmentParser {
    NSString *_data;
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([@"Data" isEqualToString:elementName]) {
        _data = characters;
    }
}

- (NSString *)data {
    return _data;
}

@end
