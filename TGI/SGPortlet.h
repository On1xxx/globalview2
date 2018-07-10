//
//  SGPortlet.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"
#import "SGPortletDelegate.h"

@interface SGPortlet : NSObject <NSURLConnectionDataDelegate>

- (id)initWithPortlet:(NSString *)aPortlet
                  tag:(NSString *)aTag
               parser:(id <SGParserDelegate>)aParserDelegate
             delegate:(id <SGPortletDelegate>)aDelegate;

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate;

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate
            onSuccess:(void (^)())successBlock;

- (id)initWithPortlet:(NSString *)aPortlet
               parser:(id <SGParserDelegate>)aParserDelegate
            onSuccess:(void (^)())successBlock
              onError:(void (^)())errorBlock;

- (void)addParameter:(NSString *)name value:(NSString *)value;

- (void)setDisplayError:(BOOL)displayError;

- (void)invoke;
- (BOOL)invokeSynchronously;
- (void)invokeWithXml:(NSString *)xml;

@end
