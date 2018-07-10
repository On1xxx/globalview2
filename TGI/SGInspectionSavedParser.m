//
//  SGInspectionSavedParser.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionSavedParser.h"

@implementation SGInspectionSavedParser

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    NSLog(@"Start: %@", elementName);
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    NSLog(@"End: %@, text: %@", elementName, characters);
    if ([@"inspection_id" isEqualToString:elementName]) {
        self.inspectionId = characters;
    }
}

@end
