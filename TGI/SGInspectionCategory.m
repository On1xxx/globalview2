//
//  SGInspectionCategory.m
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import "SGInspectionCategory.h"

@implementation SGInspectionCategory {
    NSMutableArray *_questions;
}

- (instancetype)initWithTitle:(NSString *)aTitle {
    self = [super init];
    if (self) {
        self.title = aTitle;
        self.collapsed = YES;
        _questions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addQuestion:(SGInspectionQuestion *)question {
    [_questions addObject:question];
}

- (NSUInteger)getQuestionCount {
    return _questions.count;
}

- (SGInspectionQuestion *)getQuestionAtIndex:(NSUInteger)index {
    return _questions[index];
}

- (void)respondToTapGesture:(UIGestureRecognizer *)recognizer {
    self.collapsed = !self.collapsed;
    NSLog(@"Collapsing: %@, collapsed: %d", self.title, self.collapsed);
    [self.tableView reloadData];
}

@end
