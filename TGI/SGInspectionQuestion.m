//
//  SGInspectionQuestion.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionQuestion.h"

@implementation SGInspectionQuestion

- (instancetype)initWithTitle:(NSString *)aTitle {
    self = [super init];
    if (self) {
        self.title = aTitle;
    }
    return self;
}

@end
