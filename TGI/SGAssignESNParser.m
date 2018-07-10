//
//  SGAssignESNParser.m
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import "SGAssignESNParser.h"

@implementation SGAssignESNParser {
    NSString *_result;
}

- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters {
    if ([elementName isEqualToString:@"result"]) {
        _result = characters;
    }
}

- (NSString *)result {
    return _result;
}

@end
