//
//  SGDwellTimeParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGDwellTimeParser.h"
#import "SGDwellTime.h"
#import "SGDwellTimeDate.h"

@implementation SGDwellTimeParser
{
    NSMutableArray *array;
    SGDwellTime *curr;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"row"]) {
        curr = [[SGDwellTime alloc] init];
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
        } else if ([elementName isEqualToString:@"City"]) {
            curr.city = characters;
        } else if ([elementName isEqualToString:@"Cost"]) {
            curr.cost = characters;
        } else if ([elementName isEqualToString:@"Country"]) {
            curr.country = characters;
        } else if ([elementName isEqualToString:@"Days"]) {
            curr.days = characters;
        } else if ([elementName isEqualToString:@"Description"]) {
            curr.assetDescription = characters;
        } else if ([elementName isEqualToString:@"ESN"]) {
            curr.esn = characters;
        } else if ([elementName isEqualToString:@"Group"]) {
            curr.group = characters;
        } else if ([elementName isEqualToString:@"Landmark"]) {
            curr.landmark = characters;
        } else if ([elementName isEqualToString:@"Province"]) {
            curr.province = characters;
        } else if ([elementName isEqualToString:@"Revenue"]) {
            curr.revenue = characters;
        } else if ([elementName isEqualToString:@"Serial_Number"]) {
            curr.serialNumber = characters;
        } else if ([elementName isEqualToString:@"Status"]) {
            curr.status = characters;
        } else if ([elementName isEqualToString:@"Sub_Group"]) {
            curr.subGroup = characters;
        } else if ([elementName isEqualToString:@"Type"]) {
            curr.type = characters;
        } else if ([elementName isEqualToString:@"VIN"]) {
            curr.vin = characters;
        } else if ([elementName hasPrefix:@"Last_Landmark_Date"]) {
            NSString *str = [elementName stringByReplacingOccurrencesOfString:@"Last_Landmark_Date" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            SGDwellTimeDate *date = [[SGDwellTimeDate alloc] init];
            date.label = str;
            date.date = characters;
            
            [curr addLandmarkDate:date];
        } else if ([elementName hasPrefix:@"Last_Location_Date"]) {
            NSString *str = [elementName stringByReplacingOccurrencesOfString:@"Last_Location_Date" withString:@""];
            str = [str stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

            SGDwellTimeDate *date = [[SGDwellTimeDate alloc] init];
            date.label = str;
            date.date = characters;
            
            [curr addLocationDate:date];
        }
    }
}

- (NSArray *)array
{
    return array;
}

@end
