//
//  SGESNCheckParser.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGESNCheckParser : NSObject <SGParserDelegate>

- (NSDictionary *)result;

@end
