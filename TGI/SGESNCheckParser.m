//
//  SGESNCheckParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGESNCheckParser.h"

@implementation SGESNCheckParser
{
    NSMutableDictionary *result;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"ESNCHECK"]) {
        result = [[NSMutableDictionary alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters
{
    [result setObject:characters forKey:elementName];
}

- (NSDictionary *)result
{
    return result;
}

@end
