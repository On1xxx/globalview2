//
//  SGYardCheckAssetParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGYardCheckAssetParser.h"
#import "SGYardCheckAsset.h"

@implementation SGYardCheckAssetParser
{
    NSMutableArray *array;
    SGYardCheckAsset *curr;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"row"]) {
        curr = [[SGYardCheckAsset alloc] init];
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
        if ([elementName isEqualToString:@"Asset_Id"]) {
            curr.assetId = characters;
        } else if ([elementName isEqualToString:@"Group"]) {
            curr.group = characters;
        } else if ([elementName isEqualToString:@"Sub_Group"]) {
            curr.subGroup = characters;
        } else if ([elementName isEqualToString:@"Type"]) {
            curr.type = characters;
        } else if ([elementName isEqualToString:@"Days_Not_Moved"]) {
            curr.daysNotMoved = characters;
        } else if ([elementName isEqualToString:@"Description"]) {
            curr.assetDescription = characters;
        } else if ([elementName isEqualToString:@"ESN"]) {
            curr.esn = characters;
        } else if ([elementName isEqualToString:@"Last_Update"]) {
            curr.lastUpdate = characters;
        } else if ([elementName isEqualToString:@"Serial_Number"]) {
            curr.serialNumber = characters;
        } else if ([elementName isEqualToString:@"Status"]) {
            curr.status = characters;
        } else if ([elementName isEqualToString:@"VIN"]) {
            curr.vin = characters;
        }
    }
}

- (NSArray *)array
{
    return array;
}

@end
