//
//  SGInspectionListParser.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGInspectionListParser : NSObject <SGParserDelegate>

@property (readonly, nonatomic) NSArray *items;

@end
