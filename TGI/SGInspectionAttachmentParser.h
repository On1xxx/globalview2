//
//  SGAttachmentParser.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGInspectionAttachmentParser : NSObject <SGParserDelegate>

@property (readonly, nonatomic) NSString *data;

@end
