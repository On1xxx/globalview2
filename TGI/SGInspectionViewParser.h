//
//  SGInspectionViewParser.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"
#import "SGInspection.h"

@interface SGInspectionViewParser : NSObject <SGParserDelegate>

@property (readonly, nonatomic) SGInspection *inspection;

@end
