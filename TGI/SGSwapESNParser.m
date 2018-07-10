//
//  SGSwapESNParser.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGSwapESNParser.h"

@implementation SGSwapESNParser {
    NSMutableArray *_messages;
}

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes {
    if ([elementName isEqualToString:@"TRKESNSWAP"]) {
        _messages = [[NSMutableArray alloc] init];
    }
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([elementName isEqualToString:@"message"]) {
        [_messages addObject:characters];
    }
}

- (NSArray *)messages {
    return _messages;
}

@end
