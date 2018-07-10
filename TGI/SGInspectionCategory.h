//
//  SGInspectionCategory.h
//  TGI
//
//  Copyright (c) 2014 Sophia Group Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGInspectionQuestion.h"

@interface SGInspectionCategory : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *tag;
@property (nonatomic) BOOL collapsed;

@property (nonatomic) UIView *view;
@property (weak, nonatomic) UITableView *tableView;

- (instancetype)initWithTitle:(NSString *)aTitle;

- (void)addQuestion:(SGInspectionQuestion *)question;
- (NSUInteger)getQuestionCount;
- (SGInspectionQuestion *)getQuestionAtIndex:(NSUInteger)index;

- (void)respondToTapGesture:(UIGestureRecognizer *)recognizer;

@end
