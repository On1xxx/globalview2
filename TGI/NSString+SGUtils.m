//
//  NSString+SGUtils.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "NSString+SGUtils.h"

@implementation NSString (SGUtils)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty {
    return [self trim].length == 0;
}

@end
