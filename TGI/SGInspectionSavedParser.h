//
//  SGInspectionSavedParser.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGParserDelegate.h"

@interface SGInspectionSavedParser : NSObject <SGParserDelegate>

@property (strong, nonatomic) NSString *inspectionId;

@end
