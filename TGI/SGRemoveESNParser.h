//
//  SGRemoveESNParser.h
//  TGI
//
//  Copyright © 2015 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGRemoveESNParser : NSObject <SGParserDelegate>

- (NSArray *)messages;

@end
