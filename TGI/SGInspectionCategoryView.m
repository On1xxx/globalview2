//
//  SGInspectionCategoryView.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionCategoryView.h"
#import "SGColor.h"

@implementation SGInspectionCategoryView {
    UIEdgeInsets _insets;
}

- (instancetype)initWithCategory:(SGInspectionCategory *)category {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.text = category.title;
        self.font = [UIFont boldSystemFontOfSize:14];
        self.textColor = [SGColor darkBlue];
        
        UIGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:category
                                                                         action:@selector(respondToTapGesture:)];
        [self addGestureRecognizer:r];
        
        _insets = UIEdgeInsetsMake(0, 16, 0, 0);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}

@end
