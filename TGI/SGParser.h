//
//  SGParser.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGParser : NSObject <NSXMLParserDelegate>

@property (nonatomic) NSObject<SGParserDelegate> *delegate;

- (NSString *)errorMessage;

+ (SGParser *)parserWithDelegate:(NSObject<SGParserDelegate> *)delegate;

@end
