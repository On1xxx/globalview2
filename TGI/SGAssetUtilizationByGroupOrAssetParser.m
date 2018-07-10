//
//  SGAssetUtilizationByGroupOrAssetParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGAssetUtilizationByGroupOrAssetParser.h"
#import "SGAssetUtilizationData.h"

@implementation SGAssetUtilizationByGroupOrAssetParser
{
    NSMutableArray *array;
    SGAssetUtilizationData *curr;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"row"]) {
        curr = [[SGAssetUtilizationData alloc] init];
        curr.asset = @"";
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
        if ([@"Number_of_Assets_in_Group" isEqualToString:elementName]) {
            curr.numberOfAssetsInGroup = characters;
        } else if ([@"Number_of_Days" isEqualToString:elementName]) {
            curr.numberOfDays = characters;
        } else if ([@"Number_of_Moves" isEqualToString:elementName]) {
            curr.numberOfMoves = characters;
        } else if ([@"Avg" isEqualToString:elementName]) {
            curr.avg = characters;
            curr.avgValue = [NSNumber numberWithInt:[[[characters stringByReplacingOccurrencesOfString:@"%" withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] intValue]];
        } else if ([@"Max" isEqualToString:elementName]) {
            curr.max = characters;
        } else if ([@"Min" isEqualToString:elementName]) {
            curr.min = characters;
        } else if ([@"Group" isEqualToString:elementName]) {
            curr.group = characters;
        } else if ([@"Sub_Group" isEqualToString:elementName]) {
            curr.subGroup = characters;
        } else if ([@"Type" isEqualToString:elementName]) {
            curr.type = characters;
        } else if ([@"Asset" isEqualToString:elementName]) {
            curr.asset = characters;
        }
    }
}

- (NSArray *)array
{
    return array;
}

@end
