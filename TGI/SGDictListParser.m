//
//  SGDictListParser.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGDictListParser.h"

@implementation SGDictListParser {
    NSMutableArray *_items;
    SGDictListItem *_item;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    if ([elementName isEqualToString:@"row"]) {
        _item = [[SGDictListItem alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([elementName isEqualToString:@"row"]) {
        if (!_items) {
            _items = [[NSMutableArray alloc] init];
        }
        [_items addObject:_item];
    } else if ([elementName isEqualToString:@"Code"]) {
        _item.itemCode = characters;
    } else if ([elementName isEqualToString:@"Description"]) {
        _item.itemDescription = characters;
    }
}

- (id)result {
    return _items;
}

@end
