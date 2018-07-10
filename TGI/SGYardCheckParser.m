//
//  SGYardCheckParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckParser.h"
#import "SGYardCheck.h"

@implementation SGYardCheckParser
{
    NSMutableArray *array;
    SGYardCheck *curr;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"row"]) {
        curr = [[SGYardCheck alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters
{
    if ([elementName isEqualToString:@"row"]) {
        if (!array) {
            array = [[NSMutableArray alloc] init];
        }
        [array addObject:curr];
    } else {
        if ([elementName isEqualToString:@"Count"]) {
            curr.count = characters;
        } else if ([elementName isEqualToString:@"Group"]) {
            curr.group = characters;
        } else if ([elementName isEqualToString:@"Sub_Group"]) {
            curr.subGroup = characters;
        } else if ([elementName isEqualToString:@"Type"]) {
            curr.type = characters;
        } else if ([elementName isEqualToString:@"Landmark"]) {
            curr.landmark = characters;
        }
    }
}

- (NSArray *)array
{
    return array;
}

@end
