//
//  SGParserDelegate.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SGParserDelegate <NSObject>

@optional

- (void)elementDidStart:(NSString *)elementName attributes:(NSDictionary *)attributes;
- (void)elementDidEnd:(NSString *)elementName characters:(NSString *)characters;

- (void)willParseXML:(NSString *)xml;

- (id)result;

@end
