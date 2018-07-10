//
//  SGFindAssetParser.h
//  TGI
//
//  Copyright (c) 2012 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGFindAssetParser : NSObject <SGParserDelegate>

@property (nonatomic, readonly) NSDictionary *asset;

@end
