//
//  SGRemoveESNParser.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGRemoveESNParser.h"

@implementation SGRemoveESNParser {
    NSMutableArray *_messages;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"TRKESNREMOVE"]) {
        _messages = [[NSMutableArray alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters
{
    if ([elementName isEqualToString:@"message"]) {
        [_messages addObject:characters];
    }
}

- (NSArray *)messages {
    return _messages;
}

@end
