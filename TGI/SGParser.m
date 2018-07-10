//
//  SGParser.m
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import "SGParser.h"

@implementation SGParser
{
    NSMutableString *buf;
    NSString *errorMessage;
}

+ (SGParser *)parserWithDelegate:(NSObject<SGParserDelegate> *)delegate
{
    SGParser *p = [[SGParser alloc] init];
    p.delegate = delegate;
    return p;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    buf = [[NSMutableString alloc] init];
    if ([self.delegate respondsToSelector:@selector(elementDidStart:attributes:)]) {
        [self.delegate elementDidStart:elementName attributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [buf appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSString *str = [buf stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"error"] || [elementName isEqualToString:@"errors"]) {
        errorMessage = str;
        [parser abortParsing];
    } else {
        if ([self.delegate respondsToSelector:@selector(elementDidEnd:characters:)]) {
            [self.delegate elementDidEnd:elementName characters:str];
        }
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", parseError.localizedDescription);
}

- (NSString *)errorMessage
{
    return errorMessage;
}

@end
