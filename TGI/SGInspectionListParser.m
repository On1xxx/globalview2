//
//  SGInspectionListParser.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionListParser.h"
#import "SGInspectionListItem.h"

@implementation SGInspectionListParser {
    NSMutableArray *_items;
    SGInspectionListItem *_item;
}

- (NSArray *)items {
    return _items;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    if ([@"row" isEqualToString:elementName]) {
        if (!_items) {
            _items = [[NSMutableArray alloc] init];
        }
        _item = [[SGInspectionListItem alloc] init];
        [_items addObject:_item];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([@"Asset_Id" isEqualToString:elementName]) {
        _item.assetId = characters;
    } else if ([@"Group" isEqualToString:elementName]) {
        _item.group = characters;
    } else if ([@"Inspection_Id" isEqualToString:elementName]) {
        _item.inspectionId = characters;
    } else if ([@"Record_Status" isEqualToString:elementName]) {
        _item.status = characters;
    } else if ([@"Sub_Group" isEqualToString:elementName]) {
        _item.subGroup = characters;
    } else if ([@"Type" isEqualToString:elementName]) {
        _item.type = characters;
    } else if ([elementName hasPrefix:@"Date_"]) {
        NSArray *parts = [elementName componentsSeparatedByString:@"_"];
        NSString *tz = parts[parts.count - 1];
        if ([@"UTC" isEqualToString:tz]) {
            _item.dateUtc = characters;
        } else {
            _item.dateTz = characters;
            _item.tz = tz;
        }
    }
}

@end
